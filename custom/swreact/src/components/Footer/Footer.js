import React from 'react'
import PropTypes from 'prop-types'
import logo from '../../assets/images/sb-logo-white.png'
import { connect } from 'react-redux'
import { useFormik } from 'formik'
import { ActionBanner, SignUpForm } from '..'
import SWImage from '../SWImage/SWImage'
// import * as Yup from 'yup'

const NewsletterForm = () => {
  const formik = useFormik({
    initialValues: {
      firstName: '',
      lastName: '',
      company: '',
      email: '',
    },

    onSubmit: values => {
      alert(JSON.stringify(values, null, 2))
    },
  })

  return (
    <form onSubmit={formik.handleSubmit}>
      <div className="input-group input-group-overlay flex-nowrap">
        <div className="input-group-prepend-overlay">
          <span className="input-group-text text-muted font-size-base"></span>
        </div>
        <div className="row">
          <div className="col-12 d-flex">
            <input className="form-control prepended-form-control mr-2" type="text" name="firstName" id="firstName" onChange={formik.handleChange} value={formik.values.firstName} placeholder="First Name" required />
            <input className="form-control prepended-form-control mr-2" type="text" name="lastName" id="lastName" onChange={formik.handleChange} value={formik.values.lastName} placeholder="Last Name" required />
            <input className="form-control prepended-form-control" type="text" name="company" id="company" onChange={formik.handleChange} value={formik.values.company} placeholder="Company" required />
          </div>
          <div className="col-12 d-flex pt-2">
            <input className="form-control prepended-form-control" type="email" name="email" id="email" placeholder="Your email" onChange={formik.handleChange} value={formik.values.email} required />
            <div className="input-group-append">
              <button className="btn btn-primary" type="submit" name="subscribe" id="mc-embedded-subscribe">
                Subscribe*
              </button>
            </div>
          </div>
        </div>
      </div>
      {/* <!--- real people should not fill this in and expect good things - do not remove this or risk form bot signups---> */}
      <div style={{ position: 'absolute', left: '-5000px' }} aria-hidden="true">
        <input type="text" name="b_c7103e2c981361a6639545bd5_29ca296126" tabIndex="-1" />
      </div>
      <small className="form-text text-light opacity-50" id="mc-helper">
        *Subscribe to our newsletter to receive early discount offers, updates and new products info.
      </small>
      <div className="subscribe-status"></div>
    </form>
  )
}

function Footer({ actionBanner, getInTouch, siteLinks, stayInformed, copywriteDate, actionBannerDisable, formLink }) {
  return (
    <footer className="pt-5">
      {actionBanner.display && !actionBannerDisable && <ActionBanner {...actionBanner} />}

      <div className="bg-light pt-4">
        <div className="container">
          <div className="row pt-2">
            <div className="col-md-2 col-sm-6">
              <div className="widget widget-links pb-2 mb-4" dangerouslySetInnerHTML={{ __html: siteLinks }} />
            </div>
            <div className="col-md-4 col-sm-6">
              <div className="widget widget-links pb-2 mb-4" dangerouslySetInnerHTML={{ __html: getInTouch }} />
            </div>
            <div className="col-md-6">
              <div className="widget pb-2 mb-4">
                <div dangerouslySetInnerHTML={{ __html: stayInformed }} />
                <SignUpForm url={formLink} />
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="bg-darker pt-4">
        <div className="container">
          <div className="row">
            <div className="col-md-6 text-center text-md-left mb-4 text-light">
              <SWImage className="w-50" src={logo} alt="Stone and Berg logo" />
            </div>
            <div className="col-md-6 font-size-xs text-light text-center text-md-right mb-4">{`@${copywriteDate} `} All rights reserved. Stone and Berg Company Inc</div>
          </div>
        </div>
      </div>
    </footer>
  )
}
Footer.propTypes = {
  actionBanner: PropTypes.object,
  getInTouch: PropTypes.string,
  siteLinks: PropTypes.string,
  stayInformed: PropTypes.string,
  copywriteDate: PropTypes.string,
  formLink: PropTypes.string,
  actionBannerDisable: PropTypes.bool,
}

Footer.defaultProps = {
  actionBanner: {
    display: true,
    markup: '',
  },
  getInTouch: '',
  siteLinks: '',
  stayInformed: '',
  copywriteDate: '',
  formLink: 'https://jster.us7.list-manage.com/subscribe/post?u=XXXX&id=XXXXXX',
  actionBannerDisable: false,
}

function mapStateToProps(state) {
  const { preload } = state
  return { ...preload.footer }
}

export default connect(mapStateToProps)(Footer)
