import { useFormik } from 'formik'
import { connect } from 'react-redux'
import AccountContent from '../AccountContent/AccountContent'
import AccountLayout from '../AccountLayout/AccountLayout'
import AccountAddressForm from './AccountAddressForm'
import SwSelect from './SwSelect'
import { toast } from 'react-toastify'
import useRedirect from '../../../hooks/useRedirect'

const months = Array.from({ length: 12 }, (_, i) => {
  return { key: i + 1, value: i + 1 }
})
const years = Array(10)
  .fill(new Date().getFullYear())
  .map((year, index) => {
    return { key: year + index, value: year + index }
  })

const CreateOrEditAccountPaymentMethod = ({ cardData, isEdit, customBody, contentTitle, accountAddresses, accountPaymentMethods }) => {
  const [redirect, setRedirect] = useRedirect({ location: '/my-account/card' })

  const formik = useFormik({
    enableReinitialize: true,
    initialValues: {
      accountPaymentMethodName: cardData.accountPaymentMethodName,
      'paymentMethod.paymentMethodID': cardData.accountPaymentMethodID,
      creditCardNumber: ``,
      nameOnCreditCard: cardData.nameOnCreditCard,
      expirationMonth: cardData.expirationMonth || new Date().getMonth(),
      expirationYear: cardData.expirationYear ? `20${cardData.expirationYear}` : new Date().getFullYear(),
      securityCode: '',
      'billingAccountAddress.accountAddressID': '',
      'billingAccountAddress.countryCode': '',
      'billingAccountAddress.name': '',
      'billingAccountAddress.company': '',
      'billingAccountAddress.phoneNumber': '',
      'billingAccountAddress.streetAddress': '',
      'billingAccountAddress.street2Address': '',
      'billingAccountAddress.city': '',
      'billingAccountAddress.stateCode': '',
      'billingAccountAddress.postalCode': '',
    },
    onSubmit: values => {
      // TODO: Dispatch Actions
      console.log('values', values)
      if (isEdit) {
        toast.success('Card Updated')
      } else {
        toast.success('New Card Saved')
      }
      setRedirect({ ...redirect, shouldRedirect: true })
    },
  })
  return (
    <AccountLayout title={'Add Account Payment Method'}>
      <AccountContent customBody={customBody} contentTitle={contentTitle} />
      <h1>{isEdit ? 'Edit' : 'New'}</h1>
      <form onSubmit={formik.handleSubmit}>
        <div className="row">
          <div className={`col-sm-${isEdit ? 12 : 6}`}>
            <div className="form-group">
              <label htmlFor="accountPaymentMethodName">Nickname</label>
              <input className="form-control" type="text" id="accountPaymentMethodName" value={formik.values.accountPaymentMethodName} onChange={formik.handleChange} />
            </div>
            <div className="form-group">
              <label htmlFor="paymentMethod.paymentMethodID">Payment Method</label>
              <SwSelect id="paymentMethod.paymentMethodID" value={formik.values['paymentMethodID']} onChange={formik.handleChange} options={accountPaymentMethods} />
            </div>
            <hr />
            <h2>Credit Card Details</h2>
            <div className="form-group">
              <label htmlFor="creditCardNumber">Credit Card Number</label>
              <input className="form-control" type="text" id="creditCardNumber" placeholder={`************${cardData.creditCardLastFour}`} value={formik.values.creditCardNumber} onChange={formik.handleChange} />
            </div>
            <div className="form-group">
              <label htmlFor="nameOnCreditCard">Name On Card</label>
              <input className="form-control" type="text" id="nameOnCreditCard" value={formik.values.nameOnCreditCard} onChange={formik.handleChange} />
            </div>
            <div className="form-group">
              <label htmlFor="expirationMonth">Expiration Month</label>
              <SwSelect id="expirationMonth" value={formik.values.expirationMonth} onChange={formik.handleChange} options={months} />
            </div>
            <div className="form-group">
              <label htmlFor="expirationYear">Expiration Year</label>
              <SwSelect id="expirationYear" value={formik.values.expirationYear} onChange={formik.handleChange} options={years} />
            </div>
            <div className="form-group">
              <label htmlFor="securityCode">Security Code</label>
              <input className="form-control" type="text" placeholder={`***`} id="securityCode" value={formik.values.securityCode} onChange={formik.handleChange} />
            </div>
          </div>
          {!isEdit && (
            <div className="col-sm-6">
              <div className="form-group">
                <label htmlFor="accountAddressID">Billing Account Address</label>
                <SwSelect id="billingAccountAddress.accountAddressID" value={formik.values['billingAccountAddress.accountAddressID']} onChange={formik.handleChange} options={accountAddresses} />
              </div>
              {!formik.values['billingAccountAddress.accountAddressID'] && <AccountAddressForm formik={formik} />}
            </div>
          )}
        </div>
        <div className="col-12">
          <hr className="mt-2 mb-3" />
          <div className="d-flex flex-wrap justify-content-end">
            <button type="submit" className="btn btn-primary mt-3 mt-sm-0">
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
        value: 'credit_card',
      },
    ],
  }
}
export default connect(mapStateToProps)(CreateOrEditAccountPaymentMethod)
