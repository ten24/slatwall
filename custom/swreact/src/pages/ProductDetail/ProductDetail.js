import React from 'react'
// import PropTypes from 'prop-types'
import { Layout } from '../../components'
import { connect } from 'react-redux'

const ProductPageHeader = () => {
  return (
    <div className="page-title-overlap bg-lightgray pt-4">
      <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <nav aria-label="breadcrumb">
            <ol className="breadcrumb text-small bg-lightgray flex-lg-nowrap justify-content-center justify-content-lg-start">
              <li className="breadcrumb-item">
                <a className="text-nowrap" href="index.html">
                  <i className="fa fa-home"></i>Home
                </a>
              </li>
              <li className="breadcrumb-item text-nowrap">
                <a href="##">Shop</a>
              </li>
              <li
                className="breadcrumb-item text-nowrap active"
                aria-current="page"
              >
                Product Page v.1
              </li>
            </ol>
          </nav>
        </div>
        <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 className="h3 text-dark mb-0 font-accent">Gardell 1812 Series</h1>
        </div>
      </div>
    </div>
  )
}

const ProductDetailGallery = () => {
  return (
    <div className="col-lg-6 pr-lg-5 pt-0">
      <div className="cz-product-gallery">
        <div className="cz-preview order-sm-2">
          <div className="cz-preview-item active" id="first">
            <img
              className="cz-image-zoom w-100 mx-auto"
              src="#$.getThemePath()#/custom/client/assets/images/product-img-1.png"
              data-zoom="#$.getThemePath()#/custom/client/assets/images/product-img-1.png"
              alt="Product image"
              style={{ maxWidth: '500px' }}
            />
            <div className="cz-image-zoom-pane"></div>
          </div>
        </div>
      </div>
    </div>
  )
}
const ProductPagePanels = () => {
  return (
    <div className="accordion mb-4" id="productPanels">
      <div className="card">
        <div className="card-header">
          <h3 className="accordion-heading">
            <a
              href="##productInfo"
              role="button"
              data-toggle="collapse"
              aria-expanded="true"
              aria-controls="productInfo"
            >
              <i className="far fa-key font-size-lg align-middle mt-n1 mr-2"></i>
              Product info<span className="accordion-indicator"></span>
            </a>
          </h3>
        </div>
        <div
          className="collapse show"
          id="productInfo"
          data-parent="##productPanels"
        >
          <div className="card-body">
            <div className="font-size-sm row">
              <div className="col-6">
                <ul>
                  <li>Manufacturer:</li>
                  <li>Style:</li>
                  <li>Fire Rated:</li>
                  <li>Safety Rating:</li>
                </ul>
              </div>
              <div className="col-6 text-muted">
                <ul>
                  <li>Gardall</li>
                  <li>Burgalry/Fire</li>
                  <li>2 hour</li>
                  <li>Residential Security Container (RSC)</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="card">
        <div className="card-header">
          <h3 className="accordion-heading">
            <a
              className="collapsed"
              href="##technicalinfo"
              role="button"
              data-toggle="collapse"
              aria-expanded="true"
              aria-controls="technicalinfo"
            >
              <i className="far fa-drafting-compass align-middle mt-n1 mr-2"></i>
              Technical Info<span className="accordion-indicator"></span>
            </a>
          </h3>
        </div>
        <div
          className="collapse"
          id="technicalinfo"
          data-parent="##productPanels"
        >
          <div className="card-body font-size-sm">
            <div className="d-flex justify-content-between border-bottom py-2">
              <div className="font-weight-semibold text-dark">
                Document Title
              </div>
              <a href="##">Download</a>
            </div>
            <div className="d-flex justify-content-between border-bottom py-2">
              <div className="font-weight-semibold text-dark">
                Document Title
              </div>
              <a href="##">Download</a>
            </div>
          </div>
        </div>
      </div>
      <div className="card">
        <div className="card-header">
          <h3 className="accordion-heading">
            <a
              className="collapsed"
              href="##questions"
              role="button"
              data-toggle="collapse"
              aria-expanded="true"
              aria-controls="questions"
            >
              <i className="far fa-question-circle font-size-lg align-middle mt-n1 mr-2"></i>
              Questions?<span className="accordion-indicator"></span>
            </a>
          </h3>
        </div>
        <div className="collapse" id="questions" data-parent="##productPanels">
          <div className="card-body">
            <p>Have questions about this product?</p>
            <a href="/contact">Contact Us</a>
          </div>
        </div>
      </div>
    </div>
  )
}

