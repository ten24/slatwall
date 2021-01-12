import React from 'react'
import { BreadCrumb, FeaturedProductCard, Layout } from '../../components'
import { connect } from 'react-redux'

const ProductListingHeader = ({ title, crumbs }) => {
  return (
    <div className="page-title-overlap bg-lightgray pt-4">
      <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <BreadCrumb crumbs={crumbs} />
        </div>
        <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 className="h3 text-dark mb-0">{title}</h1>
        </div>
      </div>
    </div>
  )
}
const ProductListingToolBar = ({ sortOptions, appliedFilters }) => {
  return (
    <div className="d-flex justify-content-center justify-content-sm-between align-items-center pt-2 pb-4 pb-sm-5">
      <div className="d-flex flex-wrap">
        <div className="form-inline flex-nowrap mr-3 mr-sm-4 pb-sm-3">
          <label className="text-dark opacity-75 text-nowrap mr-2 d-none d-sm-block">Applied Filters:</label>

          {appliedFilters &&
            appliedFilters.map(({ name }, index) => {
              return (
                <span key={index} className="badge badge-light border p-2 mr-2">
                  <a href="">
                    <i className="far fa-times"></i>
                  </a>
                  {name}
                </span>
              )
            })}
        </div>
      </div>
      <div className="d-sm-flex pb-3 align-items-center">
        <label className="text-dark opacity-75 text-nowrap mr-2 mb-0 d-none d-sm-block" htmlFor="sorting">
          Sort by:
        </label>
        {/* <select className="form-control custom-select" id="sorting" value={this.state.value} onChange={this.handleChange}> */}
        <select
          className="form-control custom-select"
          id="sorting"
          onChange={e => {
            console.log('changes Select', e)
          }}
        >
          {sortOptions &&
            sortOptions.map((name, index) => {
              return (
                <option key={index} value={name}>
                  {name}
                </option>
              )
            })}
        </select>
      </div>
    </div>
  )
}
const ProductListingGrid = ({ productResults }) => {
  return (
    <div className="row mx-n2">
      {productResults &&
        productResults.map((product, index) => {
          return (
            <div key={index} className="col-md-4 col-sm-6 px-2 mb-4">
              <FeaturedProductCard {...product} />
            </div>
          )
        })}
    </div>
  )
}
const ProductListingPagination = () => {
  return (
    <nav className="d-flex justify-content-between pt-2" aria-label="Page navigation">
      <ul className="pagination">
        <li className="page-item">
          <a className="page-link" href="#">
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
          <a className="page-link" href="#">
            2
          </a>
        </li>
        <li className="page-item d-none d-sm-block">
          <a className="page-link" href="#">
            3
          </a>
        </li>
        <li className="page-item d-none d-sm-block">
          <a className="page-link" href="#">
            4
          </a>
        </li>
        <li className="page-item d-none d-sm-block">
          <a className="page-link" href="#">
            5
          </a>
        </li>
      </ul>
      <ul className="pagination">
        <li className="page-item">
          <a className="page-link" href="#" aria-label="Next">
            Next <i className="far fa-chevron-right ml-2"></i>
          </a>
        </li>
      </ul>
    </nav>
  )
}
const ProductListingFilter = ({ name, type, options, index }) => {
  return (
    <div className="card border-bottom pt-1 pb-2 my-1">
      <div className="card-header">
        <h3 className="accordion-heading">
          <a className="collapsed" href={`#filer${index}`} role="button" data-toggle="collapse" aria-expanded="false" aria-controls="productType">
            {name}
            <span className="accordion-indicator"></span>
          </a>
        </h3>
      </div>
      <div className="collapse" id={`filer${index}`} data-parent="#shop-categories">
        <div className="card-body">
          <div className="widget widget-links cz-filter">
            <div className="input-group-overlay input-group-sm mb-2">
              <input className="cz-filter-search form-control form-control-sm appended-form-control" type="text" placeholder="Search" />
              <div className="input-group-append-overlay">
                <span className="input-group-text">
                  <i className="far fa-search"></i>
                </span>
              </div>
            </div>
            <ul className="widget-list cz-filter-list pt-1" style={{ height: '12rem' }} data-simplebar data-simplebar-auto-hide="false">
              {options &&
                options.map(({ name, link, count, sub }, index) => {
                  return (
                    <li key={index} className="widget-list-item cz-filter-item">
                      <a className="widget-list-link d-flex justify-content-between align-items-center" href={link}>
                        <span className="cz-filter-item-text">
                          {type === 'multi' && (
                            <div className="custom-control custom-checkbox">
                              <label className="custom-control-label" htmlFor="finish505">
                                {name} <span className="font-size-xs text-muted">{sub}</span>
                              </label>
                            </div>
                          )}
                          {type === 'single' && name}
                        </span>
                        {count && <span className="font-size-xs text-muted ml-3">{count}</span>}
                      </a>
                    </li>
                  )
                })}
            </ul>
          </div>
        </div>
      </div>
    </div>
  )
}

const ProductListingSidebar = ({ filters, resultCount = '287' }) => {
  return (
    <div className="cz-sidebar rounded-lg box-shadow-lg" id="shop-sidebar">
      <div className="cz-sidebar-header box-shadow-sm">
        <button className="close ml-auto" type="button" data-dismiss="sidebar" aria-label="Close">
          <span className="d-inline-block font-size-xs font-weight-normal align-middle">Close sidebar</span>
          <span className="d-inline-block align-middle ml-2" aria-hidden="true">
            <i className="far fa-times"></i>
          </span>
        </button>
      </div>
      <div className="cz-sidebar-body" data-simplebar data-simplebar-auto-hide="true">
        <div className="widget widget-categories mb-3">
          <div className="row">
            <h3 className="widget-title col">Filters</h3>
            <span className="text-right col">{resultCount} Results</span>
          </div>
          <div className="input-group-overlay input-group-sm mb-2">
            <input className="cz-filter-search form-control form-control-sm appended-form-control" type="text" placeholder="Search by product title or SKU" />
            <div className="input-group-append-overlay">
              <span className="input-group-text">
                <i className="fa fa-search"></i>
              </span>
            </div>
          </div>
          <div className="accordion mt-3 border-top" id="shop-categories">
            {filters &&
              filters.map((filter, index) => {
                return <ProductListingFilter {...filter} key={index} index={index} />
              })}
          </div>
        </div>
      </div>
    </div>
  )
}
const ProductListing = ({ crumbs, products, title, filters, appliedFilters, sortOptions }) => {
  return (
    <Layout>
      <ProductListingHeader title={title} crumbs={crumbs} />
      <div className="container pb-5 mb-2 mb-md-4">
        <div className="row">
          <aside className="col-lg-4">
            <ProductListingSidebar filters={filters} />
          </aside>
          <div className="col-lg-8">
            <ProductListingToolBar appliedFilters={appliedFilters} sortOptions={sortOptions} />
            <ProductListingGrid productResults={products} />
            <ProductListingPagination />
          </div>
        </div>
      </div>
    </Layout>
  )
}

function mapStateToProps(state) {
  const { preload } = state
  return preload.productListing
}

export default connect(mapStateToProps)(ProductListing)
//          <BreadCrumb crumbs={crumbs} />
