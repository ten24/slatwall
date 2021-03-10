import { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { addShippingAddressUsingAccountAddress, addShippingMethod } from '../../actions/cartActions'
import { getCountries, getStateCodeOptionsByCountryCode } from '../../actions/contentActions'
import { useFormik } from 'formik'
import SlideNavigation from './SlideNavigation'
import { SwRadioSelect } from '../../components'
import { useAddOrderShippingAddress } from '../../hooks/useAPI'
import ShippingAddressForm from './ShippingAddressForm'
const ShippingAddress = ({ orderFulfillment = {} }) => {
  const dispatch = useDispatch()
  const countryCodeOptions = useSelector(state => state.content.countryCodeOptions)
  const cc = orderFulfillment.shippingAddress && orderFulfillment.shippingAddress.countrycode ? orderFulfillment.shippingAddress.countrycode : 'US'
  const stateCodeOptions = useSelector(state => state.content.stateCodeOptions[cc]) || []
  const [isEdit, setEdit] = useState(false)
  let [order, setRequest] = useAddOrderShippingAddress()
  let initialValues = {
    name: '',
    company: '',
    streetAddress: '',
    street2Address: '',
    city: '',
    stateCode: '',
    postalCode: '',
    countryCode: 'US',
    saveAddress: false,
    blindShip: false,
    fulfillmentID: orderFulfillment.orderFulfillmentID,
    returnJSONObjects: 'cart',
  }
  if (orderFulfillment.shippingAddress) {
    const { streetAddress, street2Address, city, stateCode, postalCode, countrycode, name } = orderFulfillment.shippingAddress
    initialValues = {
      ...initialValues,
      name,
      streetAddress,
      street2Address,
      city,
      stateCode,
      postalCode,
      countryCode: countrycode.length ? countrycode : 'US',
    }
  }
  const formik = useFormik({
    enableReinitialize: true,
    initialValues: initialValues,
    onSubmit: values => {
      setRequest({ ...order, isFetching: true, isLoaded: false, params: { ...values }, makeRequest: true })
      setEdit(!isEdit)
    },
  })
  useEffect(() => {
    dispatch(getCountries())
    dispatch(getStateCodeOptionsByCountryCode(formik.values.countryCode))
  }, [dispatch])

  return (
    <>
      <form onSubmit={formik.handleSubmit}>
        <ShippingAddressForm formik={formik} isEdit={isEdit} countryCodeOptions={countryCodeOptions} stateCodeOptions={stateCodeOptions} />
        <div className="d-lg-flex pt-4 mt-3">
          <div className="w-50 pr-3">
            <div className="custom-control custom-checkbox">
              <input disabled={!isEdit} className="custom-control-input" type="checkbox" id="saveAddress" value={formik.values.saveAddress} onChange={formik.handleChange} />
              <label className="custom-control-label" htmlFor="saveAddress">
                Save this address
              </label>
            </div>
            <div className="custom-control custom-checkbox">
              <input disabled={!isEdit} className="custom-control-input" type="checkbox" id="blindShip" value={formik.values.blindShip} onChange={formik.handleChange} />
              <label className="custom-control-label" htmlFor="blindShip">
                Select for blind ship
              </label>
            </div>
          </div>
          <div className="w-50 pl-2">
            {isEdit && (
              <a className="btn btn-outline-primary btn-block" onClick={formik.handleSubmit}>
                <span className="d-none d-sm-inline">Save</span>
              </a>
            )}
            {!isEdit && (
              <a
                className="btn btn-outline-primary btn-block"
                onClick={() => {
                  setEdit(!isEdit)
                }}
              >
                <span className="d-none d-sm-inline">Edit</span>
              </a>
            )}
          </div>
        </div>
      </form>
    </>
  )
}

const ShippingSlide = ({ currentStep }) => {
  const dispatch = useDispatch()
  const accountAddresses = useSelector(state => state.userReducer.accountAddresses)
  const cart = useSelector(state => state.cart)
  const { orderFulfillments } = cart
  const [showAddress, setShowAddress] = useState(false)
  let selectedShippingMethodID = ''

  let selectedAccountID = ''
  if (orderFulfillments[0] && accountAddresses.length) {
    const selectAccount = accountAddresses
      .filter(({ address: { addressID } }) => {
        return addressID === orderFulfillments[0].shippingAddress.addressID
      })
      .map(({ accountAddressID }) => {
        return accountAddressID
      })
    selectedAccountID = selectAccount.length ? selectAccount[0] : null
  }
  if (orderFulfillments[0] && orderFulfillments[0].shippingMethod) {
    selectedShippingMethodID = orderFulfillments[0].shippingMethod.shippingMethodID
  }

  return (
    <>
      {/* <!-- Shipping address--> */}
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
      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Shipping address</h2>
      {accountAddresses && (
        <div className="row">
          <div className="col-sm-12">
            <SwRadioSelect
              label="Account Address"
              options={accountAddresses.map(({ accountAddressName, accountAddressID, address: { streetAddress } }) => {
                return { name: `${accountAddressName} - ${streetAddress}`, value: accountAddressID }
              })}
              onChange={value => {
                if (value === 'new') {
                  setShowAddress(true)
                } else {
                  dispatch(
                    addShippingAddressUsingAccountAddress({
                      accountAddressID: value,
                      fulfillmentID: orderFulfillments[0].orderFulfillmentID,
                    })
                  )
                  setShowAddress(false)
                }
              }}
              newLabel="Add Account Address"
              selectedValue={showAddress || !selectedAccountID ? 'new' : selectedAccountID}
              displayNew={true}
            />
          </div>
        </div>
      )}
      {(showAddress || !selectedAccountID) && <ShippingAddress orderFulfillment={orderFulfillments[0]} />}
      <SlideNavigation currentStep={currentStep} nextActive={!cart.orderRequirementsList.includes('fulfillment')} />
    </>
  )
}

export default ShippingSlide
