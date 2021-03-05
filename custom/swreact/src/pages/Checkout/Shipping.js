import { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { getCountries, getStateCodeOptionsByCountryCode } from '../../actions/contentActions'
import SwSelect from '../../components/SwSelect/SwSelect'

const ShippingSlide = () => {
  const dispatch = useDispatch()
  const countryCodeOptions = useSelector(state => state.content.countryCodeOptions)
  let [countryCode, setCountryCode] = useState('US')
  const stateCodeOptions = useSelector(state => state.content.stateCodeOptions[countryCode]) || []
  let [stateCode, setStateCode] = useState('')

  useEffect(() => {
    dispatch(getCountries())
    dispatch(getStateCodeOptionsByCountryCode(countryCode))
  }, [dispatch])

  return (
    <>
      {/* <!-- Shipping address--> */}
      <div className="row mb-3">
        <div className="col-sm-12">
          <div className="form-group">
            <label className="w-100" htmlFor="checkout-recieve">
              How do you want to recieve your items?
            </label>
            <div className="form-check form-check-inline custom-control custom-radio d-inline-flex">
              <input className="custom-control-input" type="radio" name="inlineRadioOptions" id="ship" value="option1" defaultChecked />
              <label className="custom-control-label" htmlFor="ship">
                Ship my order
              </label>
            </div>
            <div className="form-check form-check-inline custom-control custom-radio d-inline-flex">
              <input className="custom-control-input" type="radio" name="inlineRadioOptions" id="pickup" value="option2" />
              <label className="custom-control-label" htmlFor="pickup">
                Pick up my order
              </label>
            </div>
          </div>
        </div>
      </div>
      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Shipping address</h2>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-country">Country</label>
            <SwSelect
              id="countryCode"
              value={countryCode}
              onChange={e => {
                e.preventDefault()
                dispatch(getStateCodeOptionsByCountryCode(e.target.value))
                setCountryCode(e.target.value)
              }}
              options={countryCodeOptions}
            />
          </div>
        </div>
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-n">Name</label>
            <input className="form-control" type="text" id="checkout-n" />
          </div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-address-1">Address 1</label>
            <input className="form-control" type="text" id="checkout-address-1" />
          </div>
        </div>
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-address-2">Address 2</label>
            <input className="form-control" type="text" id="checkout-address-2" />
          </div>
        </div>
      </div>
      <div className="row">
        <div className="col-sm-6">
          <div className="form-group">
            <label htmlFor="checkout-address-1">City</label>
            <input className="form-control" type="text" id="checkout-city" />
          </div>
        </div>
        {stateCodeOptions.length > 0 && (
          <div className="col-sm-3">
            <div className="form-group">
              <label htmlFor="checkout-country">State</label>
              <SwSelect
                id="checkout-state"
                value={countryCode}
                onChange={e => {
                  e.preventDefault()
                  setCountryCode(e.target.value)
                }}
                options={stateCodeOptions}
              />
            </div>
          </div>
        )}

        <div className="col-sm-3">
          <div className="form-group">
            <label htmlFor="checkout-zip">ZIP Code</label>
            <input className="form-control" type="text" id="checkout-zip" />
          </div>
        </div>
      </div>
      <div className="custom-control custom-checkbox">
        <input className="custom-control-input" type="checkbox" id="save-address" />
        <label className="custom-control-label" htmlFor="save-address">
          Save this address
        </label>
      </div>
      <div className="custom-control custom-checkbox">
        <input className="custom-control-input" type="checkbox" id="blind-ship" />
        <label className="custom-control-label" htmlFor="blind-ship">
          Select for blind ship
        </label>
      </div>
    </>
  )
}

export default ShippingSlide
