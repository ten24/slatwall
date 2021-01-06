import React from 'react'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import AccountLayout from '../AccountLayout/AccountLayout'

const AccountPaymentMethods = () => {
  return (
    <AccountLayout>
      <h1>AccountOrderCards</h1>
      <span>https://stoneandberg.ten24dev.com/my-account/cards</span>
    </AccountLayout>
  )
}

function mapStateToProps(state) {
  const { preload } = state
  return preload
}

AccountPaymentMethods.propTypes = {}
export default connect(mapStateToProps)(AccountPaymentMethods)
