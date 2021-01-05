import React from 'react'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'

const OrderHistory = () => {
  return (
    <>
      <h1>OrderHistory</h1>
    </>
  )
}

function mapStateToProps(state) {
  const { preload } = state
  return preload
}

OrderHistory.propTypes = {}
export default connect(mapStateToProps)(OrderHistory)
