import { configureStore } from "@reduxjs/toolkit"
import photosReducer from "./models/photosSlice"

export const store = configureStore({
  reducer: {
    photosReducer: photosReducer,
  },
})

// Infer the `RootState` and `AppDispatch` types from the store itself
export type RootState = ReturnType<typeof store.getState>
// Inferred type: {posts: PostsState, comments: CommentsState, users: UsersState}
export type AppDispatch = typeof store.dispatch
