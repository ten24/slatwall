import React from 'react'
// import PropTypes from 'prop-types'
import { Layout } from '../../components'
import { connect } from 'react-redux'

const Contact = () => {
  return (
    <Layout>
      <h1>Contact</h1>
      <a
        target="_blank"
        rel="noreferrer"
        href="https://stoneandberg.ten24dev.com/contact"
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

Contact.propTypes = {}
export default connect(mapStateToProps)(Contact)
