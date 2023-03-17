import { Instance, SnapshotOut, types } from "mobx-state-tree";
import { create } from 'apisauce';

const unsplashApi = create({
    baseURL: 'https://api.unsplash.com/',
    headers: ({
        Authorization: `Client-ID qTfGrUwhF1Uy6XDhkMEqcM_UuHJhx89Hem6oBY1a_U4`
    })
})

const photos = (page) => unsplashApi.get('/photos', { page: page, per_page: 20, order_by: 'latest' })
    .then(response => {
        if (response.problem) {
            return Promise.reject(response.originalError)
        }
        return (response.data as typeof PhotoModel[])
    })

const UrlsModel = types.model({
    raw: types.string,
    full: types.string,
    small: types.string,
    thumb: types.string,
    regular: types.string,
})

const PhotoModel = types.model({
    id: types.string,
    color: types.string,
    description: types.maybeNull(types.string),
    urls: UrlsModel
})

const ContentModel = types.model("Content", {
    pageNumber: 0,
    photos: types.array(PhotoModel)
})
const ErrorModel = types.model("Error", { message: "" })
const PlaygroundUiState = types
    .model('PlaygroundUiState', {
        loading: types.boolean,
        error: types.maybe(ErrorModel),
        content: types.maybe(ContentModel)
    })
    .actions((self) => {
        function clear() {
            self.content = undefined
            self.error = undefined
            self.loading = false
        }
        function setLoading() {
            self.loading = true
        }
        function setError(error: string) {
            clear()
            self.error = ErrorModel.create({ message: error })
        }
        function setContent(page: number, photos: typeof PhotoModel[]) {
            self.loading = false
            self.error = undefined
            if (!self.content) {
                self.content = ContentModel.create({ photos: photos, pageNumber: page })
            } else {
                if (self.content.pageNumber < page) {
                    self.content.pageNumber = page
                    self.content.photos.push(...photos)
                }
            }
        }
        return {
            setLoading, setError, setContent, clear
        }
    })

const initialLoading = () => PlaygroundUiState.create({ loading: true })

export const PlaygroundStoreModel = types
    .model("PlaygroundStore")
    .props({
        uiState: types.optional(PlaygroundUiState, initialLoading)
    })
    .actions((store) => {
        async function load() {
            store.uiState.clear()
            store.uiState.setLoading()
            await loadPage(1)
        }

        async function nextPage() {
            let content = store.uiState.content
            await loadPage(content ? content.pageNumber + 1 : 1)
        }

        async function loadPage(page: number) {
            try {
                const data = await photos(page)
                store.uiState.setContent(page, data)
            } catch (e) {
                store.uiState.setError(e.message)
            }
        }

        return {
            load, nextPage
        }
    })

export interface Content extends SnapshotOut<typeof ContentModel> { }
export interface ErrorState extends SnapshotOut<typeof ErrorModel> { }
export interface Photo extends SnapshotOut<typeof PhotoModel> { }
export interface PlaygroundUiState extends SnapshotOut<typeof PlaygroundUiState> { }
export interface PlaygroundStore extends Instance<typeof PlaygroundStoreModel> { }