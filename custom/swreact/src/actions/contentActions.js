import axios from 'axios'
import { sdkURL } from '../services'

export const REQUEST_CONTENT = 'REQUEST_CONTENT'
export const RECIVE_CONTENT = 'RECIVE_CONTENT'

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

export const getHomePageContent = (content = {}) => {
  return async (dispatch, getState) => {
    dispatch(requestContent())
    const {siteCode} = getState().preload.site
    console.log('siteCode', siteCode)
    const response = await axios({
      method: 'POST',
      withCredentials: true, // default
      url: `${sdkURL}api/scope/getHomePageContent`,
      data: {
        siteCode
      }
    })
    if (response.status === 200) {
      dispatch(reciveContent(response.data.content))
    } else {
      dispatch(reciveContent({}))
    }
  }
}

export const getContent = (content = {}) => {
  return async (dispatch, getState) => {
    const {siteCode} = getState().preload.site
    dispatch(requestContent())
    const response = await axios({
      method: 'POST',
      withCredentials: true, // default

      url: `${sdkURL}api/scope/getSlatwallContent`,
      headers: {
        // Overwrite Axios's automatically set Content-Type
        'Content-Type': 'application/json',
      },
      data: {...content, siteCode},
    })
    if (response.status === 200) {
      dispatch(reciveContent(response.data.content))
    } else {
      dispatch(reciveContent({}))
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
//       dispatch(reciveContent(response.data.content))
//     } else {
//       dispatch(reciveContent({}))
//     }
//   }
// }
