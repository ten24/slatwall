export const REQUEST_CONFIGURATION = 'REQUEST_CONFIGURATION'
export const RECIVE_CONFIGURATION = 'REQUEST_CONFIGURATION'
export const SET_TITLE = 'SET_TITLE'
export const SET_TITLE_META = 'SET_TITLE_META'

export const setTitle = (title = '') => {
  return {
    type: SET_TITLE,
    title,
  }
}
