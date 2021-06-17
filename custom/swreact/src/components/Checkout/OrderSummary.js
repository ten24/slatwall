import { useTranslation } from 'react-i18next'
import { useSelector } from 'react-redux'
import { useFormatCurrency } from '../../hooks/'

const OrderSummary = () => {
  const cart = useSelector(state => state.cart)
  const { total, taxTotal, subtotal, discountTotal, fulfillmentChargeAfterDiscountTotal } = cart

  const [formatCurrency] = useFormatCurrency({})
  const { t } = useTranslation()

  return (
    <>
      <div className="widget mb-3">
        <h2 className="widget-title text-center">{t('frontend.order.summary')}</h2>
      </div>
      <ul className="list-unstyled font-size-sm pb-2 border-bottom">
        <li className="d-flex justify-content-between align-items-center">
          <span className="mr-2">{t('frontend.order.subtotal')}:</span>
          <span className="text-right">{subtotal > 0 ? formatCurrency(subtotal) : '--'}</span>
        </li>
        <li className="d-flex justify-content-between align-items-center">
          <span className="mr-2">{t('frontend.order.shipping')}:</span>
          <span className="text-right">{fulfillmentChargeAfterDiscountTotal > 0 ? formatCurrency(fulfillmentChargeAfterDiscountTotal) : '--'}</span>
        </li>
        <li className="d-flex justify-content-between align-items-center">
          <span className="mr-2">{t('frontend.order.taxes')}:</span>
          <span className="text-right">{taxTotal > 0 ? formatCurrency(taxTotal) : '--'}</span>
        </li>
        <li className="d-flex justify-content-between align-items-center">
          <span className="mr-2">{t('frontend.order.discount')}:</span>
          <span className="text-right">{discountTotal > 0 ? formatCurrency(discountTotal) : '--'}</span>
        </li>
      </ul>
      <h3 className="font-weight-normal text-center my-4">
        <span>{total > 0 ? formatCurrency(total) : '--'}</span>
      </h3>
    </>
  )
}

export { OrderSummary }
