import { connect } from 'react-redux'
import { search, setKeyword, setSort, removeFilter } from '../../actions/productSearchActions'

const ProductListingToolBar = ({ removeFilterAction, searchWithFilters, sortByAction, sortOptions, appliedFilters, sortBy }) => {
  return (
    <div className="d-flex justify-content-center justify-content-sm-between align-items-center pt-2 pb-4 pb-sm-5">
      <div className="d-flex flex-wrap">
        <div className="form-inline flex-nowrap mr-3 mr-sm-4 pb-sm-3">
          <label className="text-dark opacity-75 text-nowrap mr-2 d-none d-sm-block">Applied Filters:</label>

          {appliedFilters &&
            appliedFilters.map(({ name, filterName }, index) => {
              return (
                <span key={index} className="badge badge-light border p-2 mr-2">
                  <a
                    onClick={event => {
                      removeFilterAction({ name, filterName })
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
            sortByAction(event.target.value)
            searchWithFilters()
          }}
        >
          {sortOptions &&
            sortOptions.map((name, index) => {
              return (
                <option key={index} value={name}>
                  {name}
                </option>
              )
            })}
        </select>
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
    sortByAction: async sortBy => dispatch(setSort(sortBy)),
    setKeywordAction: async keyword => dispatch(setKeyword(keyword)),
    removeFilterAction: async filter => dispatch(removeFilter(filter)),
    searchWithFilters: async () => dispatch(search()),
  }
}
export default connect(mapStateToProps, mapDispatchToProps)(ProductListingToolBar)
