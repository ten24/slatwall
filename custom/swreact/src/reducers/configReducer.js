import { REQUEST_CONFIGURATION, RECIVE_CONFIGURATION, SET_TITLE, SET_TITLE_META } from '../actions/configActions'

const configuration = (state = {}, action) => {
  switch (action.type) {
    case REQUEST_CONFIGURATION:
      return { ...state, isFetching: true }

    case RECIVE_CONFIGURATION:
      return { ...state, ...action.config, isFetching: false }

    case SET_TITLE:
      const { title } = action
      return { ...state, seo: { title } }

    case SET_TITLE_META:
      return { ...state }

    default:
      return state
  }
}

export default configuration
