import React, { useState, useCallback, useEffect } from 'react'
import { FeaturedProductCard, Layout } from '../../components'
import { connect } from 'react-redux'
import { getUser } from '../../actions/userActions'
import { search, setKeyword, setSort, addFilter, removeFilter } from '../../actions/productSearchActions'
import _ from 'lodash'

const AttributeFacet = ({ name, count, sub, index, options, type }) => {
  return (
    <li key={index} className="widget-list-item cz-filter-item">
      <a
        className="widget-list-link d-flex justify-content-between align-items-center"
        onClick={event => {
          const filterItem = options.filter(potentialFilter => {
            return potentialFilter.name === name
          }, name)
          console.log('potentialFilter', filterItem)

          console.log('addFilterAction', { name, type, options: filterItem })
          // setFilterAction({ name, type, options: filterItem })
          // searchWithFilters()
        }}
      >
        <span className="cz-filter-item-text">
          <div className="custom-control custom-checkbox">
            <label className="custom-control-label" htmlFor="finish505">
              {name} <span className="font-size-xs text-muted">{sub}</span>
            </label>
          </div>
        </span>
        {count && <span className="font-size-xs text-muted ml-3">{count}</span>}
      </a>
    </li>
  )
}

const DrillDownFacet = ({ searchWithFilters, addFilterAction, name, count, filterName }) => {
  return (
    <li className="widget-list-item cz-filter-item">
      <a
        className="widget-list-link d-flex justify-content-between align-items-center"
        onClick={event => {
          addFilterAction({ name, filterName })
          searchWithFilters()
        }}
      >
        <span className="cz-filter-item-text">{name}</span>
        {count && <span className="font-size-xs text-muted ml-3">{count}</span>}
      </a>
    </li>
  )
}

const FacetSearch = ({ searchTerm, search }) => {
  return (
    <div className="input-group-overlay input-group-sm mb-2">
      <input
        className="cz-filter-search form-control form-control-sm appended-form-control"
        value={searchTerm}
        onChange={event => {
          search(event.target.value)
        }}
        type="text"
        placeholder="Search"
      />
      <div className="input-group-append-overlay">
        <span className="input-group-text">
          <i className="far fa-search"></i>
        </span>
      </div>
    </div>
  )
}

const ProductListingFilter = ({ searchWithFilters, appliedFilters, addFilterAction, filterName, type, options, index }) => {
  const [searchTerm, setSearchTerm] = useState('')
  const [searchResults, setSearchResults] = useState([])

  useEffect(() => {
    const validFilters = appliedFilters.filter(appliedFilter => appliedFilter.filterName === filterName)
    let results = options.filter(({ name: id1 }) => !validFilters.some(({ name: id2 }) => id2 !== id1))
    if (searchTerm.length) {
      results = options.filter(option => option.name.toLowerCase().includes(searchTerm.toLowerCase()))
    }
    setSearchResults(results)
  }, [searchTerm, options, appliedFilters])

  return (
    <div className="card border-bottom pt-1 pb-2 my-1">
      <div className="card-header">
        <h3 className="accordion-heading">
          <a className="collapsed" href={`#filer${index}`} role="button" data-toggle="collapse" aria-expanded="false" aria-controls="productType">
            {filterName}
            <span className="accordion-indicator"></span>
          </a>
        </h3>
      </div>
      <div className="collapse" id={`filer${index}`} data-parent="#shop-categories">
        <div className="card-body">
          <div className="widget widget-links cz-filter">
            <FacetSearch searchTerm={searchTerm} search={setSearchTerm} />
            <ul className="widget-list cz-filter-list pt-1" style={{ height: '12rem' }} data-simplebar data-simplebar-auto-hide="false">
              {searchResults &&
                searchResults.map((result, index) => {
                  if (type === 'single') {
                    return <DrillDownFacet searchWithFilters={searchWithFilters} addFilterAction={addFilterAction} {...result} key={index} filterName={filterName} />
                  } else {
                    return <AttributeFacet {...result} key={index} />
                  }
                })}
            </ul>
          </div>
        </div>
      </div>
    </div>
  )
}

function mapStateToProps(state) {
  const { preload, productSearchReducer } = state
  return { ...preload.productListing, ...productSearchReducer }
}
const mapDispatchToProps = dispatch => {
  return {
    getUser: async () => dispatch(getUser()),
    sortByAction: async sortBy => dispatch(setSort(sortBy)),
    setKeywordAction: async keyword => dispatch(setKeyword(keyword)),
    removeFilterAction: async filter => dispatch(removeFilter(filter)),
    addFilterAction: async filter => dispatch(addFilter(filter)),
    searchWithFilters: async () => dispatch(search()),
  }
}
export default connect(mapStateToProps, mapDispatchToProps)(ProductListingFilter)
