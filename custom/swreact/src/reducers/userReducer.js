import { REQUEST_CARTS_AND_QUOTES, RECEIVE_CARTS_AND_QUOTES, RECEIVE_WISHLIST, RECEIVE_ACCOUNT_ORDERS, REQUEST_ACCOUNT_ORDERS, REQUEST_USER, RECEIVE_USER, CLEAR_USER, REQUEST_CREATE_USER, RECEIVE_CREATE_USER, ERROR_CREATE_USER } from '../actions/userActions'

const initialState = {
  accountID: '',
  firstName: '',
  lastName: '',
  accountAddresses: [],
  accountPaymentMethods: [],
  primaryEmailAddress: {
    emailAddress: '',
  },
  primaryPhoneNumber: {
    phoneNumber: '',
  },
  favouriteSkus: {
    orderTemplateID: '',
    skusList: [],
    isLoaded: false,
  },
  cartsAndQuotesOnAccount: [],
  company: '',
  verifiedAccountFlag: false,
  isLoaded: false,
  isFetching: false,
  isFetchingOrders: false,
}
const user = (state = initialState, action) => {
  const { user, err, ordersOnAccount, cartsAndQuotesOnAccount, favouriteSkus } = action

  switch (action.type) {
    case REQUEST_USER:
      return { ...state, isFetching: true }

    case REQUEST_CARTS_AND_QUOTES:
      return { ...state, isFetchingOrders: true }

    case RECEIVE_CARTS_AND_QUOTES:
      return { ...state, cartsAndQuotesOnAccount, isFetchingOrders: false }

    case RECEIVE_ACCOUNT_ORDERS:
      return { ...state, ordersOnAccount, isFetchingOrders: false }

    case REQUEST_ACCOUNT_ORDERS:
      return { ...state, isFetchingOrders: true }

    case RECEIVE_USER:
      if (user.loginToken) delete user.loginToken
      return { ...state, ...user, isFetching: false, isLoaded: true }

    case CLEAR_USER:
      return { ...initialState }

    case REQUEST_CREATE_USER:
      return { ...state, isFetching: true }

    case RECEIVE_CREATE_USER:
      if (user.loginToken) delete user.loginToken
      user.isFetching = false
      return { ...state, user }

    case RECEIVE_WISHLIST:
      return { ...state, favouriteSkus: { ...state.favouriteSkus, ...favouriteSkus, isLoaded: true } }

    case ERROR_CREATE_USER:
      return { ...state, err, isFetching: false }

    default:
      return { ...state, isFetching: false, isRedirect: false, err: null }
  }
}

export default user
