import { useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { useFormik } from 'formik'
import { SwSelect, AccountAddress } from '../../components'
import { useTranslation } from 'react-i18next'
import { addNewAccountAndSetAsBilling } from '../../actions/cartActions'
import { addPaymentMethod } from '../../actions/userActions'

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

const CreditCardDetails = ({ onSubmit }) => {
  const [isEdit, setEdit] = useState(true)
  const { t } = useTranslation()
  const dispatch = useDispatch()
  const billingAccountAddress = useSelector(state => state.cart.billingAccountAddress)

  const formik = useFormik({
    enableReinitialize: false,
    initialValues: {
      creditCardNumber: '',
      nameOnCreditCard: '',
      expirationMonth: new Date().getMonth() + 1,
      expirationYear: new Date().getFullYear().toString().substring(2),
      securityCode: '',
      accountPaymentMethodName: '',
      accountAddressID: billingAccountAddress ? billingAccountAddress.accountAddressID : '',
      saveShippingAsBilling: false,
      returnJSONObjects: 'cart',
    },
    onSubmit: values => {
      let payload = {
        accountPaymentMethodName: values.accountPaymentMethodName,
        paymentMethodType: 'creditCard',
        nameOnCreditCard: values.nameOnCreditCard,
        creditCardNumber: values.creditCardNumber,
        expirationMonth: values.expirationMonth,
        expirationYear: values.expirationYear,
        securityCode: values.securityCode,
        billingAccountAddress: {
          accountAddressID: values.accountAddressID,
        },
      }
      if (values.saveShippingAsBilling) {
        payload.newOrderPayment['saveShippingAsBilling'] = 1
        delete payload.newOrderPayment.accountAddressID
      }
      dispatch(addPaymentMethod(payload))
      setEdit(!isEdit)
      onSubmit()
    },
  })

  return (
    <>
      <div className="row mb-3">
        <div className="col-sm-12">
          {!formik.values.saveShippingAsBilling && (
            <AccountAddress
              isShipping={false}
              addressTitle={'Billing Address'}
              selectedAccountID={formik.values.accountAddressID}
              onSelect={value => {
                formik.setFieldValue('accountAddressID', value)
              }}
              onSave={values => {
                dispatch(addNewAccountAndSetAsBilling({ ...values }))
              }}
            />
          )}
        </div>
      </div>
      <div className="row mb-3">
        <div className="col-sm-12">
          <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Credit Card Information</h2>
          <div className="row">
            <div className="col-sm-6">
              <div className="form-group">
                <label htmlFor="accountPaymentMethodName">{t('frontend.account.payment_method.nickname')}</label>
                <input className="form-control" type="text" id="accountPaymentMethodName" value={formik.values.accountPaymentMethodName} onChange={formik.handleChange} />{' '}
              </div>
            </div>

            <div className="col-sm-6">
              <div className="form-group">
                <label htmlFor="nameOnCreditCard">{t('frontend.account.payment_method.name')}</label>
                <input disabled={!isEdit} className="form-control" type="text" id="nameOnCreditCard" value={formik.values.nameOnCreditCard} onChange={formik.handleChange} />
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-sm-5">
              <div className="form-group">
                <label htmlFor="creditCardNumber">{t('frontend.account.payment_method.ccn')}</label>
                <input disabled={!isEdit} className="form-control" type="text" id="creditCardNumber" value={formik.values.creditCardNumber} onChange={formik.handleChange} />
              </div>
            </div>
            <div className="col-sm-2">
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
            <div className="col-sm-2">
              <div className="form-group">
                <label htmlFor="expirationYear">{t('frontend.account.payment_method.expiration_year')}</label>
                <SwSelect disabled={!isEdit} id="expirationYear" value={formik.values.expirationYear} onChange={formik.handleChange} options={years} />
              </div>
            </div>
          </div>

          <div className="row mb-3">
            <div className="col-sm-12">
              <div className="row">
                <div className="col-sm-12">{/* <div className="custom-control custom-checkbox">
                    <input className="custom-control-input" type="checkbox" id="saveShippingAsBilling" checked={formik.values.saveShippingAsBilling} onChange={formik.handleChange} />
                    <label className="custom-control-label" htmlFor="saveShippingAsBilling">
                      Same as shipping address
                    </label>
                  </div> */}</div>
              </div>
            </div>
          </div>

          {formik.values.accountAddressID !== '' && (
            <div className="d-lg-flex pt-4 mt-3">
              <div className="w-50 pr-3"></div>
              <div className="w-50 pl-2">
                <button className="btn btn-outline-primary btn-block" onClick={formik.handleSubmit}>
                  <span className="d-none d-sm-inline">Save</span>
                </button>
              </div>
            </div>
          )}
        </div>
      </div>
    </>
  )
}

export { CreditCardDetails }
