import { toast } from 'react-toastify'
import { SlatwalApiService } from '../services'
import { requestUser, receiveUser, clearUser } from './userActions'
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

export const requestLogOut = () => {
  return {
    type: LOGOUT,
  }
}
export const logout = () => {
  return async dispatch => {
    const bearerToken = localStorage.getItem('loginToken')
    const response = await SlatwalApiService.auth.removeToken(bearerToken)
    dispatch(softLogout())
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
        dispatch(receiveLogin(req.success().token))
        dispatch(receiveUser(req))
        toast.success('Login Successful')
      }
    }
  }
}
