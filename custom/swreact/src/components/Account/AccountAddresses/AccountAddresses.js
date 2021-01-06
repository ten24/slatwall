import React from 'react'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import AccountLayout from '../AccountLayout/AccountLayout'

const AccountAddresses = () => {
  return (
    <AccountLayout>
      <h1>AccountAddresses</h1>
      <span>https://stoneandberg.ten24dev.com/my-account/addresses</span>
    </AccountLayout>
  )
}

function mapStateToProps(state) {
  const { preload } = state
  return preload
}

AccountAddresses.propTypes = {}
export default connect(mapStateToProps)(AccountAddresses)
