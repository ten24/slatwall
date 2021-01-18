import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { ActionBanner, SignUpForm } from '..'
import SWImage from '../SWImage/SWImage'
import styles from './Footer.module.css'
// import * as Yup from 'yup'

function Footer({ actionBanner, getInTouch, siteLinks, stayInformed, copywriteDate, actionBannerDisable, formLink, logo }) {
  return (
    <footer className="pt-5">
      {actionBanner.display && !actionBannerDisable && <ActionBanner {...actionBanner} />}

      <div className="bg-light p-5">
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
                <div className={`${styles.stayInformed}`} dangerouslySetInnerHTML={{ __html: stayInformed }} />
                <SignUpForm url={formLink} />
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className={`${styles.bgFooter} pt-4`}>
        <div className="container">
          <div className="row">
            <div className="col-md-6 text-center text-md-left mb-4 text-light">
              <SWImage className="w-50" src={logo} alt="Stone and Berg logo" />
            </div>
            <div className="col-md-6 font-size-xs text-center text-md-right mb-4">{`@${copywriteDate} `} All rights reserved. Stone and Berg Company Inc</div>
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
  logo: PropTypes.string,
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
