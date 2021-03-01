import { Layout } from '../../components'
import ListingPage from '../../components/Listing/Listing'
const ProductType = props => {
  const path = props.location.pathname.split('/').reverse()
  const filter = {
    productType: path[0],
  }
  return (
    <Layout>
      <ListingPage preFilter={filter} hide={'productType'} />
    </Layout>
  )
}

export default ProductType
