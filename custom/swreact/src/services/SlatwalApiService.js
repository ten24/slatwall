import * as SlatwalSDK from '@slatwall/slatwall-sdk/dist/client/index'
// import config from '../config/env'

const sdkURL = process.env.REACT_APP_API_URL

let SlatwalApiService = SlatwalSDK.init({
  host: sdkURL,
})
export { sdkURL, SlatwalApiService }
