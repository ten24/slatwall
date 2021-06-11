import { HeartButton, ProductPrice, SWImage } from '..'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useSelector } from 'react-redux'
import { getBrandRoute, getProductRoute } from '../../selectors'
import ProductImage from '../ProductImage/ProductImage'

const ProductCard = props => {
  const { productName, productCode, calculatedSalePrice, urlTitle, brand_brandName, brand_urlTitle, listPrice, imageFile, defaultSku_imageFile, productClearance, skuID = '' } = props
  const { t } = useTranslation()
  const brand = useSelector(getBrandRoute)
  const product = useSelector(getProductRoute)

  let productLink = `/${product}/${urlTitle}` + (skuID.length ? `?skuid=${skuID}` : '')
  return (
    <div className="card product-card pb-2 pt-3">
      {productClearance === true && <span className="badge badge-primary">{t('frontend.core.special')}</span>}
      <HeartButton skuID={skuID} />
      <Link className="card-img-top d-block overflow-hidden" to={productLink}>
        <ProductImage skuID={skuID} />
      </Link>
      <div className="card-body py-2 text-left">
        <Link className="product-meta d-block font-size-xs pb-1" to={`/${brand}/${brand_urlTitle}`}>
          {brand_brandName}
        </Link>
        <h3 className="font-size-sm text-muted mb-2">{productCode}</h3>
        <h3 className="product-title font-size-md">
          <Link to={productLink}>{productName}</Link>
        </h3>
        <div className="d-flex justify-content-between">
          <ProductPrice salePrice={calculatedSalePrice} listPrice={listPrice} />
        </div>
      </div>
    </div>
  )
}

export default ProductCard
