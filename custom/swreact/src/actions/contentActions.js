import axios from 'axios'
import { sdkURL } from '../services'
import { setTitle } from './configActions'

export const REQUEST_CONTENT = 'REQUEST_CONTENT'
export const RECIVE_CONTENT = 'RECIVE_CONTENT'
export const RECIVE_STATE_CODES = 'RECIVE_STATE_CODES'

export const requestContent = () => {
  return {
    type: REQUEST_CONTENT,
  }
}

export const reciveContent = content => {
  return {
    type: RECIVE_CONTENT,
    content,
  }
}
export const reciveStateCodes = codes => {
  return {
    type: RECIVE_STATE_CODES,
    payload: codes,
  }
}

const shouldUseData = (content = {}, request = {}) => {
  let hasAllContent = true
  Object.keys(request).map(requestKey => {
    const hasContent = Object.keys(content)
      .map(key => {
        return key.includes(`${requestKey}/`) ? content : null
      })
      .filter(item => {
        return item
      }).length
    if (!hasContent) {
      hasAllContent = false
    }
  })
  return !hasAllContent
}

export const getContent = (content = {}) => {
  return async (dispatch, getState) => {
    // if (!getState().content.isFetching && shouldUseData(getState().content, content.content)) {
    const { siteCode } = getState().configuration.site
    dispatch(requestContent())
    const response = await axios({
      method: 'POST',
      withCredentials: true,
      url: `${sdkURL}api/scope/getSlatwallContent`,
      headers: {
        'Content-Type': 'application/json',
      },
      data: { ...content, siteCode },
    })
    if (response.status === 200) {
      dispatch(reciveContent({ ...response.data.content }))
    } else {
      dispatch(reciveContent({}))
    }
  }
  // }
}

export const getPageContent = (content = {}, slug = '') => {
  return async (dispatch, getState) => {
    const { siteCode } = getState().configuration.site
    dispatch(requestContent())
    const response = await axios({
      method: 'POST',
      withCredentials: true,
      url: `${sdkURL}api/scope/getSlatwallContent`,
      headers: {
        'Content-Type': 'application/json',
      },
      data: { ...content, siteCode },
    })
    if (response.status === 200) {
      dispatch(reciveContent(response.data.content))
    } else {
      dispatch(reciveContent({}))
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
      dispatch(reciveStateCodes(payload))
    } else {
      dispatch(reciveStateCodes({}))
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
      dispatch(reciveContent({ countryCodeOptions: response.data.countryCodeOptions }))
    } else {
      dispatch(reciveContent({}))
    }
  }
}
export const addContent = (content = {}) => {
  return async dispatch => {
    if (content.setting) {
      dispatch(setTitle(content.setting.contentHTMLTitleString))
    }
    dispatch(reciveContent(content))
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
//       dispatch(reciveContent(response.data.content))
//     } else {
//       dispatch(reciveContent({}))
//     }
//   }
// }
