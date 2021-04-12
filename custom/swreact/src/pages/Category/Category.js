import { Layout } from '../../components'
import ListingPage from '../../components/Listing/Listing'

const Category = props => {
  const path = props.location.pathname.split('/').reverse()
  const filter = {
    category: path[0],
  }
  return (
    <Layout>
      <ListingPage preFilter={filter} hide={'category'} />
    </Layout>
  )
}

export default Category
