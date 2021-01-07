import React, { useState } from 'react'
import { login } from '../../../actions/authActions'
import { getUser } from '../../../actions/userActions'
import { connect } from 'react-redux'

const AccountLogin = ({ login, auth }) => {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  return (
    <div>
      <h1>API --</h1>
      <span>Username</span>
      <input
        value={email}
        onChange={event => {
          setEmail(event.target.value)
        }}
      />
      <span>Password</span>
      <input
        value={password}
        type="password"
        onChange={event => {
          setPassword(event.target.value)
        }}
      />
      <button
        type="button"
        className="btn btn-outline-primary"
        disabled={auth.isFetching}
        onClick={() => {
          login(email, password)
        }}
      >
        use SDK
      </button>
    </div>
  )
}
const mapStateToProps = state => {
  return {
    auth: state.authReducer,
    user: state.userReducer,
  }
}

const mapDispatchToProps = dispatch => {
  console.log('were')
  return {
    getUser: async () => dispatch(getUser()),
    login: async (email, password) => dispatch(login(email, password)),
  }
}
export default connect(mapStateToProps, mapDispatchToProps)(AccountLogin)
