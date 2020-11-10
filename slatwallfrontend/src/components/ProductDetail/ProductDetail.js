import React from "react"
import { connect } from "react-redux"
import { addProductToCart } from "../../actions"
import { withRouter } from "react-router"

class ProductDetail extends React.Component {
  addToCart = () => {
    this.props.dispatch(addProductToCart(this.props.product))
  }
  render() {
    const { id, title, description } = this.props.product
    return (
      <div>
        <h1>Book name {title}</h1>
        <p>{description}</p>
        <button onClick={this.addToCart}>Add to Cart</button>
      </div>
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
