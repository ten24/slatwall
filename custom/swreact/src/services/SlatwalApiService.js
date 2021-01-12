import * as SlatwalSDK from '@slatwall/slatwall-sdk/dist/client/index'

const sdkURL = window.__SDK_URL__ && process.env.NODE_ENV !== 'development' ? window.__SDK_URL__ : 'http://stoneandberg.local:8906/index.cfm/'

delete window.__SDK_URL__

let SlatwalApiService = SlatwalSDK.init({
  host: sdkURL,
})

export default SlatwalApiService
