import { useTranslation } from 'react-i18next'
import { useDispatch, useSelector } from 'react-redux'
import { Link } from 'react-router-dom'
import { SWImage } from '../..'
import { addToCart } from '../../../actions/cartActions'
import useFormatCurrency from '../../../hooks/useFormatCurrency'

const OrderItem = ({ quantity, sku_skuID, sku_product_productName, sku_product_urlTitle, BrandName, isSeries, ProductSeries, calculatedExtendedPriceAfterDiscount, sku_calculatedSkuDefinition, sku_imageFile, price }) => {
  const [formatCurrency] = useFormatCurrency({})
  const routing = useSelector(state => state.configuration.router)
  const dispatch = useDispatch()
  const { t, i18n } = useTranslation()

  const product = routing
    .map(route => {
      return route.URLKeyType === 'Product' ? route.URLKey : null
    })
    .filter(item => {
      return item
    })
  const brand = routing
    .map(route => {
      return route.URLKeyType === 'Brand' ? route.URLKey : null
    })
    .filter(item => {
      return item
    })

  return (
    <div className="d-sm-flex justify-content-between align-items-center my-4 pb-3 border-bottom">
      <div className="media media-ie-fix d-block d-sm-flex align-items-center text-center text-sm-left">
        <Link to={`/${product[0]}/${sku_product_urlTitle}?skuid=${sku_skuID}`} className="d-inline-block mx-auto mr-sm-4" style={{ width: '10rem' }}>
          <SWImage src={sku_imageFile} alt="Product" />
        </Link>
        <div className="media-body pt-2">
          {isSeries && <span className="product-meta d-block font-size-xs pb-1">{ProductSeries}</span>}
          {/* <!--- only show this span if part of a bundled product? ---> */}
          <h3 className="product-title font-size-base mb-2">
            <Link to={`/${product[0]}/${sku_product_urlTitle}?skuid=${sku_skuID}`}>{sku_product_productName}</Link>
          </h3>
          {/* <!--- product title ---> */}
          <div className="font-size-sm">
            {BrandName} <span className="text-muted mr-2">{sku_calculatedSkuDefinition}</span>
          </div>
          {/* <!--- brand / sku ---> */}
          <div className="font-size-sm">
            {`${formatCurrency(price)} ${t('frontend.core.each')} `}

            {/* <span className="text-muted mr-2">{`($${listPrice} list)`}</span> */}
          </div>
          {/* <!--- each / list price ---> */}
          <div className="font-size-lg text-accent pt-2">{formatCurrency(calculatedExtendedPriceAfterDiscount)}</div>
          {/* <!--- total ---> */}
        </div>
      </div>
      <div className="pt-2 pt-sm-0 pl-sm-3 mx-auto mx-sm-0 text-center text-sm-left" style={{ width: '9rem' }}>
        <div className="form-group mb-0">
          <label className="font-weight-medium">{t('frontend.core.quantity')}: </label>
          <span>{quantity}</span>
        </div>
        <button
          onClick={event => {
            event.preventDefault()
            dispatch(addToCart(sku_skuID, quantity))
            window.scrollTo({
              top: 0,
              behavior: 'smooth',
            })
          }}
          className="btn btn-outline-secondary"
        >
          Re-order
        </button>
      </div>
    </div>
  )
}

const OrderShipments = ({ shipments }) => {
  return (
    <div className="order-items mr-3">
      {shipments &&
        shipments.map((shipment, index) => {
          return (
            <div className="shippment mb-5" key={index}>
              <div className="row order-tracking bg-lightgray p-2">
                <div className="col-sm-6">{`Shippment ${index + 1} of ${shipments.length}`}</div>
                {shipment.trackingNumber && (
                  <div className="col-sm-6 text-right">
                    {'Tracking Number: '}
                    <a href="#" target="_blank">
                      {shipment.trackingNumber}
                    </a>
                  </div>
                )}
              </div>
              {shipment.orderItems &&
                shipment.orderItems.map((item, index) => {
                  return <OrderItem key={index} {...item} />
                })}
            </div>
          )
        })}
    </div>
  )
}

export default OrderShipments
