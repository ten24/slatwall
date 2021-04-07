const ShippingAddressDetails = ({ shippingAddress, shippingAddressNickname }) => {
  const { name, streetAddress, city, stateCode, postalCode } = shippingAddress

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

export { ShippingAddressDetails }
