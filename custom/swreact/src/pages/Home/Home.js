import React, { useEffect } from 'react'
import { HomeBanner, HomeBrand, HomeDetails, Layout } from '../../components'
import PropTypes from 'prop-types'
import { connect, useDispatch } from 'react-redux'
import { getHomePageContent } from '../../actions/contentActions'

const Home = ({ featuredSlider, homeMainBanner, homeBrand, homeContent, 'home/shop-by': shopBy }) => {
  const dispatch = useDispatch()
  useEffect(() => {
    dispatch(getHomePageContent())
  }, [dispatch])
  return (
    <Layout>
      <HomeBanner homeMainBanner={homeMainBanner} featuredSlider={featuredSlider} />
      <HomeDetails homeContent={homeContent} />
      <HomeBrand homeBrand={homeBrand} shopBy={shopBy} />
    </Layout>
  )
}
Home.propTypes = {
  homeMainBanner: PropTypes.array,
  featuredSlider: PropTypes.array,
  homeContent: PropTypes.array,
  homeBrand: PropTypes.array,
  shopBy: PropTypes.string,
}

function mapStateToProps(state) {
  return state.content
}

export default connect(mapStateToProps)(Home)
