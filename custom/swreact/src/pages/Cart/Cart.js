import { BreadCrumb, Layout, SWImage } from '../../components'
import { useDispatch, useSelector } from 'react-redux'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useHistory } from 'react-router-dom'
import { updateItemQuantity, removeItem, applyPromoCode, removePromoCode, getCart } from '../../actions/cartActions'
import { useDebouncedCallback } from 'use-debounce'
import { useEffect, useState } from 'react'

const PageHeader = ({ title = 'Page Title' }) => {
  return (
    <div className="page-title-overlap bg-lightgray pt-4">
      <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <BreadCrumb />
        </div>
        <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 className="h3 text-dark mb-0 font-accent">{title}</h1>
        </div>
      </div>
    </div>
  )
}

const CartLineItem = ({ orderItemID }) => {
  const { isFetching, orderItems, orderFulfillments } = useSelector(state => state.cart)
  const dispatch = useDispatch()
  const debounced = useDebouncedCallback(value => {
    dispatch(updateItemQuantity(skuID, fulfillmentMethodID, value))
  }, 1000)
  const orderItem = orderItems.filter(orderItem => {
    return orderItem.orderItemID === orderItemID
  })
  const { price, quantity, sku, extendedPriceAfterDiscount, currencyCode, orderFulfillment } = orderItem[0]
  const { skuID, listPrice, imagePath, skuCode, product } = sku
  const { productName, urlTitle, brand } = product
  const { brandName } = brand
  const fulfillmentMethodID = orderFulfillments
    .filter(fulfillments => {
      return fulfillments.orderFulfillmentID === orderFulfillment.orderFulfillmentID
    })
    .reduce((acc, orderFulfillment) => orderFulfillment.fulfillmentMethod.fulfillmentMethodID, '')

  const isBackordered = false
  const routing = useSelector(state => state.configuration.router)
  const productRouting = routing
    .map(route => {
      return route.URLKeyType === 'Product' ? route.URLKey : null
    })
    .filter(item => item)
  return (
    <div className="d-sm-flex justify-content-between align-items-center my-4 pb-3 border-bottom">
      <div className="media media-ie-fix d-block d-sm-flex align-items-center text-center text-sm-left">
        <Link className="d-inline-block mx-auto mr-sm-4" to={urlTitle} style={{ width: '10rem' }}>
          <SWImage customPath={imagePath} alt="Product" />
        </Link>
        <div className="media-body pt-2">
          <span className="product-meta d-block font-size-xs pb-1">Product Series</span>
          <h3 className="product-title font-size-base mb-2">
            <Link
              to={{
                pathname: `/${productRouting[0]}/${urlTitle}`,
                state: { ...product },
              }}
            >
              {productName}
            </Link>
          </h3>
          <div className="font-size-sm">
            {`${brandName} `}
            <span className="text-muted mr-2">{skuCode}</span>
          </div>
          <div className="font-size-sm">
            {`$${price} each `}
            <span className="text-muted mr-2">{`($${listPrice} list)`}</span>
          </div>
          <div className="font-size-lg text-accent pt-2">{`$${extendedPriceAfterDiscount}`}</div>
        </div>
      </div>
      {isBackordered && (
        <div className="p-2 border rounded mx-auto mx-sm-0 text-center" style={{ maxWidth: '15rem' }}>
          <i className="fal fa-exclamation-circle"></i>
          <p className="text-sm mb-0">This item is on backorder.</p>
        </div>
      )}
      <div className="pt-2 pt-sm-0 pl-sm-3 mx-auto mx-sm-0 text-center text-sm-left" style={{ maxWidth: '9rem' }}>
        <div className="form-group mb-0">
          <label className="font-weight-medium" htmlFor="quantity4">
            Quantity
          </label>
          <input
            className="form-control"
            type="number"
            id="quantity4"
            defaultValue={quantity}
            disabled={isFetching}
            onChange={e => {
              debounced.callback(e.target.value)
            }}
          />
        </div>
        <button
          className="btn btn-link px-0 text-danger"
          type="button"
          disabled={isFetching}
          onClick={event => {
            event.preventDefault()
            dispatch(removeItem(orderItemID))
          }}
        >
          <i className="fal fa-times-circle"></i>
          <span className="font-size-sm"> Remove</span>
        </button>
      </div>
    </div>
  )
}

