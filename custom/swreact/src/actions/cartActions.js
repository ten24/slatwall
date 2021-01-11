import { SlatwalApiService } from '../services'

export const REQUEST_CART = 'REQUEST_CART'
export const RECEIVE_CART = 'RECEIVE_CART'
export const CLEAR_CART = 'CLEAR_CART'
export const ADD_TO_CART = 'ADD_TO_CART'
export const REMOVE_FROM_CART = 'REMOVE_FROM_CART'

export const requestCart = loginToken => {
  return {
    type: REQUEST_CART,
    loginToken,
  }
}

export const receiveCart = cart => {
  return {
    type: RECEIVE_CART,
    cart,
  }
}

export const clearCart = loginToken => {
  return {
    type: CLEAR_CART,
  }
}

export const addToCart = () => {
  return async dispatch => {
    const loginToken = localStorage.getItem('loginToken')

    dispatch(requestCart(loginToken))

    const req = await SlatwalApiService.cart.get({
      bearerToken: loginToken,
      contentType: 'application/json',
    })

    if (req.success()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}
export const removeFromCart = () => {
  return async dispatch => {
    const loginToken = localStorage.getItem('loginToken')

    dispatch(requestCart(loginToken))

    const req = await SlatwalApiService.cart.get({
      bearerToken: loginToken,
      contentType: 'application/json',
    })

    if (req.success()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}

export const getCart = () => {
  return async dispatch => {
    const loginToken = localStorage.getItem('loginToken')

    dispatch(requestCart(loginToken))

    const req = await SlatwalApiService.cart.get({
      bearerToken: loginToken,
      contentType: 'application/json',
    })

    if (req.success()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}
