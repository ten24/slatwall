import { toast } from 'react-toastify'
import { SlatwalApiService } from '../services'
import axios from 'axios'
import { sdkURL } from '../services'

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
export const getCart = () => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.get()

    if (req.isSuccess()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}
export const clearCartData = () => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.clear()

    if (req.isSuccess()) {
      dispatch(receiveCart(req.success().cart))
    }
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
export const updateItemQuantity = (skuID, quantity = 1) => {
  return async dispatch => {
    dispatch(requestCart())

    // const req = await SlatwalApiService.cart.updateItemQuantity({
    //   'orderItem.sku.skuID': skuID,
    //   'orderItem.qty': parseInt(quantity),
    //   returnJSONObjects: 'cart',
    // })

    // if (req.isSuccess()) {
    //   dispatch(receiveCart(req.success().cart))
    // } else {
    //   dispatch(receiveCart())
    // }

    const response = await axios({
      method: 'POST',
      withCredentials: true, // default
      url: `${sdkURL}api/scope/updateOrderItemQuantity`,
      headers: {
        'Content-Type': 'application/json',
        'Auth-Token': `Bearer ${localStorage.getItem('token')}`,
      },
      data: {
        orderItem: {
          sku: {
            skuID,
          },
          qty: quantity,
        },
        returnJSONObjects: 'cart',
      },
    })
    if (response.status === 200) {
      dispatch(receiveCart(response.data.cart))
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

export const addShippingAddress = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.addShippingAddress(params)

    if (req.isSuccess()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}
export const addShippingAddressUsingAccountAddress = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.addShippingAddressUsingAccountAddress(params)

    if (req.isSuccess()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}
export const addShippingMethod = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.addShippingMethod(params)

    if (req.isSuccess()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}

export const addPickupLocation = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.addPickupLocation(params)

    if (req.isSuccess()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}

export const updateFulfillment = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.updateFulfillment(params)

    if (req.isSuccess()) {
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

export const addBillingAddress = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.addBillingAddress(params)

    if (req.isSuccess()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}

export const addPayment = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.addPayment(params)

    if (req.isSuccess()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}

export const removePayment = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.removePayment(params)

    if (req.isSuccess()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}

export const placeOrder = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.placeOrder(params)

    if (req.isSuccess()) {
      dispatch(receiveCart(req.success().cart))
    }
  }
}
