import {
  REQUEST_LOGIN,
  RECEIVE_LOGIN,
  ERROR_LOGIN,
  LOGOUT,
} from '../actions/authActions'

const loginToken = localStorage.getItem('loginToken')

const initState = {
  loginToken,
  isFetching: false,
  err: null,
}

const auth = (state = initState, action) => {
  switch (action.type) {
    case REQUEST_LOGIN:
      return { ...state, isFetching: true }

    case RECEIVE_LOGIN:
      const { loginToken } = action
      localStorage.setItem('loginToken', loginToken)

      return { ...state, loginToken, isFetching: false, err: null }

    case ERROR_LOGIN:
      const { err } = action
      return { ...state, err, isFetching: false }

    case LOGOUT:
      localStorage.removeItem('loginToken')

      return { ...state, loginToken: null, isFetching: false }

    default:
      return state
  }
}

export default auth
