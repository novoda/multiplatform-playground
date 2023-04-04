import { configureStore } from "@reduxjs/toolkit"
import photoReducer from "./features/playground/photoSlice"
import AsyncStorage from "@react-native-async-storage/async-storage"
import { FLUSH, PAUSE, PERSIST, persistReducer, persistStore, PURGE, REGISTER, REHYDRATE } from "redux-persist"

const persistConfig = {
  key: "root-v2",
  storage: AsyncStorage,
}

export const store = configureStore({
  reducer: {
    photo: persistReducer(persistConfig, photoReducer),
  },
  // enhancers: [Reactotron.createEnhancer!()],
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: [FLUSH, REHYDRATE, PAUSE, PERSIST, PURGE, REGISTER],
      },
    }),
})
export const persistor = persistStore(store)

// Infer the `RootState` and `AppDispatch` types from the store itself
export type RootState = ReturnType<typeof store.getState>
// Inferred type: {posts: PostsState, comments: CommentsState, users: UsersState}
export type AppDispatch = typeof store.dispatch
