import React, { useEffect } from 'react'
// import PropTypes from 'prop-types'
import { Layout } from '../../components'
import { connect, useDispatch } from 'react-redux'
import { useHistory } from 'react-router-dom'
import { getContent } from '../../actions/contentActions'

const About = ({ title, customBody }) => {
  const dispatch = useDispatch()

  let history = useHistory()
  useEffect(() => {
    dispatch(
      getContent({
        content: {
          about: ['customBody', 'customSummary', 'title'],
        },
      })
    )
  }, [dispatch])
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
          onClick={event => {
            event.preventDefault()
            history.push(event.target.getAttribute('href'))
          }}
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
