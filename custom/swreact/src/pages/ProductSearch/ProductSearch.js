import React from 'react'
// import PropTypes from 'prop-types'
import { Layout } from '../../components'
import { connect } from 'react-redux'

const ProductSearch = () => {
  return (
    <Layout>
      <h1>ProductSearch</h1>
      <a
        target="_blank"
        rel="noreferrer"
        href="https://stoneandberg.ten24dev.com/products"
      >
        Template
      </a>
    </Layout>
  )
}

function mapStateToProps(state) {
  const { preload } = state
  return preload
}

ProductSearch.propTypes = {}
export default connect(mapStateToProps)(ProductSearch)
