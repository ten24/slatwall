const TermPaymentDetails = ({ termPayment }) => {
  const { purchaseOrderNumber, paymentMethod } = termPayment

  return (
    <>
      <h3 className="h6">Payment Method:</h3>
      <em>{paymentMethod.paymentMethodName}</em>
      <br />
      {purchaseOrderNumber}
    </>
  )
}
export { TermPaymentDetails }
