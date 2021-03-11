import { useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { SwRadioSelect } from '../../components'
import SlideNavigation from './SlideNavigation'
import { useTranslation } from 'react-i18next'
import { addPayment } from '../../actions/cartActions'
import CreditCardDetails from './CreditCardDetails'

export const CREDIT_CARD = '444df303dedc6dab69dd7ebcc9b8036a'
export const GIFT_CARD = '50d8cd61009931554764385482347f3a'

const PaymentSlide = ({ currentStep }) => {
  const orderRequirementsList = useSelector(state => state.cart.orderRequirementsList)
  const eligiblePaymentMethodDetails = useSelector(state => state.cart.eligiblePaymentMethodDetails)
  const orderPayments = useSelector(state => state.cart.orderPayments)
  const { paymentMethod, accountPaymentMethod } = orderPayments[0] || {}
  const { accountPaymentMethodID } = accountPaymentMethod || {}
  const accountPaymentMethods = useSelector(state => state.userReducer.accountPaymentMethods)
  const [selectedPaymentMethod, setSelectedPaymentMethod] = useState('')
  const [paymentMethodOnOrder, setPaymentMethodOnOrder] = useState(false)
  const [newOrderPayment, setNewOrderPayment] = useState(false)
  const dispatch = useDispatch()

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
            options={
              eligiblePaymentMethodDetails &&
              eligiblePaymentMethodDetails.map(({ paymentMethod }) => {
                return { name: paymentMethod.paymentMethodName, value: paymentMethod.paymentMethodID }
              })
            }
            onChange={value => {
              setSelectedPaymentMethod(value)
            }}
            selectedValue={selectedPaymentMethod.length > 0 ? selectedPaymentMethod : paymentMethodOnOrder}
          />
        </div>
      </div>

      {selectedPaymentMethod === CREDIT_CARD && (
        <>
          <div className="row mb-3">
            <div className="col-sm-12">
              <SwRadioSelect
                label="Select Payment"
                options={accountPaymentMethods.map(({ accountPaymentMethodName, creditCardType, creditCardLastFour, accountPaymentMethodID }) => {
                  return { name: `${accountPaymentMethodName} | ${creditCardType} - *${creditCardLastFour}`, value: accountPaymentMethodID }
                })}
                onChange={value => {
                  if (value === 'new') {
                    setNewOrderPayment('new')
                  } else {
                    setNewOrderPayment(false)
                    dispatch(
                      addPayment({
                        accountPaymentMethodID: value,
                        copyFromType: 'accountPaymentMethod',
                      })
                    )
                  }
                }}
                newLabel="Add Payment Method"
                selectedValue={newOrderPayment ? newOrderPayment : accountPaymentMethodID}
                displayNew={true}
              />
            </div>
          </div>
          {newOrderPayment === 'new' && <CreditCardDetails />}
        </>
      )}

      <SlideNavigation currentStep={currentStep} nextActive={!orderRequirementsList.includes('payment')} />
    </>
  )
}

export default PaymentSlide
