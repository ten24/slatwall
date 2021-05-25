import * as SlatwalSDK from '@slatwall/slatwall-sdk/dist/client/index'

const sdkURL = process.env.REACT_APP_API_URL

let SlatwalApiService = SlatwalSDK.init({
  host: sdkURL,
})

SlatwalApiService.sdkScope.httpService.axios.interceptors.response.use(
  successRes => {
    if (successRes.data.token) localStorage.setItem('token', successRes.data.token)
    return successRes
  },
  error => {}
)
export { sdkURL, SlatwalApiService }
