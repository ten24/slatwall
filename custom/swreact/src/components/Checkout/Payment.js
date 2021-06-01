import { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { useLocation } from 'react-router-dom';
import { CreditCardDetails, SlideNavigation, AccountAddress, GiftCardDetails, CCDetails, SwRadioSelect, TermPaymentDetails, Overlay } from '../../components'
import { addNewAccountAndSetAsBilling, addPayment, removePayment } from '../../actions/cartActions'
import { eligiblePaymentMethodDetailSelector, orderPayment, billingAccountAddressSelector, getAllOrderPayments, disableInteractionSelector } from '../../selectors/orderSelectors'
import { accountPaymentMethods } from '../../selectors/userSelectors'
import { useTranslation } from 'react-i18next'

export const CREDIT_CARD = '444df303dedc6dab69dd7ebcc9b8036a'
export const GIFT_CARD = '50d8cd61009931554764385482347f3a'
export const TERM_PAYMENT = '2c918088783591e3017836350bd21385'

const CreditCardPayment = () => {
  const paymentMethods = useSelector(accountPaymentMethods)
  const [newOrderPayment, setNewOrderPayment] = useState(false)
  const { accountPaymentMethod = { accountPaymentMethodID: '' } } = useSelector(orderPayment)
  const dispatch = useDispatch()

  // @function - Opens new payment method form
  const openAddPaymentForm = () => {
    setNewOrderPayment('new')
  }

  useEffect(() => {
    if (paymentMethods.length === 0) {
      // if there is no payment method found for the user , open new payment form
      openAddPaymentForm()
    }
  }, [paymentMethods])

  return (
    <>
      <div className="row mb-3">
        <div className="col-sm-12">
          <SwRadioSelect
            label="Select Payment"
            options={paymentMethods}
            onChange={value => {
              if (value === 'new') {
                openAddPaymentForm()
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

const ListPayments = () => {
  const payments = useSelector(getAllOrderPayments)
  const disableInteraction = useSelector(disableInteractionSelector)
  const location = useLocation();
  const pageName = location.pathname.split('/')[2];
  
  const { t } = useTranslation()
  const dispatch = useDispatch()
  if (payments.length === 0) {
    return null
  }
  
  return (
    <>
      <p className="h6">{t('frontend.checkout.payments')}:</p>
      <div className="row ">
        {payments.map(payment => {
          return (
            <div className="bg-lightgray rounded mb-5 col-md-4" key={payment.orderPaymentID}>
              {payment.paymentMethod.paymentMethodType === 'creditCard' && <CCDetails hideHeading={true} creditCardPayment={payment} />}
              {payment.paymentMethod.paymentMethodType === 'giftCard' && <GiftCardDetails />}
              {payment.paymentMethod.paymentMethodType === 'termPayment' && <TermPaymentDetails hideHeading={true} termPayment={payment} />}
              <hr />
                <button
                className="btn btn-link px-0 text-danger"
                type="button"
                disabled={disableInteraction}
                onClick={event => {
                  event.preventDefault()
                  dispatch(removePayment({ orderPaymentID: payment.orderPaymentID }))
                }}
              >
                <i className="fal fa-times-circle"></i>
                <span className="font-size-sm"> Remove</span>
              </button>
              
              
            </div>
          )
        })}
      </div>
    </>
  )
}
const TermPayment = ({ method }) => {
  const dispatch = useDispatch()
  const [accountAddressID, setAccountAddressID] = useState('')
  const { purchaseOrderNumber } = useSelector(orderPayment)
  const [termOrderNumber, setTermOrderNumber] = useState(purchaseOrderNumber)
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
      {termOrderNumber && termOrderNumber.length > 0 && (
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
  const allPayments = useSelector(getAllOrderPayments)
  const { isFetching } = useSelector(state => state.cart)

  if (paymentMethod && paymentMethod.paymentMethodID && paymentMethodOnOrder !== paymentMethod.paymentMethodID) {
    setPaymentMethodOnOrder(paymentMethod.paymentMethodID)
    setSelectedPaymentMethod(paymentMethod.paymentMethodID)
  }
  return (
    <Overlay active={isFetching} spinner>
      {/* <!-- Payment Method --> */}
      <ListPayments />
      {allPayments.length === 0 && (
        <>
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

          {selectedPaymentMethod === CREDIT_CARD && <CreditCardPayment />}
          {selectedPaymentMethod === GIFT_CARD && <GiftCardPayemnt />}
          {selectedPaymentMethod === TERM_PAYMENT && <TermPayment method={selectedPaymentMethod} />}
        </>
      )}

      <SlideNavigation currentStep={currentStep} nextActive={!orderRequirementsList.includes('payment')} />
    </Overlay>
  )
}

export { PaymentSlide, TermPayment, ListPayments, GiftCardPayemnt, CreditCardPayment }