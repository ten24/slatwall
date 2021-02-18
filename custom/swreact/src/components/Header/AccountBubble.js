import React, { useEffect } from 'react'
import { connect, useDispatch } from 'react-redux'
import { getUser } from '../../actions/userActions'
import { useTranslation } from 'react-i18next'

const AccountBubble = ({ isAuthenticated, name }) => {
  const dispatch = useDispatch()
  const { t, i18n } = useTranslation()

  useEffect(() => {
    dispatch(getUser())
  }, [dispatch])
  return (
    <>
      <div className="navbar-tool-icon-box d-flex justify-content-center align-items-center">
        <i className="far fa-user"></i>
      </div>
      <div className="navbar-tool-text ml-n3">
        <small>
          Hello, {isAuthenticated && name}
          {!isAuthenticated && t('frontend.account.sign_in')}
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
