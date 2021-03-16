import { useDispatch } from 'react-redux'
import { addWishlistItem, removeWishlistItem } from '../../actions/userActions'
import useWishList from '../../hooks/useWishlist'

const HeartButton = ({ skuID, className = 'btn-wishlist btn-sm' }) => {
  const dispatch = useDispatch()
  const [isOnWishlist] = useWishList(skuID)
  if (isOnWishlist) {
    return (
      <button
        className={className}
        onClick={e => {
          e.preventDefault()
          dispatch(removeWishlistItem(skuID))
        }}
        type="button"
        data-toggle="tooltip"
        data-placement="left"
        title=""
        data-original-title="Add to wishlist"
      >
        <i className="far fa-heart" style={{ color: '#5f1018' }}></i>
      </button>
    )
  } else {
    return (
      <button
        onClick={e => {
          e.preventDefault()
          dispatch(addWishlistItem(skuID))
        }}
        className={className}
        type="button"
        data-toggle="tooltip"
        data-placement="left"
        title=""
        data-original-title="Add to wishlist"
      >
        <i className="far fa-heart"></i>
      </button>
    )
  }
}
export default HeartButton
