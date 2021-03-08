import { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { addShippingAddressUsingAccountAddress, addShippingMethod } from '../../actions/cartActions'
import { getCountries, getStateCodeOptionsByCountryCode } from '../../actions/contentActions'
import SwSelect from '../../components/SwSelect/SwSelect'
import { useFormik } from 'formik'
import SlideNavigation from './SlideNavigation'

const ShippingAddress = ({ formik }) => {
  const dispatch = useDispatch()
  const countryCodeOptions = useSelector(state => state.content.countryCodeOptions)
  const stateCodeOptions = useSelector(state => state.content.stateCodeOptions[formik.values.countryCode]) || []
  useEffect(() => {
    dispatch(getCountries())
    dispatch(getStateCodeOptionsByCountryCode(formik.values.countryCode))
  }, [dispatch])
  return (
    <>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-country">Country</label>
            <SwSelect
              id="countryCode"
              value={formik.values.countryCode}
              onChange={e => {
                e.preventDefault()
                dispatch(getStateCodeOptionsByCountryCode(e.target.value))
                formik.handleChange(e)
              }}
              options={countryCodeOptions}
            />
          </div>
        </div>
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-n">Name</label>
            <input className="form-control" type="text" id="checkout-n" value={formik.values.name} onChange={formik.handleChange} />
          </div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-address-1">Address 1</label>
            <input className="form-control" type="text" id="checkout-address-1" value={formik.values.streetAddress} onChange={formik.handleChange} />
          </div>
        </div>
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-address-2">Address 2</label>
            <input className="form-control" type="text" id="checkout-address-2" value={formik.values.street2Address} onChange={formik.handleChange} />
          </div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-address-1">City</label>
            <input className="form-control" type="text" id="checkout-city" value={formik.values.city} onChange={formik.handleChange} />
          </div>
        </div>
        {stateCodeOptions.length > 0 && (
          <div className="col-sm-3">
            <div className="form-group">
              <label htmlFor="checkout-state">State</label>
              <SwSelect
                id="checkout-state"
                value={formik.values.stateCode}
                onChange={e => {
                  e.preventDefault()
                  formik.handleChange(e)
                }}
                options={stateCodeOptions}
              />
            </div>
          </div>
        )}

        <div className="col-sm-3">
          <div className="form-group">
            <label htmlFor="checkout-zip">ZIP Code</label>
            <input className="form-control" type="text" id="checkout-zip" value={formik.values.postalCode} onChange={formik.handleChange} />
          </div>
        </div>
      </div>
      <div className="custom-control custom-checkbox">
        <input className="custom-control-input" type="checkbox" id="save-address" value={formik.values.saveAddress} />
        <label className="custom-control-label" htmlFor="save-address">
          Save this address
        </label>
      </div>
      <div className="custom-control custom-checkbox">
        <input className="custom-control-input" type="checkbox" id="blind-ship" value={formik.values.blindShip} />
        <label className="custom-control-label" htmlFor="blind-ship">
          Select for blind ship
        </label>
      </div>
    </>
  )
}

const ShippingSlide = ({ currentStep }) => {
  const dispatch = useDispatch()
  const accountAddresses = useSelector(state => state.userReducer.accountAddresses)
  const orderFulfillments = useSelector(state => state.cart.orderFulfillments)

  let initialValues = {}
  if (orderFulfillments && orderFulfillments[0] && orderFulfillments[0].shippingAddress) {
    const { streetAddress, street2Address, city, stateCode, postalCode, countrycode, name } = orderFulfillments[0].shippingAddress
    initialValues = {
      name,
      streetAddress,
      street2Address,
      city,
      stateCode,
      postalCode,
      countryCode: countrycode,
    }
  }

  const formik = useFormik({
    enableReinitialize: true,
    initialValues: {
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
      ...initialValues,
    },
    onSubmit: values => {
      // TODO: Dispatch Actions
      console.log('values', values)
    },
  })

  return (
    <>
      {/* <!-- Shipping address--> */}
      <div className="row mb-3">
        <div className="col-sm-12">
          <div className="form-group">
            <label className="w-100" htmlFor="checkout-recieve">
              How do you want to recieve your items?
            </label>
            {orderFulfillments.length > 0 &&
              orderFulfillments[0].shippingMethodOptions.map(({ value, name, shippingMethodCode }) => {
                return (
                  <div key={value} className="form-check form-check-inline custom-control custom-radio d-inline-flex">
                    <input className="custom-control-input" type="radio" name="inlineRadioOptions" id={shippingMethodCode} value={value} defaultChecked={orderFulfillments[0].shippingMethod && value === orderFulfillments[0].shippingMethod.shippingMethodID} />
                    <label
                      className="custom-control-label"
                      htmlFor={shippingMethodCode}
                      onClick={e => {
                        e.preventDefault()
                        dispatch(addShippingMethod(value))
                      }}
                    >
                      {name}
                    </label>
                  </div>
                )
              })}
          </div>
        </div>
      </div>
      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Shipping address</h2>
      {accountAddresses && (
        <div className="row">
          <div className="col-sm-12">
            <div className="form-group">
              <label htmlFor="account-address">Account Address</label>
              <SwSelect
                id="account-address"
                value={(orderFulfillments[0] && orderFulfillments[0].accountAddress && orderFulfillments[0].accountAddress.accountAddressID) || ''}
                onChange={e => {
                  e.preventDefault()
                  dispatch(
                    addShippingAddressUsingAccountAddress({
                      accountAddressID: '101be9e19bed5a70ab2f1dbb07638ff2',
                      fulfillmentID: '',
                      shippingMethodID: '2c91808678024adb01780f5035dc00b1',
                    })
                  )

                  console.log(e.target.value)
                }}
                options={accountAddresses.map(({ accountAddressName, accountAddressID, address: { streetAddress } }) => {
                  return { key: `${accountAddressName} - ${streetAddress}`, value: accountAddressID }
                })}
              />
            </div>
          </div>
        </div>
      )}
      <ShippingAddress formik={formik} />
      <SlideNavigation currentStep={currentStep} handleSubmit={formik.handleSubmit} />
    </>
  )
}

export default ShippingSlide
