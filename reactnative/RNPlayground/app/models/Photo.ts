import { Instance, SnapshotIn, SnapshotOut, types } from "mobx-state-tree";

const UrlsModel = types.model({
    raw: types.string,
    full: types.string,
    small: types.string,
    thumb: types.string,
    regular: types.string,
})

export const PhotoModel = types.model({
    localId: types.identifier,
    id: types.string,
    color: types.string,
    description: types.maybeNull(types.string),
    urls: UrlsModel
})

export interface Photo extends Instance<typeof PhotoModel> { }
export interface PhotoSnapshotOut extends SnapshotOut<typeof PhotoModel> { }
export interface PhotoSnapshotIn extends SnapshotIn<typeof PhotoModel> { }

export interface PhotoPage {
    photos: PhotoSnapshotIn[]
    currentPage: number
    totalPages: number
}