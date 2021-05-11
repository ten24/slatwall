import { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { getCountries, getStateCodeOptionsByCountryCode } from '../../actions/contentActions'
import { useFormik } from 'formik'
import { SwRadioSelect, ShippingAddressForm } from '../../components'
const ShippingAddress = ({ onSave }) => {
  const dispatch = useDispatch()
  const isFetching = useSelector(state => state.content.isFetching)
  const countryCodeOptions = useSelector(state => state.content.countryCodeOptions)
  const stateCodeOptions = useSelector(state => state.content.stateCodeOptions)
  const [isEdit, setEdit] = useState(true)

  let initialValues = {
    name: '',
    company: '',
    streetAddress: '',
    street2Address: '',
    city: '',
    stateCode: '',
    postalCode: '',
    countryCode: 'US',
    accountAddressName: '',
    saveAddress: true,
    blindShip: false,
  }

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
        <ShippingAddressForm formik={formik} isEdit={isEdit} countryCodeOptions={countryCodeOptions} stateCodeOptions={stateCodeOptions[formik.values.countryCode]} />
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

const AccountAddress = ({ onSelect, onSave, selectedAccountID, addressTitle = 'Addresses' }) => {
  const accountAddresses = useSelector(state => state.userReducer.accountAddresses)
  const [showAddress, setShowAddress] = useState(false)
  if (showAddress || accountAddresses.length === 0) {
    selectedAccountID = 'new'
  }
  return (
    <>
      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">{addressTitle}</h2>
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
                  setShowAddress(false)
                  onSelect(value)
                }
              }}
              newLabel="Add Account Address"
              selectedValue={selectedAccountID}
              displayNew={true}
            />
          </div>
        </div>
      )}
      {(showAddress || selectedAccountID === 'new') && (
        <ShippingAddress
          setShowAddress={showAddress}
          onSave={values => {
            setShowAddress(false)
            onSave(values)
          }}
        />
      )}
    </>
  )
}

export { AccountAddress }
