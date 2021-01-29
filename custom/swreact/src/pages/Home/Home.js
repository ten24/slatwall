import React, { useEffect } from 'react'
import { HomeBanner, HomeBrand, HomeDetails, Layout } from '../../components'
import { useDispatch } from 'react-redux'
import { getHomePageContent, getContent } from '../../actions/contentActions'
const Home = () => {
  const dispatch = useDispatch()
  useEffect(() => {
    dispatch(getHomePageContent())
    dispatch(
      getContent({
        content: {
          home: ['title', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage'],
        },
      })
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
