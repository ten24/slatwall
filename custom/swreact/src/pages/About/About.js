import React from 'react'
// import PropTypes from 'prop-types'
import { Layout } from '../../components'
import { connect } from 'react-redux'

const About = ({ title, customBody }) => {
  return (
    <Layout>
      <div className="bg-light p-0">
        <div className="page-title-overlap bg-lightgray pt-4">
          <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
            <div className="order-lg-1 pr-lg-4 text-center">
              <h1 className="h3 text-dark mb-0 font-accent">{title}</h1>
            </div>
          </div>
        </div>

        <div
          className="container bg-light box-shadow-lg rounded-lg p-5"
          dangerouslySetInnerHTML={{
            __html: customBody,
          }}
        ></div>
      </div>
    </Layout>
  )
}

function mapStateToProps(state) {
  const { preload } = state
  return preload.about
}

About.propTypes = {}
export default connect(mapStateToProps)(About)
