import { useSelector } from 'react-redux'
import { Redirect } from 'react-router'
import { CartLineItem, GiftCardDetails, PickupLocationDetails, ShippingAddressDetails, CreditCardDetails, TermPaymentDetails, BillingAddressDetails } from '../../components'
import { fulfillmentSelector, shippingAddressSelector, orderPayment, billingAddressNickname, shippingAddressNicknameSelector } from '../../selectors/orderSelectors'
import SlideNavigation from './SlideNavigation'

const ReviewSlide = ({ currentStep }) => {
  const cart = useSelector(state => state.cart)
  const { fulfillmentMethod } = useSelector(fulfillmentSelector)
  const payment = useSelector(orderPayment)
  const shippingAddress = useSelector(shippingAddressSelector)
  let shippingAddressNickname = useSelector(shippingAddressNicknameSelector)
  if (cart.isPlaced) {
    return <Redirect to={'/order-confirmation'} />
  }

  return (
    <>
      <div className="row bg-lightgray pt-3 pr-3 pl-3 rounded mb-5">
        {fulfillmentMethod.fulfillmentMethodType === 'shipping' && <ShippingAddressDetails shippingAddress={shippingAddress} shippingAddressNickname={shippingAddressNickname} />}
        {fulfillmentMethod.fulfillmentMethodType === 'pickup' && <PickupLocationDetails pickupLocation={fulfillmentMethod} />}
        <BillingAddressDetails />
        {payment.paymentMethod.paymentMethodType === 'creditCard' && <CreditCardDetails creditCardPayment={payment} />}
        {payment.paymentMethod.paymentMethodType === 'giftCard' && <GiftCardDetails />}
        {payment.paymentMethod.paymentMethodType === 'termPayment' && <TermPaymentDetails termPayment={payment} />}
      </div>

      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Review your order</h2>
      {cart.orderItems &&
        cart.orderItems.map(({ orderItemID }) => {
          return <CartLineItem key={orderItemID} orderItemID={orderItemID} isDisabled={true} /> // this cannot be index or it wont force a rerender
        })}
      <SlideNavigation currentStep={currentStep} />
    </>
  )
}

export default ReviewSlide
