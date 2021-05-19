import * as SlatwalSDK from '@slatwall/slatwall-sdk/dist/client/index'
// import config from '../config/env'
import store from '../createStore'

const sdkURL = process.env.REACT_APP_API_URL

let SlatwalApiService = SlatwalSDK.init({
  host: sdkURL,
})
SlatwalApiService.sdkScope.httpService.axios.interceptors.request.use(config => {
  const siteCode = store.getState().configuration.site.siteCode
  config.headers['SWX-requestSiteCode'] = siteCode
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
