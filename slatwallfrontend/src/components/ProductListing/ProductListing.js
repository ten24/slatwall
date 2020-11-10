import React from "react"
import { connect } from "react-redux"
import { Product } from ".."

const ProductListing = props => {
  return (
    <div>
      {props.products.map(product => {
        return <Product key={product.id} product={product} />
      })}
      <h1>Product Listing </h1>
    </div>
  )
}
const mapStateToProps = state => {
  return { products: state.shop.products }
}

export default connect(mapStateToProps, null)(ProductListing)
