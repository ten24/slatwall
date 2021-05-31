import { useTranslation } from 'react-i18next'

const BillingAddressDetails = ({ orderPayment, billingNickname }) => {
  const { billingAddress } = orderPayment
  const { name, streetAddress, city, stateCode, postalCode, emailAddress } = billingAddress || {}
  const { t } = useTranslation()

  return (
    <>
      <h3 className="h6">{t('frontend.checkout.billing_address')}</h3>
      {billingAddress && (
        <p>
          {billingNickname && (
            <>
              <em>{billingNickname}</em>
              <br />
            </>
          )}
          {name} <br />
          {streetAddress} <br />
          {`${city}, ${stateCode} ${postalCode}`} <br />
          {emailAddress && emailAddress}
        </p>
      )}
    </>
  )
}

export { BillingAddressDetails }
