/**
 * This Api class lets you define an API endpoint and methods to request
 * data and process it.
 *
 * See the [Backend API Integration](https://github.com/infinitered/ignite/blob/master/docs/Backend-API-Integration.md)
 * documentation for more details.
 */
import { ApiResponse, ApisauceInstance, create } from "apisauce"
import Config from "../../config"
import { PhotoPage } from "../../models/Photo"
import type { ApiConfig, ApiPhotosResponse } from "./api.types"
import { GeneralApiProblem, getGeneralApiProblem } from "./apiProblem"

/**
 * Configuring the apisauce instance.
 */
export const DEFAULT_API_CONFIG: ApiConfig = {
  url: Config.API_URL,
  timeout: 10000,
  apiKey: process.env.UNSPLASH_API_KEY,
}

/**
 * Manages all requests to the API. You can use this class to build out
 * various requests that you need to call from your backend API.
 */
export class Api {
  apisauce: ApisauceInstance
  config: ApiConfig

  /**
   * Set up our API instance. Keep this lightweight!
   */
  constructor(config: ApiConfig = DEFAULT_API_CONFIG) {
    this.config = config
    console.log(`API KEY: ${this.config.apiKey}`)
    console.log(`ENV: ${JSON.stringify(process.env["UNSPLASH_API_KEY"])}`)
    this.apisauce = create({
      baseURL: this.config.url,
      timeout: this.config.timeout,
      headers: {
        Accept: "application/json",
        Authorization: `Client-ID ${this.config.apiKey}`,
      },
    })
  }

  async getPhotos(page: number): Promise<ApiResult<PhotoPage>> {
    const pageSize = 20
    const config = { page: page, per_page: pageSize }
    const mapper = function(response: ApiResponse<ApiPhotosResponse>) {
      const totalItems = Number(response.headers["x-total"])
      return ({
        photos: response.data.map((raw) => ({
          localId: raw.id + page,
          ...raw,
        })),
        currentPage: page,
        totalPages: Math.ceil(totalItems / pageSize),
      })
    }

    const response: ApiResponse<ApiPhotosResponse> = await this.apisauce.get("/photos", config)

    return handleResponse(response, mapper)
  }

}

function handleResponse<ApiIn, DomainOut>(
  response: ApiResponse<ApiIn>,
  mapSuccess: (response: ApiResponse<ApiIn>) => DomainOut,
): ApiResult<DomainOut> {
  if (!response.ok) {
    console.log(response)
    const problem = getGeneralApiProblem(response)
    if (problem) return problem
  }
  try {
    return { kind: "ok", data: mapSuccess(response) }
  } catch (e) {
    console.log(`Bad data: ${e.message}\n${response.data}`, e.stack)
    return { kind: "bad-data" }
  }
}

export type ApiResult<T> = { kind: "ok"; data: T } | GeneralApiProblem
// Singleton instance of the API for convenience
export const api = new Api()
