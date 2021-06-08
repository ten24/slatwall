import { useDispatch, useSelector } from 'react-redux'
import { addAddressAndAttachAsShipping, addShippingAddressUsingAccountAddress, addShippingAddress, getEligibleFulfillmentMethods, getPickupLocations } from '../../../actions/cartActions'
import { FulfilmentAddressSelector, SlideNavigation, Overlay, FulfillmentPicker, PickupLocationPicker, ShippingMethodPicker } from '../../../components'
import { useEffect } from 'react'
import { accountAddressSelector, fulfillmentSelector } from '../../../selectors/orderSelectors'
import { useTranslation } from 'react-i18next'

const ShippingSlide = ({ currentStep }) => {
  const dispatch = useDispatch()
  const { orderRequirementsList } = useSelector(state => state.cart)
  let selectedFulfillmentMethod = useSelector(fulfillmentSelector)
  let selectedAccountID = useSelector(accountAddressSelector)
  const orderFulfillment = useSelector(fulfillmentSelector)
  const { isFetching } = useSelector(state => state.cart)

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
          <FulfilmentAddressSelector
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
              if (values.saveAddress) {
                dispatch(addAddressAndAttachAsShipping({ ...values }))
              } else {
                dispatch(addShippingAddress({ ...values, fulfillmentID: orderFulfillment.orderFulfillmentID, returnJSONObjects: 'cart' }))
              }
            }}
          />
        )}
        {selectedFulfillmentMethod.fulfillmentMethod.fulfillmentMethodType === 'shipping' && selectedAccountID.length > 0 && <ShippingMethodPicker />}
      </Overlay>
      <SlideNavigation currentStep={currentStep} nextActive={!orderRequirementsList.includes('fulfillment')} />
    </>
  )
}

export { ShippingSlide }
