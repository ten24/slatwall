import { Layout, Listing } from '../../components'

const Attribute = props => {
  const path = props.location.pathname.split('/').reverse()
  const filter = {
    attributeOptions: path[0],
  }
  return (
    <Layout>
      <Listing preFilter={filter} hide={'attributeOptions'} />
    </Layout>
  )
}

export default Attribute
