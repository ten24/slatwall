const TermPaymentDetails = ({ termPayment }) => {
  const { purchaseOrderNumber, paymentMethod } = termPayment

  return (
    <div className="col-md-4">
      <h3 className="h6">Payment Method:</h3>
      <em>{paymentMethod.paymentMethodName}</em>
      <br />
      {purchaseOrderNumber}
    </div>
  )
}
export { TermPaymentDetails }
