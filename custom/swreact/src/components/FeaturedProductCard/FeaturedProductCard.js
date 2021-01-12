import { SWImage } from '../index'
import PropTypes from 'prop-types'

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

const FeaturedProductCard = ({ isSpecial, brand, productTile, price, displayPrice, linkUrl, imgUrl }) => {
  return (
    <div>
      <div className="card product-card">
        {isSpecial && <span className="badge badge-primary">On Special</span>}
        <HeartButton isSaved={false} />
        <a className="card-img-top d-block overflow-hidden" href={linkUrl}>
          <SWImage src={imgUrl} alt="Product" />
        </a>
        <div className="card-body py-2 text-left">
          <a className="product-meta d-block font-size-xs pb-1" href="#">
            {brand}
          </a>
          <h3 className="product-title font-size-sm">
            <a href={linkUrl}>{productTile}</a>
          </h3>
          <div className="d-flex justify-content-between">
            <div className="product-price">
              <span className="text-accent">{displayPrice}</span>
              <span className="">{price}</span>
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
