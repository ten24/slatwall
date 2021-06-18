import { useSelector } from 'react-redux'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useFormatCurrency } from '../../hooks/'

const CartMenuItem = () => {
  const { t } = useTranslation()
  const cart = useSelector(state => state.cart)
  const cartQuantity = cart.orderItems.reduce((accumulator, orderItem) => accumulator + orderItem.quantity, 0)
  const [formatCurrency] = useFormatCurrency({})

  return (
    <div className="navbar-tool ml-3">
      <Link className="navbar-tool-icon-box bg-secondary" to="/shopping-cart">
        {cartQuantity > 0 && <span className="navbar-tool-label">{cartQuantity}</span>}
        <i className="far fa-shopping-cart"></i>
      </Link>
      <Link className="navbar-tool-text" to="/shopping-cart">
        <small>{t('frontend.cart.my')}</small>
        {formatCurrency(cart.total)}
      </Link>
    </div>
  )
}

export { CartMenuItem }
