import { useDispatch, useSelector } from 'react-redux'
import { addAddressAndAttachAsShipping, addPickupLocation, addShippingAddressUsingAccountAddress, addShippingMethod, changeOrderFulfillment, getEligibleFulfillmentMethods, getPickupLocations, setPickupDate } from '../../actions/cartActions'
import { AccountAddress, SlideNavigation, SwRadioSelect } from '../../components'
import { useEffect } from 'react'
import { accountAddressSelector, fulfillmentMethodSelector, fulfillmentSelector, pickupLocation, pickupLocationOptions, shippingMethodSelector } from '../../selectors/orderSelectors'
import DatePicker from 'react-datepicker'
import 'react-datepicker/dist/react-datepicker.css'

const FulfillmentPicker = () => {
  const dispatch = useDispatch()
  const { eligibleFulfillmentMethods, orderItems } = useSelector(state => state.cart)
  let selectedFulfillmentMethod = useSelector(fulfillmentMethodSelector)

  return (
    <div className="row mb-3">
      <div className="col-sm-12">
        {eligibleFulfillmentMethods && eligibleFulfillmentMethods.length > 0 && (
          <SwRadioSelect
            label="How do you want to recieve your items?"
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
  return (
    <div className="row mb-3">
      <div className="col-sm-12">
        {orderFulfillments.length > 0 && (
          <SwRadioSelect
            label="How do you want to recieve your items?"
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
              label="Which Location would you like to pickup from?"
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

  useEffect(() => {
    dispatch(getEligibleFulfillmentMethods())
    dispatch(getPickupLocations())
  }, [dispatch])

  return (
    <>
      <FulfillmentPicker />
      {selectedFulfillmentMethod.fulfillmentMethod.fulfillmentMethodType === 'pickup' && <PickupLocationPicker />}
      {selectedFulfillmentMethod.fulfillmentMethod.fulfillmentMethodType === 'shipping' && (
        <AccountAddress
          addressTitle={'Shipping address'}
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
      <SlideNavigation currentStep={currentStep} nextActive={!orderRequirementsList.includes('fulfillment')} />
    </>
  )
}

export { ShippingSlide, PickupLocationPicker, ShippingMethodPicker, FulfillmentPicker }
