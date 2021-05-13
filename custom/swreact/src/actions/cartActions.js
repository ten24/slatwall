import { toast } from 'react-toastify'
import { SlatwalApiService, axios } from '../services'
import { sdkURL } from '../services'
import { receiveUser, requestUser } from './userActions'
import { updateToken } from './authActions'
import { getErrorMessage } from '../utils'

export const REQUEST_CART = 'REQUEST_CART'
export const RECEIVE_CART = 'RECEIVE_CART'
export const CONFIRM_ORDER = 'CONFIRM_ORDER'
export const CLEAR_CART = 'CLEAR_CART'
export const ADD_TO_CART = 'ADD_TO_CART'
export const REMOVE_FROM_CART = 'REMOVE_FROM_CART'
export const SET_ERROR = 'SET_ERROR'

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
export const confirmOrder = (isPlaced = true) => {
  return {
    type: CONFIRM_ORDER,
    isPlaced,
  }
}
export const setError = (error = null) => {
  return {
    type: SET_ERROR,
    error,
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
      dispatch(updateToken(req.success()))
      dispatch(receiveCart(req.success().cart))
    }
  }
}
export const clearCartData = () => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.clear()

    if (req.isSuccess()) {
      dispatch(updateToken(req.success()))
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
      dispatch(updateToken(req.success()))
      dispatch(receiveCart(req.success().cart))
      if (req.success().errors) toast.error(getErrorMessage(req.success().errors))
    } else {
      dispatch(receiveCart())

      toast.error('Error')
    }
  }
}

export const getEligibleFulfillmentMethods = () => {
  return async dispatch => {
    dispatch(requestCart())

    const response = await axios({
      method: 'POST',
      withCredentials: true,
      url: `${sdkURL}api/scope/getEligibleFulfillmentMethods`,
      headers: {
        'Content-Type': 'application/json',
      },
    })
    if (response.status === 200 && response.data) {
      dispatch(updateToken(response.data))
      dispatch(receiveCart({ eligibleFulfillmentMethods: response.data.eligibleFulfillmentMethods }))
    } else {
      dispatch(receiveCart())
    }
  }
}

export const getPickupLocations = () => {
  return async dispatch => {
    dispatch(requestCart())

    const response = await axios({
      method: 'GET',
      withCredentials: true,
      url: `${sdkURL}api/scope/getPickupLocations`,
      headers: {
        'Content-Type': 'application/json',
      },
    })
    if (response.status === 200 && response.data) {
      dispatch(updateToken(response.data))
      dispatch(receiveCart({ pickupLocations: response.data.locations }))
    } else {
      dispatch(receiveCart())
    }
  }
}

export const addPickupLocation = params => {
  return async dispatch => {
    dispatch(requestCart())

    const response = await axios({
      method: 'POST',
      withCredentials: true,
      url: `${sdkURL}api/scope/addPickupFulfillmentLocation`,
      headers: {
        'Content-Type': 'application/json',
      },
      data: {
        ...params,
        returnJSONObjects: 'cart',
      },
    })
    if (response.status === 200 && response.data) {
      dispatch(updateToken(response.data))
      dispatch(receiveCart(response.data.cart))
    } else {
      dispatch(receiveCart())
    }
  }
}
export const setPickupDate = params => {
  return async dispatch => {
    dispatch(requestCart())

    const response = await axios({
      method: 'POST',
      withCredentials: true,
      url: `${sdkURL}api/scope/setPickupDate`,
      headers: {
        'Content-Type': 'application/json',
      },
      data: {
        ...params,
        returnJSONObjects: 'cart',
      },
    })
    if (response.status === 200 && response.data) {
      dispatch(updateToken(response.data))
      dispatch(receiveCart(response.data.cart))
    } else {
      dispatch(receiveCart())
    }
  }
}
export const updateOrderNotes = params => {
  return async dispatch => {
    dispatch(requestCart())

    const response = await axios({
      method: 'POST',
      withCredentials: true,
      url: `${sdkURL}api/scope/updateOrderNotes`,
      headers: {
        'Content-Type': 'application/json',
      },
      data: {
        ...params,
        returnJSONObjects: 'cart',
      },
    })
    if (response.status === 200 && response.data) {
      dispatch(updateToken(response.data))
      dispatch(receiveCart(response.data.cart))
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
      dispatch(updateToken(response.data))
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
    if (req.isSuccess()) {
      dispatch(updateToken(req.success()))
      dispatch(receiveCart(req.success().cart))
    }
  }
}

export const addShippingAddress = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.addShippingAddress(params)

    if (req.isSuccess()) {
      dispatch(updateToken(req.success()))
      dispatch(receiveCart(req.success().cart))
    }
  }
}
export const addShippingAddressUsingAccountAddress = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.addShippingAddressUsingAccountAddress({
      ...params,
      returnJSONObjects: 'cart',
    })

    if (req.isSuccess()) {
      dispatch(updateToken(req.success()))
      dispatch(receiveCart(req.success().cart))
    }
  }
}
export const addShippingMethod = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.addShippingMethod({
      ...params,
      returnJSONObjects: 'cart',
    })

    if (req.isSuccess()) {
      dispatch(updateToken(req.success()))
      dispatch(receiveCart(req.success().cart))
    }
  }
}

// export const addPickupLocation = (params = {}) => {
//   return async dispatch => {
//     dispatch(requestCart())

//     const req = await SlatwalApiService.cart.addPickupLocation(params)

//     if (req.isSuccess()) {
//       dispatch(receiveCart(req.success().cart))
//     }
//   }
// }

