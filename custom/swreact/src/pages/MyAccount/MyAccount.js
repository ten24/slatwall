import React from 'react'
import { Layout } from '../../components'
import { getUser } from '../../actions/userActions'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { Switch, Route, useRouteMatch, Link } from 'react-router-dom'

const AccountLogin = React.lazy(() => import('../../components/Account/AccountLogin/AccountLogin'))
const AccountOverview = React.lazy(() => import('../../components/Account/AccountOverview/AccountOverview'))

const AccountProfile = React.lazy(() => import('../../components/Account/AccountProfile/AccountProfile'))

const AccountFavorites = React.lazy(() => import('../../components/Account/AccountFavorites/AccountFavorites'))

const AccountAddresses = React.lazy(() => import('../../components/Account/AccountAddresses/AccountAddresses'))

const AccountPaymentMethods = React.lazy(() => import('../../components/Account/AccountPaymentMethods/AccountPaymentMethods'))

const AccountOrderHistory = React.lazy(() => import('../../components/Account/AccountOrderHistory/AccountOrderHistory'))

const MyAccount = props => {
  const { auth } = props
  let match = useRouteMatch()
  return (
    <Layout>
      {auth.loginToken && (
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
          <Route path={`${match.path}/order-history`}>
            <AccountOrderHistory />
          </Route>
          <Route path={`${match.path}/profile`}>
            <AccountProfile />
          </Route>
          <Route path={match.path}>
            {auth.loginToken && <AccountOverview />}
            {!auth.loginToken && <AccountLogin />}
          </Route>
        </Switch>
      )}
      {!auth.loginToken && <AccountLogin />}
    </Layout>
  )
}

const mapStateToProps = state => {
  return {
    auth: state.authReducer,
    user: state.userReducer,
  }
}

const mapDispatchToProps = dispatch => {
  return {
    getUser: async () => dispatch(getUser()),
  }
}
export default connect(mapStateToProps, mapDispatchToProps)(MyAccount)
