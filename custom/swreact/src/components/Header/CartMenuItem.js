import { useSelector } from 'react-redux'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'

const CartMenuItem = () => {
  const { t, i18n } = useTranslation()
  const cart = useSelector(state => state.cart)
  const cartQuantity = cart.orderItems.reduce((accumulator, orderItem) => accumulator + orderItem.quantity, 0)

  return (
    <div className="navbar-tool ml-3">
      <Link className="navbar-tool-icon-box bg-secondary" to="/shopping-cart">
        {cartQuantity > 0 && <span className="navbar-tool-label">{cartQuantity}</span>}
        <i className="far fa-shopping-cart"></i>
      </Link>
      <Link className="navbar-tool-text" to="/shopping-cart">
        <small>{t('frontend.cart.my')}</small>${cart.total}
      </Link>
    </div>
  )
}

export default CartMenuItem
