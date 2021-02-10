import ProductDetailGallery from './ProductDetailGallery'
import ProductPagePanels from './ProductPagePanels'
import React, { useEffect, useState } from 'react'
import { addToCart } from '../../actions/cartActions'
import { useDispatch } from 'react-redux'
import axios from 'axios'
import { sdkURL } from '../../services'
import { HeartButton } from '../../components'

const ProductPageContent = ({ productID, calculatedTitle, productClearance, productCode, productDescription, calculatedSalePrice, listPrice = 'MISSING' }) => {
  const dispatch = useDispatch()
  const [quantity, setQuantity] = useState(1)
  const [skus, setSksus] = useState({ list: [], isLoaded: false })
  const [sku, setSku] = useState({ skuID: '' })

  if (skus.list.length && !sku.skuID.length) {
    setSku(skus.list[0])
  }

  useEffect(() => {
    let didCancel = false
    if (!skus.isLoaded) {
      axios({
        method: 'POST',
        withCredentials: true, // default

        url: `${sdkURL}api/scope/getProductSkus`,
        data: {
          productID: productID,
        },
        headers: {
          'Content-Type': 'application/json',
        },
      }).then(response => {
        if (response.status === 200 && !didCancel) {
          setSksus({ list: response.data.skus, isLoaded: true })
        } else if (!didCancel) {
          setSksus({ ...skus, isLoaded: true })
        }
      })
    }

    return () => {
      didCancel = true
    }
  }, [setSksus, skus, productID])

  return (
    <div className="container bg-light box-shadow-lg rounded-lg px-4 py-3 mb-5">
      <div className="px-lg-3">
        <div className="row">
          <ProductDetailGallery productID={productID} />
          {/* <!-- Product details--> */}
          <div className="col-lg-6 pt-0">
            <div className="product-details pb-3">
              <div className="d-flex justify-content-between align-items-center mb-2">
                <span className="d-inline-block font-size-sm align-middle px-2 bg-primary text-light"> {productClearance === true && ' On Special'}</span>
                <HeartButton className={'btn-wishlist mr-0 mr-lg-n3'} />
              </div>
              <div className="mb-2">
                <span className="text-small text-muted">product: </span>
                <span className="h4 font-weight-normal text-large text-accent mr-1">{productCode}</span>
              </div>
              <h2 className="h4 mb-2">{calculatedTitle}</h2>
              <div
                className="mb-3 font-weight-light font-size-small text-muted"
                dangerouslySetInnerHTML={{
                  __html: productDescription,
                }}
              />
              <form
                className="mb-grid-gutter"
                onSubmit={event => {
                  event.preventDefault()
                  dispatch(addToCart(sku.skuID, quantity))
                }}
              >
                {skus.list.length > 1 && (
                  <div className="form-group">
                    <div className="d-flex justify-content-between align-items-center pb-1">
                      <label className="font-weight-medium" htmlFor="product-size">
                        Option
                      </label>
                    </div>

                    <select className="custom-select" required id="product-size">
                      {skus.list &&
                        skus.list.map(({ skuID, calculatedSkuDefinition }, index) => {
                          return (
                            <option key={index} value={skuID}>
                              {calculatedSkuDefinition}
                            </option>
                          )
                        })}
                    </select>
                  </div>
                )}

                <div className="mb-3">
                  <span className="h4 text-accent font-weight-light">{sku.price || ''}</span> <span className="font-size-sm ml-1">{`${sku.listPrice || ''} list`}</span>
                </div>
                <div className="form-group d-flex align-items-center">
                  <select
                    value={quantity}
                    onChange={event => {
                      setQuantity(event.target.value)
                    }}
                    className="custom-select mr-3"
                    style={{ width: '5rem' }}
                  >
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                  </select>
                  <button className="btn btn-primary btn-block" type="submit">
                    <i className="far fa-shopping-cart font-size-lg mr-2"></i>
                    Add to Cart
                  </button>
                </div>
                <div className="alert alert-danger" role="alert">
                  <i className="far fa-exclamation-circle"></i> This item is not eligable for free freight
                </div>
              </form>
              {/* <!-- Product panels--> */}
              <ProductPagePanels />
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default ProductPageContent
