import React, { useEffect } from 'react'
import { FeaturedProductCard } from '../../components'
import { connect } from 'react-redux'
import { SlatwalApiService } from '../../services'

const ProductListingGrid = () => {
  let products = []
  useEffect(() => {
    SlatwalApiService.products
      .list('token', {
        perPage: 20,
        page: 1,
        filter: {
          urlTitle: 'h-money-money-h',
          productName: '',
        },
      })
      .then(function (response) {
        console.log(response)
      })
  }, [products, SlatwalApiService])

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
