import { toast } from 'react-toastify'
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
    } else {
      dispatch(receiveCart())
    }
  }
}
export const updateItemQuantity = (skuID, fulfillmentMethodID, quantity = 1) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.updateItemQuantity({
      'orderItem.sku.skuID': skuID,
      'orderItem.qty': parseInt(quantity),
      'orderItem.fulfillmentMethodID': fulfillmentMethodID,
      returnJSONObjects: 'cart',
    })

    if (req.isSuccess()) {
      dispatch(receiveCart(req.success().cart))
    } else {
      dispatch(receiveCart())
    }
  }
}
export const removeItem = orderItemID => {
  return async dispatch => {
    dispatch(requestCart())
    const req = await SlatwalApiService.cart.removeItem({
      orderItemID,
      returnJSONObjects: 'cart',
    })
    if (req.success()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}

export const applyPromoCode = promotionCode => {
  return async dispatch => {
    dispatch(requestCart())
    const req = await SlatwalApiService.cart.applyPromoCode({
      promotionCode,
      returnJSONObjects: 'cart',
    })
    if (req.success()) {
      const { cart, errors } = req.success()
      if (errors) {
        const errorMessages = Object.keys(errors).map(key => {
          return errors[key]
        })
        toast.error(errorMessages.join(' '))
      }
      dispatch(receiveCart(cart))
    }
  }
}
export const removePromoCode = (promotionCode, promotionCodeID) => {
  return async dispatch => {
    dispatch(requestCart())
    const req = await SlatwalApiService.cart.removePromoCode({
      promotionCode,
      promotionCodeID,
      returnJSONObjects: 'cart',
    })
    if (req.success()) {
      dispatch(receiveCart(req.success().cart))
    }
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
