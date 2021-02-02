import { softLogout } from './authActions'
import { SlatwalApiService } from '../services'
import { toast } from 'react-toastify'

export const REQUEST_USER = 'REQUEST_USER'
export const RECEIVE_USER = 'RECEIVE_USER'

export const RECEIVE_ACCOUNT_ORDERS = 'RECEIVE_ACCOUNT_ORDERS'
export const REQUEST_ACCOUNT_ORDERS = 'REQUEST_ACCOUNT_ORDERS'

export const CLEAR_USER = 'CLEAR_USER'
export const REQUEST_CREATE_USER = 'REQUEST_CREATE_USER'
export const RECEIVE_CREATE_USER = 'RECEIVE_CREATE_USER'
export const ERROR_CREATE_USER = 'ERROR_CREATE_USER'

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
  return async dispatch => {
    dispatch(requestUser())

    const req = await SlatwalApiService.account.get()

    if (req.isFail()) {
      dispatch(softLogout())
    } else {
      if (req.success().account.accountID === '') {
        dispatch(softLogout())
      } else {
        dispatch(receiveUser(req.success().account))
      }
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

// export const createUser = (email, password, confirmPassword, accountNumber) => {
//   return async dispatch => {
//     dispatch(requestCreateUser())

//     if (!accountNumber || !accountNumber.length)
//       return dispatch(errorCreateUser('Account number is a required field!'))

//     if (!email || !email.length)
//       return dispatch(errorCreateUser('Email is a required field!'))
//     if (!validator.isEmail(email))
//       return dispatch(errorCreateUser('Email is invalid!'))

//     if (!password || !password.length)
//       return dispatch(errorCreateUser('Password is a required field!'))
//     if (password.length < 8)
//       return dispatch(
//         errorCreateUser('Password must be 8 characters or longer!')
//       )

//     if (password !== confirmPassword)
//       return dispatch(errorCreateUser(`Passwords don't match!`))

//     const req = {}

//     //Create Account
//     // slatwall.account.createAccount( {
//     //     emailAddress: newUserAccount + "@ten24web.com",
//     //     emailAddressConfirm: newUserAccount + "@ten24web",
//     //     password: "123456@ABC",
//     //     passwordConfirm: "123456@ABC",
//     //     username: newUserAccount,
//     //     firstName: "Gaurav",
//     //     lastName: "Singh",
//     //     company: "",
//     //     phoneNumber: "",
//     //     organizationFlag: "",
//     //     parentAccountID: "",
//     // } ).then(function (response) {
//     //     console.log("createAccount", response.isFail(), response.isSuccess() );
//     // });
//     if (false) {
//       dispatch(errorCreateUser(err.toString()))
//     } else {
//       const { loginToken } = user
//       dispatch(receiveCreateUser(user))
//       dispatch(requestLogin())
//       dispatch(receiveLogin(loginToken))
//     }
//   }
// }
