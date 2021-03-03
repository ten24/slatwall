import { useSelector } from 'react-redux'
import { CartLineItem } from '../../components'

const ReviewSlide = () => {
  const cart = useSelector(state => state.cart)
  return (
    <>
      <div className="row bg-lightgray pt-3 pr-3 pl-3 rounded mb-5">
        <div className="col-md-4">
          <h3 className="h6">Shipping Address:</h3>
          <p>
            <em>Address Nickname</em>
            <br />
            Name <br />
            Street Address <br />
            City, State Zip
          </p>
        </div>
        <div className="col-md-4">
          <h3 className="h6">Billing Address:</h3>
          <p>
            <em>Address Nickname</em>
            <br />
            Name <br />
            Street Address <br />
            City, State Zip
          </p>
        </div>
        <div className="col-md-4">
          <h3 className="h6">Payment Method:</h3>
          <p>
            <em>method of payment</em>
            <br />
            Name <br />
            Vias ending in x1234
          </p>
        </div>
      </div>

      {/* <!-- Order Items --> */}
      <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Review your order</h2>
      {cart.orderItems &&
        cart.orderItems.map(({ orderItemID }) => {
          return <CartLineItem key={orderItemID} orderItemID={orderItemID} isDisabled={true} /> // this cannot be index or it wont force a rerender
        })}
    </>
  )
}

export default ReviewSlide
