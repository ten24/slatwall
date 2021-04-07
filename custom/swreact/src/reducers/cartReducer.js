import { CONFIRM_ORDER, REQUEST_CART, RECEIVE_CART, CLEAR_CART } from '../actions/cartActions'

const initState = {
  orderID: null,
  orderItems: [],
  subtotal: 0,
  promotionCodes: [],
  appliedPromotionMessages: [],
  total: 0,
  checkoutStep: '',
  orderPayments: [],
  orderFulfillments: [],
  eligibleFulfillmentMethods: [],
  orderRequirementsList: '',
  isFetching: false,
  isPlaced: false,
  err: null,
}

const cart = (state = initState, action) => {
  switch (action.type) {
    case REQUEST_CART:
      return { ...state, isFetching: true }
    case RECEIVE_CART:
      const { cart } = action
      return { ...state, ...cart, isFetching: false, err: null }
    case CLEAR_CART:
      return { ...state, loginToken: null, isFetching: false }
    case CONFIRM_ORDER:
      return { ...state, loginToken: null, isPlaced: action.isPlaced }

    default:
      return { ...state }
  }
}

export default cart
