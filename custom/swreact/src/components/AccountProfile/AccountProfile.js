import { useEffect } from 'react'
import { getUser } from '../../actions/userActions'
import { logout } from '../../actions/authActions'
import { connect } from 'react-redux'

const AccountProfile = ({ getUser, user, logout }) => {
  useEffect(() => {
    getUser()
  }, [])

  if (!user.accountID === '' || user.isFetching) {
    return (
      <div>
        <span>Loading...</span>
        <button
          type="button"
          className="btn btn-outline-primary"
          onClick={() => {
            logout()
          }}
        >
          Logout
        </button>{' '}
      </div>
    )
  }
  return (
    <div>
      <h1>Account Profile</h1>
      <button
        type="button"
        className="btn btn-outline-primary"
        onClick={() => {
          getUser()
        }}
      >
        Account Profile
      </button>
      <button
        type="button"
        className="btn btn-outline-primary"
        onClick={() => {
          logout()
        }}
      >
        Logout
      </button>
      <div>
        <pre>{JSON.stringify(user, null, 2)}</pre>
      </div>
    </div>
  )
}
const mapStateToProps = (state) => {
  return {
    user: state.userReducer,
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    getUser: async () => dispatch(getUser()),
    logout: async () => dispatch(dispatch(logout())),
  }
}
export default connect(mapStateToProps, mapDispatchToProps)(AccountProfile)
