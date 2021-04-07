const BillingAddressDetails = ({ orderPayment, billingNickname }) => {
  const { billingAddress } = orderPayment

  return (
    <>
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
    </>
  )
}

export { BillingAddressDetails }
