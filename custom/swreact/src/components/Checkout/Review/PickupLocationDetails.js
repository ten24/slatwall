import { useTranslation } from 'react-i18next'
const PickupLocationDetails = ({ pickupLocation }) => {
  const { t } = useTranslation()
  return (
    <>
      <h3 className="h6">{t('frontend.checkout.fulfilment.pickup.location')}:</h3>
      <p>{pickupLocation.locationName}</p>
    </>
  )
}

export { PickupLocationDetails }
