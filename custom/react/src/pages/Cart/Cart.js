import React from 'react'
import { connect } from 'react-redux'
import { CartLineItem, Layout } from '../../components'

class Cart extends React.Component {
  render() {
    return (
      <Layout>
        <div className="Cart">
          {this.props.cart.map((lineItem, index) => {
            return <CartLineItem key={index} product={lineItem} />
          })}
        </div>
      </Layout>
    )
  }
}
const mapStateToProps = state => {
  return { cart: state.shop.cart }
}

export default connect(mapStateToProps, null)(Cart)
