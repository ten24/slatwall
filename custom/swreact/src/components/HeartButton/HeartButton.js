import { useDispatch, useSelector } from 'react-redux'
import { addWishlistItem, removeWishlistItem } from '../../actions/userActions'
import useWishList from '../../hooks/useWishlist'

const HeartButton = ({ skuID, className = 'btn-wishlist btn-sm' }) => {
  const dispatch = useDispatch()
  const [isOnWishlist] = useWishList(skuID)
  const primaryColor = useSelector(state => state.configuration.theme.primaryColor)

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
        data-original-title="Remove from wishlist"
      >
        <i className="fas fa-heart" style={{ color: `#${primaryColor}` }}></i>
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
