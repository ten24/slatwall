import React, { useState, useCallback } from 'react'
import { connect, useDispatch } from 'react-redux'
import { search, setKeyword } from '../../actions/productSearchActions'
import debounce from 'lodash/debounce'
import ProductListingFilter from './ProductListingFilter'

const ProductListingSidebar = ({ keyword, possibleFilters, attributes, recordsCount }) => {
  const dispatch = useDispatch()
  const [searchTerm, setSearchTerm] = useState(keyword)

  // TODO: Shouls this be an auto search or should you have to click enter
  const slowlyRequest = useCallback(
    debounce(value => {
      dispatch(setKeyword(value))
      dispatch(search())
    }, 500),
    [debounce, dispatch]
  )

  const handleInputChange = e => {
    setSearchTerm(e.target.value)
    slowlyRequest(e.target.value)
  }
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
            <span className="text-right col">{recordsCount} Results</span>
          </div>
          <div className="input-group-overlay input-group-sm mb-2">
            <input className="cz-filter-search form-control form-control-sm appended-form-control" type="text" value={searchTerm} onChange={handleInputChange} placeholder="Search by product title or SKU" />
            <div className="input-group-append-overlay">
              <span className="input-group-text">
                <i className="fa fa-search"></i>
              </span>
            </div>
          </div>
          <div className="accordion mt-3 border-top" id="shop-categories">
            {possibleFilters &&
              possibleFilters.map((filter, index) => {
                return <ProductListingFilter key={index} index={`filter${index}`} {...filter} />
              })}
            {attributes &&
              attributes.map((filter, index) => {
                return <ProductListingFilter key={index} type="attribute" index={`attr${index}`} {...filter} />
              })}
          </div>
        </div>
      </div>
    </div>
  )
}
function mapStateToProps(state) {
  return state.productSearchReducer
}

export default connect(mapStateToProps)(ProductListingSidebar)
