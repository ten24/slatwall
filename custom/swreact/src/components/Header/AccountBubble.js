import React, { useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { getUser } from '../../actions/userActions'
import { useTranslation } from 'react-i18next'

const AccountBubble = () => {
  const dispatch = useDispatch()
  const { t } = useTranslation()
  const { firstName, lastName, accountID } = useSelector(state => state.userReducer)
  const name = `${firstName} ${lastName}`
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
          Hello, {accountID && name}
          {!accountID && t('frontend.account.sign_in')}
        </small>
        My Account
      </div>
    </>
  )
}

export { AccountBubble }
