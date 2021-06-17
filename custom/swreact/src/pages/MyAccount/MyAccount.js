import React, { useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Switch, Route, useRouteMatch, useLocation, Redirect } from 'react-router-dom'
import { getUser } from '../../actions/userActions'

import { isAuthenticated } from '../../utils'
import queryString from 'query-string'
import { Layout, CreateAccount, ForgotPassword, AccountCarts, AccountLogin, AccountOverview, AccountProfile, AccountFavorites, AccountAddresses, CreateOrEditAccountAddress, AccountOrderDetail, AccountPaymentMethods, AccountOrderHistory, CreateOrEditAccountPaymentMethod } from '../../components'

// eslint-disable-next-line no-unused-vars
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
const MyAccount = () => {
  let match = useRouteMatch()
  let loc = useLocation()
  const dispatch = useDispatch()
  const user = useSelector(state => state.userReducer)

  useEffect(() => {
    if (isAuthenticated() && !user.isFetching && !user.accountID.length) {
      dispatch(getUser())
    }
  }, [dispatch, user])
  if (isAuthenticated() && loc.search.includes('redirect=')) {
    const params = queryString.parse(loc.search)
    return <Redirect to={params.redirect} />
  }

  const path = loc.pathname.split('/').reverse()
  return (
    <Layout>
      {isAuthenticated() && (
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
          <Route path={`${match.path}/carts`}>
            <AccountCarts />
          </Route>
          <Route path={match.path}>{isAuthenticated() && <AccountOverview />}</Route>
        </Switch>
      )}
      {!isAuthenticated() && (
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

export default MyAccount
