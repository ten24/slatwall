import { REQUEST_CONTENT, RECEIVE_CONTENT, RECEIVE_STATE_CODES } from '../actions/contentActions'

const initState = {
  productTypes: [],
  countryCodeOptions: [],
  stateCodeOptions: {},
  isFetching: false,
}

const content = (state = initState, action) => {
  switch (action.type) {
    case REQUEST_CONTENT:
      return { ...state, isFetching: true }

    case RECEIVE_CONTENT:
      const { content } = action
      return { ...state, ...content, isFetching: false }

    case RECEIVE_STATE_CODES:
      return { ...state, stateCodeOptions: { ...state.stateCodeOptions, ...action.payload }, isFetching: false }

    default:
      return state
  }
}

export default content
