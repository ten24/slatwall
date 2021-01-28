import { REQUEST_LOGIN, RECEIVE_LOGIN, ERROR_LOGIN, LOGOUT } from '../actions/authActions'

const initState = {
  isAuthenticanted: false,
  isFetching: false,
  err: null,
}

const auth = (state = initState, action) => {
  switch (action.type) {
    case REQUEST_LOGIN:
      return { ...state, isFetching: true }

    case RECEIVE_LOGIN:
      const { isAuthenticanted } = action
      return { ...state, isAuthenticanted, isFetching: false, err: null }

    case ERROR_LOGIN:
      const { err } = action
      return { ...state, err, isFetching: false }

    case LOGOUT:
      return { ...state, isAuthenticanted: false, isFetching: false }

    default:
      return state
  }
}

export default auth
