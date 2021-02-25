import { useTranslation } from 'react-i18next'
import { useLocation } from 'react-router-dom'
import queryString from 'query-string'

const ListingToolBar = ({ hide, sorting, orderBy, removeFilter, setSort }) => {
  const { t, i18n } = useTranslation()
  const loc = useLocation()

  const qs = queryString.parse(loc.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
  if (qs.orderBy) {
    orderBy = qs.orderBy
  }
  let appliedFilters = Object.keys(qs)
    .map(key => {
      return { filterName: key, name: qs[key] }
    })
    .filter(filter => {
      return filter.filterName !== 'pageSize' && filter.filterName !== 'currentPage' && filter.filterName !== 'orderBy' && filter.filterName !== 'keyword' && filter.filterName !== hide
    })
  return (
    <div className="d-flex justify-content-center justify-content-sm-between align-items-center pt-2 pb-4 pb-sm-5">
      <div className="d-flex flex-wrap">
        <div className="form-inline flex-nowrap mr-3 mr-sm-4 pb-sm-3">
          <label className="text-dark opacity-75 text-nowrap mr-2 d-none d-sm-block">{t('frontend.plp.search.applied_filters')}</label>

          {appliedFilters &&
            appliedFilters.map(flt => {
              if (Array.isArray(flt.name)) {
                flt = flt.name.map(singleFilter => {
                  return { filterName: flt.filterName, name: singleFilter }
                })
              } else {
                flt = [flt]
              }
              return flt.map((filter, index) => {
                return (
                  <span key={index} className="badge badge-light border p-2 mr-2">
                    <a
                      onClick={event => {
                        event.preventDefault()
                        removeFilter({ name: filter.name, filterName: filter.filterName })
                      }}
                    >
                      <i className="far fa-times"></i>
                    </a>
                    {filter.name}
                  </span>
                )
              })
            })}
        </div>
      </div>
      <div className="d-sm-flex pb-3 align-items-center">
        <label className="text-dark opacity-75 text-nowrap mr-2 mb-0 d-none d-sm-block" htmlFor="sorting">
          Sort by:
        </label>
        <select
          className="form-control custom-select"
          id="sorting"
          value={orderBy}
          onChange={event => {
            setSort(event.target.value)
          }}
        >
          {sorting &&
            sorting.options &&
            sorting.options.length > 1 &&
            sorting.options.map(({ name, value }, index) => {
              return (
                <option key={index} value={value}>
                  {name}
                </option>
              )
            })}
        </select>
      </div>
    </div>
  )
}

export default ListingToolBar
