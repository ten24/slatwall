const OrderDetails = props => {
  const { name, BusinessName, street, city, state, zip, PONumber, date } = props
  const { billingAddress_street, billingAddress_city, billingAddress_state, billingAddress_zip, billingAddress_Name, billingAddress_BuisnessName } = props
  const { name, BusinessName, street, city, state, zip, PONumber, date } = props
  const { total, subTotal, shipping, taxes, handlingFee, discounts } = props

  return (
    <div className="row align-items-start mb-5 mr-3">
      <div className="col-md-7">
        <div className="row">
          <div className="col-6">
            <h3 className="h6">Shipping Address</h3>
            <p className="text-sm">
              {name}
              <br />
              {BusinessName}
              <br />
              {street}
              <br />
              {`${city}, ${state} ${zip}`}
            </p>

            <h3 className="h6">PO Number</h3>
            <p className="text-sm">{PONumber}</p>

            <h3 className="h6">Date Placed</h3>
            <p className="text-sm">{date}</p>
          </div>
          <div className="col-6">
            <h3 className="h6">Billing Address</h3>
            <p className="text-sm">
              {billingAddress_Name}
              <br />
              {billingAddress_BuisnessName}
              <br />
              {billingAddress_street}
              <br />
              {`${billingAddress_city}, ${billingAddress_state} ${billingAddress_zip}`}
            </p>

            <h3 className="h6">Payment Method</h3>
            <p className="text-sm">
              Credit Card
              <br />
              Visa ending in x4172
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
              <td className="text-right">${subTotal}</td>
            </tr>
            <tr>
              <td className="text-left">Shipping:</td>
              <td className="text-right">${shipping}</td>
            </tr>
            <tr>
              <td className="text-left">Taxes:</td>
              <td className="text-right">${taxes}</td>
            </tr>
            <tr>
              <td className="text-left">Handling Fee:</td>
              <td className="text-right">${handlingFee}</td>
            </tr>
            {discounts && (
              <tr>
                <td className="text-left">Discounts:</td>
                <td className="text-right">- ${discounts}</td>
              </tr>
            )}
          </tbody>
        </table>
        <hr className="mb-4 mt-4" />
        <span className="order-total h3">${total}</span>
      </div>
    </div>
  )
}

export default OrderDetails
