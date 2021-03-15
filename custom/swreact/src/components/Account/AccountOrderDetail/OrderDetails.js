import useFormatCurrency from '../../../hooks/useFormatCurrency'
import useFormatDate from '../../../hooks/useFormatDate'

const OrderDetails = ({ orderInfo, orderFulfillments, orderPayments }) => {
  const { orderOpenDateTime, billingAddress_streetAddress, billingAddress_city, billingAddress_stateCode, billingAddress_postalCode, billingAddress_name } = orderInfo
  const { orderFulfillment_shippingAddress_name, orderFulfillment_shippingAddress_streetAddress, orderFulfillment_shippingAddress_city, orderFulfillment_shippingAddress_stateCode, orderFulfillment_shippingAddress_postalCode } = orderFulfillments
  const { calculatedTotal, calculatedSubTotal, calculatedTaxTotal, calculatedFulfillmentTotal, calculatedDiscountTotal } = orderInfo
  const { paymentMethod_paymentMethodName, creditCardLastFour } = orderPayments
  const [formateDate] = useFormatDate({})
  const [formatCurrency] = useFormatCurrency({})

  return (
    <div className="row align-items-start mb-5 mr-3">
      <div className="col-md-7">
        <div className="row">
          <div className="col-6">
            <h3 className="h6">Shipping Address</h3>
            <p className="text-sm">
              {orderFulfillment_shippingAddress_name}
              {/* <br />
              {BusinessName} */}
              <br />
              {orderFulfillment_shippingAddress_streetAddress}
              <br />
              {`${orderFulfillment_shippingAddress_city}, ${orderFulfillment_shippingAddress_stateCode} ${orderFulfillment_shippingAddress_postalCode}`}
            </p>

            {/* <h3 className="h6">PO Number</h3>
            <p className="text-sm">{'PONumber'}</p> */}

            <h3 className="h6">Date Placed</h3>
            <p className="text-sm">{formateDate(orderOpenDateTime)}</p>
          </div>
          <div className="col-6">
            <h3 className="h6">Billing Address</h3>
            <p className="text-sm">
              {billingAddress_name}
              {/* <br />
              {billingAddress_BuisnessName} */}
              <br />
              {billingAddress_streetAddress}
              <br />
              {`${billingAddress_city}, ${billingAddress_stateCode} ${billingAddress_postalCode}`}
            </p>

            <h3 className="h6">Payment Method</h3>
            <p className="text-sm">
              {paymentMethod_paymentMethodName}
              <br />
              Card ending in {creditCardLastFour}
            </p>
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
