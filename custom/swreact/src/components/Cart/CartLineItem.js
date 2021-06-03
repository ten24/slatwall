import { ProductPrice } from '../../components'
import { useDispatch, useSelector } from 'react-redux'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { updateItemQuantity, removeItem } from '../../actions/cartActions'
import useFormatCurrency from '../../hooks/useFormatCurrency'
import { getProductRoute } from '../../selectors/configurationSelectors'
import ProductImage from '../ProductImage/ProductImage'

const CartLineItem = ({ orderItemID, isDisabled = false }) => {
  const { isFetching, orderItems } = useSelector(state => state.cart)
  const dispatch = useDispatch()
  const [formatCurrency] = useFormatCurrency({})
  const productRouting = useSelector(getProductRoute)
  const { t } = useTranslation()

  const orderItem = orderItems.filter(orderItem => {
    return orderItem.orderItemID === orderItemID
  })
  const { price, quantity, sku, extendedPriceAfterDiscount } = orderItem[0]
  const { skuID, listPrice, skuCode, product } = sku
  const { productID, productName, urlTitle, brand, productSeries } = product
  const { brandName } = brand

  const isBackordered = false

  return (
    <div className="d-sm-flex justify-content-between align-items-top my-4 py-3 border-bottom">
      
      <Link className="d-inline-block mr-sm-4" to={urlTitle} style={{ width: '10rem' }}>
        <ProductImage productID={productID} skuID={skuID} />
        {/* <SWImage customPath={imagePath} alt="Product" /> */}
      </Link>
      
      <div className="d-sm-flex flex-row flex-wrap w-100">
        <div className="d-flex justify-content-between align-items-center w-100">
        
          <div className="media media-ie-fix d-block d-sm-flex">
            <div className="media-body pt-2 pt-sm-0">
              <span className="product-meta d-block font-size-xs pb-1">{productSeries || t('frontend.product.series')}</span>
              <h3 className="product-title font-size-base mb-2">
                <Link
                  to={{
                    pathname: `/${productRouting}/${urlTitle}`,
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
              {price != listPrice && <ProductPrice salePrice={price} listPrice={listPrice} salePriceSuffixKey="frontend.core.each" accentSalePrice={false} />}
              <div className="font-size-lg text-accent pt-2">{formatCurrency(extendedPriceAfterDiscount)}</div>
            </div>
          </div>
        
          <div className="pt-2 pt-sm-0 pl-sm-3 mx-0" style={{ maxWidth: '8rem' }}>
            {isDisabled && (
              <div className="form-group mb-0">
                <div className="pt-2 pt-sm-0 pl-sm-3 mx-auto mx-sm-0 text-center text-sm-right" style={{ maxWidth: '9rem' }}>
                  <p className="mb-0">
                    <span className="text-muted font-size-sm"> {t('frontend.core.quantity')}:</span>
                    <span>{quantity}</span>
                  </p>
                </div>
              </div>
            )}
            {!isDisabled && (
              <>
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
                      dispatch(updateItemQuantity(skuID, e.target.value))
                    }}
                  />
                </div>
                <button
                  className="btn btn-link px-0 text-primary"
                  type="button"
                  disabled={isFetching}
                  onClick={event => {
                    event.preventDefault()
                    dispatch(removeItem(orderItemID))
                  }}
                >
                  <i className="fal fa-times-circle mr-1"></i>
                  <span className="font-size-sm">{t('frontend.core.remove')}</span>
                </button>
              </>
            )}
          </div>
          
        </div>
        
        {isBackordered && (
          <div className="p-2 border rounded w-100 d-flex mt-2 align-items-center">
            <i className="fal fa-exclamation-circle mr-2"></i>
            <p className="text-sm mb-0">{t('frontend.order.backorder')}</p>
          </div>
        )}
        
      </div>
      
    </div>
  )
}
export default CartLineItem