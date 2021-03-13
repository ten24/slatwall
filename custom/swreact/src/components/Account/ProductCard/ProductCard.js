import { HeartButton, SWImage } from '../..'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useSelector } from 'react-redux'
import useFormatCurrency from '../../../hooks/useFormatCurrency'

const ProductCard = props => {
  const { productName, calculatedSalePrice, urlTitle, brand_brandName, brand_urlTitle, listPrice, defaultProductImageFiles = [], productClearance, skuID = '' } = props
  const imgUrl = defaultProductImageFiles.length > 0 ? defaultProductImageFiles[0].imageFile : ''
  const { t, i18n } = useTranslation()
  const routing = useSelector(state => state.configuration.router)
  const [formatCurrency] = useFormatCurrency({})

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
    <div>
      <div className="card product-card">
        {productClearance === true && <span className="badge badge-primary">{t('frontend.core.special')}</span>}
        <HeartButton isSaved={false} />
        <Link className="card-img-top d-block overflow-hidden" to={`/${product[0]}/${urlTitle}?skuid=${skuID}`}>
          <SWImage src={imgUrl} alt="Product" />
        </Link>
        <div className="card-body py-2 text-left">
          <Link className="product-meta d-block font-size-xs pb-1" to={`/${brand[0]}/${brand_urlTitle}`}>
            {brand_brandName}
          </Link>
          <h3 className="product-title font-size-sm">
            <Link to={`/${product[0]}/${urlTitle}?skuid=${skuID}`}>{productName}</Link>
          </h3>
          <div className="d-flex justify-content-between">
            <div className="product-price">
              {calculatedSalePrice > 0 && <span className="text-accent">{formatCurrency(calculatedSalePrice)}</span>}
              <span style={{ marginLeft: '5px' }}>
                <small>{`${formatCurrency(listPrice)} LIST`}</small>
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default ProductCard
