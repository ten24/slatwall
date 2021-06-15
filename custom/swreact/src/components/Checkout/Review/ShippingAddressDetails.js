import { useTranslation } from 'react-i18next'

const ShippingAddressDetails = ({ shippingAddress, shippingAddressNickname }) => {
  const { name, streetAddress, city, stateCode, postalCode, emailAddress } = shippingAddress || {}
  const { t } = useTranslation()
  return (
    <>
      <h3 className="h6">{t('frontend.checkout.shipping_address')}</h3>
      <p>
        {shippingAddressNickname && (
          <>
            {shippingAddressNickname}
            <br />
          </>
        )}
        {name} <br />
        {streetAddress} <br />
        {`${city}, ${stateCode} ${postalCode}`} <br />
        {emailAddress && emailAddress}
      </p>
    </>
  )
}

export { ShippingAddressDetails }
