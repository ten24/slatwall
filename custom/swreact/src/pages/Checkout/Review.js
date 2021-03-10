import { useSelector } from 'react-redux'
import { CartLineItem } from '../../components'

const ReviewSlide = () => {
  const cart = useSelector(state => state.cart)
  const orderPayments = useSelector(state => state.cart.orderPayments)
  const orderFulfillments = useSelector(state => state.cart.orderFulfillments)
  const accountPaymentMethods = useSelector(state => state.userReducer.accountPaymentMethods)
  const accountAddresses = useSelector(state => state.userReducer.accountAddresses)
  const { paymentMethod, billingAddress, creditCardType, nameOnCreditCard, creditCardLastFour } = orderPayments.length ? orderPayments[0] : {}
  const { name, streetAddress, city, stateCode, postalCode } = orderFulfillments.length ? orderFulfillments[0].shippingAddress : {}
  let shippingAddressNickname = ''
  if (orderFulfillments.length) {
    shippingAddressNickname = accountAddresses
      .filter(({ address: { addressID } }) => {
        return addressID === orderFulfillments[0].shippingAddress.addressID
      })
      .map(({ accountAddressName }) => {
        return accountAddressName
      })
    shippingAddressNickname = shippingAddressNickname.length ? shippingAddressNickname[0] : null
  }
  let billingAddressNickname = ''
  if (orderPayments.length && orderPayments[0].accountPaymentMethod) {
    billingAddressNickname = accountPaymentMethods
      .filter(({ accountPaymentMethodID }) => {
        return accountPaymentMethodID === orderPayments[0].accountPaymentMethod.accountPaymentMethodID
      })
      .map(({ accountPaymentMethodName }) => {
        return accountPaymentMethodName
      })
    billingAddressNickname = billingAddressNickname.length ? billingAddressNickname[0] : null
  }

  return (
    <>
      <div className="row bg-lightgray pt-3 pr-3 pl-3 rounded mb-5">
        <div className="col-md-4">
          <h3 className="h6">Shipping Address:</h3>
          {orderFulfillments.length > 0 && orderFulfillments[0].shippingAddress && (
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
          )}
        </div>
        <div className="col-md-4">
          <h3 className="h6">Billing Address:</h3>
          {billingAddress && (
            <p>
              {billingAddressNickname && (
                <>
                  <em>{billingAddressNickname}</em>
                  <br />
                </>
              )}
              {billingAddress.name} <br />
              {billingAddress.streetAddress} <br />
              {`${billingAddress.city}, ${billingAddress.stateCode} ${billingAddress.postalCode}`}
            </p>
          )}
        </div>
        <div className="col-md-4">
          <h3 className="h6">Payment Method:</h3>
          {paymentMethod && (
            <p>
              <em>{paymentMethod.paymentMethodName}</em>
              <br />
              {nameOnCreditCard} <br />
              {`${creditCardType} ending in ${creditCardLastFour}`}
            </p>
          )}
        </div>
      </div>

      {/* <!-- Order Items --> */}
      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Review your order</h2>
      {cart.orderItems &&
        cart.orderItems.map(({ orderItemID }) => {
          return <CartLineItem key={orderItemID} orderItemID={orderItemID} isDisabled={true} /> // this cannot be index or it wont force a rerender
        })}
    </>
  )
}

export default ReviewSlide
