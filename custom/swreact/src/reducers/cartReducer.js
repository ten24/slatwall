import { REQUEST_CART, RECEIVE_CART, CLEAR_CART } from '../actions/cartActions'

const initState = {
  orderID: null,
  orderItems: [],
  subtotal: 0,

  total: 0,

  isFetching: false,
  err: null,
}

const cart = (state = initState, action) => {
  switch (action.type) {
    case REQUEST_CART:
      return { ...state, isFetching: true }

    case RECEIVE_CART:
      const { loginToken } = action

      return { ...state, loginToken, isFetching: false, err: null }

    case CLEAR_CART:
      return { ...state, loginToken: null, isFetching: false }

    default:
      return state
  }
}

export default cart
