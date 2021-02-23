import { Layout } from '../../components'
import BrandBanner from './BrandBanner'
import ListingPage from '../../components/Listing/Listing'

const Brand = props => {
  const path = props.location.pathname.split('/').reverse()
  const brandFilter = {
    'brand.urlTitle:eq': path[0],
  }

  return (
    <Layout>
      <ListingPage preFilter={brandFilter}>
        <BrandBanner brandCode={path[0]} />
      </ListingPage>
    </Layout>
  )
}

export default Brand
