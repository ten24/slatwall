import { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { CreditCardDetails, SwRadioSelect } from '../..'
import { addPayment } from '../../../actions/cartActions'
import { orderPayment } from '../../../selectors/orderSelectors'
import { accountPaymentMethods } from '../../../selectors/userSelectors'
import { useTranslation } from 'react-i18next'

const CreditCardPayment = () => {
  const paymentMethods = useSelector(accountPaymentMethods)
  const [newOrderPayment, setNewOrderPayment] = useState(false)
  const { accountPaymentMethod = { accountPaymentMethodID: '' } } = useSelector(orderPayment)
  const dispatch = useDispatch()

  useEffect(() => {
    if (paymentMethods.length === 0) {
      // if there is no payment method found for the user , open new payment form
      setNewOrderPayment('new')
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
            selectedValue={newOrderPayment ? newOrderPayment : accountPaymentMethod.accountPaymentMethodID}
            displayNew={true}
          />
          <button
            className="btn btn-secondary mt-2"
            onClick={() => {
              setNewOrderPayment('new')
            }}
          >
            Add Payment Method
          </button>
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

export { CreditCardPayment }
