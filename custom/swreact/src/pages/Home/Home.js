import React, { useEffect } from 'react'
import { HomeBanner, HomeBrand, HomeDetails, Layout } from '../../components'
import { useDispatch } from 'react-redux'
import { getHomePageContent } from '../../actions/contentActions'
const Home = () => {
  const dispatch = useDispatch()
  useEffect(() => {
    dispatch(getHomePageContent())
  }, [dispatch])
  return (
    <Layout>
      <HomeBanner />
      <HomeDetails />
      <HomeBrand />
    </Layout>
  )
}

export default Home
