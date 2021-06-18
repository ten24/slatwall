import { CartPromoBox, OrderNotes, OrderSummary, PromotionalMessaging, REVIEW, getCurrentStep } from '../../components'
import { useDispatch, useSelector } from 'react-redux'
import { useLocation } from 'react-router-dom'
import { useTranslation } from 'react-i18next'

import { placeOrder } from '../../actions/'
// https://www.digitalocean.com/community/tutorials/how-to-create-multistep-forms-with-react-and-semantic-ui
// https://github.com/srdjan/react-multistep/blob/master/react-multistep.js
// https://www.geeksforgeeks.org/how-to-create-multi-step-progress-bar-using-bootstrap/

//

const CheckoutSideBar = () => {
  const cart = useSelector(state => state.cart)
  const { isFetching } = cart
  const loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const currentStep = getCurrentStep(path)
  const { t } = useTranslation()
  const dispatch = useDispatch()

  return (
    <aside className="col-lg-4 pt-4 pt-lg-0">
      <div className="cz-sidebar-static rounded-lg box-shadow-lg ml-lg-auto">
        <PromotionalMessaging />

        <OrderSummary />
        {currentStep.key !== REVIEW && <CartPromoBox />}
        {currentStep.key === REVIEW && <OrderNotes />}
        {currentStep.key === REVIEW && (
          <button
            className="btn btn-primary btn-block mt-4"
            type="submit"
            disabled={isFetching}
            onClick={event => {
              dispatch(placeOrder())
              event.preventDefault()
            }}
          >
            {t('frontend.order.complete')}
          </button>
        )}
      </div>
    </aside>
  )
}

export { CheckoutSideBar }
