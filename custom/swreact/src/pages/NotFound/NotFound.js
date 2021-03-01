import React, { useEffect } from 'react'
// import PropTypes from 'prop-types'
import { useSelector } from 'react-redux'
import { useLocation } from 'react-router-dom'

const NotFound = () => {
  let loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const contentStore = useSelector(state => state.content[path]) || {}

  return (
    <div className="container py-5 mb-lg-3">
      <div className="row justify-content-center pt-lg-4 text-center">
        <div className="col-lg-5 col-md-7 col-sm-9">
          <h1 className="display-404">{contentStore.title}</h1>
          <div
            dangerouslySetInnerHTML={{
              __html: contentStore.customSummary,
            }}
          ></div>
        </div>
      </div>
      <div className="row justify-content-center">
        <div className="col-xl-8 col-lg-10">
          <div
            dangerouslySetInnerHTML={{
              __html: contentStore.customBody,
            }}
          ></div>
        </div>
      </div>
    </div>
  )
}

export default NotFound
