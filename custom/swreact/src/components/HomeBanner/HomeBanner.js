import React, { useEffect } from 'react'
import PropTypes from 'prop-types'
import Background from '../../assets/images/main-bg-img.jpg'
import Slider from 'react-slick'
import { FeaturedProductCard } from '..'
import { getUser } from '../../actions/userActions'
import { getFeaturedItems } from '../../actions/productSearchActions'
import { connect } from 'react-redux'
import { useHistory } from 'react-router-dom'

const FeaturedProducts = ({ sliderData }) => {
  const settings = {
    dots: false,
    infinite: true,
    slidesToShow: 4,
    slidesToScroll: 1,
    responsive: [
      {
        breakpoint: 1200,
        settings: {
          slidesToShow: 3,
        },
      },
      {
        breakpoint: 800,
        settings: {
          slidesToShow: 2,
        },
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 1,
        },
      },
    ],
  }
  return (
    <div className="container">
      <div className="featured-products bg-white text-center pb-5 pt-5">
        <h3 className="h3 mb-0">Featured Products</h3>
        <a href="/All" className="text-link">
          Shop All Specials
        </a>
        <Slider style={{ margin: '0 4rem', height: 'fit-content' }} className="row mt-4" {...settings}>
          {sliderData.map((slide, index) => {
            return <FeaturedProductCard {...slide} key={index} imgKey={index} />
          })}
        </Slider>
      </div>
    </div>
  )
}

const BannerSlide = ({ customBody, title, linkUrl, linkLabel, slideKey }) => {
  let history = useHistory()

  return (
    <div index={slideKey} className="repeater">
      <h2 className="h2">{title}</h2>
      <p
        onClick={event => {
          event.preventDefault()
          history.push(event.target.getAttribute('href'))
        }}
        dangerouslySetInnerHTML={{ __html: customBody }}
      />
      <a href={linkUrl} className="btn btn-light btn-long">
        {linkLabel}
      </a>
    </div>
  )
}

const MainBanner = props => {
  const settings = {
    dots: true,
    infinite: false,
    slidesToShow: 1,
    slidesToScroll: 1,
  }
  return (
    <div className="container">
      <div style={{ height: 'fit-content' }} className="main-banner text-white text-center mr-5 ml-5">
        <Slider className="slider-dark" {...settings}>
          {props.sliderData.map((slideData, index) => {
            return <BannerSlide {...slideData} key={index} slideKey={index} />
          })}
        </Slider>
      </div>
    </div>
  )
}

function HomeBanner({ getFeaturedItemsAction, featuredSlider, homeMainBanner }) {
  useEffect(() => {
    getFeaturedItemsAction()
  }, [])

  return (
    <div className="hero mt-2" style={{ backgroundImage: `url(${Background})` }}>
      <FeaturedProducts sliderData={featuredSlider} />
      <MainBanner sliderData={homeMainBanner} />
    </div>
  )
}

HomeBanner.propTypes = {
  homeMainBanner: PropTypes.array,
  featuredSlider: PropTypes.array,
}

function mapStateToProps(state) {
  const { productSearchReducer } = state
  return { ...productSearchReducer }
}

const mapDispatchToProps = dispatch => {
  return {
    getUser: async () => dispatch(getUser()),
    getFeaturedItemsAction: async () => dispatch(getFeaturedItems()),
  }
}
export default connect(mapStateToProps, mapDispatchToProps)(HomeBanner)
