import * as SlatwalSDK from '@slatwall/slatwall-sdk/dist/client/index'

const sdkURL = process.env.REACT_APP_API_URL
const siteCode = process.env.REACT_APP_SITE_CODE

let SlatwalApiService = SlatwalSDK.init({
  host: sdkURL,
})
// This sadly needs to be a in localStorage or default because of how rollup is setup.

SlatwalApiService.sdkScope.httpService.axios.interceptors.request.use(config => {
  config.headers['SWX-requestSiteCode'] = localStorage.getItem('siteCode') || siteCode
  if (localStorage.getItem('token')) {
    config.headers['Auth-Token'] = `Bearer ${localStorage.getItem('token')}`
  }
  return config
})
SlatwalApiService.sdkScope.httpService.axios.interceptors.response.use(
  successRes => {
    if (successRes.data.token) localStorage.setItem('token', successRes.data.token)
    return successRes
  },
  error => {}
)
export { sdkURL, SlatwalApiService }
