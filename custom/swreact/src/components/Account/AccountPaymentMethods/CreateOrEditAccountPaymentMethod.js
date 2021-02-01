import { useFormik } from 'formik'
import { connect } from 'react-redux'
import { useRouteMatch } from 'react-router'
import AccountContent from '../AccountContent/AccountContent'
import AccountLayout from '../AccountLayout/AccountLayout'
import AccountAddressForm from './AccountAddressForm'
import SwSelect from './SwSelect'

const CreateOrEditAccountPaymentMethod = props => {
  let match = useRouteMatch()
  let isEdit = false
  const { customBody, contentTitle, accountAddresses, accountPaymentMethods } = props
  let cardData = accountPaymentMethods.filter(card => {
    return card.accountPaymentMethodID === match.params.id
  })
  if (!cardData.length) {
    cardData = {
      accountPaymentMethodID: '',
      accountPaymentMethodName: '',
      activeFlag: false,
      creditCardLastFour: '',
      creditCardType: '',
      expirationMonth: '',
      expirationYear: '',
      hasErrors: false,
      nameOnCreditCard: '',
    }
  } else {
    cardData = cardData[0]
    isEdit = true
  }
  const paymentMethods = [
    {
      key: 'Credit Card',
      value: '444df303dedc6dab69dd7ebcc9b8036a',
    },
  ]
  const months = Array.from({ length: 12 }, (_, i) => {
    return { key: i + 1, value: i + 1 }
  })
  const years = Array(10)
    .fill(new Date().getFullYear())
    .map((year, index) => {
      return { key: year + index, value: year + index }
    })
  console.log('cardData[0]', cardData)
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
      alert(JSON.stringify(values, null, 2))
    },
  })

  //Expiration Month
  //Expiration Year
  //Security Code

  //Nickname
  //Payment Method
  return (
    <AccountLayout title={'Add Account Payment Method'}>
      <AccountContent customBody={customBody} contentTitle={contentTitle} />
      <form onSubmit={formik.handleSubmit}>
        <div className="row">
          <div className={`col-sm-${isEdit ? 12 : 6}`}>
            <div className="form-group">
              <label htmlFor="accountPaymentMethodName">Nickname</label>
              <input className="form-control" type="text" id="accountPaymentMethodName" value={formik.values.accountPaymentMethodName} onChange={formik.handleChange} />
            </div>
            <div className="form-group">
              <label htmlFor="paymentMethod.paymentMethodID">Payment Method</label>
              <SwSelect id="paymentMethod.paymentMethodID" value={formik.values['paymentMethodID']} onChange={formik.handleChange} options={paymentMethods} />
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
              Save Credit Card Details
            </button>
          </div>
        </div>
      </form>
    </AccountLayout>
  )
}
const mapStateToProps = state => {
  let accountAddresses = state.userReducer.accountAddresses.map(({ address, accountAddressID }) => {
    return { key: `${address.streetAddress} ${address.city}, ${address.stateCode}`, value: accountAddressID }
  })
  accountAddresses.push({ key: 'New', value: '' })
  return {
    accountAddresses,
    accountPaymentMethods: state.userReducer.accountPaymentMethods,
  }
}
export default connect(mapStateToProps)(CreateOrEditAccountPaymentMethod)
