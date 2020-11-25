import React from 'react'
import PropTypes from 'prop-types'

function HomeDetails(props) {
  return (
    <div className="container">
      <div className="row text-center mt-5 mb-5">
        <div className="col-md">
          <img className="mb-3" src="" alt="" />
          <h3 className="h3">High Quality Products</h3>
          <p>
            We keep inventory of over 90 manufacturers on the shelf, giving you
            access to a wide range of products. No matter what the job requires
            we can get you what you need, and fast.
          </p>
        </div>
        <div className="col-md">
          <img className="mb-3" src="" alt="" />
          <h3 className="h3">In-House Training</h3>
          <p>
            We love our industry, and believe that working together is essential
            to ensuring that it thrives. We offer in-house training for anyone
            that would like to expand their knowledge and continue learning
            through a hands-on approach.
          </p>
        </div>
        <div className="col-md">
          <img className="mb-3" src="" alt="" />
          <h3 className="h3">Give us a Call</h3>
          <p>
            Stone &amp; Berg Company, Inc. has been providing specialized
            services to clients in the locksmith industry for more than 52
            years. We have an in-house technical staff that will be happy to
            assist you with any questions you may have, so don&rsquo;t be afraid
            to pick up the phone!
          </p>
        </div>
      </div>
    </div>
  )
}

HomeDetails.propTypes = {}

export default HomeDetails
