import { useTranslation } from 'react-i18next'

const TermPaymentDetails = ({ termPayment, hideHeading }) => {
  const { purchaseOrderNumber, paymentMethod } = termPayment
  const { t } = useTranslation()

  return (
    <>
      {!hideHeading && <h3 className="h6">{t('frontend.checkout.payment_method')}</h3>}
      <em>{paymentMethod.paymentMethodName}</em>
      <br />
      {purchaseOrderNumber}
    </>
  )
}
export { TermPaymentDetails }
