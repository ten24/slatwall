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

export { CreditCardPayment }
