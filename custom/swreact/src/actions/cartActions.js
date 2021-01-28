import { SlatwalApiService } from '../services'

export const REQUEST_CART = 'REQUEST_CART'
export const RECEIVE_CART = 'RECEIVE_CART'
export const CLEAR_CART = 'CLEAR_CART'
export const ADD_TO_CART = 'ADD_TO_CART'
export const REMOVE_FROM_CART = 'REMOVE_FROM_CART'

export const requestCart = () => {
  return {
    type: REQUEST_CART,
  }
}

export const receiveCart = cart => {
  return {
    type: RECEIVE_CART,
    cart,
  }
}

export const clearCart = () => {
  return {
    type: CLEAR_CART,
  }
}

export const addToCart = (skuID, quantity = 1) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.addItem({
      skuID,
      quantity,
      returnJSONObjects: 'cart',
    })

    if (req.isSuccess()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}
export const removeFromCart = () => {
  return async dispatch => {
    // dispatch(requestCart(loginToken))
    // const req = await SlatwalApiService.cart.removeItem()
    // if (req.success()) {
    //   dispatch(receiveCart(req.success().cart))
    // }
  }
}

export const getCart = () => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.get()

    if (req.success()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}
