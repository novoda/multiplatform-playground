import { types } from "mobx-state-tree";
import { delay } from "../utils/delay";

const Content = types.model("Content", { number: 0 })
const Loading = types.model("Loading")
const Error = types.model("Error", { message: "" })
const PlaygroundUiState = types
    .model('PlaygroundUiState', {
        loading: types.maybe(Loading),
        error: types.maybe(Error),
        content: types.maybe(Content)
    })
    .actions((self) => {
        function clear() {
            self.content = undefined
            self.error = undefined
            self.loading = undefined
        }
        function setLoading() {
            clear()
            self.loading = Loading.create()
        }
        function setError(error: string) {
            clear()
            self.error = Error.create({ message: error })
        }
        function setContent(number: number) {
            clear()
            self.content = Content.create({ number: number })
        }
        return {
            setLoading, setError, setContent
        }
    })

const initialLoading = () => PlaygroundUiState.create({ loading: Loading.create() })

export const PlaygroundStoreModel = types
    .model("PlaygroundStore")
    .props({
        uiState: types.optional(PlaygroundUiState, initialLoading)
    })
    .actions((store) => {
        let interval = null

        async function startCounter() {
            store.uiState.setLoading()
            await delay(1000)
            console.log("START")

            interval = setInterval(() => {
                if (store.uiState.content) {
                    const value = store.uiState.content.number
                    if (value < 30) {
                        store.uiState.setContent(value + 1)
                    } else {
                        store.uiState.setError("Encountered a fake error")
                        stopCounter()
                    }
                } else {
                    store.uiState.setContent(0)
                }
            }, 500)
        }

        function stopCounter() {
            console.log("STOP")
            clearInterval(interval)
            interval = null
        }
        async function resetCounter() {
            stopCounter()
            startCounter()
        }
        return {
            startCounter, stopCounter, resetCounter
        }
    })

