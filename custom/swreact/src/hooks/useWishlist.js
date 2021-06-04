import { useSelector } from 'react-redux'

const useWishList = (skuID = '') => {
  const skusList = useSelector(state => state.userReducer.favouriteSkus.skusList)
  return [skusList.length && skuID.length ? skusList.includes(skuID) : false]
}
export default useWishList
