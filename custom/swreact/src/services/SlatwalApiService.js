import * as SlatwalSDK from '@slatwall/slatwall-sdk/dist/client/index'
// import config from '../config/env'

const sdkURL = process.env.NODE_ENV !== 'development' ? 'https://stoneandberg-admin.ten24dev.com/index.cfm/' : 'http://stoneandberg.local:8906/index.cfm/'

let SlatwalApiService = SlatwalSDK.init({
  host: sdkURL,
})
export { sdkURL, SlatwalApiService }
