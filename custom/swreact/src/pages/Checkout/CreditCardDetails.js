import { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { SwRadioSelect } from '../../components'
import { useFormik } from 'formik'
import SwSelect from '../../components/SwSelect/SwSelect'
import { useTranslation } from 'react-i18next'
import { addPayment } from '../../actions/cartActions'
import ShippingAddressForm from './ShippingAddressForm'
import { getCountries, getStateCodeOptionsByCountryCode } from '../../actions/contentActions'

export const CREDIT_CARD = '444df303dedc6dab69dd7ebcc9b8036a'
export const GIFT_CARD = '50d8cd61009931554764385482347f3a'

const months = Array.from({ length: 12 }, (_, i) => {
  return { key: i + 1, value: i + 1 }
})
const years = Array(10)
  .fill(new Date().getFullYear())
  .map((year, index) => {
    return { key: year + index, value: year + index }
  })

const CreditCardDetails = () => {
  const [isEdit, setEdit] = useState(false)
  const { t, i18n } = useTranslation()
  const dispatch = useDispatch()
  const { billingAddress, accountPaymentMethod, expirationYear, nameOnCreditCard, expirationMonth, creditCardLastFour } = useSelector(state => state.cart.orderPayments[0])
  const accountAddresses = useSelector(state => state.userReducer.accountAddresses)
  const countryCodeOptions = useSelector(state => state.content.countryCodeOptions)
  let defaultCountryCode = 'US'
  if (billingAddress && billingAddress.countrycode) {
    defaultCountryCode = billingAddress.countrycode ? billingAddress.countrycode : defaultCountryCode
  }

  const stateCodeOptions = useSelector(state => state.content.stateCodeOptions[defaultCountryCode]) || []

  let selectedAccountID = ''
  if (billingAddress) {
    const selectAccount = accountAddresses
      .filter(({ address: { addressID } }) => {
        return addressID === billingAddress.addressID
      })
      .map(({ accountAddressID }) => {
        return accountAddressID
      })
    selectedAccountID = selectAccount.length ? selectAccount[0] : null
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
      creditCardNumber: creditCardLastFour ? creditCardLastFour : '',
      nameOnCreditCard: nameOnCreditCard ? nameOnCreditCard : '',
      expirationMonth: expirationMonth ? expirationMonth : new Date().getMonth() + 1,
      expirationYear: expirationYear ? expirationYear : new Date().getFullYear().toString().substring(2),
      securityCode: '',
      accountAddressID: '',
      saveShippingAsBilling: false,
      returnJSONObjects: 'cart',
    },
    onSubmit: values => {
      let payload = {
        newOrderPayment: {
          nameOnCreditCard: values.nameOnCreditCard,
          creditCardNumber: values.creditCardNumber,
          expirationMonth: values.expirationMonth,
          expirationYear: values.expirationYear,
          securityCode: values.securityCode,
        },
      }
      if (values.saveShippingAsBilling) {
        payload.newOrderPayment['saveShippingAsBilling'] = 1
      } else if (values.accountAddressID === 'new') {
        payload.newOrderPayment = {
          ...payload.newOrderPayment,
          billingAddress: {
            name: values.name,
            company: values.company,
            streetAddress: values.streetAddress,
            street2Address: values.street2Address,
            city: values.city,
            stateCode: values.stateCode,
            postalCode: values.postalCode,
          },
        }
      } else if (values.accountAddressID.length) {
        payload['accountAddressID'] = values.accountAddressID
      }
      dispatch(addPayment(payload))
      setEdit(!isEdit)
    },
  })

  useEffect(() => {
    dispatch(getCountries())
    dispatch(getStateCodeOptionsByCountryCode(formik.values.countryCode))
  }, [dispatch])

  return (
    <>
      <div className="row mb-3">
        <div className="col-sm-12">
          <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Credit Card Information</h2>
          <div className="row">
            <div className="col-sm-6">
              <div className="form-group">
                <label htmlFor="nameOnCreditCard">{t('frontend.account.payment_method.name')}</label>
                <input disabled={!isEdit} className="form-control" type="text" id="nameOnCreditCard" value={formik.values.nameOnCreditCard} onChange={formik.handleChange} />
              </div>
            </div>
            <div className="col-sm-6">
              <div className="form-group">
                <label htmlFor="creditCardNumber">{t('frontend.account.payment_method.ccn')}</label>
                <input disabled={!isEdit} className="form-control" type="text" id="creditCardNumber" value={formik.values.creditCardNumber} onChange={formik.handleChange} />
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-sm-6">
              <div className="form-group">
                <label htmlFor="securityCode">{t('frontend.account.payment_method.cvv')}</label>
                <input disabled={!isEdit} className="form-control" type="text" id="securityCode" value={formik.values.securityCode} onChange={formik.handleChange} />
              </div>
            </div>
            <div className="col-sm-3">
              <div className="form-group">
                <label htmlFor="expirationMonth">{t('frontend.account.payment_method.expiration_month')}</label>
                <SwSelect disabled={!isEdit} id="expirationMonth" value={formik.values.expirationMonth} onChange={formik.handleChange} options={months} />
              </div>
            </div>
            <div className="col-sm-3">
              <div className="form-group">
                <label htmlFor="expirationYear">{t('frontend.account.payment_method.expiration_year')}</label>
                <SwSelect disabled={!isEdit} id="expirationYear" value={formik.values.expirationYear} onChange={formik.handleChange} options={years} />
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="row mb-3">
        <div className="col-sm-12">
          {/* <!-- Billing Address --> */}
          {/* <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Billing Address</h2> */}
          <div className="row mb-3">
            <div className="col-sm-12">
              <div className="row">
                <div className="col-sm-12">
                  <div className="custom-control custom-checkbox">
                    <input className="custom-control-input" type="checkbox" id="saveShippingAsBilling" checked={formik.values.saveShippingAsBilling} onChange={formik.handleChange} />
                    <label className="custom-control-label" htmlFor="saveShippingAsBilling">
                      Same as shipping address
                    </label>
                  </div>
                </div>
              </div>
            </div>
          </div>
          {!formik.values.saveShippingAsBilling && accountAddresses && (
            <>
              <div className="row">
                <div className="col-sm-12">
                  <SwRadioSelect
                    label="Billing Address"
                    options={accountAddresses.map(({ accountAddressName, accountAddressID, address: { streetAddress } }) => {
                      return { name: `${accountAddressName} - ${streetAddress}`, value: accountAddressID }
                    })}
                    onChange={value => {
                      if (value === 'new') {
                        formik.setFieldValue('accountAddressID', 'new')
                      } else {
                        formik.setFieldValue('accountAddressID', value)
                      }
                    }}
                    newLabel="Add Address"
                    selectedValue={formik.values.accountAddressID}
                    displayNew={true}
                  />
                </div>
              </div>
              {formik.values.accountAddressID === 'new' && <ShippingAddressForm formik={formik} isEdit={isEdit} countryCodeOptions={countryCodeOptions} stateCodeOptions={stateCodeOptions} />}
            </>
          )}
        </div>
      </div>
      <div className="row mb-3">
        <div className="col-sm-12">
          <div className="row">
            <div className="col-sm-6"></div>
            <div className="col-sm-6">
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
        </div>
      </div>
    </>
  )
}

export default CreditCardDetails
