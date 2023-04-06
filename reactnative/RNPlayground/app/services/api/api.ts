/**
 * This Api class lets you define an API endpoint and methods to request
 * data and process it.
 *
 * See the [Backend API Integration](https://github.com/infinitered/ignite/blob/master/docs/Backend-API-Integration.md)
 * documentation for more details.
 */
import { ApiResponse, ApisauceInstance, create } from "apisauce"
import Config from "../../config"
import { GeneralApiProblem, getGeneralApiProblem } from "./apiProblem"

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

  apiKey: string
}

/**
 * Configuring the apisauce instance.
 */
export const DEFAULT_API_CONFIG: ApiConfig = {
  url: Config.API_URL,
  timeout: 10000,
  apiKey: Config.API_KEY,
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
    this.apisauce = create({
      baseURL: this.config.url,
      timeout: this.config.timeout,
      headers: {
        Accept: "application/json",
        Authorization: `Client-ID ${this.config.apiKey}`,
      },
    })
  }

  async handleResponse<ApiIn, DomainOut>(
    request: Promise<ApiResponse<ApiIn>>,
    mapSuccess: (response: ApiResponse<ApiIn>) => DomainOut,
  ): Promise<ApiResult<DomainOut>> {
    try {
      const response = await request
      if (!response.ok) {
        const problem = getGeneralApiProblem(response)
        if (problem) return problem
      }
      return { kind: "ok", data: mapSuccess(response) }
    } catch (e) {
      console.log(`Bad data: ${e.message}`, e.stack)
      return { kind: "bad-data" }
    }
  }

}

export type ApiResult<T> = { kind: "ok"; data: T } | GeneralApiProblem
