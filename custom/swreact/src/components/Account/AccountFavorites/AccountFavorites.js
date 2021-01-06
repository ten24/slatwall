import React from 'react'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import AccountLayout from '../AccountLayout/AccountLayout'

const AccountFavorites = () => {
  return (
    <AccountLayout>
      <h1>AccountFavorites</h1>
      <span>https://stoneandberg.ten24dev.com/my-account/favorites</span>
    </AccountLayout>
  )
}

function mapStateToProps(state) {
  const { preload } = state
  return preload
}

AccountFavorites.propTypes = {}
export default connect(mapStateToProps)(AccountFavorites)
