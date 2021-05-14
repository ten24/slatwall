import { toast } from 'react-toastify'
import { SlatwalApiService, sdkURL, axios } from '../services'
import { getCart, receiveCart, requestCart } from './cartActions'
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

export const login = (email, password) => {
  return async (dispatch, getState) => {
    let { accountID } = getState().userReducer
    if (!accountID.length) {
      dispatch(requestLogin())
      dispatch(requestUser())
      dispatch(requestCart())

      const response = await axios({
        method: 'POST',
        withCredentials: true,
        url: `${sdkURL}api/scope/login`,
        data: {
          emailAddress: email,
          password: password,
          returnJSONObjects: 'account,cart',
        },
        headers: {
          'Content-Type': 'application/json',
        },
      })

      if (response.status === 200 && response.data) {
        console.log('req', response.data)
        dispatch(receiveLogin({ isAuthenticanted: true }))
        dispatch(receiveUser(response.data.account))
        dispatch(receiveCart(response.data.cart))
        toast.success('Login Successful')
      } else {
        errorLogin({})
        toast.error('Incorrect Username or Password')
      }
    }
  }
}

export const createAccount = user => {
  return async dispatch => {}
}
