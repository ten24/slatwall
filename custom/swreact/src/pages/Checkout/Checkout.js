import { CartPromoBox, Layout, PromotionalMessaging, Spinner } from '../../components'
import { useSelector } from 'react-redux'
import { Link, Redirect, Route, Switch, useHistory, useLocation, useRouteMatch } from 'react-router-dom'
import PageHeader from '../../components/PageHeader/PageHeader'
import { useTranslation } from 'react-i18next'
import './checkout.css'
import useFormatCurrency from '../../hooks/useFormatCurrency'
import ShippingSlide from './Shipping'
import PaymentSlide from './Payment'
import ReviewSlide from './Review'
import { checkOutSteps, REVIEW } from './steps'
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
  const { t, i18n } = useTranslation()
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
          <a
            className={`step-item ${progressSate}`}
            key={step.progress}
            onClick={e => {
              e.preventDefault()
              history.push(step.link)
            }}
          >
            <div className="step-progress">
              <span className="step-count">{step.progress}</span>
            </div>
            <div className="step-label">
              <i className={`fal fa-${step.icon}`}></i>
              {t(step.name)}
            </div>
          </a>
        )
      })}
    </div>
  )
}

const SlideNavigation = () => {
  const loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const currentStep = getCurrentStep(path)

  return (
    <>
      <div className="d-lg-flex pt-4 mt-3">
        <div className="w-50 pr-3">
          <Link className="btn btn-secondary btn-block" to={currentStep.previous}>
            <i className="far fa-chevron-left"></i> <span className="d-none d-sm-inline">Back</span>
            <span className="d-inline d-sm-none">Back</span>
          </Link>
        </div>
        {currentStep.next.length > 0 && (
          <div className="w-50 pl-2">
            <Link className="btn btn-primary btn-block" to={currentStep.next}>
              <span className="d-none d-sm-inline">Save & Continue</span>
              <span className="d-inline d-sm-none">Next</span> <i className="far fa-chevron-right"></i>
            </Link>
          </div>
        )}
      </div>
    </>
  )
}

const CheckoutSideBar = () => {
  const cart = useSelector(state => state.cart)
  const { isFetching, total, taxTotal, subtotal, discountTotal, fulfillmentChargeAfterDiscountTotal } = cart
  const loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const currentStep = getCurrentStep(path)
  const [formatCurrency] = useFormatCurrency({})
  const { t, i18n } = useTranslation()

  return (
    <aside className="col-lg-4 pt-4 pt-lg-0">
      <div className="cz-sidebar-static rounded-lg box-shadow-lg ml-lg-auto">
        <PromotionalMessaging />

        <div className="widget mb-3">
          <h2 className="widget-title text-center">Order summary</h2>
        </div>
        <ul className="list-unstyled font-size-sm pb-2 border-bottom">
          <li className="d-flex justify-content-between align-items-center">
            <span className="mr-2">Subtotal:</span>
            <span className="text-right">{subtotal > 0 ? formatCurrency(subtotal) : '--'}</span>
          </li>
          <li className="d-flex justify-content-between align-items-center">
            <span className="mr-2">Shipping:</span>
            <span className="text-right">{fulfillmentChargeAfterDiscountTotal > 0 ? formatCurrency(fulfillmentChargeAfterDiscountTotal) : '--'}</span>
          </li>
          <li className="d-flex justify-content-between align-items-center">
            <span className="mr-2">Taxes:</span>
            <span className="text-right">{taxTotal > 0 ? formatCurrency(taxTotal) : '--'}</span>
          </li>
          <li className="d-flex justify-content-between align-items-center">
            <span className="mr-2">Discount:</span>
            <span className="text-right">{discountTotal > 0 ? formatCurrency(discountTotal) : '--'}</span>
          </li>
        </ul>
        <h3 className="font-weight-normal text-center my-4">
          <span>{total > 0 ? formatCurrency(total) : '--'}</span>
          {/* $274.<small>50</small> */}
        </h3>
        {currentStep.key !== REVIEW && <CartPromoBox />}
        {currentStep.key !== REVIEW && (
          <button
            className="btn btn-primary btn-block mt-4"
            type="submit"
            disabled={isFetching}
            onClick={event => {
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
  const cart = useSelector(state => state.cart)
  const { isFetching } = cart
  let match = useRouteMatch()
  const loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const currentStep = getCurrentStep(path)

  return (
    <Layout>
      <PageHeader />
      <div className="container pb-5 mb-2 mb-md-4">
        <div className="row">
          <section className="col-lg-8">
            {/* <!-- Steps--> */}
            <StepsHeader />

            <Switch>
              <Route path={`${match.path}/shipping`}>
                <ShippingSlide />
              </Route>
              <Route path={`${match.path}/cart`}>
                <Redirect to="/cart" />
              </Route>
              <Route path={`${match.path}/payment`}>
                <PaymentSlide />
              </Route>
              <Route path={`${match.path}/review`}>
                <ReviewSlide />
              </Route>
              <Route path={match.path}>
                <Redirect to={`${match.path}/shipping`} />
              </Route>
            </Switch>

            <SlideNavigation />
          </section>
          {/* <!-- Sidebar--> */}
          <CheckoutSideBar />
        </div>
      </div>
    </Layout>
  )
}

export default Checkout
