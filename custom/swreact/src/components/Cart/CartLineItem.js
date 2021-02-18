import { SWImage } from '../../components'
import { useDispatch, useSelector } from 'react-redux'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { updateItemQuantity, removeItem } from '../../actions/cartActions'
import { useDebouncedCallback } from 'use-debounce'
import useFormatCurrency from '../../hooks/useFormatCurrency'

const CartLineItem = ({ orderItemID }) => {
  const { isFetching, orderItems } = useSelector(state => state.cart)
  const dispatch = useDispatch()
  const [formatCurrency] = useFormatCurrency({})
  const { t, i18n } = useTranslation()
  const debounced = useDebouncedCallback(value => {
    dispatch(updateItemQuantity(skuID, value))
  }, 1000)
  const orderItem = orderItems.filter(orderItem => {
    return orderItem.orderItemID === orderItemID
  })
  const { price, quantity, sku, extendedPriceAfterDiscount, currencyCode } = orderItem[0]
  const { skuID, listPrice, imagePath, skuCode, product } = sku
  const { productName, urlTitle, brand } = product
  const { brandName } = brand

  const isBackordered = false
  const routing = useSelector(state => state.configuration.router)
  const productRouting = routing
    .map(route => {
      return route.URLKeyType === 'Product' ? route.URLKey : null
    })
    .filter(item => item)
  return (
    <div className="d-sm-flex justify-content-between align-items-center my-4 pb-3 border-bottom">
      <div className="media media-ie-fix d-block d-sm-flex align-items-center text-center text-sm-left">
        <Link className="d-inline-block mx-auto mr-sm-4" to={urlTitle} style={{ width: '10rem' }}>
          <SWImage customPath={imagePath} alt="Product" />
        </Link>
        <div className="media-body pt-2">
          <span className="product-meta d-block font-size-xs pb-1">{t('frontend.product.series')}</span>
          <h3 className="product-title font-size-base mb-2">
            <Link
              to={{
                pathname: `/${productRouting[0]}/${urlTitle}`,
                state: { ...product },
              }}
            >
              {productName}
            </Link>
          </h3>
          <div className="font-size-sm">
            {`${brandName} `}
            <span className="text-muted mr-2">{skuCode}</span>
          </div>
          <div className="font-size-sm">
            {`${formatCurrency(price)} ${t('frontend.core.each')} `}
            <span className="text-muted mr-2">{`(${formatCurrency(listPrice)} ${t('frontend.core.list')})`}</span>
          </div>
          <div className="font-size-lg text-accent pt-2">{formatCurrency(extendedPriceAfterDiscount)}</div>
        </div>
      </div>
      {isBackordered && (
        <div className="p-2 border rounded mx-auto mx-sm-0 text-center" style={{ maxWidth: '15rem' }}>
          <i className="fal fa-exclamation-circle"></i>
          <p className="text-sm mb-0">{t('frontend.order.backorder')}</p>
        </div>
      )}
      <div className="pt-2 pt-sm-0 pl-sm-3 mx-auto mx-sm-0 text-center text-sm-left" style={{ maxWidth: '9rem' }}>
        <div className="form-group mb-0">
          <label className="font-weight-medium" htmlFor="quantity4">
            {t('frontend.core.quantity')}
          </label>
          <input
            className="form-control"
            type="number"
            id="quantity4"
            defaultValue={quantity}
            disabled={isFetching}
            onChange={e => {
              debounced.callback(e.target.value)
            }}
          />
        </div>
        <button
          className="btn btn-link px-0 text-danger"
          type="button"
          disabled={isFetching}
          onClick={event => {
            event.preventDefault()
            dispatch(removeItem(orderItemID))
          }}
        >
          <i className="fal fa-times-circle"></i>
          <span className="font-size-sm">{t('frontend.core.remove')}</span>
        </button>
      </div>
    </div>
  )
}
export default CartLineItem
