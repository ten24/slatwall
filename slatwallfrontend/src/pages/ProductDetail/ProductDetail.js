import React from "react"
import { connect } from "react-redux"
import { addProductToCart } from "../../actions"
import { withRouter } from "react-router"
import { Layout } from "../../components"

class ProductDetail extends React.Component {
  addToCart = () => {
    this.props.dispatch(addProductToCart(this.props.product))
  }
  render() {
    const { id, title, description } = this.props.product
    return (
      <Layout>
        <h1>Book name {title}</h1>
        <p>{description}</p>
        <button onClick={this.addToCart}>Add to Cart</button>
      </Layout>
    )
  }
}
const mapStateToProps = (state, props) => {
  const product = state.shop.products.find(
    product => product.id === +props.match.params.id
  )
  return {
    product,
  }
}

export default withRouter(connect(mapStateToProps, null)(ProductDetail))
