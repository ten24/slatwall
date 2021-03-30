import { useSelector } from 'react-redux'
import { Redirect, useHistory } from 'react-router'
import { CartLineItem } from '../../components'
import { fulfillmentSelector, shippingAddressSelector, orderPayment, billingAddressNickname, shippingAddressNicknameSelector } from '../../selectors/orderSelectors'
import SlideNavigation from './SlideNavigation'

const ShippingAddressDetails = () => {
  const { name, streetAddress, city, stateCode, postalCode } = useSelector(shippingAddressSelector)
  let shippingAddressNickname = useSelector(shippingAddressNicknameSelector)
  return (
    <div className="col-md-4">
      <h3 className="h6">Shipping Address:</h3>
      <p>
        {shippingAddressNickname && (
          <>
            <em>{shippingAddressNickname}</em>
            <br />
          </>
        )}
        {name} <br />
        {streetAddress} <br />
        {`${city}, ${stateCode} ${postalCode}`}
      </p>
    </div>
  )
}
const PickupLocationDetails = () => {
  const { pickupLocation } = useSelector(fulfillmentSelector)
  return (
    <div className="col-md-4">
      <h3 className="h6">Pickup Location:</h3>
      <p>{pickupLocation.locationName}</p>
    </div>
  )
}
const CreditCardDetails = () => {
  const { paymentMethod, creditCardType, nameOnCreditCard, creditCardLastFour } = useSelector(orderPayment)

  return (
    <div className="col-md-4">
      <h3 className="h6">Payment Method:</h3>
      <p>
        <em>{paymentMethod.paymentMethodName}</em>
        <br />
        {nameOnCreditCard} <br />
        {`${creditCardType} ending in ${creditCardLastFour}`}
      </p>
    </div>
  )
}
const GiftCardDetails = () => {
  return (
    <div className="col-md-4">
      <h3 className="h6">Payment Method:</h3>
      <p>Gift Card</p>
    </div>
  )
}
const TermPaymentDetails = () => {
  const { purchaseOrderNumber, paymentMethod } = useSelector(orderPayment)

  return (
    <div className="col-md-4">
      <h3 className="h6">Payment Method:</h3>
      <em>{paymentMethod.paymentMethodName}</em>
      <br />
      {purchaseOrderNumber}
    </div>
  )
}
const BillingAddressDetails = () => {
  let billingNickname = useSelector(billingAddressNickname)
  const { billingAddress } = useSelector(orderPayment)

  return (
    <div className="col-md-4">
      <h3 className="h6">Billing Address:</h3>
      {billingAddress && (
        <p>
          {billingNickname && (
            <>
              <em>{billingNickname}</em>
              <br />
            </>
          )}
          {billingAddress.name} <br />
          {billingAddress.streetAddress} <br />
          {`${billingAddress.city}, ${billingAddress.stateCode} ${billingAddress.postalCode}`}
        </p>
      )}
    </div>
  )
}

const ReviewSlide = ({ currentStep }) => {
  const cart = useSelector(state => state.cart)
  const { fulfillmentMethod } = useSelector(fulfillmentSelector)
  const { paymentMethod } = useSelector(orderPayment)
  let history = useHistory()

  if (cart.isPlaced) {
    return <Redirect to={'/order-confirmation'} />
  }

  return (
    <>
      <div className="row bg-lightgray pt-3 pr-3 pl-3 rounded mb-5">
        {fulfillmentMethod.fulfillmentMethodType === 'shipping' && <ShippingAddressDetails />}
        {fulfillmentMethod.fulfillmentMethodType === 'pickup' && <PickupLocationDetails />}
        <BillingAddressDetails />
        {paymentMethod.paymentMethodType === 'creditCard' && <CreditCardDetails />}
        {paymentMethod.paymentMethodType === 'giftCard' && <GiftCardDetails />}
        {paymentMethod.paymentMethodType === 'termPayment' && <TermPaymentDetails />}
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
