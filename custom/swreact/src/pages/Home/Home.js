import React, { useEffect } from 'react'
import { HomeBanner, HomeBrand, HomeDetails, Layout } from '../../components'
import { useDispatch } from 'react-redux'
import { getHomePageContent, getPageContent } from '../../actions/contentActions'
const Home = () => {
  const dispatch = useDispatch()
  useEffect(() => {
    dispatch(getHomePageContent())
    dispatch(
      getPageContent(
        {
          content: {
            home: ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage'],
          },
        },
        'home'
      )
    )
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
