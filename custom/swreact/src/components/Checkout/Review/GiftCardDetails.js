import { useTranslation } from 'react-i18next'

const GiftCardDetails = ({ hideHeading }) => {
  const { t } = useTranslation()
  return (
    <>
      {!hideHeading && <h3 className="h6">{t('frontend.checkout.payment_method')}</h3>}
      <p>Gift Card</p>
    </>
  )
}

export { GiftCardDetails }
