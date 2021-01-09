import * as SlatwalSDK from '@slatwall/slatwall-sdk/dist/client/index'
const sdkURL = window.__SDK_URL__

delete window.__SDK_URL__

let SlatwalApiService = SlatwalSDK.init({
  host: sdkURL,
})

export default SlatwalApiService
