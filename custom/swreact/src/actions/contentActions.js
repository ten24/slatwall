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

export const getContent = (content = {}) => {
  return async (dispatch, getState) => {
    dispatch(requestContent())

    const req = await axios({
      method: 'GET',
      withCredentials: true, // default

      url: `${sdkURL}api/scope/getSlatwallContent`,
      data: content,
    }).then(response => {
      return response.status === 200 ? response.data : ''
    })

    dispatch(reciveContent(req.content))
  }
}
