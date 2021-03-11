import { useDispatch, useSelector } from 'react-redux'
import { useTranslation } from 'react-i18next'
import { applyPromoCode, removePromoCode } from '../../actions/cartActions'
import { useState } from 'react'

const CartPromoBox = () => {
  const { isFetching } = useSelector(state => state.cart.isFetching)
  const promotionCodes = useSelector(state => state.cart.promotionCodes)
  const dispatch = useDispatch()
  const [promoCode, setPromoCode] = useState('')
  const { t, i18n } = useTranslation()
  return (
    <div className="accordion" id="order-options">
      <div className="card">
        <div className="card-header">
          <h3 className="accordion-heading">
            <a href="#promo-code" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="promo-code">
              {t('frontend.order.promo.code.apply')}
            </a>
          </h3>
        </div>
        <div className="collapse show" id="promo-code" data-parent="#order-options">
          <form className="card-body needs-validation" method="post" noValidate="">
            <div className="form-group">
              <input className="form-control" type="text" placeholder="Promo code" value={promoCode} required onChange={e => setPromoCode(e.target.value)} />
              <div className="invalid-feedback">{t('frontend.order.promo.code.provide')}</div>
            </div>
            <button
              className="btn btn-outline-primary btn-block"
              type="submit"
              disabled={isFetching}
              onClick={e => {
                e.preventDefault()
                dispatch(applyPromoCode(promoCode))
                setPromoCode('')
              }}
            >
              {t('frontend.order.promo.code.apply')}
            </button>
            {promotionCodes.length > 0 &&
              promotionCodes.map(promotionCodeItem => {
                const { promotionCode, promotion } = promotionCodeItem
                const { promotionName } = promotion
                return (
                  <button
                    className="btn btn-link px-0 text-danger"
                    type="button"
                    key={promotionCode}
                    disabled={isFetching}
                    onClick={event => {
                      event.preventDefault()
                      dispatch(removePromoCode(promotionCode))
                    }}
                  >
                    <i className="fal fa-times-circle"></i>
                    <span className="font-size-sm"> {promotionName}</span>
                  </button>
                )
              })}
          </form>
        </div>
      </div>
    </div>
  )
}
export default CartPromoBox
