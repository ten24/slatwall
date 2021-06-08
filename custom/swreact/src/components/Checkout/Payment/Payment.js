import { useState } from 'react'
import { useSelector } from 'react-redux'
import { SlideNavigation, SwRadioSelect, Overlay, PaymentList, CreditCardPayment, TermPayment, GiftCardPayment } from '../..'
import { eligiblePaymentMethodDetailSelector, orderPayment, getAllOrderPayments } from '../../../selectors/orderSelectors'
import { useTranslation } from 'react-i18next'

export const CREDIT_CARD = '444df303dedc6dab69dd7ebcc9b8036a'
export const GIFT_CARD = '50d8cd61009931554764385482347f3a'
export const TERM_PAYMENT = '2c918088783591e3017836350bd21385'

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
      <PaymentList />
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
          {selectedPaymentMethod === GIFT_CARD && <GiftCardPayment />}
          {selectedPaymentMethod === TERM_PAYMENT && <TermPayment method={selectedPaymentMethod} />}
        </>
      )}

      <SlideNavigation currentStep={currentStep} nextActive={!orderRequirementsList.includes('payment')} />
    </Overlay>
  )
}

export { PaymentSlide }
