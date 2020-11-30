import React from 'react'
import { HomeBanner, HomeBrand, HomeDetails } from '../../components'
import PropTypes from 'prop-types'

const Home = props => {
  console.log(props)
  return (
    <>
      <HomeBanner
        homeMainBanner={props.homeMainBanner}
        featuredSlider={props.featuredSlider}
      />
      <HomeDetails homeContent={props.homeContent} />
      <HomeBrand homeBrand={props.homeBrand} shopBy={props.shopBy} />
    </>
  )
}
Home.propTypes = {
  homeMainBanner: PropTypes.string,
  featuredSlider: PropTypes.string,
  homeContent: PropTypes.string,
  homeBrand: PropTypes.string,
  shopBy: PropTypes.string,
}
export default Home
