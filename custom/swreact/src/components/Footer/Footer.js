import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { ActionBanner, SignUpForm } from '..'
import styles from './Footer.module.css'
import logo from '../../assets/images/sb-logo-white.png'

function Footer({ actionBanner, getInTouch, siteLinks, stayInformed, copywriteDate, actionBannerDisable, formLink }) {
  return (
    <footer className="pt-5">
      {actionBanner.display && !actionBannerDisable && <ActionBanner {...actionBanner} />}

      <div className={`${styles.bottomBar} p-5`}>
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
              <img className="w-50" src={logo} alt="Stone & Berg Logo" />
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
  copywriteDate: PropTypes.number,
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
  return {
    actionBanner: {
      display: true,
      markup: state.preload.stackedContent['footer/contact-us'],
    },
    getInTouch: state.preload.stackedContent['footer/get-in-touch'],
    siteLinks: state.preload.stackedContent['footer/site-links'],
    stayInformed: state.preload.stackedContent['footer/stay-informed'],
    copywriteDate: state.preload.stackedContent['footer/copywriteDate'],
    formLink: state.preload.footer.formLink,
  }
}

export default connect(mapStateToProps)(Footer)
