import * as SlatwalSDK from '@slatwall/slatwall-sdk/dist/client/index'
import config from '../config/env'

const sdkURL = config.apiUrl
let SlatwalApiService = SlatwalSDK.init({
  host: sdkURL,
})
export { sdkURL, SlatwalApiService }
