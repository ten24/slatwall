import { REQUEST_CONTENT, RECIVE_CONTENT, RECIVE_STATE_CODES } from '../actions/contentActions'

const initState = {
  countryCodeOptions: [],
  stateCodeOptions: {},
  isFetching: false,
}

const content = (state = initState, action) => {
  switch (action.type) {
    case REQUEST_CONTENT:
      return { ...state, isFetching: true }

    case RECIVE_CONTENT:
      const { content } = action
      return { ...state, ...content, isFetching: false }

    case RECIVE_STATE_CODES:
      return { ...state, stateCodeOptions: { ...state.stateCodeOptions, ...action.payload }, isFetching: false }

    default:
      return state
  }
}

export default content
