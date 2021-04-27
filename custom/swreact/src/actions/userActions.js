import { softLogout } from './authActions'
import { SlatwalApiService, sdkURL } from '../services'
import { toast } from 'react-toastify'
import { receiveCart } from './cartActions'
import axios from 'axios'
import { isAuthenticated } from '../utils'

export const REQUEST_USER = 'REQUEST_USER'
export const RECEIVE_USER = 'RECEIVE_USER'

export const REQUEST_WISHLIST = 'REQUEST_WISHLIST'
export const RECEIVE_WISHLIST = 'RECEIVE_WISHLIST'

export const RECEIVE_ACCOUNT_ORDERS = 'RECEIVE_ACCOUNT_ORDERS'
export const REQUEST_ACCOUNT_ORDERS = 'REQUEST_ACCOUNT_ORDERS'

export const CLEAR_USER = 'CLEAR_USER'
export const REQUEST_CREATE_USER = 'REQUEST_CREATE_USER'
export const RECEIVE_CREATE_USER = 'RECEIVE_CREATE_USER'
export const ERROR_CREATE_USER = 'ERROR_CREATE_USER'

export const requestWishlist = () => {
  return {
    type: REQUEST_WISHLIST,
  }
}

export const receiveWishlist = (favouriteSkus = {}) => {
  return {
    type: RECEIVE_WISHLIST,
    favouriteSkus,
  }
}

export const requestUser = () => {
  return {
    type: REQUEST_USER,
  }
}

export const receiveUser = (user = {}) => {
  return {
    type: RECEIVE_USER,
    user,
  }
}

export const clearUser = () => {
  return {
    type: CLEAR_USER,
  }
}

export const requestCreateUser = () => {
  return {
    type: REQUEST_CREATE_USER,
  }
}

export const receiveCreateUser = user => {
  return {
    type: RECEIVE_CREATE_USER,
    user,
  }
}

export const requestAccountOrders = () => {
  return {
    type: REQUEST_ACCOUNT_ORDERS,
  }
}

export const receiveAccountOrders = ordersOnAccount => {
  return {
    type: RECEIVE_ACCOUNT_ORDERS,
    ordersOnAccount,
  }
}

export const getUser = () => {
  return async (dispatch, getState) => {
    dispatch(requestUser())

    const req = await SlatwalApiService.account.get({ returnJSONObjects: 'cart' })

    if (req.isFail()) {
      dispatch(softLogout())
    } else {
      console.log('req.success().account', req.success().account)
      if (req.success().account.accountID.length) {
        dispatch(receiveUser(req.success().account))
      } else {
        dispatch(softLogout())
      }

      dispatch(receiveCart(req.success().cart))
    }
  }
}

export const updateUser = user => {
  return async dispatch => {
    dispatch(requestUser())

    const response = await SlatwalApiService.account.update(user)

    if (response.isSuccess()) {
      toast.success('Update Successful')
      dispatch(receiveUser(response.success().account))
    } else {
      toast.error('Update Failed')
    }
  }
}

export const getAccountOrders = () => {
  return async dispatch => {
    dispatch(requestAccountOrders())
    const req = await SlatwalApiService.account.accountOrders()
    if (req.isFail()) {
      dispatch(receiveAccountOrders([]))
    } else {
      dispatch(receiveAccountOrders(req.success().ordersOnAccount.ordersOnAccount))
    }
  }
}

export const orderDeliveries = () => {
  return async dispatch => {
    const req = await SlatwalApiService.account.orderDeliveries()

    if (req.isFail()) {
    } else {
    }
  }
}

export const addNewAccountAddress = address => {
  return async dispatch => {
    dispatch(requestUser())

    const response = await SlatwalApiService.account.addAddress({ ...address, returnJSONObjects: 'account' })

    if (response.isSuccess()) {
      toast.success('Update Successful')
      dispatch(receiveUser(response.success().account))
    } else {
      dispatch(receiveUser({}))
      toast.error('Error')
    }
  }
}

export const updateAccountAddress = user => {
  return async dispatch => {
    dispatch(requestUser())

    const response = await SlatwalApiService.account.updateAddress({ ...user, returnJSONObjects: 'account' })

    if (response.isSuccess()) {
      toast.success('Update Successful')
      dispatch(receiveUser(response.success().account))
    } else {
      toast.error('Update Failed')
    }
  }
}

export const deleteAccountAddress = accountAddressID => {
  return async dispatch => {
    const response = await SlatwalApiService.account.deleteAddress({ accountAddressID, returnJSONObjects: 'account' })

    if (response.isSuccess()) {
      toast.success('Update Successful')
      dispatch(receiveUser(response.success().account))
    } else {
      toast.error('Update Failed')
    }
  }
}

