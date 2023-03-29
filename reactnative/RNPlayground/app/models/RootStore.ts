import { Instance, SnapshotOut, types } from "mobx-state-tree"
import { PhotosScreenStoreModel } from "./PhotosScreenStore"

/**
 * A RootStore model.
 */
export const RootStoreModel = types.model("RootStore").props({
    photosScreenStore: types.optional(PhotosScreenStoreModel, {})
})

/**
 * The RootStore instance.
 */
export interface RootStore extends Instance<typeof RootStoreModel> {}
/**
 * The data of a RootStore.
 */
export interface RootStoreSnapshot extends SnapshotOut<typeof RootStoreModel> {}
