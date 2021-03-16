import { useDispatch, useSelector } from 'react-redux'
import { addAddressAndAttachAsShipping, addShippingAddressUsingAccountAddress, addShippingMethod, changeOrderFulfillment, getEligibleFulfillmentMethods } from '../../actions/cartActions'
import SlideNavigation from './SlideNavigation'
import { SwRadioSelect } from '../../components'
import AccountAddress from './AccountAddress'
import { useEffect } from 'react'
import { accountAddressSelector, fulfillmentMethodSelector, fulfillmentSelector, shippingMethodSelector } from '../../selectors/orderSelectors'

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

const ShippingSlide = ({ currentStep }) => {
  const dispatch = useDispatch()
  const { isFetching, orderRequirementsList } = useSelector(state => state.cart)
  let selectedFulfillmentMethod = useSelector(fulfillmentSelector)
  let selectedAccountID = useSelector(accountAddressSelector)
  const orderFulfillment = useSelector(fulfillmentSelector)

  useEffect(() => {
    dispatch(getEligibleFulfillmentMethods())
  }, [dispatch])

  return (
    <>
      <FulfillmentPicker />
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

export default ShippingSlide
