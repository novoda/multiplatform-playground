/**
 * These types indicate the shape of the data you expect to receive from your
 * API endpoint, assuming it's a JSON object like we have.
 */
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

/**
 * The options used to configure apisauce.
 */
export interface ApiConfig {
  /**
   * The URL of the api.
   */
  url: string

  /**
   * Milliseconds before we timeout the request.
   */
  timeout: number

  // TODO is this the right place?
  apiKey: string
}
