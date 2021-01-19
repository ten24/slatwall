import React from 'react'
import PropTypes from 'prop-types'
import { useHistory } from 'react-router-dom'

const ActionBanner = ({ display, markup }) => {
  let history = useHistory()

  if (display) {
    return (
      <div className="bg-primary p-5">
        <div className="container">
          <div className="row">
            <div className="col-0 col-md-2"></div>
            <div
              className="col-md-8 text-center"
              onClick={event => {
                event.preventDefault()
                history.push(event.target.getAttribute('href'))
              }}
              dangerouslySetInnerHTML={{ __html: markup }}
            />
            <div className="col-0 col-md-2"></div>
          </div>
        </div>
      </div>
    )
  } else {
    return <></>
  }
}
ActionBanner.propTypes = {
  display: PropTypes.bool,
  markup: PropTypes.string,
}

export default ActionBanner
// export default connect(mapStateToProps)(Layout)
