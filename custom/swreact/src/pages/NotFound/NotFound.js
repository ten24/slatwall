import React, { useEffect } from 'react'
// import PropTypes from 'prop-types'
import { Layout } from '../../components'
import { connect, useDispatch } from 'react-redux'
import { useHistory } from 'react-router-dom'
import { getContent } from '../../actions/contentActions'

const NotFound = ({ title, customBody, customSummary }) => {
  const dispatch = useDispatch()

  let history = useHistory()
  useEffect(() => {
    dispatch(
      getContent({
        content: {
          notfound: ['customBody', 'customSummary', 'title'],
        },
      })
    )
  }, [dispatch])
  return (
    <Layout>
      <div class="container py-5 mb-lg-3">
      <div class="row justify-content-center pt-lg-4 text-center">
        <div class="col-lg-5 col-md-7 col-sm-9">
          <h1 class="display-404">{title}</h1>
          <div
            dangerouslySetInnerHTML={{
              __html: customSummary,
            }}
          ></div>
        </div>
      </div>
      <div class="row justify-content-center">
        <div class="col-xl-8 col-lg-10">
          <div
            dangerouslySetInnerHTML={{
              __html: customBody,
            }}
          ></div>
        </div>
      </div>
    </div>
    </Layout>
  )
}

function mapStateToProps(state) {
  return { ...state.content.notfound }
}

NotFound.propTypes = {}
export default connect(mapStateToProps)(NotFound)
