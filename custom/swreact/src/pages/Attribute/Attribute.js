import { Layout } from '../../components'
import ListingPage from '../../components/Listing/Listing'

const Attribute = props => {
  const path = props.location.pathname.split('/').reverse()
  const filter = {
    attributeOptions: path[0],
  }
  return (
    <Layout>
      <ListingPage preFilter={filter} hide={'attributeOptions'} />
    </Layout>
  )
}

export default Attribute
