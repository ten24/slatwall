import { Layout, Listing } from '../../components'

const Category = props => {
  const path = props.location.pathname.split('/').reverse()
  const filter = {
    category: path[0],
  }
  return (
    <Layout>
      <Listing preFilter={filter} hide={'category'} />
    </Layout>
  )
}

export default Category
