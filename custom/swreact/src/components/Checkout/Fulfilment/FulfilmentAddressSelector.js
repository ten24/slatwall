import { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { getCountries, getStateCodeOptionsByCountryCode } from '../../../actions/contentActions'
import { useFormik } from 'formik'
import { SwRadioSelect, SwSelect } from '../..'
import { useTranslation } from 'react-i18next'
let initialValues = {
  name: '',
  company: '',
  streetAddress: '',
  street2Address: '',
  city: '',
  stateCode: '',
  emailAddress: '',
  postalCode: '',
  countryCode: 'US',
  accountAddressName: '',
  saveAddress: false,
  blindShip: false,
}
const BillingAddress = ({ onSave }) => {
  const dispatch = useDispatch()
  const isFetching = useSelector(state => state.content.isFetching)
  const countryCodeOptions = useSelector(state => state.content.countryCodeOptions)
  const stateCodeOptions = useSelector(state => state.content.stateCodeOptions)
  const [isEdit, setEdit] = useState(true)
  const { t } = useTranslation()

  const formik = useFormik({
    enableReinitialize: false,
    initialValues: initialValues,
    onSubmit: values => {
      setEdit(!isEdit)
      onSave(values)
    },
  })
  useEffect(() => {
    if (countryCodeOptions.length === 0 && !isFetching) {
      dispatch(getCountries())
    }
    if (!stateCodeOptions[formik.values.countryCode] && !isFetching) {
      dispatch(getStateCodeOptionsByCountryCode(formik.values.countryCode))
    }
  }, [dispatch, formik, stateCodeOptions, countryCodeOptions, isFetching])

  return (
    <>
      <form onSubmit={formik.handleSubmit}>
        <div className="row">
          <div className="col-sm-6">
            <div className="form-group">
              <label htmlFor="checkout-country">{t('frontend.account.countryCode')}</label>
              <SwSelect
                id="countryCode"
                disabled={!isEdit}
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
              <label htmlFor="name">{t('frontend.account.name')}</label>
              <input disabled={!isEdit} className="form-control" type="text" id="name" value={formik.values.name} onChange={formik.handleChange} />
            </div>
          </div>
        </div>
        <div className="row">
          <div className="col-sm-6">
            <div className="form-group">
              <label htmlFor="emailAddress">{t('frontend.account.emailAddress')}</label>
              <input disabled={!isEdit} className="form-control" type="text" id="emailAddress" value={formik.values.emailAddress} onChange={formik.handleChange} />
            </div>
          </div>
          <div className="col-sm-6">
            <div className="form-group"></div>
          </div>
        </div>
        <div className="row">
          <div className="col-sm-6">
            <div className="form-group">
              <label htmlFor="streetAddress">{t('frontend.account.streetAddress')}</label>
              <input disabled={!isEdit} className="form-control" type="text" id="streetAddress" value={formik.values.streetAddress} onChange={formik.handleChange} />
            </div>
          </div>
          <div className="col-sm-6">
            <div className="form-group">
              <label htmlFor="street2Address">{t('frontend.account.street2Address')}</label>
              <input disabled={!isEdit} className="form-control" type="text" id="street2Address" value={formik.values.street2Address} onChange={formik.handleChange} />
            </div>
          </div>
        </div>
        <div className="row">
          <div className="col-sm-6">
            <div className="form-group">
              <label htmlFor="city">{t('frontend.account.city')}</label>
              <input disabled={!isEdit} className="form-control" type="text" id="city" value={formik.values.city} onChange={formik.handleChange} />
            </div>
          </div>
          {stateCodeOptions[formik.values.countryCode] && stateCodeOptions[formik.values.countryCode].length > 0 && (
            <div className="col-sm-3">
              <div className="form-group">
                <label htmlFor="stateCode">{t('frontend.account.stateCode')}</label>
                <SwSelect
                  id="stateCode"
                  disabled={!isEdit}
                  value={formik.values.stateCode}
                  onChange={e => {
                    e.preventDefault()
                    formik.handleChange(e)
                  }}
                  options={stateCodeOptions[formik.values.countryCode]}
                />
              </div>
            </div>
          )}

          <div className="col-sm-2">
            <div className="form-group">
              <label htmlFor="postalCode">{t('frontend.account.postalCode')}</label>
              <input disabled={!isEdit} className="form-control" type="text" id="postalCode" value={formik.values.postalCode} onChange={formik.handleChange} />
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-sm-12">
            <div className="form-group">
              <div className="custom-control custom-checkbox">
                <input className="custom-control-input" type="checkbox" id="saveAddress" checked={formik.values.saveAddress} onChange={formik.handleChange} />
                <label className="custom-control-label" htmlFor="saveAddress">
                  Save to Account
                </label>
              </div>
            </div>
          </div>
        </div>

        <div className="d-lg-flex pt-4 mt-3">
          <div className="w-50 pr-3"></div>
          <div className="w-50 pl-2">
            <button className="btn btn-outline-primary btn-block" onClick={formik.handleSubmit}>
              <span className="d-none d-sm-inline">Save</span>
            </button>
          </div>
        </div>
      </form>
    </>
  )
}

const FulfilmentAddressSelector = ({ onSelect, onSave, selectedAccountID, addressTitle = 'Addresses', isShipping = true }) => {
  const accountAddresses = useSelector(state => state.userReducer.accountAddresses)
  const fulfillments = useSelector(state => state.cart.orderFulfillments)
  const [showAddress, setShowAddress] = useState(false)
  const [hasRemovedShippingAddress, setRemovedShippingAddress] = useState(false)
  const { t } = useTranslation()

  if (showAddress || accountAddresses.length === 0) {
    selectedAccountID = 'new'
  }

  return (
    <>
      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">{addressTitle}</h2>

      {!hasRemovedShippingAddress && fulfillments.length > 0 && (
        <div className="row ">
          {fulfillments.map(({ shippingAddress }) => {
            return (
              <div className="bg-lightgray rounded mb-5 col-md-4" key={shippingAddress?.addressID}>
                <p>
                  <em>{shippingAddress.name}</em>
                  <br />
                  {shippingAddress.streetAddress} <br />
                  {`${shippingAddress.city}, ${shippingAddress.stateCode} ${shippingAddress.postalCode}`} <br />
                </p>
                <hr />
                <button
                  className="btn btn-link px-0 text-danger"
                  type="button"
                  disabled={false}
                  onClick={event => {
                    event.preventDefault()
                    setRemovedShippingAddress(true)
                    //   dispatch(removePayment({ orderPaymentID: payment.orderPaymentID }))
                  }}
                >
                  <i className="fal fa-times-circle"></i>
                  <span className="font-size-sm"> Remove</span>
                </button>
              </div>
            )
          })}
        </div>
      )}
      {hasRemovedShippingAddress && accountAddresses && (
        <div className="row">
          <div className="col-sm-12">
            <SwRadioSelect
              options={accountAddresses.map(({ accountAddressName, accountAddressID, address: { streetAddress } }) => {
                return { name: `${accountAddressName} - ${streetAddress}`, value: accountAddressID }
              })}
              onChange={value => {
                setShowAddress(false)
                setRemovedShippingAddress(false)
                onSelect(value)
              }}
              customLabel={t('frontend.checkout.receive_option')}
              selectedValue={selectedAccountID}
              displayNew={true}
            />
            <button className="btn btn-secondary mt-2" onClick={() => setShowAddress(true)}>
              New Address
            </button>
          </div>
        </div>
      )}
      {showAddress && (
        <BillingAddress
          isShipping={isShipping}
          setShowAddress={showAddress}
          onSave={values => {
            setShowAddress(false)
            setRemovedShippingAddress(false)
            onSave(values)
          }}
        />
      )}
    </>
  )
}

export { FulfilmentAddressSelector }
