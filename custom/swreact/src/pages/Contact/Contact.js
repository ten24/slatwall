import React from 'react'
// import PropTypes from 'prop-types'
import { ActionBanner, Layout } from '../../components'
import { connect } from 'react-redux'

// TODO:  https://stoneandberg.ten24dev.com/contact?submitted=true

const Contact = ({ title, customSummary, form, customBody, actionBanner }) => {
  return (
    <Layout actionBannerDisable={actionBanner.display}>
      <div className="page-title-overlap bg-lightgray pt-4 pb-5">
        <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
          <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
            <h1 className="h3 mb-0">{title}</h1>
          </div>
        </div>
      </div>

      {/* <!-- Page Content--> */}
      <div className="container pb-5 mb-2 mb-md-3">
        <div className="row">
          {/* <!-- Content  --> */}
          <section className="col-lg-8">
            {/* <!-- Summary Content--> */}
            <div className="mt-5 pt-5">
              <div
                dangerouslySetInnerHTML={{
                  __html: customSummary,
                }}
              />
              {/* <!--- UK Storage Signup Form ---> */}
              {/* <cfif isDefined("url.submitted")> */}
              {/* <div className="alert alert-success" role="alert">
                Thank you for contacting us, we will get back to you as soon as
                possible.
              </div> */}
              {/* </cfif> */}
              {/* <div className="contactForm mt-4 <cfif IsDefined("url.submitted")>hide</cfif>"> */}
              <div className="contactForm mt-4">
                <div
                  dangerouslySetInnerHTML={{
                    __html: form.markup,
                  }}
                />
                {/* #dspForm('contact-us','?submitted=true')# */}
              </div>
            </div>
          </section>

          {/* <!-- Sidebar--> */}
          <aside className="col-lg-4 pt-4 pt-lg-0">
            <div className="cz-sidebar-static rounded-lg box-shadow-lg p-4 mb-5">
              <div
                dangerouslySetInnerHTML={{
                  __html: customBody,
                }}
              />

              {/* <!--- google maps embed code ---> */}
              <iframe title="location Map" src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2953.180159000361!2d-71.84762278454714!3d42.25332507919407!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89e4041d31deb0af%3A0xeb395499aba6c944!2sStone%20%26%20Berg%20Wholesale!5e0!3m2!1sen!2sus!4v1602162888268!5m2!1sen!2sus" width="400" height="250" frameBorder="0" style={{ border: 0 }} aria-hidden="false" tabIndex="0" />
            </div>
          </aside>
        </div>
      </div>

      <ActionBanner {...actionBanner} />
    </Layout>
  )
}

function mapStateToProps(state) {
  const { preload } = state
  return preload.contact
}

Contact.propTypes = {}
export default connect(mapStateToProps)(Contact)
