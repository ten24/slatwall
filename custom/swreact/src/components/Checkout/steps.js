const CART = 'checkout'
const SHIPPING = 'shipping'
const PAYMENT = 'payment'
const REVIEW = 'review'

const getCurrentStep = path => {
  return (checkOutSteps.filter(step => {
    return step.key === path
  }) || [checkOutSteps[1]])[0]
}

const checkOutSteps = [
  {
    key: CART,
    progress: 1,
    icon: 'shopping-cart',
    name: 'frontend.checkout.cart.heading',
    state: '',
    previous: '',
    next: '',
  },
  {
    key: SHIPPING,
    progress: 2,
    icon: 'shipping-fast',
    name: 'frontend.checkout.shipping.heading',
    state: '',
    next: 'payment',
    previous: '/shopping-cart',
  },
  {
    key: PAYMENT,
    progress: 3,
    icon: 'credit-card',
    name: 'frontend.checkout.payment.heading',
    state: '',
    previous: 'shipping',
    next: 'review',
  },
  {
    key: REVIEW,
    progress: 4,
    icon: 'check-circle',
    name: 'frontend.checkout.review.heading',
    state: '',
    previous: 'payment',
    next: '',
  },
]
export { checkOutSteps, CART, SHIPPING, PAYMENT, REVIEW, getCurrentStep }
