import * as SlatwalSDK from '@slatwall/slatwall-sdk/dist/client/index'

const sdkURL = process.env.NODE_ENV !== 'development' ? 'https://stoneandberg-admin.ten24dev.com/index.cfm/' : 'https://stoneandberg-admin.ten24dev.com/index.cfm/'

let SlatwalApiService = SlatwalSDK.init({
  host: sdkURL,
})
export { sdkURL, SlatwalApiService }
