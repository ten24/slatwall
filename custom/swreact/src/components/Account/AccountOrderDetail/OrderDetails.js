import { useFormatDateTime, useFormatCurrency } from '../../../hooks/'
import { useSelector } from 'react-redux'
import { ShippingAddressDetails, BillingAddressDetails, TermPaymentDetails, GiftCardDetails, CCDetails, PickupLocationDetails } from '../../'
import { orderPayment } from '../../../selectors/'
import { useTranslation } from 'react-i18next'

const OrderDetails = ({ orderInfo, orderFulfillments, orderPayments }) => {
  const { orderOpenDateTime } = orderInfo
  const { orderFulfillment_shippingAddress_emailAddress, orderFulfillment_fulfillmentMethod_fulfillmentMethodType, orderFulfillment_shippingAddress_name, orderFulfillment_shippingAddress_streetAddress, orderFulfillment_shippingAddress_city, orderFulfillment_shippingAddress_stateCode, orderFulfillment_shippingAddress_postalCode, orderFulfillment_pickupLocation_locationName } = orderFulfillments
  const { calculatedTotal, calculatedSubTotal, calculatedTaxTotal, calculatedFulfillmentTotal, calculatedDiscountTotal } = orderInfo
  const { paymentMethod_paymentMethodType, paymentMethod_paymentMethodName, billingAddress_streetAddress, billingAddress_emailAddress, billingAddress_city, billingAddress_stateCode, billingAddress_postalCode, billingAddress_name, purchaseOrderNumber } = orderPayments
  const [formateDate] = useFormatDateTime({})
  const [formatCurrency] = useFormatCurrency({})
  const payment = useSelector(orderPayment)
  const { t } = useTranslation()

  return (
    <div className="row align-items-start mb-5 mr-3">
      <div className="col-md-7">
        <div className="row text-sm">
          <div className="col-6 ">
            {orderFulfillment_fulfillmentMethod_fulfillmentMethodType === 'shipping' && <ShippingAddressDetails className="" shippingAddress={{ name: orderFulfillment_shippingAddress_name, streetAddress: orderFulfillment_shippingAddress_streetAddress, city: orderFulfillment_shippingAddress_city, emailAddress: orderFulfillment_shippingAddress_emailAddress, stateCode: orderFulfillment_shippingAddress_stateCode, postalCode: orderFulfillment_shippingAddress_postalCode }} shippingAddressNickname={''} />}
            {orderFulfillment_fulfillmentMethod_fulfillmentMethodType === 'pickup' && <PickupLocationDetails className="" pickupLocation={{ locationName: orderFulfillment_pickupLocation_locationName }} />}
            <h3 className="h6">{t('frontend.account.order.datePlaced')}</h3>
            <p>{formateDate(orderOpenDateTime)}</p>
            <h3 className="h6">{t('frontend.order.OrderNo')}</h3>
            <p>{orderPayments.order_orderNumber}</p>
          </div>
          <div className="col-6">
            <BillingAddressDetails billingAddressNickname={''} orderPayment={{ billingAddress: { name: billingAddress_name, streetAddress: billingAddress_streetAddress, city: billingAddress_city, stateCode: billingAddress_stateCode, postalCode: billingAddress_postalCode, emailAddress: billingAddress_emailAddress } }} />
            {paymentMethod_paymentMethodType === 'termPayment' && <TermPaymentDetails termPayment={{ purchaseOrderNumber: purchaseOrderNumber, paymentMethod: { paymentMethodName: paymentMethod_paymentMethodName } }} />}
            {paymentMethod_paymentMethodType === 'giftCard' && <GiftCardDetails />}
            {paymentMethod_paymentMethodType === 'creditCard' && <CCDetails creditCardPayment={payment} />}
          </div>
        </div>
      </div>

      <div className="col-md-5 order-summary border rounded p-3 text-center">
        <h3 className="h6">Order Summary</h3>
        <table className="w-100 text-sm">
          <tbody>
            <tr>
              <td className="text-left">Subtotal:</td>
              <td className="text-right">{formatCurrency(calculatedSubTotal)}</td>
            </tr>
            <tr>
              <td className="text-left">Shipping:</td>
              <td className="text-right">{formatCurrency(calculatedFulfillmentTotal)}</td>
            </tr>
            <tr>
              <td className="text-left">Taxes:</td>
              <td className="text-right">{formatCurrency(calculatedTaxTotal)}</td>
            </tr>
            <tr>
              <td className="text-left">Discounts:</td>
              <td className="text-right">- {formatCurrency(calculatedDiscountTotal)}</td>
            </tr>
          </tbody>
        </table>
        <hr className="mb-4 mt-4" />
        <span className="order-total h3">{formatCurrency(calculatedTotal)}</span>
      </div>
    </div>
  )
}

export { OrderDetails }
