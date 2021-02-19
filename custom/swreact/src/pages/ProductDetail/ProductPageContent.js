import ProductDetailGallery from './ProductDetailGallery'
import ProductPagePanels from './ProductPagePanels'
import React, { useEffect, useRef, useState } from 'react'
import { addToCart } from '../../actions/cartActions'
import { useDispatch } from 'react-redux'
import axios from 'axios'
import { sdkURL, SlatwalApiService } from '../../services'
import { HeartButton } from '../../components'
import { useTranslation } from 'react-i18next'

const ProductPageContent = ({ productID, productName, productClearance, productCode, productDescription, defaultSku_skuID = '' }) => {
  const dispatch = useDispatch()
  const { t, i18n } = useTranslation()

  const [quantity, setQuantity] = useState(1)
  const [productDetails, setProductDetails] = useState({ skus: [], options: [], defaultSelectedOptions: '', availableSkuOptions: '', currentGroupId: '', isLoaded: false })
  const [sku, setSku] = useState({ skuID: defaultSku_skuID, isLoaded: false })
  const refs = useRef([React.createRef(), React.createRef(), React.createRef(), React.createRef(), React.createRef(), React.createRef()])

  const refreshOptions = (selectedOptionIDList = '', previousOption = '', currentGroupId) => {
    axios({
      method: 'POST',
      withCredentials: true,
      url: `${sdkURL}api/scope/productAvailableSkuOptions`,
      data: {
        productID,
        selectedOptionIDList,
      },
      headers: {
        'Content-Type': 'application/json',
      },
    }).then(response => {
      if (response.status === 200) {
        const { availableSkuOptions } = response.data
        let newDefault = ''
        const newOptions = availableSkuOptions.split(',')
        const legacyDefault = newOptions.reduce((acc, curr) => {
          return productDetails.defaultSelectedOptions.includes(curr) ? curr : acc
        }, '')
        if (legacyDefault) {
          newDefault = productDetails.defaultSelectedOptions.replace(previousOption, selectedOptionIDList)
        } else {
          newDefault = selectedOptionIDList
        }
        setProductDetails({ ...productDetails, defaultSelectedOptions: newDefault, availableSkuOptions, currentGroupId, isLoaded: true })
        getSku()
      }
    })
  }

  const getSku = () => {
    const selectedOptionIDList = refs.current.reduce((acc, ref) => (ref.current ? [...acc, ref.current.value] : acc), []).join()
    axios({
      method: 'POST',
      withCredentials: true, // default

      url: `${sdkURL}api/scope/productSkuSelected`,
      data: {
        productID,
        selectedOptionIDList: selectedOptionIDList,
      },
      headers: {
        'Content-Type': 'application/json',
      },
    }).then(response => {
      if (response.status === 200) {
        const { skuID } = response.data
        setSku({ skuID })
        getSkuDetails(skuID)
      }
    })
  }
  const getSkuDetails = skuID => {
    SlatwalApiService.products.getSku(skuID).then(response => {
      if (response.isSuccess()) {
        const sdkuDetails = response.success()
        setSku({ ...sku, ...sdkuDetails, isLoaded: true })
      }
    })
  }

  useEffect(() => {
    let didCancel = false
    if (!sku.isLoaded && sku.skuID.length) {
      getSkuDetails(sku.skuID)
    }
    if (!productDetails.isLoaded) {
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
          const { options, skus, defaultSelectedOptions } = response.data
          setProductDetails({ ...productDetails, skus, options, defaultSelectedOptions, isLoaded: true })
          if (skus.length && !sku.skuID.length) {
            getSkuDetails(skus[0].skuID)
          }
        } else if (!didCancel) {
          setProductDetails({ ...productDetails, isLoaded: true })
        }
      })
    }

    return () => {
      didCancel = true
    }
  }, [setProductDetails, productDetails, productID, sku, getSkuDetails])

  // Leaving this here until this logic is proven solid. Uncomment for helpful debugging
  console.log('sku', sku)

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
                  dispatch(addToCart(sku.skuID, quantity))
                }}
              >
                {productDetails.options.length > 0 &&
                  productDetails.options.map(({ optionGroupName, options, optionGroupID }, index) => {
                    const selectOption = options.filter(option => {
                      return productDetails.defaultSelectedOptions.includes(option.optionID)
                    })
                    let filteredOptions = options
                    if (productDetails.currentGroupId !== '' && optionGroupID !== productDetails.currentGroupId) {
                      filteredOptions = options.filter(opt => {
                        return productDetails.availableSkuOptions.includes(opt.optionID)
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
                            const previousOption = options.reduce((acc, curr) => {
                              return productDetails.defaultSelectedOptions.includes(curr.optionID) ? curr.optionID : acc
                            }, '')

                            refreshOptions(e.target.value, previousOption, optionGroupID)
                          }}
                        >
                          {filteredOptions &&
                            filteredOptions.map(({ optionID, optionName }) => {
                              return (
                                <option key={optionID} value={optionID}>
                                  {optionName + ' - ' + optionID}
                                </option>
                              )
                            })}
                        </select>
                      </div>
                    )
                  })}

                {productDetails.options.length === 0 && productDetails.skus.length > 1 && (
                  <div className="form-group">
                    <div className="d-flex justify-content-between align-items-center pb-1">
                      <label className="font-weight-medium" htmlFor="product-size">
                        Option
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
                )}

                <div className="mb-3">
                  <span className="h4 text-accent font-weight-light">{sku.price ? sku.price : ''}</span> <span className="font-size-sm ml-1">{sku.listPrice ? `${sku.listPrice} ${t('frontend.core.list')}` : ''}</span>
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
                    {sku.calculatedQATS > 0 &&
                      [...Array(sku.calculatedQATS > 20 ? 20 : sku.calculatedQATS).keys()].map((value, index) => (
                        <option key={index + 1} value={index + 1}>
                          {index + 1}
                        </option>
                      ))}
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
