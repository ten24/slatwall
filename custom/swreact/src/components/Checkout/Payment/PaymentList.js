import { useDispatch, useSelector } from 'react-redux'
import { GiftCardDetails, CCDetails, TermPaymentDetails } from '../..'
import { removePayment } from '../../../actions/'
import { getAllOrderPayments, disableInteractionSelector } from '../../../selectors/'
import { useTranslation } from 'react-i18next'

const PaymentList = () => {
  const payments = useSelector(getAllOrderPayments)
  const disableInteraction = useSelector(disableInteractionSelector)

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
                <span className="font-size-sm"> {t('frontend.core.remove')}</span>
              </button>
            </div>
          )
        })}
      </div>
    </>
  )
}
export { PaymentList }
