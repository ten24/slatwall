import { REQUEST_CONTENT, RECIVE_CONTENT } from '../actions/contentActions'

const initState = {
  isFetching: false,
  err: null,
}

const content = (state = initState, action) => {
  switch (action.type) {
    case REQUEST_CONTENT:
      return { ...state, isFetching: true }

    case RECIVE_CONTENT:
      const { content } = action
      return { ...state, ...content, isFetching: false }

    default:
      return state
  }
}

export default content
