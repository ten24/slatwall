import React from 'react'
import { Layout } from '../../components'
import { getUser } from '../../actions/userActions'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'

const AccountLogin = React.lazy(() =>
  import('../../components/AccountLogin/AccountLogin')
)
const AccountProfile = React.lazy(() =>
  import('../../components/AccountProfile/AccountProfile')
)

const MyAccount = ({ user, auth }) => {
  return (
    <Layout>
      <div>MyAccount</div>
      {auth.loginToken && <AccountProfile />}
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
