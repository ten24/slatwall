import React from 'react'
// import PropTypes from 'prop-types'
import { Layout, BreadCrumb } from '../../components'
import { connect } from 'react-redux'

const CategoryList = ({ categories }) => {
  return (
    <div className="container pb-4 pb-sm-5">
      {/* <!--- Categories grid ---> */}
      <div className="row pt-5">
        {/* <!--- Catogory ---> */}
        {categories.map(({ heading, items }, index) => {
          return (
            <div className="col-md-4 col-sm-6 mb-3">
              <div className="card border-0">
                <a
                  className="d-block overflow-hidden rounded-lg"
                  href="shop-grid-ls.html"
                >
                  <img
                    className="d-block w-100"
                    src="#$.getThemePath()#/custom/client/assets/images/category-img-1.png"
                    alt=""
                  />
                </a>
                <div className="card-body">
                  <h2 className="h5">{heading}</h2>
                  <ul className="list-unstyled font-size-sm mb-0">
                    {items.map(({ title, link }, index) => {
                      return (
                        <li className="d-flex align-items-center justify-content-between">
                          <a className="nav-link-style" href={link}>
                            <i className="far fa-chevron-circle-right pr-2"></i>
                            {title}
                          </a>
                        </li>
                      )
                    })}
                  </ul>
                </div>
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}

const CategoryListing = ({ crumbs, title, categories }) => {
  return (
    <Layout>
      <div className="bg-secondary py-4">
        <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
          <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
            <BreadCrumb crumbs={crumbs} />
          </div>
          <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
            <h1 className="h3 mb-0">{title}</h1>
          </div>
        </div>
      </div>

      <CategoryList categories={categories} />
    </Layout>
  )
}

function mapStateToProps(state) {
  const { preload } = state
  return preload.categoryListing
}

CategoryListing.propTypes = {}
export default connect(mapStateToProps)(CategoryListing)
