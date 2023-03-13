import { Instance, SnapshotOut, types } from "mobx-state-tree"
import { PlaygroundStoreModel } from "./PlaygroundStore"

/**
 * A RootStore model.
 */
export const RootStoreModel = types.model("RootStore").props({
    playgroundStore: types.optional(PlaygroundStoreModel, {})
})

/**
 * The RootStore instance.
 */
export interface RootStore extends Instance<typeof RootStoreModel> {}
/**
 * The data of a RootStore.
 */
export interface RootStoreSnapshot extends SnapshotOut<typeof RootStoreModel> {}
