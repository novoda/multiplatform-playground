import { PhotoPage } from "../../models/Photo"
import { ApiResponse } from "apisauce"
import { Api, ApiResult } from "./api"

export class PhotoApi extends Api {

  async getPhotos(page: number): Promise<ApiResult<PhotoPage>> {
    return this.handleResponse(
      this.apisauce.get("/photos", { page: page, per_page: 20 }),
      photosResponseMapper,
    )
  }
}

const photosResponseMapper = (response: ApiResponse<ApiPhotosResponse>) => {
  const totalItems = Number(response.headers["x-total"])
  const { page, per_page } = response.config.params
  console.log(response)
  return ({
    photos: response.data.map((raw) => ({
      localId: raw.id + page,
      ...raw,
    })),
    currentPage: page,
    totalPages: Math.ceil(totalItems / per_page),
  })
}

export interface ApiPhoto {
  id: string
  created_at: string
  updated_at: string
  width: number,
  height: number,
  color: string
  blur_hash: string
  likes: number,
  liked_by_user: false,
  description: string
  user: {
    id: string
    username: string
    name: string
    portfolio_url: string
    bio: string
    location: string
    total_likes: number,
    total_photos: number,
    total_collections: number,
    instagram_username: string
    twitter_username: string
    profile_image: {
      small: string
      medium: string
      large: string
    },
    links: {
      self: string
      html: string
      photos: string
      likes: string
      portfolio: string
    }
  },
  urls: {
    raw: string
    full: string
    regular: string
    small: string
    thumb: string
  },
  links: {
    self: string
    html: string
    download: string
    download_location: string
  }
}

export type ApiPhotosResponse = ApiPhoto[]