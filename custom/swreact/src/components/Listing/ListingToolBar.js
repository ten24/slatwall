import { useTranslation } from 'react-i18next'

const ListingToolBar = ({ sortingOptions, appliedFilters, sortBy, removeFilter, setSort }) => {
  const { t, i18n } = useTranslation()

  return (
    <div className="d-flex justify-content-center justify-content-sm-between align-items-center pt-2 pb-4 pb-sm-5">
      <div className="d-flex flex-wrap">
        <div className="form-inline flex-nowrap mr-3 mr-sm-4 pb-sm-3">
          <label className="text-dark opacity-75 text-nowrap mr-2 d-none d-sm-block">{t('frontend.plp.search.applied_filters')}</label>

          {appliedFilters &&
            appliedFilters.map(({ name, filterName }, index) => {
              return (
                <span key={index} className="badge badge-light border p-2 mr-2">
                  <a
                    onClick={event => {
                      event.preventDefault()
                      removeFilter({ name, filterName })
                    }}
                  >
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
        <select
          className="form-control custom-select"
          id="sorting"
          value={sortBy}
          onChange={event => {
            event.preventDefault()
            setSort(event.target.value)
          }}
        >
          {sortingOptions &&
            sortingOptions.map(({ name, value }, index) => {
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
