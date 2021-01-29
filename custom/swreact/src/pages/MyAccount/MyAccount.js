import React from 'react'
import { Layout } from '../../components'
import { connect } from 'react-redux'
import { Switch, Route, useRouteMatch } from 'react-router-dom'

const AccountLogin = React.lazy(() => import('../../components/Account/AccountLogin/AccountLogin'))
const AccountOverview = React.lazy(() => import('../../components/Account/AccountOverview/AccountOverview'))

const AccountProfile = React.lazy(() => import('../../components/Account/AccountProfile/AccountProfile'))

const AccountFavorites = React.lazy(() => import('../../components/Account/AccountFavorites/AccountFavorites'))

const AccountAddresses = React.lazy(() => import('../../components/Account/AccountAddresses/AccountAddresses'))

const AccountPaymentMethods = React.lazy(() => import('../../components/Account/AccountPaymentMethods/AccountPaymentMethods'))

const AccountOrderHistory = React.lazy(() => import('../../components/Account/AccountOrderHistory/AccountOrderHistory'))
const CreateOrEditAccountPaymentMethod = React.lazy(() => import('../../components/Account/AccountPaymentMethods/CreateOrEditAccountPaymentMethod'))

const MyAccount = ({ auth }) => {
  let match = useRouteMatch()
  return (
    <Layout>
      {auth.isAuthenticanted && (
        <Switch>
          <Route path={`${match.path}/addresses`}>
            <AccountAddresses />
          </Route>
          <Route path={`${match.path}/favorites`}>
            <AccountFavorites />
          </Route>
          <Route path={`${match.path}/cards`}>
            <AccountPaymentMethods />
          </Route>
          <Route path={`${match.path}/card/:id`}>
            <CreateOrEditAccountPaymentMethod />
          </Route>
          <Route path={`${match.path}/order-history`}>
            <AccountOrderHistory />
          </Route>
          <Route path={`${match.path}/profile`}>
            <AccountProfile />
          </Route>
          <Route path={match.path}>{auth.isAuthenticanted && <AccountOverview />}</Route>
        </Switch>
      )}
      {!auth.isAuthenticanted && <AccountLogin />}
    </Layout>
  )
}

const mapStateToProps = state => {
  return {
    auth: state.authReducer,
  }
}

export default connect(mapStateToProps)(MyAccount)
