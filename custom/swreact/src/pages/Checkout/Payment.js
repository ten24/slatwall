import { useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { SwRadioSelect } from '../../components'
import SlideNavigation from './SlideNavigation'
import { useFormik } from 'formik'
import SwSelect from '../../components/SwSelect/SwSelect'
import { useTranslation } from 'react-i18next'
import { addPayment } from '../../actions/cartActions'
const months = Array.from({ length: 12 }, (_, i) => {
  return { key: i + 1, value: i + 1 }
})
const years = Array(10)
  .fill(new Date().getFullYear())
  .map((year, index) => {
    return { key: year + index, value: year + index }
  })

const CreditCardInfo = () => {
  const [isEdit, setEdit] = useState(false)
  const { t, i18n } = useTranslation()
  const dispatch = useDispatch()

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

      creditCardNumber: '',
      nameOnCreditCard: '',
      expirationMonth: new Date().getMonth() + 1,
      expirationYear: new Date().getFullYear().toString().substring(2),
      securityCode: '',

      returnJSONObjects: 'cart',
    },
    onSubmit: values => {
      console.log('values', values)
      setEdit(!isEdit)
    },
  })
  return (
    <>
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
      {/* <!-- Billing Address --> */}
      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Billing Address</h2>

      <div className="custom-control custom-checkbox">
        <input className="custom-control-input" type="checkbox" defaultChecked id="same-address" />
        <label className="custom-control-label" htmlFor="same-address">
          Same as shipping address
        </label>
      </div>
    </>
  )
}

const PaymentSlide = ({ currentStep }) => {
  const orderRequirementsList = useSelector(state => state.cart.orderRequirementsList)
  const eligiblePaymentMethodDetails = useSelector(state => state.cart.eligiblePaymentMethodDetails)
  const orderPayments = useSelector(state => state.cart.orderPayments) || [{}]
  const { paymentMethod, billingAddress, accountPaymentMethod, orderPaymentID } = orderPayments[0] || {}
  const accountPaymentMethods = useSelector(state => state.userReducer.accountPaymentMethods)
  const [showNewPayemnt, setShowNewPayemnt] = useState(false)
  const [selectedPaymentMethod, setSelectedPaymentMethod] = useState('')
  const dispatch = useDispatch()

  console.log('showNewPayemnt', showNewPayemnt ? 'true' : 'false')
  console.log('selectedPaymentMethod', selectedPaymentMethod)
  return (
    <>
      {/* <!-- Payment Method --> */}
      <div className="row mb-3">
        <div className="col-sm-12">
          <SwRadioSelect
            label="Select Your Method of Payment"
            options={
              eligiblePaymentMethodDetails &&
              eligiblePaymentMethodDetails.map(({ paymentMethod }) => {
                return { name: paymentMethod.paymentMethodName, value: paymentMethod.paymentMethodID }
              })
            }
            onChange={value => {
              setSelectedPaymentMethod(value)
              console.log('Payment Method')
            }}
            selectedValue={paymentMethod ? paymentMethod.paymentMethodID : ''}
          />
        </div>
      </div>
      <div className="row mb-3">
        <div className="col-sm-12">
          <SwRadioSelect
            label="Select Payment"
            options={accountPaymentMethods.map(({ accountPaymentMethodName, creditCardType, creditCardLastFour, accountPaymentMethodID }) => {
              return { name: `${accountPaymentMethodName} | ${creditCardType} - *${creditCardLastFour}`, value: accountPaymentMethodID }
            })}
            onChange={value => {
              if (value === 'new') {
                setShowNewPayemnt(true)
              } else {
                dispatch(
                  addPayment({
                    accountPaymentMethodID: value,
                    copyFromType: 'accountPaymentMethod',
                  })
                )
              }
              console.log('Payment Method')
            }}
            newLabel="Add Payment Method"
            selectedValue={showNewPayemnt || !accountPaymentMethod ? 'new' : accountPaymentMethod.accountPaymentMethodID}
            displayNew={true}
          />
        </div>
      </div>

      {/* <!-- Credit Card --> */}
      {showNewPayemnt || (!accountPaymentMethod && <CreditCardInfo />)}

      <SlideNavigation currentStep={currentStep} nextActive={!orderRequirementsList.includes('payment')} />
    </>
  )
}

export default PaymentSlide
