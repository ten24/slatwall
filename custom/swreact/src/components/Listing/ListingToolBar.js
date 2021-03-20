import { useTranslation } from 'react-i18next'
import { useLocation } from 'react-router-dom'
import queryString from 'query-string'

const ListingToolBar = ({ hide, sorting, orderBy, setSort }) => {
  const { t, i18n } = useTranslation()
  const loc = useLocation()

  const qs = queryString.parse(loc.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
  if (qs.orderBy) {
    orderBy = qs.orderBy
  }
  return (
    <div className="d-flex justify-content-end align-items-center pt-2 pb-4 pb-sm-5">
      <div className="d-sm-flex pb-3 align-items-center">
        <label className="text-dark opacity-75 text-nowrap mr-2 mb-0 d-none d-sm-block" htmlFor="sorting">
          Sort by:
        </label>
        <select
          className="form-control custom-select"
          id="sorting"
          value={orderBy}
          style={{ minWidth: '150' }}
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
