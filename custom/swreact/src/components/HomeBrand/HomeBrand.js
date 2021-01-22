import React from 'react'
import PropTypes from 'prop-types'
import Slider from 'react-slick'
import { SWImage } from '..'
import { connect } from 'react-redux'

const BandSlide = ({ associatedImage, linkUrl, title, slideKey }) => {
  return (
    <div index={slideKey} className="repeater">
      <div className="brand-box bg-white box-shadow-sm rounded-lg m-3">
        <a className="d-block p-4" href={linkUrl}>
          <SWImage className="d-block mx-auto" customPath="/custom/assets/files/associatedimage/" src={associatedImage} alt={title} />
        </a>
      </div>
    </div>
  )
}

function HomeBrand({ homeBrand, 'home/shop-by': shopBy }) {
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
  return (
    <div style={{ height: 'fit-content' }} className="home-brand container-slider container py-lg-4 mb-4 mt-4 text-center">
      <h3 className="h3">{shopBy.title}</h3>
      <Slider {...settings}>
        {homeBrand &&
          homeBrand.map((slide, index) => {
            return <BandSlide {...slide} key={index} slideKey={index} />
          })}
      </Slider>
      <a className="btn btn-primary mt-3 btn-long" href={shopBy.linkUrl}>
        More Brands
      </a>
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
