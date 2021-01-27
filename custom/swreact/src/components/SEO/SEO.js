import React from 'react'
import PropTypes from 'prop-types'
import { Helmet } from 'react-helmet'
// import { useLocation } from '@reach/router'
import { connect } from 'react-redux'

const SEO = ({ title, description, image, article, site, pathname }) => {
  //  const { pathname } = useLocation()
  const {
    defaultTitle,
    titleTemplate,
    defaultDescription,
    siteUrl,
    defaultImage,
    twitterUsername,
  } = site.siteMetadata

  const seo = {
    title: title || defaultTitle,
    description: description || defaultDescription,
    image: `${siteUrl}${image || defaultImage}`,
    url: `${siteUrl}${pathname}`,
  }

  return (
    <Helmet title={seo.title} titleTemplate={titleTemplate}>
      <meta name="description" content={seo.description} />
      <meta name="image" content={seo.image} />

      {seo.url && <meta property="og:url" content={seo.url} />}

      {(article ? true : null) && <meta property="og:type" content="article" />}

      {seo.title && <meta property="og:title" content={seo.title} />}

      {seo.description && (
        <meta property="og:description" content={seo.description} />
      )}

      {seo.image && <meta property="og:image" content={seo.image} />}

      <meta name="twitter:card" content="summary_large_image" />

      {twitterUsername && (
        <meta name="twitter:creator" content={twitterUsername} />
      )}

      {seo.title && <meta name="twitter:title" content={seo.title} />}

      {seo.description && (
        <meta name="twitter:description" content={seo.description} />
      )}

      {seo.image && <meta name="twitter:image" content={seo.image} />}
    </Helmet>
  )
}
function mapStateToProps(state) {
  const dummy = {
    title: '',
    description: '',
    image: '',
    article: false,
    site: {
      siteMetadata: {
        defaultTitle: '',
        titleTemplate: '',
        defaultDescription: '',
        siteUrl: '',
        defaultImage: '',
        twitterUsername: '',
      },
    },
    pathname: '',
  }
  return dummy
}

export default connect(mapStateToProps)(SEO)

SEO.propTypes = {
  title: PropTypes.string,
  description: PropTypes.string,
  image: PropTypes.string,
  site: PropTypes.object,
  article: PropTypes.bool,
  pathname: PropTypes.string,
}

SEO.defaultProps = {
  title: null,
  description: null,
  image: null,
  site: null,
  article: false,
  pathname: null,
}
