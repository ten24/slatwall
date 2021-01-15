import { FeaturedProductCard } from '../../components'
import { connect } from 'react-redux'

const ProductListingGrid = ({ products }) => {
  return (
    <div className="row mx-n2">
      {products &&
        products.map((product, index) => {
          return (
            <div key={index} className="col-md-4 col-sm-6 px-2 mb-4">
              <FeaturedProductCard {...product} />
            </div>
          )
        })}
    </div>
  )
}

function mapStateToProps(state) {
  const { productSearchReducer } = state
  return { ...productSearchReducer }
}

export default connect(mapStateToProps)(ProductListingGrid)
