import { Layout } from '../../components'
import { Helmet } from 'react-helmet'
import { useLocation } from 'react-router-dom'

import ListingPage from '../../components/Listing/Listing'

const ProductListing = () => {
  const loc = useLocation()

  return (
    <Layout>
      <Helmet title={"Search - " + new URLSearchParams(loc.search).get('keyword')} />
      <ListingPage />
    </Layout>
  )
}

export default ProductListing
