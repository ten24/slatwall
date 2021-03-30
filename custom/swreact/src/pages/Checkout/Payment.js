import { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { SwRadioSelect } from '../../components'
import SlideNavigation from './SlideNavigation'
import { useTranslation } from 'react-i18next'
import { addNewAccountAndSetAsBilling, addPayment } from '../../actions/cartActions'
import CreditCardDetails from './CreditCardDetails'
import { eligiblePaymentMethodDetailSelector, orderPayment, billingAccountAddressSelector } from '../../selectors/orderSelectors'
import { accountPaymentMethods } from '../../selectors/userSelectors'
import { addNewAccountAddress, addPaymentMethod } from '../../actions/userActions'
import AccountAddress from './AccountAddress'

export const CREDIT_CARD = '444df303dedc6dab69dd7ebcc9b8036a'
export const GIFT_CARD = '50d8cd61009931554764385482347f3a'
export const TERM_PAYMENT = '2c918088783591e3017836350bd21385'

const CreditCardPayemnt = () => {
  const paymentMethods = useSelector(accountPaymentMethods)
  const [newOrderPayment, setNewOrderPayment] = useState(false)
  const { accountPaymentMethod = { accountPaymentMethodID: '' } } = useSelector(orderPayment)
  const dispatch = useDispatch()

  return (
    <>
      <div className="row mb-3">
        <div className="col-sm-12">
          <SwRadioSelect
            label="Select Payment"
            options={paymentMethods}
            onChange={value => {
              if (value === 'new') {
                setNewOrderPayment('new')
              } else {
                setNewOrderPayment(false)
                dispatch(
                  addPayment({
                    accountPaymentMethodID: value,
                  })
                )
              }
            }}
            newLabel="Add Payment Method"
            selectedValue={newOrderPayment ? newOrderPayment : accountPaymentMethod.accountPaymentMethodID}
            displayNew={true}
          />
        </div>
      </div>
      {newOrderPayment === 'new' && (
        <CreditCardDetails
          onSubmit={() => {
            setNewOrderPayment(false)
          }}
        />
      )}
    </>
  )
}

const GiftCardPayemnt = () => {
  return (
    <>
      <h1>Gift Cards</h1>
    </>
  )
}
const TermPayment = ({ method }) => {
  const dispatch = useDispatch()
  const [accountAddressID, setAccountAddressID] = useState('')
  const { purchaseOrderNumber } = useSelector(orderPayment)
  const [termOrderNumber, setTermOrderNumber] = useState(purchaseOrderNumber || '')
  const selectedAccountID = useSelector(billingAccountAddressSelector)

  return (
    <>
      <div className="row mb-3">
        <div className="col-sm-12">
          <div className="form-group">
            <label htmlFor="purchaseOrderNumber">Purchase Order Number</label>
            <input
              className="form-control"
              type="text"
              id="purchaseOrderNumber"
              value={termOrderNumber}
              onChange={e => {
                e.preventDefault()
                setTermOrderNumber(e.target.value)
              }}
            />
          </div>
        </div>
      </div>
      {termOrderNumber.length > 0 && (
        <AccountAddress
          addressTitle={'Billing Address'}
          selectedAccountID={selectedAccountID || accountAddressID}
          onSelect={value => {
            dispatch(
              addPayment({
                accountAddressID: value,
                newOrderPayment: {
                  purchaseOrderNumber: termOrderNumber,
                  paymentMethod: {
                    paymentMethodID: method,
                  },
                },
              })
            )
            setAccountAddressID(value)
          }}
          onSave={values => {
            dispatch(addNewAccountAndSetAsBilling({ ...values }))
          }}
        />
      )}
    </>
  )
}
const PaymentSlide = ({ currentStep }) => {
  const orderRequirementsList = useSelector(state => state.cart.orderRequirementsList)
  const eligiblePaymentMethodDetails = useSelector(eligiblePaymentMethodDetailSelector)
  const { paymentMethod } = useSelector(orderPayment)
  const [selectedPaymentMethod, setSelectedPaymentMethod] = useState('')
  const [paymentMethodOnOrder, setPaymentMethodOnOrder] = useState(false)

  if (paymentMethod && paymentMethod.paymentMethodID && paymentMethodOnOrder != paymentMethod.paymentMethodID) {
    setPaymentMethodOnOrder(paymentMethod.paymentMethodID)
    setSelectedPaymentMethod(paymentMethod.paymentMethodID)
  }
  return (
    <>
      {/* <!-- Payment Method --> */}
      <div className="row mb-3">
        <div className="col-sm-12">
          <SwRadioSelect
            label="Select Your Method of Payment"
            options={eligiblePaymentMethodDetails}
            onChange={value => {
              setSelectedPaymentMethod(value)
            }}
            selectedValue={selectedPaymentMethod.length > 0 ? selectedPaymentMethod : paymentMethodOnOrder}
          />
        </div>
      </div>
      {selectedPaymentMethod === CREDIT_CARD && <CreditCardPayemnt />}
      {selectedPaymentMethod === GIFT_CARD && <GiftCardPayemnt />}
      {selectedPaymentMethod === TERM_PAYMENT && <TermPayment method={selectedPaymentMethod} />}

      <SlideNavigation currentStep={currentStep} nextActive={!orderRequirementsList.includes('payment')} />
    </>
  )
}

export default PaymentSlide
