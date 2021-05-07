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
    name: 'frontend.checkout.cart',
    state: '',
    previous: '',
    next: '',
  },
  {
    key: SHIPPING,
    progress: 2,
    icon: 'shipping-fast',
    name: 'frontend.checkout.shipping',
    state: '',
    next: 'payment',
    previous: '/shopping-cart',
  },
  {
    key: PAYMENT,
    progress: 3,
    icon: 'credit-card',
    name: 'frontend.checkout.payment',
    state: '',
    previous: 'shipping',
    next: 'review',
  },
  {
    key: REVIEW,
    progress: 4,
    icon: 'check-circle',
    name: 'frontend.checkout.review',
    state: '',
    previous: 'payment',
    next: '',
  },
]
export { checkOutSteps, CART, SHIPPING, PAYMENT, REVIEW, getCurrentStep }
