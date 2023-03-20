import { Instance, SnapshotOut, types } from "mobx-state-tree";
import { api } from "../services/api";
import { PhotoModel, PhotoPage } from "./Photo";

const ContentModel = types.model("Content", {
    currentPage: 1,
    totalPages: 0,
    photos: types.array(PhotoModel)
})
const ErrorModel = types.model("Error", { message: "" })
const PlaygroundUiState = types
    .model('PlaygroundUiState', {
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
            self.content.currentPage++
            self.content.photos.push(...photoPage.photos)
            self.content.totalPages = photoPage.totalPages
        }
        return {
            setLoading, setError, setContent, clear
        }
    })

export const PlaygroundStoreModel = types
    .model("PlaygroundStore")
    .props({
        uiState: types.optional(PlaygroundUiState, () => PlaygroundUiState.create({}))
    })
    .actions((store) => {
        async function load() {
            store.uiState.clear()
            await loadPage(1)
        }

        async function nextPage() {
            if (store.uiState.isLoading) return
            let content = store.uiState.content
            if (content.currentPage < content.totalPages) {
                console.log(`Fetching page: ${content.currentPage} out of ${content.totalPages}`)
                await loadPage(content.currentPage)
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
                store.uiState.setError(response.kind)
                console.log(`Error fetching episodes: ${JSON.stringify(response)}`, [])
            }
        }

        return {
            load, nextPage
        }
    })

export interface Content extends SnapshotOut<typeof ContentModel> { }
export interface ErrorState extends Instance<typeof ErrorModel> { }
export interface PlaygroundUiState extends Instance<typeof PlaygroundUiState> { }
export interface PlaygroundStore extends Instance<typeof PlaygroundStoreModel> { }