import { sdkURL, axios } from '../services'
import { updateToken } from './authActions'

export const REQUEST_CONFIGURATION = 'REQUEST_CONFIGURATION'
export const RECIVE_CONFIGURATION = 'RECIVE_CONFIGURATION'
export const SET_TITLE = 'SET_TITLE'
export const SET_TITLE_META = 'SET_TITLE_META'

export const setTitle = (title = '') => {
  return {
    type: SET_TITLE,
    title,
  }
}
export const reciveConfiguration = config => {
  return {
    type: RECIVE_CONFIGURATION,
    config,
  }
}
export const requestConfiguration = () => {
  return {
    type: REQUEST_CONFIGURATION,
  }
}

export const getConfiguration = () => {
  return async (dispatch, getState) => {
    dispatch(requestConfiguration())
    const siteCode = getState().configuration.site.siteCode

    axios({
      method: 'POST',
      withCredentials: true, // default
      url: `${sdkURL}api/scope/getConfiguration`,
      headers: {
        'Content-Type': 'application/json',
      },
      data: {
        siteCode: siteCode,
      },
    }).then(response => {
      dispatch(updateToken(response.data))
      if (response.status === 200 && response.data.config && Object.keys(response.data.config).length > 0) {
        dispatch(reciveConfiguration(response.data.config))
      } else {
        dispatch(reciveConfiguration({}))
      }
    })
  }
}
