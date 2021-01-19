import { connect } from 'react-redux'
import { search } from '../../actions/productSearchActions'

const ProductListingPagination = () => {
  return (
    <nav className="d-flex justify-content-between pt-2" aria-label="Page navigation">
      <ul className="pagination">
        <li className="page-item">
          <a className="page-link" href="#">
            <i className="far fa-chevron-left mr-2"></i> Prev
          </a>
        </li>
      </ul>
      <ul className="pagination">
        <li className="page-item d-sm-none">
          <span className="page-link page-link-static">1 / 5</span>
        </li>
        <li className="page-item active d-none d-sm-block" aria-current="page">
          <span className="page-link">
            1<span className="sr-only">(current)</span>
          </span>
        </li>
        <li className="page-item d-none d-sm-block">
          <a className="page-link" href="#">
            2
          </a>
        </li>
        <li className="page-item d-none d-sm-block">
          <a className="page-link" href="#">
            3
          </a>
        </li>
        <li className="page-item d-none d-sm-block">
          <a className="page-link" href="#">
            4
          </a>
        </li>
        <li className="page-item d-none d-sm-block">
          <a className="page-link" href="#">
            5
          </a>
        </li>
      </ul>
      <ul className="pagination">
        <li className="page-item">
          <a className="page-link" href="#" aria-label="Next">
            Next <i className="far fa-chevron-right ml-2"></i>
          </a>
        </li>
      </ul>
    </nav>
  )
}
function mapStateToProps(state) {
  const { preload, productSearchReducer } = state
  return { ...preload.productListing, ...productSearchReducer }
}
const mapDispatchToProps = dispatch => {
  return {
    searchWithFilters: async () => dispatch(search()),
  }
}
export default connect(mapStateToProps, mapDispatchToProps)(ProductListingPagination)
