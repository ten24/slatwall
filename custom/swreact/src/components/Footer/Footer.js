import React from 'react'
import PropTypes from 'prop-types'
import logo from '../../assets/images/sb-logo-white.png'

function Footer(props) {
  return (
    <footer className="pt-5">
      {props.isContact === 'true' && (
        <div className="bg-primary p-5">
          <div className="container">
            <div className="row">
              <div className="col-0 col-md-2"></div>
              <div
                className="col-md-8 text-center tom2"
                dangerouslySetInnerHTML={{ __html: props.contactUs }}
              />
              <div className="col-0 col-md-2"></div>
            </div>
          </div>
        </div>
      )}

      <div className="bg-light pt-4">
        <div className="container">
          <div className="row pt-2">
            <div className="col-md-2 col-sm-6">
              <div
                className="widget widget-links pb-2 mb-4"
                dangerouslySetInnerHTML={{ __html: props.siteLinks }}
              />
            </div>
            <div className="col-md-4 col-sm-6">
              <div
                className="widget widget-links pb-2 mb-4"
                dangerouslySetInnerHTML={{ __html: props.getInTouch }}
              />
            </div>
            <div className="col-md-6">
              <div className="widget pb-2 mb-4">
                <div dangerouslySetInnerHTML={{ __html: props.stayInformed }} />
                <form
                  className="validate"
                  action="##"
                  method="get"
                  name="mc-embedded-subscribe-form"
                  id="mc-embedded-subscribe-form"
                >
                  <div className="input-group input-group-overlay flex-nowrap">
                    <div className="input-group-prepend-overlay">
                      <span className="input-group-text text-muted font-size-base"></span>
                    </div>
                    <div className="row">
                      <div className="col-12 d-flex">
                        <input
                          className="form-control prepended-form-control mr-2"
                          type="text"
                          name="FirstName"
                          id="mce-FirstName"
                          defaultValue=""
                          onChange={() => {}}
                          placeholder="First Name"
                          required
                        />
                        <input
                          className="form-control prepended-form-control mr-2"
                          type="text"
                          name="LastName"
                          id="mce-LastName"
                          defaultValue=""
                          onChange={() => {}}
                          placeholder="Last Name"
                          required
                        />
                        <input
                          className="form-control prepended-form-control"
                          type="text"
                          name="Company"
                          id="mce-Comapny"
                          defaultValue=""
                          placeholder="Company"
                          required
                        />
                      </div>
                      <div className="col-12 d-flex pt-2">
                        <input
                          className="form-control prepended-form-control"
                          type="email"
                          name="Email"
                          id="mce-Email"
                          defaultValue=""
                          onChange={() => {}}
                          placeholder="Your email"
                          required
                        />
                        <div className="input-group-append">
                          <button
                            className="btn btn-primary"
                            type="submit"
                            name="subscribe"
                            id="mc-embedded-subscribe"
                          >
                            Subscribe*
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                  {/* <!--- real people should not fill this in and expect good things - do not remove this or risk form bot signups---> */}
                  <div
                    style={{ position: 'absolute', left: '-5000px' }}
                    aria-hidden="true"
                  >
                    <input
                      type="text"
                      name="b_c7103e2c981361a6639545bd5_29ca296126"
                      tabIndex="-1"
                    />
                  </div>
                  <small
                    className="form-text text-light opacity-50"
                    id="mc-helper"
                  >
                    *Subscribe to our newsletter to receive early discount
                    offers, updates and new products info.
                  </small>
                  <div className="subscribe-status"></div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="bg-darker pt-4">
        <div className="container">
          <div className="row">
            <div className="col-md-6 text-center text-md-left mb-4 text-light">
              <img className="w-50" src={logo} alt="Stone and Berg logo" />
            </div>
            <div className="col-md-6 font-size-xs text-light text-center text-md-right mb-4">
              {`@${props.copywriteDate} `} All rights reserved. Stone and Berg
              Company Inc
            </div>
          </div>
        </div>
      </div>
    </footer>
  )
}
Footer.propTypes = {
  isContact: PropTypes.string,
  contactUs: PropTypes.string,
  getInTouch: PropTypes.string,
  siteLinks: PropTypes.string,
  stayInformed: PropTypes.string,
  copywriteDate: PropTypes.string,
}

export default Footer
