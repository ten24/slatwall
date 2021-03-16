import { useSelector } from 'react-redux'
import { useTranslation } from 'react-i18next'
import { useHistory } from 'react-router-dom'

const OrderNotes = () => {
  const isFetching = useSelector(state => state.cart.isFetching)
  let history = useHistory()
  const { t, i18n } = useTranslation()

  return (
    <div className="form-group mb-4 mt-3">
      <label className="mb-2" htmlFor="order-comments">
        <span className="font-weight-medium">{t('frontend.order.notes')}</span>
      </label>
      <textarea className="form-control" rows="6" id="order-comments"></textarea>
    </div>
  )
}
export default OrderNotes
