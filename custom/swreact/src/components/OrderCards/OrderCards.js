import React from 'react'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'

const OrderCards = () => {
  return (
    <>
      <h1>OrderCards</h1>
    </>
  )
}

function mapStateToProps(state) {
  const { preload } = state
  return preload
}

OrderCards.propTypes = {}
export default connect(mapStateToProps)(OrderCards)
