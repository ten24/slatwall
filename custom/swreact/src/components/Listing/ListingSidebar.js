import React, { useState, useCallback } from 'react'
import debounce from 'lodash/debounce'
import ProductListingFilter from './ListingFilter'
import { useTranslation } from 'react-i18next'
import queryString from 'query-string'
import ContentLoader from 'react-content-loader'

const getAppliedFilters = (params, facetKey) => {
  const qs = queryString.parse(params, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
  if (qs[facetKey]) {
    return Array.isArray(qs[facetKey]) ? qs[facetKey] : [qs[facetKey]]
  }
  return []
}

const FilterLoader = props => (
  <ContentLoader speed={2} width={400} height={150} viewBox="0 0 400 200" backgroundColor="#f3f3f3" foregroundColor="#ecebeb" {...props}>
    <rect x="25" y="15" rx="5" ry="5" width="350" height="20" />
    <rect x="25" y="45" rx="5" ry="5" width="350" height="10" />
    <rect x="25" y="60" rx="5" ry="5" width="350" height="10" />
    <rect x="26" y="75" rx="5" ry="5" width="350" height="10" />
    <rect x="27" y="107" rx="5" ry="5" width="350" height="20" />
    <rect x="26" y="135" rx="5" ry="5" width="350" height="10" />
    <rect x="26" y="150" rx="5" ry="5" width="350" height="10" />
    <rect x="27" y="165" rx="5" ry="5" width="350" height="10" />
  </ContentLoader>
)

const ListingSidebar = ({ isFetching, qs, hide, optionGroups, brands, categories, productTypes, keyword, recordsCount, setKeyword, updateAttribute }) => {
  const { t, i18n } = useTranslation()

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
            <input
              className="cz-filter-search form-control form-control-sm appended-form-control"
              type="text"
              defaultValue={keyword}
              onKeyDown={e => {
                if (e.key === 'Enter') {
                  e.preventDefault()
                  setKeyword(e.target.value)
                }
              }}
              placeholder={t('frontend.plp.search.placeholder')}
            />
            <div className="input-group-append-overlay">
              <span className="input-group-text">
                <i
                  className="fa fa-search"
                  onClick={e => {
                    e.preventDefault()
                    setKeyword(e.target.value)
                  }}
                />
              </span>
            </div>
          </div>
          <div className="accordion mt-3 border-top" id="shop-categories">
            {isFetching && (
              <>
                <FilterLoader />
                <FilterLoader />
                <FilterLoader />
              </>
            )}

            {!isFetching &&
              optionGroups &&
              optionGroups.map((filter, index) => {
                return <ProductListingFilter qs={qs} key={`attr${filter.name.replace(' ', '')}`} index={`attr${index}`} {...filter} appliedFilters={getAppliedFilters(qs, filter.facetKey)} updateAttribute={updateAttribute} />
              })}

            {!isFetching &&
              brands &&
              brands !== {} &&
              brands.facetKey !== hide &&
              [brands].map((filter, index) => {
                return <ProductListingFilter qs={qs} key={`brand${filter.name.replace(' ', '')}`} index={`brand${index}`} {...filter} appliedFilters={getAppliedFilters(qs, filter.facetKey)} updateAttribute={updateAttribute} />
              })}
            {!isFetching &&
              categories &&
              categories.options &&
              categories.options.length > 0 &&
              categories.facetKey !== hide &&
              [categories].map((filter, index) => {
                return <ProductListingFilter qs={qs} key={`cat${filter.name.replace(' ', '')}`} index={`cat${index}`} {...filter} appliedFilters={getAppliedFilters(qs, filter.facetKey)} updateAttribute={updateAttribute} />
              })}
            {!isFetching &&
              productTypes &&
              productTypes.options &&
              productTypes.options.length > 0 &&
              productTypes.facetKey !== hide &&
              [productTypes].map((filter, index) => {
                return <ProductListingFilter qs={qs} key={`pt${filter.name.replace(' ', '')}`} index={`pt${index}`} {...filter} appliedFilters={getAppliedFilters(qs, filter.facetKey)} updateAttribute={updateAttribute} />
              })}
          </div>
        </div>
      </div>
    </div>
  )
}

export default ListingSidebar
