import { useState } from 'react'
import { addToCart } from '../../actions/'
import { useDispatch, useSelector } from 'react-redux'
import { ProductDetailGallery, ProductPagePanels, SkuOptions, Button, HeartButton, ProductPrice } from '..'
import { useTranslation } from 'react-i18next'

const ProductPageContent = ({ product, attributeSets, skuID, sku, productOptions = [], availableSkuOptions = '', isFetching = false }) => {
  const dispatch = useDispatch()
  const { t } = useTranslation()
  const cart = useSelector(state => state.cart)
  const [quantity, setQuantity] = useState(1)

  return (
    <div className="container bg-light box-shadow-lg rounded-lg px-4 py-3 mb-5">
      <div className="px-lg-3">
        <div className="row">
          <ProductDetailGallery productID={product.productID} skuID={skuID} />
          {/* <!-- Product details--> */}
          <div className="col-lg-6 pt-0">
            <div className="product-details pb-3">
              <div className="d-flex justify-content-between align-items-center mb-2">
                <span className="d-inline-block font-size-sm align-middle px-2 bg-primary text-light"> {product.productClearance === true && ' On Special'}</span>
                {skuID && <HeartButton skuID={skuID} className={'btn-wishlist mr-0'} />}
              </div>
              <h2 className="h4 mb-2">{product.productName}</h2>
              <div className="mb-2">
                <span className="text-small text-muted">{`SKU: `}</span>
                {sku && <span className="font-weight-normal text-large text-accent mr-1">{sku.skuCode}</span>}
              </div>
              <div
                className="mb-3 font-weight-light font-size-small text-muted"
                dangerouslySetInnerHTML={{
                  __html: product.productDescription,
                }}
              />
              <form className="mb-grid-gutter" onSubmit={e => e.preventDefault()}>
                {productOptions.length > 0 && <SkuOptions productID={product.productID} skuOptionDetails={productOptions} availableSkuOptions={availableSkuOptions} sku={sku} skuID={skuID} />}
                <div className="mb-3">{sku && <ProductPrice salePrice={sku.price} listPrice={sku.listPrice} />}</div>
                <div className="form-group d-flex align-items-center">
                  <select
                    value={quantity}
                    onChange={event => {
                      setQuantity(event.target.value)
                    }}
                    className="custom-select mr-3"
                    style={{ width: '5rem' }}
                  >
                    {sku &&
                      sku.calculatedQATS > 0 &&
                      [...Array(sku.calculatedQATS > 20 ? 20 : sku.calculatedQATS).keys()].map((value, index) => (
                        <option key={index + 1} value={index + 1}>
                          {index + 1}
                        </option>
                      ))}
                  </select>
                  <Button
                    disabled={cart.isFetching || !skuID}
                    isLoading={cart.isFetching}
                    className="btn btn-primary btn-block"
                    onClick={event => {
                      dispatch(addToCart(sku.skuID, quantity))
                      window.scrollTo({
                        top: 0,
                        behavior: 'smooth',
                      })
                    }}
                  >
                    <i className="far fa-shopping-cart font-size-lg mr-2"></i>
                    {t('frontend.product.add_to_cart')}
                  </Button>
                </div>
              </form>
              {/* <!-- Product panels--> */}
              <ProductPagePanels product={product} attributeSets={attributeSets} />
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export { ProductPageContent }
