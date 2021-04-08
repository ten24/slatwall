const CreditCardDetails = ({ creditCardPayment }) => {
  const { paymentMethod, creditCardType, nameOnCreditCard, creditCardLastFour } = creditCardPayment

  return (
    <>
      <h3 className="h6">Payment Method:</h3>
      <p>
        <em>{paymentMethod.paymentMethodName}</em>
        <br />
        {nameOnCreditCard} <br />
        {`${creditCardType} ending in ${creditCardLastFour}`}
      </p>
    </>
  )
}

export { CreditCardDetails }
