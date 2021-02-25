import { Layout } from '../../components'
import BrandBanner from './BrandBanner'
import ListingPage from '../../components/Listing/Listing'

const Brand = props => {
  const path = props.location.pathname.split('/').reverse()
  const brandFilter = {
    brands: path[0],
  }

  return (
    <Layout>
      <ListingPage preFilter={brandFilter} hide={'brands'}>
        <BrandBanner brandCode={path[0]} />
      </ListingPage>
    </Layout>
  )
}

export default Brand
