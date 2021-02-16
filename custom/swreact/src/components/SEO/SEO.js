import React from 'react'
import { Helmet } from 'react-helmet'
import { useSelector } from 'react-redux'

const SEO = () => {
  const configuration = useSelector(state => state.configuration)
  const { site = {}, seo = {} } = configuration
  return (
    <Helmet title={seo.title || site.siteName}>
      {seo.description && <meta name="description" content={seo.description} />}
      {/* {seo.image && <meta name="image" content={seo.image} />}
      {seo.url && <meta property="og:url" content={seo.url} />} */}

      {/* {(article ? true : null) && <meta property="og:type" content="article" />} */}

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

export default SEO
