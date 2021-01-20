import React, { useEffect } from 'react'
import { connect, useDispatch } from 'react-redux'
import { getUser } from '../../actions/userActions'
const AccountBubble = ({ isAuthenticated, name }) => {
  const dispatch = useDispatch()

  useEffect(() => {
    dispatch(getUser())
  }, [dispatch])
  return (
    <>
      <div className="navbar-tool-icon-box">
        <i className="far fa-user"></i>
      </div>
      <div className="navbar-tool-text ml-n3">
        <small>
          Hello, {isAuthenticated && name}
          {!isAuthenticated && 'Sign in'}
        </small>
        My Account
      </div>
    </>
  )
}

function mapStateToProps(state) {
  return {
    isAuthenticated: state.userReducer.accountID,
    name: `${state.userReducer.firstName} ${state.userReducer.lastName}`,
  }
}
export default connect(mapStateToProps)(AccountBubble)
