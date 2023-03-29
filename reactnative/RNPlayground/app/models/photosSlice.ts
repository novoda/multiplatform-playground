import { createAsyncThunk, createSlice, isFulfilled, isRejectedWithValue } from "@reduxjs/toolkit"
import { Photo, PhotoPage } from "./Photo"
import { api, ApiResult } from "../services/api"
import { RootState } from "../store"

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

const photosSlice = createSlice({
  name: "photosSlice",
  initialState: {
    isLoading: false,
    error: null,
    content: emptyContent,
  },
  reducers: {},
  extraReducers: builder => {
    builder
      .addCase(load.pending, state => {
        state.isLoading = true
        state.error = null
        state.content = emptyContent
      })
      .addCase(nextPage.pending, state => {
        state.isLoading = true
        state.error = null
      })
      .addMatcher(isFulfilled(load, nextPage), (state, action) => {
        state.isLoading = false
        state.error = null
        state.content = {
          nextPage: action.payload.currentPage + 1,
          totalPages: action.payload.totalPages,
          photos: [...state.content.photos, ...action.payload.photos],
        }
      })
      .addMatcher<typeof load | typeof nextPage>(isRejectedWithValue(load, nextPage), (state, action) => {
        console.log(`Error fetching episodes: ${JSON.stringify(action)}`)
        state.isLoading = false
        state.content = emptyContent
        switch (action.payload.kind) {
          case "unauthorized":
            state.error = { message: "Unauthorized, make sure you have a valid key in .env file" }
            break
          default:
            state.error = { message: action.payload.kind }
        }
        state.error = { message: JSON.stringify(action.payload) }
      })
  },
})

export const load = createAsyncThunk(
  `${photosSlice.name}/load`,
  async (_, thunkAPI) => {
    const { photosReducer } = thunkAPI.getState() as RootState

    try {
      return await loadPage(photosReducer.content.nextPage)
    } catch (e) {
      throw thunkAPI.rejectWithValue(e)
    }
  },
)

export const nextPage = createAsyncThunk(
  `${photosSlice.name}/nextPage`,
  async (_, thunkAPI) => {
    const { photosReducer } = thunkAPI.getState() as RootState
    try {
      return await loadPage(photosReducer.content.nextPage)
    } catch (e) {
      throw thunkAPI.rejectWithValue(e)
    }
  },
  {
    condition: (_, thunkAPI) => !(thunkAPI.getState() as RootState).photosReducer.isLoading,
  },
)

async function loadPage(page: number) {
  let response: ApiResult<PhotoPage>
  try {
    console.log(`Fetching page ${page}`)
    response = await api.getPhotos(page)
  } catch (e) {
    throw { kind: "unknown", temporary: true, cause: e.message }
  }
  if (response.kind === "ok") {
    return response.data
  } else {
    throw response
  }
}

export const photosState = (state: RootState) => state.photosReducer
export default photosSlice.reducer
