import React, { useState, useEffect } from 'react'
import SimpleBar from 'simplebar-react'

const AttributeFacet = ({ qs, facet, filterName, facetKey, updateAttribute, isSelected = false }) => {
  const token = filterName.replace(/\s/g, '') + facet.name.replace(/\s/g, '') + 'input'
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
                updateAttribute({ name: facet.value, filterName: facetKey })
              }}
              id={token}
            />
            <label className="custom-control-label" htmlFor={token}>
              {facet.name} {/* <span className="font-size-xs text-muted">{sub}</span> */}
            </label>
          </div>
        </span>
        {/* {count && <span className="font-size-xs text-muted ml-3">{count}</span>} */}
      </div>
    </li>
  )
}

const DrillDownFacet = ({ name, count, filterName, addFilter }) => {
  return (
    <li className="widget-list-item cz-filter-item">
      <a
        className="widget-list-link d-flex justify-content-between align-items-center"
        onClick={event => {
          event.preventDefault()
          addFilter({ name, filterName })
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
const ListingFilter = ({ qs, appliedFilters, name, facetKey, selectType, options, index, updateAttribute }) => {
  const [searchTerm, setSearchTerm] = useState('')
  const [searchResults, setSearchResults] = useState([])
  useEffect(() => {
    let results = options
    if (searchTerm.length) {
      results = options.filter(option => option.name.toLowerCase().includes(searchTerm.toLowerCase()))
    }
    if (selectType === 'single') {
      results = options.filter(option => {
        return appliedFilters.includes(option.value)
      })
      if (results.length === 0) {
        results = options
      }
    }
    setSearchResults([...results])
  }, [searchTerm, options, appliedFilters, name])
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
            <FacetSearch searchTerm={searchTerm} search={setSearchTerm} />
            <SimpleBar className="widget-list cz-filter-list pt-1" style={{ 'max-height': '12rem' }} forceVisible="y" autoHide={false}>
              {searchResults &&
                searchResults.map((facet, index) => {
                  const isSelected = appliedFilters.includes(facet.value)
                  return <AttributeFacet qs={qs} isSelected={isSelected} facet={facet} key={`opt${facet.value}`} filterName={name} facetKey={facetKey} updateAttribute={updateAttribute} />
                })}
            </SimpleBar>
          </div>
        </div>
      </div>
    </div>
  )
}

export default ListingFilter
