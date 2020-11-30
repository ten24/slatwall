import React from 'react'
import PropTypes from 'prop-types'
import Slider from 'react-slick'

function HomeBrand(props) {
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
  const homeBrand = JSON.parse(props.homeBrand)

  return (
    <div className="home-brand container-slider container py-lg-4 mb-4 mt-4 text-center">
      <h3 className="h3">Shop by Manufacturer</h3>
      <Slider {...settings}>
        {homeBrand.map(({ associatedImage, linkUrl, title }, index) => {
          return (
            <div key={index} className="repeater">
              <div className="brand-box bg-white box-shadow-sm rounded-lg m-3">
                <a className="d-block p-4" href={linkUrl}>
                  <img
                    className="d-block mx-auto"
                    src={`/custom/assets/files/associatedimage/${associatedImage}`}
                    alt={title}
                  />
                </a>
              </div>
            </div>
          )
        })}
      </Slider>
      <a className="btn btn-primary mt-3 btn-long" href={props.shopBy}>
        More Brands
      </a>
    </div>
  )
}

HomeBrand.propTypes = {
  homeBrand: PropTypes.string,
  shopBy: PropTypes.string,
}

export default HomeBrand
