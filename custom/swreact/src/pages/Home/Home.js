import React from 'react'
import { useSelector } from 'react-redux'
import { ContentSlider, ProductSlider, HomeBrand, HomeDetails, Layout } from '../../components'
const Home = () => {
  const home = useSelector(state => state.content['home'])

  return (
    <Layout>
      <ContentSlider />
      <ProductSlider
        params={{
          'f:publishedFlag': 1,
          'f:productFeaturedFlag': 1,
        }}
      >
        {home && <div dangerouslySetInnerHTML={{ __html: home.customBody }} />}
      </ProductSlider>

      <HomeDetails />
      <HomeBrand />
    </Layout>
  )
}

export default Home
