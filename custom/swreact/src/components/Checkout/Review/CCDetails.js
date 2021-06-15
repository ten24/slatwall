import { useTranslation } from 'react-i18next'

const CCDetails = ({ creditCardPayment, hideHeading = false }) => {
  const { paymentMethod, creditCardType, nameOnCreditCard, creditCardLastFour } = creditCardPayment
  const { t } = useTranslation()

  return (
    <>
      {!hideHeading && <h3 className="h6">{t('frontend.checkout.payment_method')}</h3>}
      <p>
        <em>{paymentMethod.paymentMethodName}</em>
        <br />
        {nameOnCreditCard} <br />
        {`${creditCardType} ending in ${creditCardLastFour}`}
      </p>
    </>
  )
}

export { CCDetails }
