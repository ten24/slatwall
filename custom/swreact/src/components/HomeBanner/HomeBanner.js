import React from 'react'
import PropTypes from 'prop-types'
import pi1 from '../../assets/images/product-img-1.png'
import pi2 from '../../assets/images/product-img-2.png'
import pi3 from '../../assets/images/product-img-3.png'
import pi4 from '../../assets/images/product-img-4.png'
import Background from '../../assets/images/main-bg-img.jpg'
import Slider from 'react-slick'
const FeaturedProducts = () => {
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
  const styler = { width: '100%', display: 'inline-block' }
  return (
    <div className="container">
      <div className="featured-products bg-white text-center pb-5 pt-5">
        <h3 className="h3 mb-0">Featured Products</h3>
        <a href="#" className="text-link">
          Shop All Specials
        </a>
        <Slider style={{ margin: '0 4rem' }} className="row mt-4" {...settings}>
          <div index={1} style={styler}>
            <div className="card product-card">
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
                <img src={pi1} alt="Product" />
              </a>
              <div className="card-body py-2 text-left">
                <a className="product-meta d-block font-size-xs pb-1" href="#">
                  Brand Here
                </a>
                <h3 className="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div className="product-price">
                  <span className="text-accent">$156.99</span>
                  $209.24
                </div>
              </div>
            </div>
          </div>
          <div index={2} style={styler}>
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
                <img src={pi2} alt="Product" />
              </a>
              <div className="card-body py-2 text-left">
                <a className="product-meta d-block font-size-xs pb-1" href="#">
                  Brand Here
                </a>
                <h3 className="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div className="d-flex justify-content-between">
                  <div className="product-price">
                    <span className="text-accent">$156.99</span>
                    $209.24
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div index={3} style={styler}>
            <div className="card product-card">
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
                <img src={pi3} alt="Product" />
              </a>
              <div className="card-body py-2 text-left">
                <a className="product-meta d-block font-size-xs pb-1" href="#">
                  Brand Here
                </a>
                <h3 className="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div className="d-flex justify-content-between">
                  <div className="product-price">
                    <span className="text-accent">$156.99</span>
                    $209.24
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div index={4} style={styler}>
            <div className="card product-card">
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
                <img src={pi4} alt="Product" />
              </a>
              <div className="card-body py-2 text-left">
                <a className="product-meta d-block font-size-xs pb-1" href="#">
                  Brand Here
                </a>
                <h3 className="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div className="d-flex justify-content-between">
                  <div className="product-price">
                    <span className="text-accent">$156.99</span>
                    $209.24
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div index={5} style={styler}>
            <div className="card product-card">
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
                <img src={pi3} alt="Product" />
              </a>
              <div className="card-body py-2 text-left">
                <a className="product-meta d-block font-size-xs pb-1" href="#">
                  Brand Here
                </a>
                <h3 className="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div className="d-flex justify-content-between">
                  <div className="product-price">
                    <span className="text-accent">$156.99</span>
                    $209.24
                  </div>
                </div>
              </div>
            </div>
          </div>
        </Slider>
      </div>
    </div>
  )
}
const MainBanner = () => {
  const settings = {
    dots: true,
    infinite: false,
    slidesToShow: 1,
    slidesToScroll: 1,
  }
  return (
    <div className="container">
      <div className="main-banner text-white text-center mr-5 ml-5">
        <Slider className="slider-dark" {...settings}>
          <div index={1} className="repeater">
            <h2 className="h2">Stone & Berg’s Commitment to You</h2>
            <p>
              We are a Security Hardware Wholesale Company based out of
              Worcester, MA, dedicated to helping you and your company do
              business on a day-to-day basis. We offer a wide range of
              high-quality products and services at competitive prices. There is
              no minimum order requirement, and we ship to most locations in New
              England next-day delivery.
            </p>
            <a href="/shop" className="btn btn-light btn-long">
              Shop
            </a>
          </div>
        </Slider>
      </div>
    </div>
  )
}

function HomeBanner(props) {
  return (
    <div
      className="hero mt-2"
      style={{ backgroundImage: `url(${Background})` }}
    >
      <FeaturedProducts />
      <MainBanner />
    </div>
  )
}

HomeBanner.propTypes = {}

export default HomeBanner
