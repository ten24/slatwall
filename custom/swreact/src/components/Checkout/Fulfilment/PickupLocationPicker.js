import { useDispatch, useSelector } from 'react-redux'
import { addPickupLocation, setPickupDate } from '../../../actions/'
import { SwRadioSelect } from '../../'
import { fulfillmentSelector, shippingMethodSelector, pickupLocationOptions } from '../../../selectors/'
import DatePicker from 'react-datepicker'
import 'react-datepicker/dist/react-datepicker.css'
import { useTranslation } from 'react-i18next'

const PickupLocationPicker = () => {
  const dispatch = useDispatch()
  const pickupLocations = useSelector(pickupLocationOptions)
  const selectedLocation = useSelector(shippingMethodSelector)
  const { orderFulfillmentID, estimatedShippingDate } = useSelector(fulfillmentSelector)
  const { t } = useTranslation()

  const isFutureDate = date => {
    const currentDate = new Date()
    currentDate.setHours(0, 0, 0, 0)
    return date >= currentDate
  }
  return (
    <>
      <div className="row mb-3">
        <div className="col-sm-12">
          <div className="form-group">
            <label htmlFor="locationPickupDate">{t('frontend.checkout.fulfilment.pickup.date')}</label>
            <br />
            <DatePicker
              id="locationPickupDate"
              selected={estimatedShippingDate ? new Date(estimatedShippingDate) : ''}
              showTimeSelect
              timeIntervals={60}
              timeCaption="Time"
              dateFormat="MM/dd/yyyy h:mm aa"
              filterDate={isFutureDate}
              className="form-control"
              onChange={pickupDate => {
                dispatch(
                  setPickupDate({
                    pickupDate: pickupDate.toLocaleString().replace(',', ''),
                    orderFulfillmentID,
                  })
                )
              }}
            />
          </div>
        </div>
      </div>
      <div className="row mb-3">
        <div className="col-sm-12">
          {pickupLocations.length > 0 && (
            <SwRadioSelect
              label={t('frontend.checkout.location_option')}
              options={pickupLocations}
              onChange={value => {
                dispatch(
                  addPickupLocation({
                    value,
                  })
                )
              }}
              selectedValue={selectedLocation.locationID}
            />
          )}
        </div>
      </div>
    </>
  )
}

export { PickupLocationPicker }
