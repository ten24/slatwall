import { sdkURL, axios } from '../services'
import { setTitle } from './configActions'
import queryString from 'query-string'

export const REQUEST_CONTENT = 'REQUEST_CONTENT'
export const RECEIVE_CONTENT = 'RECEIVE_CONTENT'
export const RECEIVE_STATE_CODES = 'RECEIVE_STATE_CODES'

export const requestContent = () => {
  return {
    type: REQUEST_CONTENT,
  }
}

export const receiveContent = content => {
  return {
    type: RECEIVE_CONTENT,
    content,
  }
}
export const receiveStateCodes = codes => {
  return {
    type: RECEIVE_STATE_CODES,
    payload: codes,
  }
}

// const shouldUseData = (content = {}, request = {}) => {
//   let hasAllContent = true
//   Object.keys(request).map(requestKey => {
//     const hasContent = Object.keys(content)
//       .map(key => {
//         return key.includes(`${requestKey}/`) ? content : null
//       })
//       .filter(item => {
//         return item
//       }).length
//     if (!hasContent) {
//       hasAllContent = false
//     }
//   })
//   return !hasAllContent
// }

export const getContent = (content = {}) => {
  return async (dispatch, getState) => {
    // if (!getState().content.isFetching && shouldUseData(getState().content, content.content)) {
    const { site, cmsProvider } = getState().configuration
    if (cmsProvider === 'slatwallCMS') {
      dispatch(requestContent())
      const response = await axios({
        method: 'POST',
        withCredentials: true,
        url: `${sdkURL}api/scope/getSlatwallContent`,
        headers: {
          'Content-Type': 'application/json',
        },
        data: { ...content, siteCode: site.siteCode },
      })
      if (response.status === 200) {
        dispatch(receiveContent({ ...response.data.content }))
      } else {
        dispatch(receiveContent({}))
      }
    }
  }
  // }
}

export const getPageContent = (content = {}, slug = '') => {
  return async (dispatch, getState) => {
    if (getState().content[slug]) {
      return
    }
    dispatch(requestContent())
    const response = await axios({
      method: 'GET',
      withCredentials: true,
      url: `${sdkURL}api/public/content?${queryString.stringify({ 'f:activeFlag': true, 'p:show': 250, ...content }, { arrayFormat: 'comma' })}`,
      headers: {
        'Content-Type': 'application/json',
      },
    })
    if (response.status === 200 && response.data.data && response.data.data.pageRecords) {
      const data = response.data.data.pageRecords.reduce((accumulator, content) => {
        accumulator[content.urlTitlePath] = content
        return accumulator
      }, {})
      dispatch(receiveContent(data))
    } else {
      dispatch(receiveContent({}))
    }
  }
}

export const getStateCodeOptionsByCountryCode = (countryCode = 'US') => {
  return async (dispatch, getState) => {
    dispatch(requestContent())
    const response = await axios({
      method: 'POST',
      withCredentials: true,
      url: `${sdkURL}api/scope/getStateCodeOptionsByCountryCode?countryCode=${countryCode}`,
      headers: {
        'Content-Type': 'application/json',
      },
    })
    if (response.status === 200) {
      let payload = {}
      payload[countryCode] = response.data.stateCodeOptions || []
      dispatch(receiveStateCodes(payload))
    } else {
      dispatch(receiveStateCodes({}))
    }
  }
}
export const getCountries = () => {
  return async (dispatch, getState) => {
    dispatch(requestContent())
    const response = await axios({
      method: 'POST',
      withCredentials: true,
      url: `${sdkURL}api/scope/getCountries`,
      headers: {
        'Content-Type': 'application/json',
      },
    })
    if (response.status === 200) {
      dispatch(receiveContent({ countryCodeOptions: response.data.countryCodeOptions }))
    } else {
      dispatch(receiveContent({}))
    }
  }
}
export const addContent = (content = {}) => {
  return async dispatch => {
    if (content.settings) {
      dispatch(setTitle(content.settings.contentHTMLTitleString))
    }
    dispatch(receiveContent(content))
  }
}
export const getProductTypes = () => {
  return async dispatch => {
    dispatch(requestContent())
    const response = await axios({
      method: 'GET',
      withCredentials: true,
      url: `${sdkURL}api/public/productType?p:show=500`,
      headers: {
        'Content-Type': 'application/json',
      },
    })
    if (response.status === 200 && response.data.data && response.data.data.pageRecords) {
      dispatch(receiveContent({ productTypes: response.data.data.pageRecords }))
    } else {
      dispatch(receiveContent({}))
    }
  }
}
// export const addFormResponse = (content = {}) => {
//   return async (dispatch, getState) => {
//     dispatch(requestContent())
//     const response = await axios({
//       method: 'POST',
//       withCredentials: true, // default

//       url: `${sdkURL}api/scope/getSlatwallContent`,
//       headers: {
//         // Overwrite Axios's automatically set Content-Type
//         'Content-Type': 'application/json',
//       },
//       data: content,
//     })
//     if (response.status === 200) {
//       dispatch(receiveContent(response.data.content))
//     } else {
//       dispatch(receiveContent({}))
//     }
//   }
// }
