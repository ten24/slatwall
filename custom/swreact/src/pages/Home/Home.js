import React from 'react'
import { Link } from 'react-router-dom'
import { ContentSlider, ProductSlider, BrandSlider, ContentColumns, Layout } from '../../components'
import { useTranslation } from 'react-i18next'

const Home = () => {
  const { t } = useTranslation()

  return (
    <Layout>
      <ContentSlider />
      <ProductSlider
        title={t('frontend.home.featured.heading')}
        params={{
          'f:publishedFlag': 1,
          'f:productFeaturedFlag': 1,
        }}
      >
        <p>
          <Link to={`/specials`}>{t('frontend.home.featured.cta')}</Link>
        </p>
      </ProductSlider>
      <ContentColumns page={'home'} />
      <BrandSlider />
    </Layout>
  )
}

export default Home
