import React, { useState, useEffect } from 'react'
import { connect, useDispatch } from 'react-redux'
import { search, addFilter, updateAttribute } from '../../actions/productSearchActions'

const AttributeFacet = ({ name, count, sub, filterName, isSelected }) => {
  const dispatch = useDispatch()

  const token = filterName.replace(/\s/g, '') + name.replace(/\s/g, '') + 'input'
  return (
    <li className="widget-list-item cz-filter-item">
      <div className="widget-list-link d-flex justify-content-between align-items-center">
        <span className="cz-filter-item-text">
          <div className="custom-control custom-checkbox">
            <input
              className="custom-control-input"
              type="checkbox"
              checked={isSelected}
              onChange={event => {
                dispatch(updateAttribute({ name, filterName }))
                dispatch(search())
              }}
              id={token}
            />
            <label className="custom-control-label" htmlFor={token}>
              {name} <span className="font-size-xs text-muted">{sub}</span>
            </label>
          </div>
        </span>
        {count && <span className="font-size-xs text-muted ml-3">{count}</span>}
      </div>
    </li>
  )
}

const DrillDownFacet = ({ name, count, filterName }) => {
  const dispatch = useDispatch()

  return (
    <li className="widget-list-item cz-filter-item">
      <a
        className="widget-list-link d-flex justify-content-between align-items-center"
        onClick={event => {
          dispatch(addFilter({ name, filterName }))
          dispatch(search())
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

const ProductListingFilter = ({ appliedFilters, key, filterName, options, index, type }) => {
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
                  if (type === 'attribute') {
                    return <AttributeFacet {...result} key={index} filterName={filterName} />
                  } else {
                    return <DrillDownFacet {...result} key={index} filterName={filterName} />
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
  return { ...state.productSearchReducer }
}
export default connect(mapStateToProps)(ProductListingFilter)
