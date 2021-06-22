import ProductDetail from '../ProductDetail/ProductDetail'
import { useLocation } from 'react-router-dom'

const Product = () => {
  let loc = useLocation()

  return <ProductDetail forwardState={loc} />
}

export default Product
