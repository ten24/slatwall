import React from 'react'
import PropTypes from 'prop-types'
import Slider from 'react-slick'
import { SWImage } from '..'
import { connect } from 'react-redux'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'

const BandSlide = ({ associatedImage, linkUrl = '/all', title, slideKey }) => {
  return (
    <div index={slideKey} className="repeater">
      <div className="brand-box bg-white box-shadow-sm rounded-lg m-3">
        <Link className="d-block p-4" to={linkUrl}>
          <SWImage className="d-block mx-auto" customPath="/custom/assets/files/associatedimage/" src={associatedImage} alt={title} />
        </Link>
      </div>
    </div>
  )
}

function HomeBrand(props) {
  const { t, i18n } = useTranslation()

  const settings = {
    dots: false,
    infinite: true,
    slidesToShow: 4,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 3000,
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
  let homeBrand = Object.keys(props)
    .filter(key => {
      return key.includes('shop-by/')
    })
    .map(key => {
      return props[key]
    })
  return (
    <div style={{ height: 'fit-content' }} className="home-brand container-slider container py-lg-4 mb-4 mt-4 text-center">
      <h3 className="h3">{props['home/shop-buy'] && props['home/shop-buy'].title}</h3>
      <Slider {...settings}>
        {homeBrand &&
          homeBrand.map((slide, index) => {
            return <BandSlide {...slide} key={index} slideKey={index} />
          })}
      </Slider>
      <Link className="btn btn-primary mt-3 btn-long" to={props['home/shop-by'].linkUrl || '/'}>
        {t('frontend.home.more_brands')}{' '}
      </Link>
    </div>
  )
}

HomeBrand.propTypes = {
  homeBrand: PropTypes.array,
  shopBy: PropTypes.object,
}

function mapStateToProps(state) {
  return state.content
}
export default connect(mapStateToProps)(HomeBrand)
