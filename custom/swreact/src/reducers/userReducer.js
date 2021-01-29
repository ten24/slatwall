import { RECEIVE_ACCOUNT_ORDERS, REQUEST_ACCOUNT_ORDERS, REQUEST_USER, RECEIVE_USER, CLEAR_USER, REQUEST_CREATE_USER, RECEIVE_CREATE_USER, ERROR_CREATE_USER } from '../actions/userActions'

const initialState = {
  accountID: '',
  firstName: '',
  lastName: '',
  accountAddresses: [],
  primaryEmailAddress: {
    emailAddress: '',
  },
  primaryPhoneNumber: {
    phoneNumber: '',
  },
  company: '',
  isFetching: false,
  isFetchingOrders: false,
}
const user = (state = initialState, action) => {
  const { user, err, ordersOnAccount } = action

  switch (action.type) {
    case REQUEST_USER:
      return { ...state, isFetching: true }

    case RECEIVE_ACCOUNT_ORDERS:
      return { ...state, ordersOnAccount, isFetchingOrders: false }

    case REQUEST_ACCOUNT_ORDERS:
      return { ...state, isFetchingOrders: true }

    case RECEIVE_USER:
      if (user.loginToken) delete user.loginToken
      user.isFetching = false
      return { ...state, ...user }

    case CLEAR_USER:
      return { ...initialState }

    case REQUEST_CREATE_USER:
      return { ...state, isFetching: true }

    case RECEIVE_CREATE_USER:
      if (user.loginToken) delete user.loginToken
      user.isFetching = false
      return { ...state, user }

    case ERROR_CREATE_USER:
      return { ...state, err, isFetching: false }

    default:
      return { ...state, isFetching: false, isRedirect: false, err: null }
  }
}

export default user
