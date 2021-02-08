import { SWImage } from '../..'

const OrderItem = ({ Quantity, ProductTitle, BrandName, isSeries, ProductSeries, totalPrice, listPrice, price, skuCode, imgUrl }) => {
  return (
    <div className="d-sm-flex justify-content-between align-items-center my-4 pb-3 border-bottom">
      <div className="media media-ie-fix d-block d-sm-flex align-items-center text-center text-sm-left">
        <a className="d-inline-block mx-auto mr-sm-4" style={{ width: '10rem' }}>
          <SWImage src={imgUrl} alt="Product" />
        </a>
        <div className="media-body pt-2">
          {isSeries && <span className="product-meta d-block font-size-xs pb-1">{ProductSeries}</span>}
          {/* <!--- only show this span if part of a bundled product? ---> */}
          <h3 className="product-title font-size-base mb-2">
            <a href="shop-single-v1.html">{ProductTitle}</a>
          </h3>
          {/* <!--- product title ---> */}
          <div className="font-size-sm">
            {BrandName} <span className="text-muted mr-2">{skuCode}</span>
          </div>
          {/* <!--- brand / sku ---> */}
          <div className="font-size-sm">
            {`$${price} each `}
            <span className="text-muted mr-2">{`($${listPrice} list)`}</span>
          </div>
          {/* <!--- each / list price ---> */}
          <div className="font-size-lg text-accent pt-2">{`$${totalPrice}`}</div>
          {/* <!--- total ---> */}
        </div>
      </div>
      <div className="pt-2 pt-sm-0 pl-sm-3 mx-auto mx-sm-0 text-center text-sm-left" style={{ width: '9rem' }}>
        <div className="form-group mb-0">
          <label className="font-weight-medium">Quantity</label>
          <span>{Quantity}</span>
        </div>
        <a href="#" className="btn btn-outline-secondary">
          Re-order
        </a>
      </div>
    </div>
  )
}

const OrderShipments = ({ shipments }) => {
  return (
    <div className="order-items mr-3">
      {shipments &&
        shipments.map((shipment, index) => {
          return (
            <div className="shippment mb-5">
              <div className="row order-tracking bg-lightgray p-2">
                <div className="col-sm-6">{`Shippment ${index + 1} of ${shipments.length}`}</div>
                <div className="col-sm-6 text-right">
                  {'Tracking Number: '}
                  <a href="#" target="_blank">
                    {shipment.trackingNumber}
                  </a>
                </div>
              </div>
              {shipment.items &&
                shipment.items.map((item, index) => {
                  return <OrderItem key={index} item={item} />
                })}
            </div>
          )
        })}
    </div>
  )
}

export default OrderShipments