const CartPromoBox = () => {
  const { isFetching } = useSelector(state => state.cart.isFetching)
  const promotionCodes = useSelector(state => state.cart.promotionCodes)
  const dispatch = useDispatch()
  const [promoCode, setPromoCode] = useState('')

  return (
    <div className="accordion" id="order-options">
      <div className="card">
        <div className="card-header">
          <h3 className="accordion-heading">
            <a href="#promo-code" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="promo-code">
              Apply promo code
            </a>
          </h3>
        </div>
        <div className="collapse show" id="promo-code" data-parent="#order-options">
          <form className="card-body needs-validation" method="post" noValidate="">
            <div className="form-group">
              <input className="form-control" type="text" placeholder="Promo code" value={promoCode} required onChange={e => setPromoCode(e.target.value)} />
              <div className="invalid-feedback">Please provide promo code.</div>
            </div>
            <button
              className="btn btn-outline-primary btn-block"
              type="submit"
              disabled={isFetching}
              onClick={e => {
                e.preventDefault()
                dispatch(applyPromoCode(promoCode))
                setPromoCode('')
              }}
            >
              Apply promo code
            </button>
            {promotionCodes.length > 0 &&
              promotionCodes.map(promotionCodeItem => {
                const { promotionCode, promotion } = promotionCodeItem
                const { promotionName } = promotion
                return (
                  <button
                    className="btn btn-link px-0 text-danger"
                    type="button"
                    key={promotionCode}
                    disabled={isFetching}
                    onClick={event => {
                      event.preventDefault()
                      dispatch(removePromoCode(promotionCode))
                    }}
                  >
                    <i className="fal fa-times-circle"></i>
                    <span className="font-size-sm"> {promotionName}</span>
                  </button>
                )
              })}
          </form>
        </div>
      </div>
    </div>
  )
}

const OrderNotes = () => {
  const isFetching = useSelector(state => state.cart.isFetching)
  let history = useHistory()

  return (
    <>
      <div className="form-group mb-4 mt-3">
        <label className="mb-2" htmlFor="order-comments">
          <span className="font-weight-medium">Order Notes</span>
        </label>
        <textarea className="form-control" rows="6" id="order-comments"></textarea>
      </div>
      <button
        className="btn btn-primary btn-block mt-4"
        disabled={isFetching}
        onClick={e => {
          e.preventDefault()
          history.push('checkout')
        }}
      >
        Proceed to Checkout
      </button>
    </>
  )
}

const Cart = () => {
  const { t, i18n } = useTranslation()

  const dispatch = useDispatch()
  const cart = useSelector(state => state.cart)
  let history = useHistory()
  const { subtotal, isFetching } = cart

  useEffect(() => {
    dispatch(getCart())
  }, [dispatch])
  return (
    <Layout>
      <PageHeader title="Your cart" />
      <div className="container pb-5 mb-2 mb-md-4">
        <div className="row">
          <section className="col-lg-8">
            <div className="d-flex justify-content-between align-items-center pt-3 pb-2 pb-sm-5 mt-1">
              <h2 className="h6 mb-0">Products</h2>
              <button
                className="btn btn-outline-primary btn-sm pl-2"
                disabled={isFetching}
                onClick={e => {
                  e.preventDefault()
                  history.goBack()
                }}
              >
                <i className="far fa-chevron-left"></i> Continue shopping
              </button>
            </div>
            {cart.orderItems &&
              cart.orderItems.map(({ orderItemID }) => {
                return <CartLineItem key={orderItemID} orderItemID={orderItemID} /> // this cannot be index or it wont force a rerender
              })}
          </section>

          <aside className="col-lg-4 pt-4 pt-lg-0">
            <div className="cz-sidebar-static rounded-lg box-shadow-lg ml-lg-auto">
              <div className="text-center mb-4 pb-3 border-bottom">
                <h2 className="h6 mb-3 pb-1">Subtotal</h2>
                <h3 className="font-weight-normal">{`$${subtotal}`}</h3>
              </div>

              <CartPromoBox />

              <OrderNotes />
            </div>
          </aside>
        </div>
      </div>
    </Layout>
  )
}

export default Cart
