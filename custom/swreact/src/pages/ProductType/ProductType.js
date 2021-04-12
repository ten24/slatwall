import { Layout } from '../../components'
import ListingPage from '../../components/Listing/Listing'
//TODO: Add a ProductType Banner that will query for PT. This is a temporary hack
const ProductType = props => {
  const path = props.location.pathname.split('/').reverse()
  const filter = {
    productType: path[0],
  }
  return (
    <Layout>
      <ListingPage preFilter={filter} hide={'productType'}>
        <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
          <h1 className="h3 text-dark mb-0 font-accent">{decodeURIComponent(path[0])}</h1>
        </div>
      </ListingPage>
    </Layout>
  )
}

export default ProductType
