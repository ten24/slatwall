import { HeartButton, ProductPrice, SWImage } from '..'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useSelector } from 'react-redux'
import { getBrandRoute, getProductRoute } from '../../selectors/configurationSelectors'

const ProductCard = props => {
  const { productName, calculatedSalePrice, urlTitle, brand_brandName, brand_urlTitle, listPrice, defaultProductImageFiles = [], productClearance, skuID = '' } = props
  const imgUrl = defaultProductImageFiles.length > 0 ? defaultProductImageFiles[0].imageFile : ''
  const { t } = useTranslation()
  const brand = useSelector(getBrandRoute)
  const product = useSelector(getProductRoute)

  return (
    <div>
      <div className="card product-card">
        {productClearance === true && <span className="badge badge-primary">{t('frontend.core.special')}</span>}
        <HeartButton skuID={skuID} />
        <Link className="card-img-top d-block overflow-hidden" to={`/${product}/${urlTitle}?skuid=${skuID}`}>
          <SWImage src={imgUrl} alt="Product" />
        </Link>
        <div className="card-body py-2 text-left">
          <Link className="product-meta d-block font-size-xs pb-1" to={`/${brand}/${brand_urlTitle}`}>
            {brand_brandName}
          </Link>
          <h3 className="product-title font-size-sm">
            <Link to={`/${product}/${urlTitle}?skuid=${skuID}`}>{productName}</Link>
          </h3>
          <div className="d-flex justify-content-between">
            <ProductPrice salePrice={calculatedSalePrice} listPrice={listPrice} />
          </div>
        </div>
      </div>
    </div>
  )
}

export default ProductCard
