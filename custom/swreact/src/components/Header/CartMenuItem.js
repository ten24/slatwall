import { connect } from 'react-redux'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'

const CartMenuItem = ({ orderCount, total }) => {
  const { t, i18n } = useTranslation()

  return (
    <div className="navbar-tool ml-3">
      <Link className="navbar-tool-icon-box bg-secondary" to="/cart">
        {orderCount > 0 && <span className="navbar-tool-label">{orderCount}</span>}
        <i className="far fa-shopping-cart"></i>
      </Link>
      <Link className="navbar-tool-text" to="/cart">
        <small>{t('frontend.cart.my')}</small>${total}
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
