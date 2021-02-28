import React, { useEffect } from 'react'
import { Layout } from '../../components'
import { connect, useDispatch } from 'react-redux'
import { Switch, Route, useRouteMatch, useLocation } from 'react-router-dom'
import { getUser } from '../../actions/userActions'
import CreateAccount from '../../components/Account/CreateAccount/CreateAccount'
import ForgotPassword from '../../components/Account/ForgotPassword/ForgotPassword'

// I think we should be prelaoding these https://medium.com/maxime-heckel/react-lazy-a-take-on-preloading-views-cc90be869f14
const AccountLogin = React.lazy(() => import('../../components/Account/AccountLogin/AccountLogin'))
const AccountOverview = React.lazy(() => import('../../components/Account/AccountOverview/AccountOverview'))
const AccountProfile = React.lazy(() => import('../../components/Account/AccountProfile/AccountProfile'))
const AccountFavorites = React.lazy(() => import('../../components/Account/AccountFavorites/AccountFavorites'))
const AccountAddresses = React.lazy(() => import('../../components/Account/AccountAddresses/AccountAddresses'))
const CreateOrEditAccountAddress = React.lazy(() => import('../../components/Account/AccountAddresses/CreateOrEditAccountAddress'))
const AccountOrderDetail = React.lazy(() => import('../../components/Account/AccountOrderDetail/AccountOrderDetail'))
const AccountPaymentMethods = React.lazy(() => import('../../components/Account/AccountPaymentMethods/AccountPaymentMethods'))
const AccountOrderHistory = React.lazy(() => import('../../components/Account/AccountOrderHistory/AccountOrderHistory'))
const CreateOrEditAccountPaymentMethod = React.lazy(() => import('../../components/Account/AccountPaymentMethods/CreateOrEditAccountPaymentMethod'))
const pageComponents = {
  AccountLogin,
  AccountOverview,
  AccountProfile,
  AccountFavorites,
  AccountAddresses,
  CreateOrEditAccountAddress,
  AccountOrderDetail,
  AccountPaymentMethods,
  AccountOrderHistory,
  CreateOrEditAccountPaymentMethod,
}
const MyAccount = ({ auth, user }) => {
  let match = useRouteMatch()
  let loc = useLocation()
  const dispatch = useDispatch()
  useEffect(() => {
    // Object.keys(pageComponents).map(key => {
    //   return pageComponents[key].preload()
    // })
    if (auth.isAuthenticanted && !user.isFetching && !user.accountID.length) {
      dispatch(getUser())
    }
  }, [dispatch, auth, user])

  const path = loc.pathname.split('/').reverse()
  return (
    <Layout>
      {auth.isAuthenticanted && (
        <Switch>
          <Route path={`${match.path}/addresses/:id`}>
            <CreateOrEditAccountAddress path={path[0]} />
          </Route>
          <Route path={`${match.path}/addresses`}>
            <AccountAddresses />
          </Route>
          <Route path={`${match.path}/cards/:id`}>
            <CreateOrEditAccountPaymentMethod path={path[0]} />
          </Route>
          <Route path={`${match.path}/cards`}>
            <AccountPaymentMethods />
          </Route>
          <Route path={`${match.path}/favorites`}>
            <AccountFavorites />
          </Route>
          <Route path={`${match.path}/orders/:id`}>
            <AccountOrderDetail path={path[0]} forwardState={loc.state} />
          </Route>
          <Route path={`${match.path}/orders`}>
            <AccountOrderHistory />
          </Route>
          <Route path={`${match.path}/profile`}>
            <AccountProfile />
          </Route>
          <Route path={match.path}>{auth.isAuthenticanted && <AccountOverview />}</Route>
        </Switch>
      )}
      {!auth.isAuthenticanted && (
        <Switch>
          <Route path={`${match.path}/createAccount`}>
            <CreateAccount />
          </Route>
          <Route path={`${match.path}/forgotPassword`}>
            <ForgotPassword />
          </Route>
          <Route path={match.path}>
            <AccountLogin />
          </Route>
        </Switch>
      )}
    </Layout>
  )
}

const mapStateToProps = state => {
  return {
    auth: state.authReducer,
    user: state.userReducer,
  }
}

export default connect(mapStateToProps)(MyAccount)
