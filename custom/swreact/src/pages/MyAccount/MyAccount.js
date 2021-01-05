import React from 'react'
import { Layout } from '../../components'
import { getUser } from '../../actions/userActions'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { Switch, Route, useRouteMatch } from 'react-router-dom'

const AccountLogin = React.lazy(() =>
  import('../../components/AccountLogin/AccountLogin')
)
const AccountProfile = React.lazy(() =>
  import('../../components/AccountProfile/AccountProfile')
)

const OrderCards = React.lazy(() =>
  import('../../components/OrderCards/OrderCards')
)

const OrderHistory = React.lazy(() =>
  import('../../components/OrderHistory/OrderHistory')
)

const MyAccountRoot = props => {
  const { auth } = props
  return (
    <Layout>
      <div>MyAccount</div>
      {auth.loginToken && <AccountProfile />}
      {!auth.loginToken && <AccountLogin />}
    </Layout>
  )
}

const MyAccount = props => {
  let match = useRouteMatch()
  return (
    <Switch>
      <Route path={`${match.path}/cards`}>
        <OrderCards />
      </Route>
      <Route path={`${match.path}/order-history`}>
        <OrderHistory />
      </Route>
      <Route path={match.path}>
        <MyAccountRoot {...props} />
      </Route>
    </Switch>
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
