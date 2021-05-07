import { CartPromoBox, Layout, OrderNotes, OrderSummary, PromotionalMessaging } from '../../components'
import { useDispatch, useSelector } from 'react-redux'
import { Redirect, Route, Switch, useHistory, useLocation, useRouteMatch } from 'react-router-dom'
import PageHeader from '../../components/PageHeader/PageHeader'
import { useTranslation } from 'react-i18next'
import './checkout.css'
import ShippingSlide from './Shipping'
import PaymentSlide from './Payment'
import ReviewSlide from './Review'

import { checkOutSteps, REVIEW } from './steps'
import { placeOrder } from '../../actions/cartActions'
import { isAuthenticated } from '../../utils'
import { useEffect } from 'react'
// https://www.digitalocean.com/community/tutorials/how-to-create-multistep-forms-with-react-and-semantic-ui
// https://github.com/srdjan/react-multistep/blob/master/react-multistep.js
// https://www.geeksforgeeks.org/how-to-create-multi-step-progress-bar-using-bootstrap/

//
const getCurrentStep = path => {
  return (checkOutSteps.filter(step => {
    return step.key === path
  }) || [checkOutSteps[1]])[0]
}

const StepsHeader = () => {
  const { t } = useTranslation()
  const loc = useLocation()
  let history = useHistory()

  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const current = getCurrentStep(path)
  return (
    <div className="steps steps-dark pt-2 pb-3 mb-5">
      {checkOutSteps.map(step => {
        let progressSate = ''
        if (step.progress < current.progress) {
          progressSate = 'active'
        } else if (step.progress === current.progress) {
          progressSate = 'active current'
        }
        return (
          <button
            className={`step-item ${progressSate} btn btn-link flex-grow-1 p-0`}
            style={{ border: 'none' }}
            key={step.progress}
            onClick={e => {
              e.preventDefault()
              if (step.key === 'checkout') history.push('/shopping-cart')
              else history.push(step.key)
            }}
            disabled={progressSate === ''}
          >
            <div className="step-progress">
              <span className="step-count">{step.progress}</span>
            </div>
            <div className="step-label">
              <i className={`fal fa-${step.icon}`}></i>
              {t(step.name)}
            </div>
          </button>
        )
      })}
    </div>
  )
}

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
const Checkout = () => {
  let match = useRouteMatch()
  const loc = useLocation()
  const history = useHistory()
  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const currentStep = getCurrentStep(path)
  const verifiedAccountFlag = useSelector(state => state.userReducer.verifiedAccountFlag)
  const enforceVerifiedAccountFlag = useSelector(state => state.configuration.enforceVerifiedAccountFlag)

  useEffect(() => {
    if (!isAuthenticated()) {
      history.push(`/my-account?redirect=${loc.pathname}`)
    }
  }, [history, loc])

  if (enforceVerifiedAccountFlag && !verifiedAccountFlag && isAuthenticated()) {
    return <Redirect to="/account-verification" />
  }

  return (
    <Layout>
      <PageHeader />
      <div className="container pb-5 mb-2 mb-md-4">
        <div className="row">
          <section className="col-lg-8">
            {/* <!-- Steps--> */}
            <StepsHeader />
            <Route path={`${match.path}/cart`}>
              <Redirect to="/cart" />
            </Route>

            <Switch>
              <Route path={`${match.path}/shipping`}>
                <ShippingSlide currentStep={currentStep} />
              </Route>

              <Route path={`${match.path}/payment`}>
                <PaymentSlide currentStep={currentStep} />
              </Route>
              <Route path={`${match.path}/review`}>
                <ReviewSlide currentStep={currentStep} />
              </Route>
              <Route path={match.path}>
                <Redirect to={`${match.path}/shipping`} />
              </Route>
            </Switch>
          </section>
          {/* <!-- Sidebar--> */}
          <CheckoutSideBar />
        </div>
      </div>
    </Layout>
  )
}

export default Checkout
