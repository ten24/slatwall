import { connect } from 'react-redux'
import { Link } from 'react-router-dom'

const CartMenuItem = ({ orderCount, total }) => {
  return (
    <div className="navbar-tool ml-3">
      <Link className="navbar-tool-icon-box bg-secondary" to="/cart">
        {orderCount > 0 && <span className="navbar-tool-label">{orderCount}</span>}
        <i className="far fa-shopping-cart"></i>
      </Link>
      <Link className="navbar-tool-text" to="/cart">
        <small>My Cart</small>${total}
      </Link>
    </div>
  )
}
function mapStateToProps(state) {
  const { cartReducer } = state
  return {
    orderCount: cartReducer.orderItems.length,
    total: cartReducer.total,
  }
}
export default connect(mapStateToProps)(CartMenuItem)
