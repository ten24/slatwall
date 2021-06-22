import { useTranslation } from 'react-i18next'
const GiftCardPayment = () => {
  const { t } = useTranslation()

  return (
    <>
      <h1>{t('frontend.checkout.payment.giftCard.title')}</h1>
    </>
  )
}

export { GiftCardPayment }
