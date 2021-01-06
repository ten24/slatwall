import validator from 'validator'
import { SlatwalApiService } from '../services'
import { requestUser, receiveUser } from './userActions'
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
export const logoutUser = () => {
  console.log('logoutUser')
  return async dispatch => {
    dispatch(logout())
  }
}

export const login = (email, password) => {
  console.log('login', email)
  return async dispatch => {
    dispatch(requestLogin())
    dispatch(requestUser())

    const req = await SlatwalApiService.auth.login({
      emailAddress: email,
      password: password,
    })

    if (req.isFail()) {
      dispatch(errorLogin(req.toString()))
    } else {
      dispatch(receiveLogin(req.success().token))
      dispatch(receiveUser(req))
    }
  }
}
