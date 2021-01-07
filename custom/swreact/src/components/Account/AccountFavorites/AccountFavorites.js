import React from 'react'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import AccountLayout from '../AccountLayout/AccountLayout'

const ProductTile = ({ brand, productTile, price, displayPrice, linkUrl }) => {
  return (
    <div className="col-md-4 col-sm-6 p-2">
      <div className="card product-card">
        <button className="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Remove from favorites">
          <i className="fas fa-heart"></i>
        </button>
        <a className="card-img-top d-block overflow-hidden" href="shop-single-v1.html">
          <img src="#$.getThemePath()#/custom/client/assets/images/product-img-1.png" alt="Product" />
        </a>
        <div className="card-body py-2 text-left">
          <a className="product-meta d-block font-size-xs pb-1" href={linkUrl}>
            {brand}
          </a>
          <h3 className="product-title font-size-sm">
            <a href="shop-single-v1.html">{productTile}</a>
          </h3>
          <div className="product-price">
            <span className="text-accent">{price}</span>
            {` ${displayPrice} list`}
          </div>
        </div>
      </div>
    </div>
  )
}

const AccountFavorites = ({ crumbs, title, items }) => {
  return (
    <AccountLayout crumbs={crumbs} title={title}>
      <div className="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
        <div className="d-flex justify-content-between w-100">&nbsp;</div>
      </div>
      <div className="row mx-n2">
        {items &&
          items.map((item, index) => {
            return <ProductTile {...item} key={index} />
          })}
      </div>

      <hr className="mb-4 mt-4" />

      <nav className="d-flex justify-content-between pt-2" aria-label="Page navigation">
        <ul className="pagination">
          <li className="page-item">
            <a className="page-link" href="##">
              <i className="far fa-chevron-left mr-2"></i> Prev
            </a>
          </li>
        </ul>
        <ul className="pagination">
          <li className="page-item d-sm-none">
            <span className="page-link page-link-static">1 / 5</span>
          </li>
          <li className="page-item active d-none d-sm-block" aria-current="page">
            <span className="page-link">
              1<span className="sr-only">(current)</span>
            </span>
          </li>
          <li className="page-item d-none d-sm-block">
            <a className="page-link" href="##">
              2
            </a>
          </li>
          <li className="page-item d-none d-sm-block">
            <a className="page-link" href="##">
              3
            </a>
          </li>
          <li className="page-item d-none d-sm-block">
            <a className="page-link" href="##">
              4
            </a>
          </li>
          <li className="page-item d-none d-sm-block">
            <a className="page-link" href="##">
              5
            </a>
          </li>
        </ul>
        <ul className="pagination">
          <li className="page-item">
            <a className="page-link" href="##" aria-label="Next">
              Next <i className="far fa-chevron-right ml-2"></i>
            </a>
          </li>
        </ul>
      </nav>
    </AccountLayout>
  )
}

const mapStateToProps = state => {
  return state.preload.accountFavorites
}
AccountFavorites.propTypes = {}
export default connect(mapStateToProps)(AccountFavorites)
