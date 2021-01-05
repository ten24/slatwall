import React from 'react'
// import PropTypes from 'prop-types'
import { Layout } from '../../components'
import { connect } from 'react-redux'

const About = () => {
  return (
    <Layout>
      <h1>About</h1>
      <a
        target="_blank"
        rel="noreferrer"
        href="https://stoneandberg.ten24dev.com/about"
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

About.propTypes = {}
export default connect(mapStateToProps)(About)
