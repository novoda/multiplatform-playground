import { Instance, SnapshotOut, types } from "mobx-state-tree";
import { PhotoModel, PhotoPage } from "./Photo";
import { PhotoApi } from "../services/api"

export const ContentModel = types.model("Content", {
    nextPage: 1,
    totalPages: 0,
    photos: types.array(PhotoModel)
})
export const ErrorModel = types.model("Error", { message: "" })
export const PhotosScreenUiStateModel = types
    .model('PhotosScreenUiState', {
        isLoading: false,
        error: types.maybe(ErrorModel),
        content: types.optional(ContentModel, () => ContentModel.create({ photos: [] }))
    })
    .views((self) => ({
        get fullScreenLoading() {
            return self.isLoading && !self.error && (!self.content || self.content.photos.length == 0)
        }
    }))
    .actions((self) => {
        function clear() {
            self.content = ContentModel.create({ photos: [] })
            self.error = undefined
            self.isLoading = false
        }
        function setLoading() {
            self.isLoading = true
        }
        function setError(error: string) {
            clear()
            self.error = ErrorModel.create({ message: error })
        }
        function setContent(photoPage: PhotoPage) {
            self.isLoading = false
            self.error = undefined
            self.content.nextPage = photoPage.currentPage + 1
            self.content.photos.push(...photoPage.photos)
            self.content.totalPages = photoPage.totalPages
        }
        return {
            setLoading, setError, setContent, clear
        }
    })

const api = new PhotoApi()
export const PhotosScreenStoreModel = types
    .model("PhotosScreenStore")
    .props({
        uiState: types.optional(PhotosScreenUiStateModel, () => PhotosScreenUiStateModel.create({}))
    })
    .actions((store) => {
        async function load() {
            store.uiState.clear()
            await loadPage(1)
        }

        async function nextPage() {
            if (store.uiState.isLoading) return
            let content = store.uiState.content
            if (content.nextPage <= content.totalPages) {
                console.log(`Fetching page: ${content.nextPage} out of ${content.totalPages}`)
                await loadPage(content.nextPage)
            } else {
                console.log('Fetched all content')
            }
        }

        async function loadPage(page: number) {
            store.uiState.setLoading()
            const response = await api.getPhotos(page)
            if (response.kind === "ok") {
                store.uiState.setContent(response.data)
            } else {
                switch (response.kind) {
                    case "unauthorized":
                    store.uiState.setError("Unauthorized, make sure you have a valid key in .env file")
                        break
                    default:
                        store.uiState.setError(response.kind)
                }
                console.log(`Error fetching episodes: ${JSON.stringify(response)}`, [])
            }
        }

        return {
            load, nextPage
        }
    })

export interface Content extends SnapshotOut<typeof ContentModel> { }
export interface ErrorState extends Instance<typeof ErrorModel> { }
export interface PhotosScreenUiState extends Instance<typeof PhotosScreenUiStateModel> { }
export interface PhotosScreenStore extends Instance<typeof PhotosScreenStoreModel> { }