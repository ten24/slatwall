import { REQUEST_LOGIN, RECEIVE_LOGIN, ERROR_LOGIN, LOGOUT } from '../actions/authActions'

const token = localStorage.getItem('token')

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
      return { ...state, isFetching: false }

    case LOGOUT:
      return { ...state, isAuthenticanted: false, isFetching: false }

    case '@@INIT':
      return { ...state, isAuthenticanted: token ? true : false }

    default:
      return { ...state }
  }
}

export default auth
