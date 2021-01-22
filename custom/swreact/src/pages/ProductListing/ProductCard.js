import { SWImage } from '../../components'
import { Link } from 'react-router-dom'

const ProductCard = ({ calculatedSalePrice, urlTitle, brand_brandName, brand_urlTitle, calculatedTitle, listPrice, defaultProductImageFiles, productClearance }) => {
  const imgUrl = defaultProductImageFiles.length > 0 ? defaultProductImageFiles[0].imageFile : ''
  const isSpecial = productClearance === true

  return (
    <div>
      <div className="card product-card">
        {isSpecial && <span className="badge badge-primary">On Special</span>}
        {/* <HeartButton isSaved={false} /> */}
        <Link className="card-img-top d-block overflow-hidden" to={`/sp/${urlTitle}`}>
          <SWImage src={imgUrl} alt="Product" />
        </Link>
        <div className="card-body py-2 text-left">
          <Link className="product-meta d-block font-size-xs pb-1" to={`/brand/${brand_urlTitle}`}>
            {brand_brandName}
          </Link>
          <h3 className="product-title font-size-sm">
            <Link to={`/sp/${urlTitle}`}>{calculatedTitle}</Link>
          </h3>
          <div className="d-flex justify-content-between">
            <div className="product-price">
              <span className="text-accent">${calculatedSalePrice.toFixed(2)}</span>
              {isSpecial && (
                <span style={{ marginLeft: '5px' }}>
                  <small>{`${listPrice} LIST`}</small>
                </span>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
//ProductCard.propTypes = {
//}
ProductCard.defaultProps = {
  calculatedProductRating: null,
  calculatedQATS: null,
  calculatedSalePrice: 0,
  productCode: '',
  productID: '',
  productName: 'Test',
  urlTitle: '',
  productClearance: false,
  brand_brandName: '',
  brand_urlTitle: '',
  calculatedTitle: '',
  listPrice: 0,
  defaultProductImageFiles: [],
}

export default ProductCard
