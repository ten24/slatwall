import { useFormik } from 'formik'
import { connect, useDispatch } from 'react-redux'
import AccountContent from '../AccountContent/AccountContent'
import { AccountLayout } from '../AccountLayout/AccountLayout'
import AccountAddressForm from './AccountAddressForm'
import useRedirect from '../../../hooks/useRedirect'
import SwSelect from '../../SwSelect/SwSelect'
import { addPaymentMethod } from '../../../actions/userActions'
import { useTranslation } from 'react-i18next'

const months = Array.from({ length: 12 }, (_, i) => {
  return { key: i + 1, value: i + 1 }
})
const years = Array(10)
  .fill(new Date().getFullYear())
  .map((year, index) => {
    return { key: year + index, value: year + index }
  })

const CreateOrEditAccountPaymentMethod = ({ cardData, isEdit, customBody, contentTitle, accountAddresses, accountPaymentMethods }) => {
  const [redirect, setRedirect] = useRedirect({ location: '/my-account/cards' })
  const dispatch = useDispatch()
  const { t } = useTranslation()

  const formik = useFormik({
    enableReinitialize: true,
    initialValues: {
      accountPaymentMethodName: cardData.accountPaymentMethodName,
      paymentMethodType: 'creditCard',
      creditCardNumber: ``,
      nameOnCreditCard: cardData.nameOnCreditCard,
      expirationMonth: cardData.expirationMonth || new Date().getMonth() + 1,
      expirationYear: cardData.expirationYear ? `${cardData.expirationYear}` : new Date().getFullYear().toString().substring(2),
      securityCode: '',
      'billingAccountAddress.accountAddressID': '',
      'billingAddress.countryCode': 'US',
      'billingAddress.name': '',
      'billingAddress.company': '',
      'billingAddress.phoneNumber': '',
      'billingAddress.streetAddress': '',
      'billingAddress.street2Address': '',
      'billingAddress.city': '',
      'billingAddress.stateCode': '',
      'billingAddress.postalCode': '',
    },
    onSubmit: values => {
      // TODO: Dispatch Actions
      if (values['billingAccountAddress.accountAddressID'].length) {
        delete values['billingAddress.countryCode']
        delete values['billingAddress.name']
        delete values['billingAddress.company']
        delete values['billingAddress.phoneNumber']
        delete values['billingAddress.streetAddress']
        delete values['billingAddress.street2Address']
        delete values['billingAddress.city']
        delete values['billingAddress.stateCode']
        delete values['billingAddress.postalCode']
      }

      if (!isEdit) {
        delete values['paymentMethod.paymentMethodID']
        dispatch(addPaymentMethod(values))
      }
      setRedirect({ ...redirect, shouldRedirect: true })
    },
  })
  return (
    <AccountLayout title={'Add Account Payment Method'}>
      <AccountContent customBody={customBody} contentTitle={contentTitle} />
      <form onSubmit={formik.handleSubmit} className="mt-5">
        <div className="row">
            <div className="col-md-6">
	            <div className="form-group">
	              <label htmlFor="paymentMethodType">{t('frontend.account.payment_method.heading')}</label>
	              <SwSelect id="paymentMethodType" value={formik.values['paymentMethodType']} onChange={formik.handleChange} options={accountPaymentMethods} disabled={isEdit} />
	            </div>
	        </div>
            <div className="col-md-12">
            	<h5 className="my-2">{t('frontend.account.payment_method.cc_details')}</h5>
           	</div>
           	<div className="col-md-6">
	            <div className="form-group">
	              <label htmlFor="creditCardNumber">{t('frontend.account.payment_method.ccn')}</label>
	              <input className="form-control" type="text" id="creditCardNumber" placeholder={`************${cardData.creditCardLastFour}`} value={formik.values.creditCardNumber} onChange={formik.handleChange} disabled={isEdit} />
	            </div>
        	  </div>
            <div className="col-md-6">
	            <div className="form-group">
	              <label htmlFor="nameOnCreditCard">{t('frontend.account.payment_method.name')}</label>
	              <input className="form-control" type="text" id="nameOnCreditCard" value={formik.values.nameOnCreditCard} onChange={formik.handleChange} disabled={isEdit} />
	            </div>
           	</div>
           	<div className="col-md-3">
  	            <div className="form-group">
  	              <label htmlFor="expirationMonth">{t('frontend.account.payment_method.expiration_month')}</label>
  	              <SwSelect id="expirationMonth" value={formik.values.expirationMonth} onChange={formik.handleChange} options={months} disabled={isEdit} />
  	            </div>
  	        </div>
  	        <div className="col-md-3">
  	            <div className="form-group">
  	              <label htmlFor="expirationYear">{t('frontend.account.payment_method.expiration_year')}</label>
  	              <SwSelect id="expirationYear" value={formik.values.expirationYear} onChange={formik.handleChange} options={years} disabled={isEdit} />
  	            </div>
  	        </div>
  	        <div className="col-md-6">
  	            <div className="form-group">
  	              <label htmlFor="securityCode">{t('frontend.account.payment_method.cvv')}</label>
  	              <input className="form-control" type="text" placeholder={`***`} id="securityCode" value={formik.values.securityCode} onChange={formik.handleChange} disabled={isEdit} />
  	            </div>
  	        </div>
  	        <div className="col-md-12">
  	          <hr className="my-4" />
  	        </div>

          {!isEdit && (
            <div className="row">
              <div className="col-sm-12">
                <div className="col-md-6 pl-0">
                  <div className="form-group">
                    <label htmlFor="accountAddressID">{t('frontend.account.billing_address')}</label>
                    <SwSelect id="billingAccountAddress.accountAddressID" value={formik.values['billingAccountAddress.accountAddressID']} onChange={formik.handleChange} options={accountAddresses} />
                  </div>
                </div>
                  {!formik.values['billingAccountAddress.accountAddressID'] && <AccountAddressForm formik={formik} />}
              </div>
            </div>
          )}
        </div>
          <div className="row">
            <hr className="mt-2 mb-3" />
            <div className="d-flex flex-wrap justify-content-end">
              <button type="submit" className="btn btn-primary mt-3 mt-sm-0" disabled={isEdit}>
                {isEdit ? 'Save Credit Card Details' : 'Save New Card'}
              </button>
            </div>
          </div>
      </form>
    </AccountLayout>
  )
}

// This seems weird but this logic just complicated the essence of the component
const mapStateToProps = (state, ownProps) => {
  let accountAddresses = state.userReducer.accountAddresses.map(({ address, accountAddressID }) => {
    return { key: `${address.streetAddress} ${address.city}, ${address.stateCode}`, value: accountAddressID }
  })

  let cardData = state.userReducer.accountPaymentMethods.filter(card => {
    return card.accountPaymentMethodID === ownProps.path
  })
  //1: "Payment Method Type must be in list cash,check,creditCard,external,giftCard,termPayment"
  return {
    accountAddresses: [...accountAddresses, { key: 'New', value: '' }],
    cardData: cardData.length
      ? cardData[0]
      : {
          accountPaymentMethodID: '',
          accountPaymentMethodName: '',
          activeFlag: false,
          creditCardLastFour: '',
          creditCardType: '',
          expirationMonth: '',
          expirationYear: '',
          hasErrors: false,
          nameOnCreditCard: '',
        },
    isEdit: cardData.length,
    accountPaymentMethods: [
      {
        key: 'Credit Card',
        value: 'creditCard',
      },
    ],
  }
}
export default connect(mapStateToProps)(CreateOrEditAccountPaymentMethod)
