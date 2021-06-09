import { useSelector } from 'react-redux'
import { Redirect } from 'react-router'
import { Link } from 'react-router-dom'
import { SlideNavigation, CartLineItem, GiftCardDetails, PickupLocationDetails, ShippingAddressDetails, TermPaymentDetails, BillingAddressDetails, CCDetails } from '../..'
import { fulfillmentSelector, shippingAddressSelector, orderPayment, billingAddressNickname, shippingAddressNicknameSelector, shippingMethodSelector } from '../../../selectors/orderSelectors'
import { useTranslation } from 'react-i18next'

const ReviewSlide = ({ currentStep }) => {
  const cart = useSelector(state => state.cart)
  const { fulfillmentMethod } = useSelector(fulfillmentSelector)
  const payment = useSelector(orderPayment)
  const shippingAddress = useSelector(shippingAddressSelector)
  const shippingMethod = useSelector(shippingMethodSelector)
  let billingNickname = useSelector(billingAddressNickname)
  const { t } = useTranslation()

  let shippingAddressNickname = useSelector(shippingAddressNicknameSelector)
  if (cart.isPlaced) {
    return <Redirect to={'/order-confirmation'} />
  }

  return (
    <>
      <div className="row bg-lightgray p-3 rounded mb-5">
        {fulfillmentMethod.fulfillmentMethodType === 'shipping' && (
          <div className="col-md-4">
            <ShippingAddressDetails shippingAddress={shippingAddress} shippingAddressNickname={shippingAddressNickname} />
            <Link to="/checkout/shipping" className="text-link">
              {t('frontend.core.edit')}
            </Link>
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
            <CCDetails creditCardPayment={payment} />
            <Link to="/checkout/payment" className="text-link">
              {t('frontend.core.edit')}
            </Link>
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

        <div className="col-md-4 mt-4 mb-4">
          <h3 class="h6">{t('frontend.checkout.shippingMethod')}</h3>
          {shippingMethod.shippingMethodName}
        </div>
      </div>

      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">{t('frontend.checkout.review.order')}</h2>
      {cart.orderItems &&
        cart.orderItems.map(({ orderItemID }) => {
          return <CartLineItem key={orderItemID} orderItemID={orderItemID} isDisabled={true} /> // this cannot be index or it wont force a rerender
        })}
      <SlideNavigation currentStep={currentStep} />
    </>
  )
}

export { ReviewSlide }