export const updateFulfillment = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.updateFulfillment(params)

    if (req.isSuccess()) {
      dispatch(updateToken(req.success()))
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
      dispatch(updateToken(req.success()))
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
      dispatch(updateToken(req.success()))
      dispatch(receiveCart(req.success().cart))
    }
  }
}

export const addBillingAddress = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.addBillingAddress(params)

    if (req.isSuccess()) {
      dispatch(updateToken(req.success()))
      dispatch(receiveCart(req.success().cart))
    }
  }
}

export const addPayment = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())
    const req = await SlatwalApiService.cart.addPayment({
      ...params,
      returnJSONObjects: 'cart,account',
    })

    if (req.isSuccess()) {
      dispatch(updateToken(req.success()))
      dispatch(receiveCart(req.success().cart))
      dispatch(receiveUser(req.success().account))
      if (req.success().errors) dispatch(setError(req.success().errors))
    }
  }
}

export const removePayment = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.removePayment({ ...params, returnJSONObjects: 'cart' })

    if (req.isSuccess()) {
      dispatch(updateToken(req.success()))
      dispatch(receiveCart({ ...req.success().cart }))
    }
  }
}

export const placeOrder = () => {
  return async dispatch => {
    dispatch(requestCart())

    const req = await SlatwalApiService.cart.placeOrder({ returnJSONObjects: 'cart' })

    if (req.isSuccess()) {
      dispatch(updateToken(req.success()))
      dispatch(receiveCart(req.success().cart))
      dispatch(confirmOrder())
    }
  }
}

export const addAddressAndAttachAsShipping = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())
    dispatch(requestUser())

    const response = await axios({
      method: 'POST',
      withCredentials: true, // default
      url: `${sdkURL}api/scope/addEditAccountAddress,addShippingAddressUsingAccountAddress`,
      headers: {
        'Content-Type': 'application/json',
      },
      data: { returnJsonObjects: 'cart,account', ...params },
    })
    if (response.status === 200 && response.data) {
      dispatch(updateToken(response.data))
      dispatch(receiveUser(response.data.account))
      dispatch(receiveCart(response.data.cart))
    } else {
      dispatch(receiveCart())
      dispatch(receiveUser())
    }
  }
}

export const changeOrderFulfillment = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())

    const response = await axios({
      method: 'POST',
      withCredentials: true, // default
      url: `${sdkURL}api/scope/changeOrderFulfillment`,
      headers: {
        'Content-Type': 'application/json',
      },
      data: { returnJsonObjects: 'cart', ...params },
    })
    if (response.status === 200 && response.data) {
      dispatch(updateToken(response.data))
      dispatch(receiveCart(response.data.cart))
    } else {
      dispatch(receiveCart())
    }
  }
}
export const addAddressAndAttachAsBilling = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())
    dispatch(requestUser())

    const response = await axios({
      method: 'POST',
      withCredentials: true, // default
      url: `${sdkURL}api/scope/addEditAccountAddress,addBillingAddressUsingAccountAddress`,
      headers: {
        'Content-Type': 'application/json',
      },
      data: { returnJsonObjects: 'cart,account', ...params },
    })
    if (response.status === 200 && response.data) {
      dispatch(updateToken(response.data))
      dispatch(receiveUser(response.data.account))
      dispatch(receiveCart(response.data.cart))
    } else {
      dispatch(receiveCart())
      dispatch(receiveUser())
    }
  }
}

export const addBillingAddressUsingAccountAddress = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())
    dispatch(requestUser())

    const response = await axios({
      method: 'POST',
      withCredentials: true, // default
      url: `${sdkURL}api/scope/addBillingAddressUsingAccountAddress`,
      headers: {
        'Content-Type': 'application/json',
      },
      data: { returnJsonObjects: 'cart', ...params },
    })
    if (response.status === 200 && response.data) {
      dispatch(updateToken(response.data))
      dispatch(receiveUser(response.data.account))
      dispatch(receiveCart(response.data.cart))
    } else {
      dispatch(receiveUser())
      dispatch(receiveCart())
    }
  }
}

export const addNewAccountAndSetAsBilling = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())
    dispatch(requestUser())

    const response = await axios({
      method: 'POST',
      withCredentials: true, // default
      url: `${sdkURL}api/scope/addNewAccountAddress,addBillingAddressUsingAccountAddress`,
      headers: {
        'Content-Type': 'application/json',
      },
      data: { returnJsonObjects: 'cart,account', ...params },
    })
    if (response.status === 200 && response.data) {
      dispatch(updateToken(response.data))
      dispatch(receiveUser(response.data.account))
      dispatch(receiveCart(response.data.cart))
    } else {
      dispatch(receiveCart())
      dispatch(receiveUser())
    }
  }
}

export const addAddressAndPaymentAndAddToOrder = (params = {}) => {
  return async dispatch => {
    dispatch(requestCart())
    dispatch(requestUser())

    const response = await axios({
      method: 'POST',
      withCredentials: true, // default
      url: `${sdkURL}api/scope/addAccountPaymentMethod`,
      headers: {
        'Content-Type': 'application/json',
      },
      data: { returnJsonObjects: 'cart,account', ...params },
    })
    if (response.status === 200 && response.data) {
      dispatch(updateToken(response.data))
      dispatch(receiveUser(response.data.account))
      dispatch(receiveCart(response.data.cart))
    } else {
      dispatch(receiveCart())
      dispatch(receiveUser())
    }
  }
}
