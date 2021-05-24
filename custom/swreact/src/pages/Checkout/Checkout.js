import { PageHeader, Layout, CheckoutSideBar, StepsHeader, getCurrentStep, ShippingSlide, PaymentSlide, ReviewSlide } from '../../components'
import { useSelector } from 'react-redux'
import { Redirect, Route, Switch, useHistory, useLocation, useRouteMatch } from 'react-router-dom'
import './checkout.css'
import { isAuthenticated } from '../../utils'
import { useEffect } from 'react'

const Checkout = () => {
  let match = useRouteMatch()
  const loc = useLocation()
  const history = useHistory()
  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const currentStep = getCurrentStep(path)
  const { verifiedAccountFlag, isFetching, accountID } = useSelector(state => state.userReducer)
  const enforceVerifiedAccountFlag = useSelector(state => state.configuration.enforceVerifiedAccountFlag)

  useEffect(() => {
    if (!isAuthenticated()) {
      history.push(`/my-account?redirect=${loc.pathname}`)
    }
  }, [history, loc])

  if (enforceVerifiedAccountFlag && !verifiedAccountFlag && isAuthenticated() && !isFetching && accountID.length > 0) {
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
