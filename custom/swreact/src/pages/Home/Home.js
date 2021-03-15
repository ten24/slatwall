import React from 'react'
import { HomeBanner, HomeBrand, HomeDetails, Layout } from '../../components'
const Home = () => {
  return (
    <Layout>
      <HomeBanner />
      <HomeDetails />
      <HomeBrand />
    </Layout>
  )
}

export default Home
