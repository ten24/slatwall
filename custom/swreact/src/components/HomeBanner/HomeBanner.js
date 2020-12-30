import React from 'react'
import PropTypes from 'prop-types'
import pi1 from '../../assets/images/product-img-1.png'
import pi2 from '../../assets/images/product-img-2.png'
import pi3 from '../../assets/images/product-img-3.png'
import pi4 from '../../assets/images/product-img-4.png'
import Background from '../../assets/images/main-bg-img.jpg'
import Slider from 'react-slick'

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
  const imgStack = [pi1, pi2, pi3, pi4, pi2, pi1, pi4]
  const styler = { width: '100%', display: 'inline-block' }
  return (
    <div className="container">
      <div className="featured-products bg-white text-center pb-5 pt-5">
        <h3 className="h3 mb-0">Featured Products</h3>
        <a href="/All" className="text-link">
          Shop All Specials
        </a>
        <Slider style={{ margin: '0 4rem' }} className="row mt-4" {...settings}>
          {sliderData.map(
            ({ brand, productTile, price, displayPrice, linkUrl }, index) => {
              return (
                <div key={index} style={styler}>
                  <div className="card product-card">
                    <span className="badge badge-primary">On Special</span>
                    <button
                      className="btn-wishlist btn-sm"
                      type="button"
                      data-toggle="tooltip"
                      data-placement="left"
                      title=""
                      data-original-title="Add to wishlist"
                    >
                      <i className="far fa-heart"></i>
                    </button>
                    <a
                      className="card-img-top d-block overflow-hidden"
                      href="shop-single-v1.html"
                    >
                      <img src={imgStack[index]} alt="Product" />
                    </a>
                    <div className="card-body py-2 text-left">
                      <a
                        className="product-meta d-block font-size-xs pb-1"
                        href="#"
                      >
                        {brand}
                      </a>
                      <h3 className="product-title font-size-sm">
                        <a href={linkUrl}>{productTile}</a>
                      </h3>
                      <div className="d-flex justify-content-between">
                        <div className="product-price">
                          <span className="text-accent">{displayPrice}</span>
                          {price}
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              )
            }
          )}
        </Slider>
      </div>
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
      <div className="main-banner text-white text-center mr-5 ml-5">
        {props.sliderData.map(
          ({ customBody, title, linkUrl, linkLabel }, index) => {
            return (
              <Slider key={index} className="slider-dark" {...settings}>
                <div index={1} className="repeater">
                  <h2 className="h2">{title}</h2>
                  <p dangerouslySetInnerHTML={{ __html: customBody }} />
                  <a href={linkUrl} className="btn btn-light btn-long">
                    {linkLabel}
                  </a>
                </div>
              </Slider>
            )
          }
        )}
      </div>
    </div>
  )
}

function HomeBanner(props) {
  const homeMainBanner = JSON.parse(props.homeMainBanner)
  const featuredSlider = JSON.parse(props.featuredSlider)

  return (
    <div
      className="hero mt-2"
      style={{ backgroundImage: `url(${Background})` }}
    >
      <FeaturedProducts sliderData={featuredSlider} />
      <MainBanner sliderData={homeMainBanner} />
    </div>
  )
}

HomeBanner.propTypes = {
  homeMainBanner: PropTypes.string,
  featuredSlider: PropTypes.string,
}

export default HomeBanner
