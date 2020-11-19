import React from 'react'
import { connect } from 'react-redux'

import {
  removeProductToCart,
  incrementCartQuantity,
  decrementCartQuantity,
} from '../../actions'

class CartLineItem extends React.Component {
  decriment = () => {
    this.props.dispatch(decrementCartQuantity(this.props.product.id))
  }
  removeFromCart = () => {
    this.props.dispatch(removeProductToCart(this.props.product.id))
  }
  increment = () => {
    this.props.dispatch(incrementCartQuantity(this.props.product.id))
  }
  render() {
    const { title, quantity } = this.props.product
    return (
      <div className="CartLineItem">
        <h1>Book name {title}</h1>
        <span>Quantity: {quantity}</span>
        <br></br>
        <button
          className="btn btn-outline-primary"
          type="input"
          onClick={this.increment}
        >
          Increment
        </button>
        <button
          className="btn btn-outline-primary"
          type="input"
          onClick={this.decriment}
        >
          Decriment
        </button>
        <button
          className="btn btn-outline-primary"
          type="input"
          onClick={this.removeFromCart}
        >
          removeFromCart
        </button>
      </div>
    )
  }
}
export default connect()(CartLineItem)
