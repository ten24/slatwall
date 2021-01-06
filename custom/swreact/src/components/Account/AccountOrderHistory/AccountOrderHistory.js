import React from 'react'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import AccountLayout from '../AccountLayout/AccountLayout'

const AccountOrderHistory = () => {
  return (
    <AccountLayout>
      <h1>AccountOrderHistory</h1>
      <h1>https://stoneandberg.ten24dev.com/my-account/order-history</h1>
    </AccountLayout>
  )
}

function mapStateToProps(state) {
  const { preload } = state
  return preload
}

AccountOrderHistory.propTypes = {}
export default connect(mapStateToProps)(AccountOrderHistory)
