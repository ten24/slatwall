import { useSelector } from 'react-redux'
import { fulfillmentSelector, shippingAddressSelector, orderPayment, billingAddressNickname, shippingAddressNicknameSelector } from '../../selectors/orderSelectors'

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

export { BillingAddressDetails }
