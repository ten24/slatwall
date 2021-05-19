import { useDispatch, useSelector } from 'react-redux'
import { addAddressAndAttachAsShipping, addPickupLocation, addShippingAddressUsingAccountAddress, addShippingMethod, changeOrderFulfillment, getEligibleFulfillmentMethods, getPickupLocations, setPickupDate } from '../../actions/cartActions'
import { AccountAddress, SlideNavigation, SwRadioSelect, Overlay } from '../../components'
import { useEffect } from 'react'
import { accountAddressSelector, fulfillmentMethodSelector, fulfillmentSelector, pickupLocation, pickupLocationOptions, shippingMethodSelector } from '../../selectors/orderSelectors'
import DatePicker from 'react-datepicker'
import 'react-datepicker/dist/react-datepicker.css'
import { useTranslation } from 'react-i18next'

const FulfillmentPicker = () => {
  const dispatch = useDispatch()
  const { eligibleFulfillmentMethods, orderItems } = useSelector(state => state.cart)
  let selectedFulfillmentMethod = useSelector(fulfillmentMethodSelector)
  const { t } = useTranslation()

  return (
    <div className="row mb-3">
      <div className="col-sm-12">
        {eligibleFulfillmentMethods && eligibleFulfillmentMethods.length > 0 && (
          <SwRadioSelect
            label={t('frontend.checkout.receive_option')}
            options={eligibleFulfillmentMethods}
            onChange={fulfillmentMethodID => {
              const orderItemIDList = orderItems
                .map(orderItem => {
                  return orderItem.orderItemID
                })
                .join()
              dispatch(changeOrderFulfillment({ fulfillmentMethodID, orderItemIDList }))
            }}
            selectedValue={selectedFulfillmentMethod.fulfillmentMethodID}
          />
        )}
      </div>
    </div>
  )
}

const ShippingMethodPicker = () => {
  const dispatch = useDispatch()
  const orderFulfillments = useSelector(state => state.cart.orderFulfillments)
  const selectedShippingMethod = useSelector(shippingMethodSelector)
  const orderFulfillment = useSelector(fulfillmentSelector)
  const { t } = useTranslation()

  return (
    <div className="row mb-3">
      <div className="col-sm-12">
        {orderFulfillments.length > 0 && (
          <SwRadioSelect
            label={t('frontend.checkout.delivery_option')}
            options={orderFulfillment.shippingMethodOptions}
            onChange={value => {
              dispatch(
                addShippingMethod({
                  shippingMethodID: value,
                  fulfillmentID: orderFulfillment.orderFulfillmentID,
                })
              )
            }}
            selectedValue={selectedShippingMethod.shippingMethodID}
          />
        )}
      </div>
    </div>
  )
}

const PickupLocationPicker = () => {
  const dispatch = useDispatch()
  const pickupLocations = useSelector(pickupLocationOptions)
  const selectedLocation = useSelector(pickupLocation)
  const { orderFulfillmentID, estimatedShippingDate } = useSelector(fulfillmentSelector)
  const { t } = useTranslation()

  // @function - returns true if date (coming from datepicker) is greater than Current-Date.
  // @param - date => any date object
  // @returns - Boolean
  // @info - https://reactdatepicker.com/#example-filter-dates
  const isFutureDate = date => {
    const currentDate = new Date()
    currentDate.setHours(0, 0, 0, 0) // set time 00:00 as date coming from datepicker has time 00:00 , just to make user can pick today date
    return date >= currentDate
  }
  return (
    <>
      <div className="row mb-3">
        <div className="col-sm-12">
          <div className="form-group">
            <label htmlFor="locationPickupDate">Pickup Date</label>
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

const ShippingSlide = ({ currentStep }) => {
  const dispatch = useDispatch()
  const { orderRequirementsList } = useSelector(state => state.cart)
  let selectedFulfillmentMethod = useSelector(fulfillmentSelector)
  let selectedAccountID = useSelector(accountAddressSelector)
  const orderFulfillment = useSelector(fulfillmentSelector)
  const { isFetching } = useSelector(state => state.cart)
  const { t } = useTranslation()

  useEffect(() => {
    dispatch(getEligibleFulfillmentMethods())
    dispatch(getPickupLocations())
  }, [dispatch])

  return (
    <>
      <Overlay active={isFetching} spinner>
        <FulfillmentPicker />
        {selectedFulfillmentMethod.fulfillmentMethod.fulfillmentMethodType === 'pickup' && <PickupLocationPicker />}
        {selectedFulfillmentMethod.fulfillmentMethod.fulfillmentMethodType === 'shipping' && (
          <AccountAddress
            addressTitle={ t('frontend.checkout.location_option') }
            selectedAccountID={selectedAccountID}
            onSelect={value => {
              dispatch(
                addShippingAddressUsingAccountAddress({
                  accountAddressID: value,
                  fulfillmentID: orderFulfillment.orderFulfillmentID,
                })
              )
            }}
            onSave={values => {
              dispatch(addAddressAndAttachAsShipping({ ...values }))
            }}
          />
        )}
        {selectedFulfillmentMethod.fulfillmentMethod.fulfillmentMethodType === 'shipping' && selectedAccountID.length > 0 && <ShippingMethodPicker />}
      </Overlay>
      <SlideNavigation currentStep={currentStep} nextActive={!orderRequirementsList.includes('fulfillment')} />
    </>
  )
}

export { ShippingSlide, PickupLocationPicker, ShippingMethodPicker, FulfillmentPicker }
