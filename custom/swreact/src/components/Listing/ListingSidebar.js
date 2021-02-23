import React, { useState, useCallback } from 'react'
import debounce from 'lodash/debounce'
import ProductListingFilter from './ListingFilter'
import { useTranslation } from 'react-i18next'

const ListingSidebar = ({ keyword, appliedFilters, possibleFilters, attributes, recordsCount, setKeyword, updateAttribute, addFilter }) => {
  const [searchTerm, setSearchTerm] = useState(keyword)
  const { t, i18n } = useTranslation()

  // TODO: Shouls this be an auto search or should you have to click enter
  const slowlyRequest = useCallback(
    debounce(value => {
      setKeyword(value)
    }, 500),
    [debounce]
  )

  const handleInputChange = e => {
    setSearchTerm(e.target.value)
    slowlyRequest(e.target.value)
  }
  return (
    <div className="cz-sidebar rounded-lg box-shadow-lg" id="shop-sidebar">
      <div className="cz-sidebar-header box-shadow-sm">
        <button className="close ml-auto" type="button" data-dismiss="sidebar" aria-label="Close">
          <span className="d-inline-block font-size-xs font-weight-normal align-middle">{t('frontend.core.close_sidebar')} </span>
          <span className="d-inline-block align-middle ml-2" aria-hidden="true">
            <i className="far fa-times"></i>
          </span>
        </button>
      </div>
      <div className="cz-sidebar-body" data-simplebar data-simplebar-auto-hide="true">
        <div className="widget widget-categories mb-3">
          <div className="row">
            <h3 className="widget-title col">{t('frontend.core.filters')}</h3>
            <span className="text-right col">{`${recordsCount} ${t('frontend.core.results')}`}</span>
          </div>
          <div className="input-group-overlay input-group-sm mb-2">
            <input className="cz-filter-search form-control form-control-sm appended-form-control" type="text" value={searchTerm} onChange={handleInputChange} placeholder={t('frontend.plp.search.placeholder')} />
            <div className="input-group-append-overlay">
              <span className="input-group-text">
                <i className="fa fa-search"></i>
              </span>
            </div>
          </div>
          <div className="accordion mt-3 border-top" id="shop-categories">
            {possibleFilters &&
              possibleFilters.map((filter, index) => {
                return <ProductListingFilter appliedFilters={appliedFilters} key={index} index={`filter${index}`} {...filter} addFilter={addFilter} updateAttribute={updateAttribute} />
              })}
            {attributes &&
              attributes.map((filter, index) => {
                return <ProductListingFilter appliedFilters={appliedFilters} key={index} type="attribute" index={`attr${index}`} {...filter} addFilter={addFilter} updateAttribute={updateAttribute} />
              })}
          </div>
        </div>
      </div>
    </div>
  )
}

export default ListingSidebar
