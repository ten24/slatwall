import React from 'react'
import PropTypes from 'prop-types'
import { Helmet } from 'react-helmet'
// import { useLocation } from '@reach/router'
import { connect } from 'react-redux'

const SEO = ({ title, description, article }) => {
  //  const { pathname } = useLocation()

  return (
    <Helmet title={title}>
      {description && <meta name="description" content={description} />}
      {/* {seo.image && <meta name="image" content={seo.image} />}
      {seo.url && <meta property="og:url" content={seo.url} />} */}

      {(article ? true : null) && <meta property="og:type" content="article" />}

      {/* {title && <meta property="og:title" content={title} />} */}

      {/* {seo.description && <meta property="og:description" content={seo.description} />} */}

      {/* {seo.image && <meta property="og:image" content={seo.image} />} */}

      {/* <meta name="twitter:card" content="summary_large_image" /> */}

      {/* {twitterUsername && <meta name="twitter:creator" content={twitterUsername} />} */}

      {/* {seo.title && <meta name="twitter:title" content={seo.title} />} */}

      {/* {seo.description && <meta name="twitter:description" content={seo.description} />} */}

      {/* {seo.image && <meta name="twitter:image" content={seo.image} />} */}
    </Helmet>
  )
}
function mapStateToProps(state) {
  const { site } = state.preload
  const { seo } = state.configuration
  return {
    title: seo.title || site.siteName,
    description: null,
    // description: '',
    // image: '',
    article: false,
    // site: {
    //   siteMetadata: {
    //     defaultTitle: seo.title || site.siteName,
    //     // titleTemplate: '',
    //     // defaultDescription: '',
    //     // siteUrl: '',
    //     // defaultImage: '',
    //     // twitterUsername: '',
    //   },
    // },
    // pathname: '',
  }
}

export default connect(mapStateToProps)(SEO)