const ProductPageContent = () => {
  return (
    <div className="container bg-light box-shadow-lg rounded-lg px-4 py-3 mb-5">
      <div className="px-lg-3">
        <div className="row">
          <ProductDetailGallery />
          {/* <!-- Product details--> */}
          <div className="col-lg-6 pt-0">
            <div className="product-details pb-3">
              <div className="d-flex justify-content-between align-items-center mb-2">
                <span className="d-inline-block font-size-sm align-middle px-2 bg-primary text-light">
                  On Special
                </span>
                <button
                  className="btn-wishlist mr-0 mr-lg-n3"
                  type="button"
                  data-toggle="tooltip"
                  title="Add to wishlist"
                >
                  <i className="far fa-heart fa-circle"></i>
                </button>
              </div>
              <div className="mb-2">
                <span className="text-small text-muted">product: </span>
                <span className="h4 font-weight-normal text-large text-accent mr-1">
                  1812
                </span>
              </div>
              <h2 className="h4 mb-2">Product Title Here</h2>
              <div className="mb-3 font-weight-light font-size-small text-muted">
                After finding the item they want and clicking the box to go to
                the product detail page, that page should be configured to the
                item that was clicked back on the product listing page. AKA,
                Click on Gardall 1812-G-E, should be brought to the 1812 series
                page with a grey safe w/ electronic lock already configured.
              </div>
              <form className="mb-grid-gutter" method="post">
                <div className="form-group">
                  <div className="d-flex justify-content-between align-items-center pb-1">
                    <label
                      className="font-weight-medium"
                      htmlFor="product-size"
                    >
                      Finish & Lock Type
                    </label>
                  </div>
                  <select className="custom-select" required id="product-size">
                    <option value="">Select size</option>
                    <option value="xs">XS</option>
                    <option value="s">S</option>
                    <option value="m">M</option>
                    <option value="l">L</option>
                    <option value="xl">XL</option>
                  </select>
                </div>
                <div className="mb-3">
                  <span className="h4 text-accent font-weight-light">
                    $48.00
                  </span>{' '}
                  <span className="font-size-sm ml-1">$59.95 list</span>
                </div>
                <div className="form-group d-flex align-items-center">
                  <select
                    className="custom-select mr-3"
                    style={{ width: '5rem' }}
                  >
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                  </select>
                  <button className="btn btn-primary btn-block" type="submit">
                    <i className="far fa-shopping-cart font-size-lg mr-2"></i>
                    Add to Cart
                  </button>
                </div>
                <div className="alert alert-danger" role="alert">
                  <i className="far fa-exclamation-circle"></i> This item is not
                  eligable for free freight
                </div>
              </form>
              {/* <!-- Product panels--> */}
              <ProductPagePanels />
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

const ProductDetailSlider = () => {
  return (
    <div className="container px-5">
      <div className="px-4 py-3 mb-5">
        <div className="px-lg-3">
          <h3 className="h3 text-center">Related Products</h3>
          <div className="product-slider row mt-4">
            {/* <!--- start of product tile ---> */}
            <div className="col-md-4 col-sm-6 px-2">
              <div className="card product-card">
                {/* <!--- only display heart when user is logged in ---> */}
                <button
                  className="btn-wishlist btn-sm"
                  type="button"
                  data-toggle="tooltip"
                  data-placement="left"
                  title=""
                  data-original-title="Add to wishlist"
                >
                  <i className="far fa-heart"></i>
                  {/* <!--- For solid heart (when product has been added to wishlist)
                <i className="far fa-heart"></i> ---> */}
                </button>
                <a
                  className="card-img-top d-block overflow-hidden"
                  href="shop-single-v1.html"
                >
                  <img
                    src="#$.getThemePath()#/custom/client/assets/images/product-img-1.png"
                    alt="Product"
                  />
                </a>
                <div className="card-body py-2 text-left">
                  <a
                    className="product-meta d-block font-size-xs pb-1"
                    href="##"
                  >
                    Brand Here
                  </a>
                  <h3 className="product-title font-size-sm">
                    <a href="shop-single-v1.html">Product Title Here</a>
                  </h3>
                  <div className="product-price">
                    <span className="text-accent">$156.99</span>
                    $209.24 {/*  <!--- list price here ---> */}
                  </div>
                </div>
              </div>
            </div>
            {/* <!--- end of product tile ---> */}

            {/* <!--- start of product tile ---> */}
            <div className="col-md-4 col-sm-6 px-2">
              <div className="card product-card">
                <span className="badge badge-primary">On Special</span>
                {/* <!--- only display heart when user is logged in ---> */}
                <button
                  className="btn-wishlist btn-sm"
                  type="button"
                  data-toggle="tooltip"
                  data-placement="left"
                  title=""
                  data-original-title="Add to wishlist"
                >
                  <i className="far fa-heart"></i>
                  {/* <!--- For solid heart (when product has been added to wishlist)
                <i className="far fa-heart"></i> ---> */}
                </button>
                <a
                  className="card-img-top d-block overflow-hidden"
                  href="shop-single-v1.html"
                >
                  <img
                    src="#$.getThemePath()#/custom/client/assets/images/product-img-2.png"
                    alt="Product"
                  />
                </a>
                <div className="card-body py-2 text-left">
                  <a
                    className="product-meta d-block font-size-xs pb-1"
                    href="##"
                  >
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

            <div className="col-md-4 col-sm-6 px-2">
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
                  <img
                    src="#$.getThemePath()#/custom/client/assets/images/product-img-3.png"
                    alt="Product"
                  />
                </a>
                <div className="card-body py-2 text-left">
                  <a
                    className="product-meta d-block font-size-xs pb-1"
                    href="##"
                  >
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

            <div className="col-md-4 col-sm-6 px-2">
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
                  <img
                    src="#$.getThemePath()#/custom/client/assets/images/product-img-4.png"
                    alt="Product"
                  />
                </a>
                <div className="card-body py-2 text-left">
                  <a
                    className="product-meta d-block font-size-xs pb-1"
                    href="##"
                  >
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

            <div className="col-md-4 col-sm-6 px-2">
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
                  <img
                    src="#$.getThemePath()#/custom/client/assets/images/product-img-3.png"
                    alt="Product"
                  />
                </a>
                <div className="card-body py-2 text-left">
                  <a
                    className="product-meta d-block font-size-xs pb-1"
                    href="##"
                  >
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
          </div>
        </div>
      </div>
    </div>
  )
}

const ProductDetail = () => {
  return (
    <Layout>
      <div className="bg-light p-0">
        <ProductPageHeader />
        <ProductPageContent />
        <ProductDetailSlider />
      </div>
    </Layout>
  )
}

function mapStateToProps(state) {
  const { preload } = state
  return preload
}

ProductDetail.propTypes = {}
export default connect(mapStateToProps)(ProductDetail)
