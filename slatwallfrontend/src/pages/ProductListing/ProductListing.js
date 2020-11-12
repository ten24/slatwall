import React from "react"
import { connect } from "react-redux"
import { AuthorFilter, Layout, Product } from "../../components"

const ProductListing = props => {
  return (
    <Layout>
      <div className="layout">
        <div className="container">
          <div className="row">
            <div className="col-sm-4">
              <AuthorFilter key="author" />
            </div>
            <div className="col-sm-8">
              <h1>Product Listing </h1>

              {props.products.map(product => {
                return <Product key={product.id} product={product} />
              })}
            </div>
          </div>
        </div>
      </div>
    </Layout>
  )
}
const mapStateToProps = state => {
  let filteredProducts = state.shop.products.filter(product =>
    state.filter.includes(product.author)
  )
  if (state.filter === "") filteredProducts = state.shop.products
  return { products: filteredProducts }
}

export default connect(mapStateToProps, null)(ProductListing)
