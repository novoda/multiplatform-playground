import { types } from "mobx-state-tree"

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

export type Urls = {
    raw: string,
    full: string,
    small: string,
    thumb: string,
    regular: string,
}

export type Photo = {
    localId: string,
    id: string,
    color: string,
    description: string|null,
    urls: Urls
}

export interface PhotoPage {
    photos: Photo[]
    currentPage: number
    totalPages: number
}