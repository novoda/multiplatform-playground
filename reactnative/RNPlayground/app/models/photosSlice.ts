import { createSlice, PayloadAction } from "@reduxjs/toolkit"
import { Photo, PhotoPage } from "./Photo"
import { api } from "../services/api"
import { AppThunk, RootState } from "../store"
import { GeneralApiProblem } from "../services/api/apiProblem"
import { delay } from "../utils/delay"

type ReduxContent = {
  nextPage: number
  totalPages: number
  photos: Photo[]
}

const emptyContent: ReduxContent = {
  nextPage: 1,
  totalPages: 0,
  photos: [],
}

type ReduxError = {
  message: string
}

type ReduxPhotosState = {
  isLoading: boolean
  error: ReduxError | null
  content: ReduxContent
}

export function fullScreenLoading(state: ReduxPhotosState) {
  return state.isLoading && !state.error && (!state.content || state.content.photos.length == 0)
}

const initialState: ReduxPhotosState = {
  isLoading: false,
  error: null,
  content: emptyContent,
}

const photosSlice = createSlice({
  name: "photosSlice",
  initialState: initialState,
  reducers: {
    initialLoad(state) {
      state.isLoading = true
      state.error = null
      state.content = emptyContent
    },
    fetchNextPage(state) {
      console.log("NEXT PAGE")
      state.isLoading = true
      state.error = null
    },
    fetchPhotosSuccess(state, action: PayloadAction<PhotoPage>) {
      console.log("SUCCESS")
      state.isLoading = false
      state.error = null
      state.content = {
        nextPage: action.payload.currentPage + 1,
        totalPages: action.payload.totalPages,
        photos: [...state.content.photos, ...action.payload.photos],
      }
    },
    fetchPhotosFailure(state, action: PayloadAction<GeneralApiProblem>) {
      console.log("FAILURE")
      console.log(`Error fetching episodes: ${JSON.stringify(action.payload)}`, [])
      state.isLoading = false
      state.content = emptyContent
      switch (action.payload.kind) {
        case "unauthorized":
          state.error = { message: "Unauthorized, make sure you have a valid key in .env file" }
          break
        default:
          state.error = { message: action.payload.kind }
      }
    },
  },
})


export const load: AppThunk = () => async (dispatch, getState) => {
  console.log("STARTED LOAD")
  dispatch(photosSlice.actions.initialLoad())
  await loadPage(dispatch, getState().photosReducer.content.nextPage)
}

export const nextPage: AppThunk = () => async (dispatch, getState) => {
  const state = getState().photosReducer
  if (state.isLoading) return
  dispatch(photosSlice.actions.fetchNextPage())
  await loadPage(dispatch, state.content.nextPage)
}

async function loadPage(dispatch, page: number) {
  try {
    console.log("API CALL")
    await delay(2000)
    const response = await api.getPhotos(page)
    if (response.kind === "ok") {
      dispatch(photosSlice.actions.fetchPhotosSuccess(response.data))
    } else {
      dispatch(photosSlice.actions.fetchPhotosFailure(response))
    }
  } catch (e) {
    const failure: GeneralApiProblem = { kind: "unknown", temporary: true, cause: e.message }
    dispatch(photosSlice.actions.fetchPhotosFailure(failure))
  }
}

export const photosState = (state: RootState) => state.photosReducer
export default photosSlice.reducer