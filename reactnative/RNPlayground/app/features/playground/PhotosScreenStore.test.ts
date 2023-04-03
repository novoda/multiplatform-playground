import { mocked } from "ts-jest/utils"
import { onSnapshot, ModelCreationType } from "mobx-state-tree"
import { ContentModel, ErrorModel, PhotosScreenStoreModel, PhotosScreenUiState, PhotosScreenUiStateModel } from "./PhotosScreenStore"
import { PhotoApi } from "../../services/api"

jest.mock('../services/api')
const mockApi = mocked(new PhotoApi())

describe("PlaygroundStoreModel", () => {

    beforeEach(() => {
        mockApi.getPhotos.mockResolvedValue({ kind: 'ok', data: { photos: [], totalPages: 0, currentPage: 1 } })
    })

    it("creates a new instance of PlaygroundStore", () => {
        const store = PhotosScreenStoreModel.create()
        expect(store).toBeDefined()
    })

    it("load fetches first page", async () => {
        const store = PhotosScreenStoreModel.create();

        await store.load();

        expect(mockApi.getPhotos.mock.calls[0][0]).toEqual(1)
    })

    it("shows loading followed by error when photo fetching fails", async () => {
        const store = PhotosScreenStoreModel.create();
        let states: PhotosScreenUiState[] = []
        onSnapshot(store, ({ uiState }) => states.push(uiState as PhotosScreenUiState))

        mockApi.getPhotos.mockResolvedValue({ kind: 'bad-data' })
        await store.load();

        expect(states).toStrictEqual([
            uiState({ isLoading: true }),
            uiState({ isLoading: false, error: ErrorModel.create({ message: 'bad-data' }) })
        ])
    })

    it("shows loading followed by content when photo fetching succeeds", async () => {
        const store = PhotosScreenStoreModel.create();
        let states: PhotosScreenUiState[] = []
        onSnapshot(store, ({ uiState }) => states.push(uiState as PhotosScreenUiState))

        mockApi.getPhotos.mockResolvedValue({ kind: 'ok', data: { photos: [], totalPages: 2, currentPage: 1 }})
        await store.load();

        expect(states).toStrictEqual([
            uiState({ isLoading: true }),
            uiState({ isLoading: false, content: ContentModel.create({ totalPages: 2, nextPage: 2, photos: [] }) })
        ])
    })

    it("loads next page until all available pages are fetched", async () => {
        const store = PhotosScreenStoreModel.create();
        let states: PhotosScreenUiState[] = []
        onSnapshot(store, ({ uiState }) => states.push(uiState as PhotosScreenUiState))

        mockApi.getPhotos.mockResolvedValue({ kind: 'ok', data: { photos: [], totalPages: 2, currentPage: 1 }})
        await store.load();
        mockApi.getPhotos.mockResolvedValue({ kind: 'ok', data: { photos: [], totalPages: 2, currentPage: 2 }})
        await store.nextPage();
        await store.nextPage();


        expect(states).toStrictEqual([
            uiState({ isLoading: true }),
            uiState({ isLoading: false, content: ContentModel.create({ totalPages: 2, nextPage: 2, photos: [] }) }),
            uiState({ isLoading: true, content: ContentModel.create({ totalPages: 2, nextPage: 2, photos: [] }) }),
            uiState({ isLoading: false, content: ContentModel.create({ totalPages: 2, nextPage: 3, photos: [] }) })
        ])
    })
})

function uiState(snapshot: ModelCreationType<PhotosScreenUiState>) {
    return PhotosScreenUiStateModel.create(snapshot)
}