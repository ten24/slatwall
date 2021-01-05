import React from 'react'
import { HomeBanner, HomeBrand, HomeDetails, Layout } from '../../components'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'

const Home = props => {
  return (
    <Layout>
      <HomeBanner
        homeMainBanner={props.homeMainBanner}
        featuredSlider={props.featuredSlider}
      />
      <HomeDetails homeContent={props.homeContent} />
      <HomeBrand homeBrand={props.homeBrand} shopBy={props.shopBy} />
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
  const { preload } = state
  return preload.home
}

export default connect(mapStateToProps)(Home)
