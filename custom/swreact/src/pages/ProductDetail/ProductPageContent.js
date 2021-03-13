import ProductDetailGallery from './ProductDetailGallery'
import ProductPagePanels from './ProductPagePanels'
import React, { useEffect, useRef, useState } from 'react'
import { addToCart } from '../../actions/cartActions'
import { useDispatch } from 'react-redux'
import axios from 'axios'
import { sdkURL, SlatwalApiService } from '../../services'
import { HeartButton } from '../../components'
import { useTranslation } from 'react-i18next'
import { useGetSku, useGetProductSkus, useGetProductAvailableSkuOptions, useGetProductSkuSelected } from '../../hooks/useAPI'
import { concat } from 'lodash'

const ProductPageContent = ({ productID, productName, productClearance, productCode, productDescription, skuID }) => {
  const dispatch = useDispatch()
  const { t, i18n } = useTranslation()
  let [sku, setRequest] = useGetSku()
  let [skus, setSkusRequest] = useGetProductSkus()
  let [skuOptions, setOptionsRequest] = useGetProductAvailableSkuOptions()
  let [skuSelected, setSlectedRequest] = useGetProductSkuSelected()
  const [lastOptionGoupID, setLastOptionGoupID] = useState('')
  let productDetails = {}
  const [quantity, setQuantity] = useState(1)
  const refs = useRef([React.createRef(), React.createRef(), React.createRef(), React.createRef(), React.createRef(), React.createRef()])

  if (skuSelected.isLoaded) {
    setSlectedRequest({ data: {}, isFetching: false, isLoaded: false, params: {}, makeRequest: false })
    setRequest({ ...sku, isFetching: true, isLoaded: false, params: { 'f:skuID': skuSelected.data.skuID || skus.data.skus[0].skuID }, makeRequest: true })
  }
  console.log('sku', sku)
  console.log('skus', skus)
  console.log('skuOptions', skuOptions)
  console.log('skuSelected', skuSelected)

  useEffect(() => {
    let didCancel = false
    if (!skus.isFetching && !skus.isLoaded) {
      setSkusRequest({ ...skus, isFetching: true, isLoaded: false, params: { productID }, makeRequest: true })
    }
    if ((skuID || (skus.isLoaded && skus.data.skus[0])) && !sku.isFetching && !sku.isLoaded) {
      setRequest({ ...sku, isFetching: true, isLoaded: false, params: { 'f:skuID': skuID || skus.data.skus[0].skuID }, makeRequest: true })
    }
    if (!skuOptions.isFetching && !skuOptions.isLoaded && sku.isLoaded) {
      setOptionsRequest({
        ...skuOptions,
        isFetching: true,
        isLoaded: false,
        params: {
          productID,
          selectedOptionIDList: '',
        },
        makeRequest: true,
      })
    }

    return () => {
      didCancel = true
    }
  }, [setSkusRequest, skus, productID, productDetails, sku, setRequest, setOptionsRequest, skuOptions])

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
                <span className="text-small text-muted">{`${t('frontend.product.subhead')} `}</span>
                <span className="h4 font-weight-normal text-large text-accent mr-1">{productCode}</span>
              </div>
              <h2 className="h4 mb-2">{productName}</h2>
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
                  dispatch(addToCart(sku.data.skuID, quantity))
                }}
              >
                {skus.isLoaded &&
                  skuOptions.isLoaded &&
                  skus.data.options.length > 0 &&
                  skus.data.options.map(({ optionGroupName, options, optionGroupID }, index) => {
                    let selectOptions = sku.data.options
                      .map(options => {
                        return options.optionID
                      })
                      .join()
                    const selectOption = options.filter(option => {
                      return selectOptions.includes(option.optionID)
                    })
                    let filteredOptions = options
                    if (lastOptionGoupID !== optionGroupID) {
                      filteredOptions = options.filter(opt => {
                        return skuOptions.data.availableSkuOptions.includes(opt.optionID)
                      })
                    }

                    if (!filteredOptions.length) {
                      return <div key={optionGroupID}></div>
                    }

                    return (
                      <div className="form-group" key={optionGroupID}>
                        <div className="d-flex justify-content-between align-items-center pb-1">
                          <label className="font-weight-medium" htmlFor={optionGroupID}>
                            {optionGroupName}
                          </label>
                        </div>

                        <select
                          className="custom-select"
                          required
                          id={optionGroupID}
                          ref={refs.current[index]}
                          value={(selectOption.length > 0 && selectOption[0].optionID) || options[0]}
                          onChange={e => {
                            const selectedOptionIDList = refs.current.reduce((acc, ref) => (ref.current ? [...acc, ref.current.value] : acc), []).join()
                            setOptionsRequest({
                              ...skuOptions,
                              isFetching: true,
                              isLoaded: false,
                              params: {
                                productID,
                                selectedOptionIDList: e.target.value,
                              },
                              makeRequest: true,
                            })

                            setSlectedRequest({ ...skuSelected, isFetching: true, isLoaded: false, params: { productID, selectedOptionIDList }, makeRequest: true })
                            setLastOptionGoupID(optionGroupID)
                          }}
                        >
                          {filteredOptions &&
                            filteredOptions.map(({ optionID, optionName }) => {
                              return (
                                <option key={optionID} value={optionID}>
                                  {optionName}
                                </option>
                              )
                            })}
                        </select>
                      </div>
                    )
                  })}

                {/* {productDetails.options.length === 0 && productDetails.skus.length > 1 && (
                  <div className="form-group">
                    <div className="d-flex justify-content-between align-items-center pb-1">
                      <label className="font-weight-medium" htmlFor="product-size">
                        {t('frontend.product.option')}
                      </label>
                    </div>

                    <select className="custom-select" required id="product-size">
                      {productDetails.skus &&
                        productDetails.skus.map(({ skuID, calculatedSkuDefinition }) => {
                          return (
                            <option key={skuID} value={skuID}>
                              {calculatedSkuDefinition}
                            </option>
                          )
                        })}
                    </select>
                  </div>
                )} */}

                <div className="mb-3">
                  <span className="h4 text-accent font-weight-light">{sku.price ? sku.price : ''}</span> <span className="font-size-sm ml-1">{sku.data.listPrice ? `${sku.data.listPrice} ${t('frontend.core.list')}` : ''}</span>
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
                    {sku.data.calculatedQATS > 0 &&
                      [...Array(sku.data.calculatedQATS > 20 ? 20 : sku.data.calculatedQATS).keys()].map((value, index) => (
                        <option key={index + 1} value={index + 1}>
                          {index + 1}
                        </option>
                      ))}
                  </select>

                  <button className="btn btn-primary btn-block" type="submit">
                    <i className="far fa-shopping-cart font-size-lg mr-2"></i>
                    {t('frontend.product.add_to_cart')}
                  </button>
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
