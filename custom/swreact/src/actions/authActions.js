import { toast } from 'react-toastify'
import { SlatwalApiService } from '../services'
import { getCart } from './cartActions'
import { requestUser, receiveUser, clearUser } from './userActions'
export const REQUEST_LOGIN = 'REQUEST_LOGIN'
export const RECEIVE_LOGIN = 'RECEIVE_LOGIN'
export const ERROR_LOGIN = 'ERROR_LOGIN'
export const LOGOUT = 'LOGOUT'
export const UPDATE_TOKEN = 'UPDATE_TOKEN'
export const NO_TOKEN = 'NO_TOKEN'

export const requestLogin = () => {
  return {
    type: REQUEST_LOGIN,
  }
}

export const receiveLogin = isAuthenticanted => {
  return {
    type: RECEIVE_LOGIN,
    isAuthenticanted,
  }
}

const errorLogin = err => {
  return {
    type: ERROR_LOGIN,
    err,
  }
}

export const requestLogOut = () => {
  return {
    type: LOGOUT,
  }
}
export const logout = () => {
  return async dispatch => {
    const response = await SlatwalApiService.auth.revokeToken()
    dispatch(softLogout())
    dispatch(getCart())

    if (response.isSuccess()) {
      toast.success('Logout Successful')
    } else {
      toast.error('Logout failed. Please close your browser')
    }
  }
}

export const softLogout = () => {
  return async dispatch => {
    dispatch(requestLogOut())
    dispatch(clearUser())
  }
}

export const updateToken = response => {
  if (response.token) {
    return {
      type: UPDATE_TOKEN,
      payload: response.token,
    }
  }
  return { type: NO_TOKEN }
}

export const login = (email, password) => {
  return async (dispatch, getState) => {
    let { accountID } = getState().userReducer
    if (!accountID.length) {
      dispatch(requestLogin())
      dispatch(requestUser())

      const req = await SlatwalApiService.auth.login({
        emailAddress: email,
        password: password,
      })

      if (req.isFail()) {
        dispatch(errorLogin(req.toString()))
        toast.error('Incorrect Username or Password')
      } else {
        dispatch(updateToken(req.success()))
        dispatch(receiveLogin({ isAuthenticanted: true }))
        dispatch(receiveUser(req))
        toast.success('Login Successful')
      }
    }
  }
}

export const createAccount = user => {
  return async dispatch => {}
}
