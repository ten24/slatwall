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
  let billingNickname = useSelector(billingAddressNickname)

  let shippingAddressNickname = useSelector(shippingAddressNicknameSelector)
  if (cart.isPlaced) {
    return <Redirect to={'/order-confirmation'} />
  }

  return (
    <>
      <div className="row bg-lightgray pt-3 pr-3 pl-3 rounded mb-5">
        {fulfillmentMethod.fulfillmentMethodType === 'shipping' && (
          <div className="col-md-4">
            <ShippingAddressDetails shippingAddress={shippingAddress} shippingAddressNickname={shippingAddressNickname} />
          </div>
        )}
        {fulfillmentMethod.fulfillmentMethodType === 'pickup' && (
          <div className="col-md-4">
            <PickupLocationDetails pickupLocation={fulfillmentMethod} />
          </div>
        )}
        <div className="col-md-4">
          <BillingAddressDetails billingAddressNickname={billingNickname} orderPayment={payment} />
        </div>
        {payment.paymentMethod.paymentMethodType === 'creditCard' && (
          <div className="col-md-4">
            <CreditCardDetails creditCardPayment={payment} />
          </div>
        )}
        {payment.paymentMethod.paymentMethodType === 'giftCard' && (
          <div className="col-md-4">
            <GiftCardDetails />
          </div>
        )}
        {payment.paymentMethod.paymentMethodType === 'termPayment' && (
          <div className="col-md-4">
            <TermPaymentDetails termPayment={payment} />
          </div>
        )}
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
