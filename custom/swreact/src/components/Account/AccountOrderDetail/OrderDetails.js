import useFormatCurrency from '../../../hooks/useFormatCurrency'
import { useFormatDateTime } from '../../../hooks/useFormatDate'
import { ShippingAddressDetails, BillingAddressDetails, TermPaymentDetails, GiftCardDetails, CreditCardDetails, PickupLocationDetails } from '../../index'

const OrderDetails = ({ orderInfo, orderFulfillments, orderPayments }) => {
  const { orderOpenDateTime } = orderInfo
  const { orderFulfillment_fulfillmentMethod_fulfillmentMethodType, orderFulfillment_shippingAddress_name, orderFulfillment_shippingAddress_streetAddress, orderFulfillment_shippingAddress_city, orderFulfillment_shippingAddress_stateCode, orderFulfillment_shippingAddress_postalCode, orderFulfillment_pickupLocation_locationName } = orderFulfillments
  const { calculatedTotal, calculatedSubTotal, calculatedTaxTotal, calculatedFulfillmentTotal, calculatedDiscountTotal } = orderInfo
  const { paymentMethod_paymentMethodType, paymentMethod_paymentMethodName, creditCardLastFour, billingAddress_streetAddress, billingAddress_city, billingAddress_stateCode, billingAddress_postalCode, billingAddress_name, purchaseOrderNumber, nameOnCreditCard, creditCardType } = orderPayments
  const [formateDate] = useFormatDateTime({})
  const [formatCurrency] = useFormatCurrency({})
  console.log('orderFulfillments', orderFulfillments)
  return (
    <div className="row align-items-start mb-5 mr-3">
      <div className="col-md-7">
        <div className="row text-sm">
          <div className="col-6 ">
            {orderFulfillment_fulfillmentMethod_fulfillmentMethodType === 'shipping' && <ShippingAddressDetails className="" shippingAddress={{ name: orderFulfillment_shippingAddress_name, streetAddress: orderFulfillment_shippingAddress_streetAddress, city: orderFulfillment_shippingAddress_city, stateCode: orderFulfillment_shippingAddress_stateCode, postalCode: orderFulfillment_shippingAddress_postalCode }} shippingAddressNickname={''} />}
            {orderFulfillment_fulfillmentMethod_fulfillmentMethodType === 'pickup' && <PickupLocationDetails className="" pickupLocation={{ locationName: orderFulfillment_pickupLocation_locationName }} />}
            <h3 className="h6">Date Placed</h3>
            <p>{formateDate(orderOpenDateTime)}</p>
          </div>
          <div className="col-6">
            <BillingAddressDetails billingAddressNickname={''} orderPayment={{ billingAddress: { name: billingAddress_name, streetAddress: billingAddress_streetAddress, city: billingAddress_city, stateCode: billingAddress_stateCode, postalCode: billingAddress_postalCode } }} />
            {paymentMethod_paymentMethodType === 'termPayment' && <TermPaymentDetails termPayment={{ purchaseOrderNumber: purchaseOrderNumber, paymentMethod: { paymentMethodName: paymentMethod_paymentMethodName } }} />}
            {paymentMethod_paymentMethodType === 'giftCard' && <GiftCardDetails />}
            {paymentMethod_paymentMethodType === 'creditCard' && <CreditCardDetails creditCardPayment={{ creditCardType, nameOnCreditCard, creditCardLastFour, paymentMethod: { paymentMethodName: paymentMethod_paymentMethodName } }} />}
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

export default OrderDetails
