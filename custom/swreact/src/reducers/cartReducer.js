import { REQUEST_CART, RECEIVE_CART, CLEAR_CART } from '../actions/cartActions'

const initState = {
  orderID: null,
  orderItems: [],
  subtotal: 0,
  promotionCodes: [],
  appliedPromotionMessages: [{ message: "You're only $16 away from a 15% discount!", errors: {}, promotionRewards: [{ errors: {}, amountType: 'percentageOff', rewardType: 'merchandise', hasErrors: false, amount: 15 }], promotionName: 'Purchase Plus (USA)', qualifierProgress: 86, hasErrors: false }],
  total: 0,
  checkoutStep: '',
  orderFulfillments: [],
  orderRequirementsList: '',
  isFetching: false,
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

    default:
      return { ...state }
  }
}

export default cart
