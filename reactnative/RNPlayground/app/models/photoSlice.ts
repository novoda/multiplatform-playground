import { createAsyncThunk, createSlice, isRejectedWithValue } from "@reduxjs/toolkit"
import { Photo, PhotoPage } from "./Photo"
import { ApiResult, PhotoApi } from "../services/api"
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

const photoSlice = createSlice({
  name: "photosSlice",
  initialState: {
    isLoading: false,
    error: null,
    content: emptyContent,
  },
  reducers: {
    clear(state) {
      state.isLoading = false
      state.error = null
      state.content = emptyContent
    },
  },
  extraReducers: builder => {
    builder
      .addCase(load.pending, state => {
        state.isLoading = true
        state.error = null
      })
      .addCase(load.fulfilled, (state, action) => {
        state.isLoading = false
        state.error = null
        state.content = {
          nextPage: action.payload.currentPage + 1,
          totalPages: action.payload.totalPages,
          photos: [...state.content.photos, ...action.payload.photos],
        }
      })
      .addMatcher<typeof load>(isRejectedWithValue(load), (state, action) => {
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
  `${photoSlice.name}/load`,
  async (_, thunkAPI) => {
    try {
      const { photo } = thunkAPI.getState() as RootState
      return await loadPage(photo.content.nextPage)
    } catch (e) {
      throw thunkAPI.rejectWithValue(e)
    }
  },
  {
    condition: (_, { getState }) => !(getState() as RootState).photo.isLoading,
  },
)

const api = new PhotoApi()
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

export const { clear } = photoSlice.actions
export const photosState = (state: RootState) => state.photo
export default photoSlice.reducer
