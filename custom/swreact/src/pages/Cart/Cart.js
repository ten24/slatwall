import { CartLineItem, CartPromoBox, Layout, PromotionalMessaging } from '../../components'
import { useDispatch, useSelector } from 'react-redux'
import { useTranslation } from 'react-i18next'
import { Link, useHistory, useLocation } from 'react-router-dom'
import { getCart } from '../../actions/cartActions'
import { useEffect } from 'react'
import useFormatCurrency from '../../hooks/useFormatCurrency'
import PageHeader from '../../components/PageHeader/PageHeader'
import { AuthenticationStepUp } from '../../components/AuthenticationStepUp/AuthenticationStepUp'

const Cart = () => {
  const { t } = useTranslation()
  const dispatch = useDispatch()

  const { total, isFetching, orderItems } = useSelector(state => state.cart)
  let history = useHistory()
  const [formatCurrency] = useFormatCurrency({})
  useEffect(() => {
    dispatch(getCart())
  }, [dispatch])
  return (
    <Layout>
      <PageHeader />

      <div className="container pb-5 mb-2 mb-md-4">
        <div className="row">
          <section className="col-lg-8">
            <div className="d-flex justify-content-between align-items-center pt-3 pb-2 pb-sm-5 mt-1">
              <h2 className="h6 mb-0">{t('frontend.cart.heading')}</h2>
              <button
                className="btn btn-outline-primary btn-sm pl-2"
                disabled={isFetching}
                onClick={e => {
                  e.preventDefault()
                  history.goBack()
                }}
              >
                <i className="far fa-chevron-left"></i> {t('frontend.order.continue_shopping')}
              </button>
            </div>
            <AuthenticationStepUp />
            {orderItems &&
              orderItems.map(({ orderItemID }) => {
                return <CartLineItem key={orderItemID} orderItemID={orderItemID} />
              })}
          </section>

          <aside className="col-lg-4 pt-4 pt-lg-0">
            <div className="cz-sidebar-static rounded-lg box-shadow-lg ml-lg-auto">
              <PromotionalMessaging />
              <div className="text-center mb-4 pb-3 border-bottom">
                <h2 className="h6 mb-3 pb-1">{t('frontend.order.subtotal')}</h2>
                <h3 className="font-weight-normal">{formatCurrency(total)}</h3>
              </div>

              <CartPromoBox />

              <button
                className="btn btn-primary btn-block mt-4"
                disabled={isFetching || orderItems.length === 0}
                onClick={e => {
                  e.preventDefault()
                  history.push('/checkout')
                }}
              >
                {t('frontend.order.to_checkout')}
              </button>
            </div>
          </aside>
        </div>
      </div>
    </Layout>
  )
}

export default Cart
