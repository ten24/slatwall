import { SWImage } from '../index'
import PropTypes from 'prop-types'
import { Link } from 'react-router-dom'

const HeartButton = ({ isSaved }) => {
  if (isSaved) {
    return (
      <button className="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
        <i className="far fa-heart" style={{ color: '#5f1018' }}></i>
      </button>
    )
  } else {
    return (
      <button className="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
        <i className="far fa-heart"></i>
      </button>
    )
  }
}

const FeaturedProductCard = ({  productClearance, brand_brandName,brand_urlTitle ='', calculatedTitle, calculatedSalePrice, listPrice,  urlTitle, defaultProductImageFiles }) => {
  const imgUrl = (defaultProductImageFiles && defaultProductImageFiles.length > 0) ? defaultProductImageFiles[0].imageFile : ''
  const isSpecial = productClearance === true
  return (
    <div>
      <div className="card product-card">
        {isSpecial && <span className="badge badge-primary">On Special</span>}
        <HeartButton isSaved={false} />
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
FeaturedProductCard.propTypes = {
  isSpecial: PropTypes.bool,
  brand: PropTypes.string,
  imgUrl: PropTypes.string,
  productTile: PropTypes.string,
  price: PropTypes.string,
  displayPrice: PropTypes.string,
  linkUrl: PropTypes.string,
}

export default FeaturedProductCard
