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
  return (
    <div className="home-brand container-slider container py-lg-4 mb-4 mt-4 text-center">
      <h3 className="h3">Shop by Manufacturer</h3>
      <Slider {...settings}>
        <div index={1} className="repeater">
          <div className="brand-box bg-white box-shadow-sm rounded-lg m-3">
            <a className="d-block p-4" href="/shop/kidde">
              <img
                className="d-block mx-auto"
                src="/custom/assets/files/associatedimage/kidde1.png"
                alt="Kidde Logo"
              />
            </a>
          </div>
        </div>
        <div index={2} className="repeater">
          <div className="brand-box bg-white box-shadow-sm rounded-lg m-3">
            <a className="d-block p-4" href="/shop/lenox">
              <img
                className="d-block mx-auto"
                src="/custom/assets/files/associatedimage/lenox1.png"
                alt="Lenox Logo"
              />
            </a>
          </div>
        </div>
        <div index={3} className="repeater">
          <div className="brand-box bg-white box-shadow-sm rounded-lg m-3">
            <a className="d-block p-4" href="/shop/gms">
              <img
                className="d-block mx-auto"
                src="/custom/assets/files/associatedimage/gms1.png"
                alt="GMS Logo"
              />
            </a>
          </div>
        </div>
        <div index={4} className="repeater">
          <div className="brand-box bg-white box-shadow-sm rounded-lg m-3">
            <a className="d-block p-4" href="/shop/master-lock">
              <img
                className="d-block mx-auto"
                src="/custom/assets/files/associatedimage/master-lock1.png"
                alt="Master Lock Logo"
              />
            </a>
          </div>
        </div>
        <div index={5} className="repeater">
          <div className="brand-box bg-white box-shadow-sm rounded-lg m-3">
            <a className="d-block p-4" href="/shop/american">
              <img
                className="d-block mx-auto"
                src="/custom/assets/files/associatedimage/american-lock1.png"
                alt="American Lock Logo"
              />
            </a>
          </div>
        </div>
      </Slider>
      <a
        className="btn btn-primary mt-3 btn-long"
        href="
          /shop/"
      >
        More Brands
      </a>
    </div>
  )
}

HomeBrand.propTypes = {}

export default HomeBrand
