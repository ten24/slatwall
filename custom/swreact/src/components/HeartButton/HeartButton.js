import { useDispatch, useSelector } from 'react-redux'
import { addSkuToWishList, removeWishlistItem } from '../../actions/userActions'
import { getDefaultWishlist, getItemsForDefaultWishList } from '../../selectors/userSelectors'
import { isAuthenticated } from '../../utils'

const HeartButton = ({ skuID, className = 'btn-wishlist btn-sm' }) => {
  const dispatch = useDispatch()
  const primaryColor = useSelector(state => state.configuration.theme.primaryColor)
  const defaultWishlist = useSelector(getDefaultWishlist)
  const items = useSelector(getItemsForDefaultWishList)

  if (!isAuthenticated()) {
    return null
  }

  if (items.includes(skuID)) {
    return (
      <button
        className={className}
        onClick={e => {
          e.preventDefault()
          dispatch(removeWishlistItem(skuID, defaultWishlist?.value))
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
          dispatch(addSkuToWishList(skuID, defaultWishlist?.value))
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
