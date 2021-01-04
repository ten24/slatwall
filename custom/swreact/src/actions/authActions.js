import validator from 'validator'
import { SlatwalApiService } from '../services'

export const REQUEST_LOGIN = 'REQUEST_LOGIN'
export const RECEIVE_LOGIN = 'RECEIVE_LOGIN'
export const ERROR_LOGIN = 'ERROR_LOGIN'
export const LOGOUT = 'LOGOUT'

export const requestLogin = () => {
  return {
    type: REQUEST_LOGIN,
  }
}

export const receiveLogin = loginToken => {
  return {
    type: RECEIVE_LOGIN,
    loginToken,
  }
}

const errorLogin = err => {
  return {
    type: ERROR_LOGIN,
    err,
  }
}

export const logout = () => {
  return {
    type: LOGOUT,
  }
}

export const login = (email, password) => {
  return async dispatch => {
    dispatch(requestLogin())
    dispatch(requestUser())

    if (!email || !email.length)
      return dispatch(errorLogin('Invalid email or password!'))
    if (!validator.isEmail(email))
      return dispatch(errorLogin('Invalid email or password!'))

    if (!password || !password.length)
      return dispatch(errorLogin('Invalid email or password!'))
    if (password.length < 8)
      return dispatch(errorLogin('Invalid email or password!'))

    const req = SlatwalApiService.auth.login({
      emailAddress: username,
      password: password,
    })

    if (req.isFail()) {
      dispatch(errorLogin(err.toString()))
    } else {
      dispatch(receiveLogin(response.success().token))
      dispatch(receiveUser(res))
    }
  }
}
