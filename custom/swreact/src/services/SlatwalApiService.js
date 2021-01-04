import * as SlatwalSDK from '@slatwall/slatwall-sdk/dist/client/index'

const hostURL = 'http://slatwalldevelop.local:8906/index.cfm/'
let SlatwalApiService = SlatwalSDK.init({
  host: hostURL,
})

export default SlatwalApiService
