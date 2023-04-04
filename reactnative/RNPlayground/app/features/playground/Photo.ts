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
  description: string | null,
  urls: Urls
}

export interface PhotoPage {
  photos: Photo[]
  currentPage: number
  totalPages: number
}