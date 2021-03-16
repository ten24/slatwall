import { useDispatch, useSelector } from 'react-redux'
import { addAddressAndAttachAsShipping, addShippingAddressUsingAccountAddress, addShippingMethod, getEligibleFulfillmentMethods } from '../../actions/cartActions'
import SlideNavigation from './SlideNavigation'
import { SwRadioSelect } from '../../components'
import AccountAddress from './AccountAddress'
import { useEffect } from 'react'

const ShippingSlide = ({ currentStep }) => {
  const dispatch = useDispatch()
  const { isFetching, orderRequirementsList, orderFulfillments, eligibleFulfillmentMethods } = useSelector(state => state.cart)
  const accountAddresses = useSelector(state => state.userReducer.accountAddresses)
  let selectedShippingMethodID = ''

  let selectedAccountID = ''

  if (orderFulfillments.length && accountAddresses.length && orderFulfillments[0].accountAddress) {
    const selectAccount = accountAddresses
      .filter(({ accountAddressID }) => {
        return accountAddressID === orderFulfillments[0].accountAddress.accountAddressID
      })
      .map(({ accountAddressID }) => {
        return accountAddressID
      })
    selectedAccountID = selectAccount.length ? selectAccount[0] : null
  }
  if (orderFulfillments[0] && orderFulfillments[0].shippingMethod) {
    selectedShippingMethodID = orderFulfillments[0].shippingMethod.shippingMethodID
  }
  useEffect(() => {
    dispatch(getEligibleFulfillmentMethods())
  }, [dispatch])
  return (
    <>
      <div className="row mb-3">
        <div className="col-sm-12">
          {orderFulfillments.length > 0 && (
            <SwRadioSelect
              label="How do you want to recieve your items?"
              options={orderFulfillments[0].shippingMethodOptions}
              onChange={value => {
                dispatch(
                  addShippingMethod({
                    shippingMethodID: value,
                    fulfillmentID: orderFulfillments[0].orderFulfillmentID,
                  })
                )
              }}
              selectedValue={selectedShippingMethodID}
            />
          )}
        </div>
      </div>
      <div className="row mb-3">
        <div className="col-sm-12">
          {orderFulfillments.length > 0 && (
            <SwRadioSelect
              label="How do you want to recieve your items?"
              options={orderFulfillments[0].shippingMethodOptions}
              onChange={value => {
                dispatch(
                  addShippingMethod({
                    shippingMethodID: value,
                    fulfillmentID: orderFulfillments[0].orderFulfillmentID,
                  })
                )
              }}
              selectedValue={selectedShippingMethodID}
            />
          )}
        </div>
      </div>

      <AccountAddress
        addressTitle={'Shipping address'}
        selectedAccountID={selectedAccountID}
        onSelect={value => {
          dispatch(
            addShippingAddressUsingAccountAddress({
              accountAddressID: value,
              fulfillmentID: orderFulfillments[0].orderFulfillmentID,
            })
          )
          console.log('onSelect', value)
        }}
        onSave={values => {
          dispatch(addAddressAndAttachAsShipping({ ...values }))
          console.log('onSave', values)
        }}
      />
      <SlideNavigation currentStep={currentStep} nextActive={!orderRequirementsList.includes('fulfillment')} />
    </>
  )
}

export default ShippingSlide
