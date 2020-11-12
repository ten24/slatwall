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
        <div className="layout">
          <div className="container">
            <div className="row">
              <div className="col-sm-4">
                <div>
                  <img
                    src="https://dummyimage.com/600x400/000/fff"
                    className="img-thumbnail"
                  />
                </div>
              </div>
              <div className="col-sm-8">
                <h1>Book name {title}</h1>
                <p>{description}</p>
                <button onClick={this.addToCart}>Add to Cart</button>
              </div>
            </div>
          </div>
        </div>
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
