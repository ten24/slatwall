import React from 'react'
import PropTypes from 'prop-types'
import { useHistory } from 'react-router-dom'
import { connect } from 'react-redux'
//        local.homeContentColumns.addFilter("urlTitlePath","%content-columns/%","LIKE")

function HomeDetails(props) {
  let homeContent = []
  Object.keys(props).map(key => {
    if (key.includes('content-columns/')) {
      homeContent.push(props[key])
    }
  })
  let history = useHistory()

  return (
    <div className="container">
      <div className="row text-center mt-5 mb-5">
        {homeContent &&
          homeContent.map((section, index) => {
            return (
              <div key={index} className="col-md">
                <img className="mb-3" src="" alt="" />
                <h3 className="h3">{section.title}</h3>
                <p
                  onClick={event => {
                    event.preventDefault()
                    history.push(event.target.getAttribute('href'))
                  }}
                  dangerouslySetInnerHTML={{ __html: section.customBody }}
                />
              </div>
            )
          })}
      </div>
    </div>
  )
}

HomeDetails.propTypes = {
  homeContent: PropTypes.array,
}

function mapStateToProps(state) {
  return state.content
}

export default connect(mapStateToProps)(HomeDetails)
