import ListingFilter from './ListingFilter'
import { useTranslation } from 'react-i18next'
import queryString from 'query-string'
import ContentLoader from 'react-content-loader'
import { useRef } from 'react'

import useFormatCurrency from '../../hooks/useFormatCurrency'

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

const formatPriceRange = (priceRange, formatCurrency) => {
  const options = priceRange?.options.map(option => {
    const ranges = option.name.split('-')
    if (ranges.length !== 2) {
      console.error('invalid currency range', option)
    }
    const name = formatCurrency(parseFloat(ranges[0])) + ' - ' + formatCurrency(parseFloat(ranges[1]))
    return { name, value: option.value }
  })
  if (options) {
    return { ...priceRange, options }
  }
}

const ListingSidebar = ({ isFetching, qs, hide, option, brand, attribute, category, priceRange, productType, keyword, recordsCount, setKeyword, updateAttribute }) => {
  const { t } = useTranslation()
  const textInput = useRef(null)
  const [formatCurrency] = useFormatCurrency({})

  const newPriceRange = formatPriceRange(priceRange, formatCurrency)

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
      <div className="cz-sidebar-body">
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
              ref={textInput}
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
                    setKeyword(textInput.current.value)
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
              brand &&
              brand !== {} &&
              brand.facetKey !== hide &&
              [brand].map(filter => {
                return <ListingFilter qs={qs} key="brand" index={brand.facetKey} {...filter} facetKey="brand" appliedFilters={getAppliedFilters(qs, 'brand')} updateAttribute={updateAttribute} />
              })}

            {!isFetching &&
              newPriceRange &&
              newPriceRange !== {} &&
              [newPriceRange].map(filter => {
                return <ListingFilter qs={qs} key={newPriceRange.facetKey} index={newPriceRange.facetKey} {...filter} facetKey="priceRange" appliedFilters={getAppliedFilters(qs, 'priceRange')} updateAttribute={updateAttribute} />
              })}

            {!isFetching &&
              attribute &&
              attribute.subFacets &&
              Object.keys(attribute.subFacets).map(facetKey => {
                return [option.subFacets[facetKey]].map(filter => {
                  return <ListingFilter qs={qs} key={facetKey} index={facetKey} {...filter} facetKey={`attribute_${facetKey}`} appliedFilters={getAppliedFilters(qs, `attribute_${facetKey}`)} updateAttribute={updateAttribute} />
                })
              })}
            {!isFetching &&
              option &&
              option.subFacets &&
              Object.keys(option.subFacets).map(facetKey => {
                return [option.subFacets[facetKey]].map(filter => {
                  return <ListingFilter qs={qs} key={facetKey} index={facetKey} {...filter} facetKey={`option_${facetKey}`} appliedFilters={getAppliedFilters(qs, `option_${facetKey}`)} updateAttribute={updateAttribute} />
                })
              })}
            {!isFetching &&
              category &&
              category.options &&
              category.options.length > 0 &&
              category.facetKey !== hide &&
              [category].map(filter => {
                return <ListingFilter qs={qs} key={category.facetKey} index={category.facetKey} {...filter} appliedFilters={getAppliedFilters(qs, 'category')} updateAttribute={updateAttribute} />
              })}
            {!isFetching &&
              productType &&
              productType.options &&
              productType.options.length > 0 &&
              productType.facetKey !== hide &&
              [productType].map(filter => {
                return <ListingFilter qs={qs} key={productType.facetKey} index={productType.facetKey} {...filter} appliedFilters={getAppliedFilters(qs, 'productType')} updateAttribute={updateAttribute} />
              })}
          </div>
        </div>
      </div>
    </div>
  )
}

export default ListingSidebar