export const addPaymentMethod = paymentMethod => {
  return async dispatch => {
    const response = await SlatwalApiService.account.addPaymentMethod({ ...paymentMethod, returnJSONObjects: 'account' })

    if (response.isSuccess()) {
      if (response.success().failureActions.length) {
        dispatch(receiveUser())
        toast.error(JSON.stringify(response.success().errors))
      } else {
        toast.success('New Card Saved')
        dispatch(receiveUser(response.success().account))
      }
    } else {
      toast.error('Save Failed')
    }
  }
}

export const updatePaymentMethod = paymentMethod => {
  return async dispatch => {
    const response = await SlatwalApiService.account.updatePaymentMethod({ paymentMethod, returnJSONObjects: 'account' })

    if (response.isSuccess()) {
      toast.success('Update Successful')
      dispatch(receiveUser(response.success().account))
    } else {
      toast.error('Update Failed')
    }
  }
}

export const deletePaymentMethod = accountPaymentMethodID => {
  return async dispatch => {
    const response = await SlatwalApiService.account.deletePaymentMethod({ accountPaymentMethodID, returnJSONObjects: 'account' })

    if (response.isSuccess()) {
      toast.success('Delete Successful')
      dispatch(receiveUser(response.success().account))
    } else {
      toast.error('Delete Failed')
    }
  }
}

export const getFavouriteProducts = () => {
  return async (dispatch, getState) => {
    dispatch(requestWishlist())

    if (!getState().userReducer.isLoaded && isAuthenticated()) {
      const response = await axios({
        method: 'GET',
        withCredentials: true,
        url: `${sdkURL}api/scope/getWishlistItems`,
        headers: {
          'Content-Type': 'application/json',
          'Auth-Token': `Bearer ${localStorage.getItem('token')}`,
        },
      })
      if (response.status === 200 && response.data && response.data.accountWishlistProducts) {
        const skusList = response.data.accountWishlistProducts.map(({ orderTemplateItems_sku_skuID }) => {
          return orderTemplateItems_sku_skuID
        })
        const orderTemplateID = response.data.accountWishlistProducts.length ? response.data.accountWishlistProducts[0].value : ''
        dispatch(
          receiveWishlist({
            skusList,
            orderTemplateID,
          })
        )
      }
    }
  }
}

export const addWishlistItem = (skuID = '') => {
  return async (dispatch, getState) => {
    dispatch(requestWishlist())
    let { isLoaded, orderTemplateID } = getState().userReducer.favouriteSkus
    if (isLoaded && isAuthenticated()) {
      const response = await axios({
        method: 'POST',
        withCredentials: true,
        url: `${sdkURL}api/scope/addWishlistItem,getWishlistItems`,
        headers: {
          'Content-Type': 'application/json',
          'Auth-Token': `Bearer ${localStorage.getItem('token')}`,
        },
        data: { skuID, orderTemplateID },
      })
      if (response.status === 200 && response.data && response.data.accountWishlistProducts) {
        const skusList = response.data.accountWishlistProducts.map(({ orderTemplateItems_sku_skuID }) => {
          return orderTemplateItems_sku_skuID
        })
        orderTemplateID = response.data.accountWishlistProducts.length ? response.data.accountWishlistProducts[0].value : ''
        dispatch(
          receiveWishlist({
            skusList,
            orderTemplateID,
          })
        )
      }
    }
  }
}

export const removeWishlistItem = (removalSkuID = '') => {
  return async (dispatch, getState) => {
    dispatch(requestWishlist())
    let { isLoaded, orderTemplateID } = getState().userReducer.favouriteSkus
    if (isLoaded && isAuthenticated()) {
      const response = await axios({
        method: 'POST',
        withCredentials: true,
        url: `${sdkURL}api/scope/removeWishlistItem,getWishlistItems`,
        headers: {
          'Content-Type': 'application/json',
          'Auth-Token': `Bearer ${localStorage.getItem('token')}`,
        },
        data: { removalSkuID, orderTemplateID },
      })
      if (response.status === 200 && response.data && response.data.accountWishlistProducts) {
        const skusList = response.data.accountWishlistProducts.map(({ orderTemplateItems_sku_skuID }) => {
          return orderTemplateItems_sku_skuID
        })
        orderTemplateID = response.data.accountWishlistProducts.length ? response.data.accountWishlistProducts[0].value : ''
        dispatch(
          receiveWishlist({
            skusList,
            orderTemplateID,
          })
        )
      }
    }
  }
}
