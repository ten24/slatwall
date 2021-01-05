import React from 'react'
// import PropTypes from 'prop-types'
import { Layout } from '../../components'
import { connect } from 'react-redux'

const CategoryListing = () => {
  return (
    <Layout>
      <h1>CategoryListing</h1>
      <a
        target="_blank"
        rel="noreferrer"
        href="https://stoneandberg.ten24dev.com/category-listing"
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

CategoryListing.propTypes = {}
export default connect(mapStateToProps)(CategoryListing)
