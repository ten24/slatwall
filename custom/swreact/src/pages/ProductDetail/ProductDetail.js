// import PropTypes from 'prop-types'
import React, { useEffect, useState } from 'react'

import { Layout } from '../../components'
import ProductPageHeader from './ProductPageHeader'
import ProductPageContent from './ProductPageContent'
import ProductDetailSlider from './ProductDetailSlider'
import { Redirect, useHistory, useLocation } from 'react-router-dom'
import { useGetProductDetails, useGetProductAvailableSkuOptions, useGetSkuOptionDetails } from '../../hooks/useAPI'
import queryString from 'query-string'
import { Helmet } from 'react-helmet'

const ProductDetail = props => {
  let { pathname, search } = useLocation()
  let [product, getProduct] = useGetProductDetails()
  let [productOptions, getProductOptions] = useGetSkuOptionDetails()
  let [skuOptions, getSkuOptionsRequest] = useGetProductAvailableSkuOptions()
  const loc = useLocation()

  let history = useHistory()
  const [path, setPath] = useState(pathname)
  const params = queryString.parse(search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
  const skuCodesToSkuIds = params => {
    const parsedOptions = queryString.parse(params, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
    return Object.keys(parsedOptions)
      .map(optionGroupCode => {
        return productOptions.data
          .map(optionGroup => {
            const optCount = optionGroup.options.filter(option => {
              return option.optionCode === parsedOptions[optionGroupCode]
            })[0]
            return optCount ? optCount.optionID : null
          })
          .filter(option => option)[0]
      })
      .join()
  }
  useEffect(() => {
    history.listen(location => {
      const parsedOptions = queryString.parse(location.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
      getSkuOptionsRequest({
        ...skuOptions,
        isFetching: false,
        isLoaded: false,
        params: {
          productID: product.data.productID,
          selectedOptionIDList: Object.keys(parsedOptions)
            .map(optionGroupCode => {
              return productOptions.data
                .map(optionGroup => {
                  const optCount = optionGroup.options.filter(option => {
                    return option.optionCode === parsedOptions[optionGroupCode]
                  })[0]
                  return optCount ? optCount.optionID : null
                })
                .filter(option => option)[0]
            })
            .join(),
        },
        makeRequest: false,
      })
    })
  }, [history, getSkuOptionsRequest, skuOptions, params, search, product, productOptions])

  //  getSkuOptionsRequest({ ...skuOptions, isFetching: true, isLoaded: false, params: { 'f:skuID': params.skuid }, makeRequest: true })

  if (product.isLoaded && !productOptions.isLoaded && !productOptions.isFetching) {
    getProductOptions({ ...productOptions, isFetching: true, isLoaded: false, params: { productID: product.data.productID }, makeRequest: true })
  }
  if (!product.isFetching && product.isLoaded && Object.keys(product.data).length === 0) {
    return <Redirect to="/404" />
  }
  if ((!product.isFetching && !product.isLoaded) || pathname !== path) {
    const urlTitle = pathname.split('/').reverse()
    setPath(pathname)

    getProduct({
      ...product,
      params: {
        filter: {
          current: 1,
          urlTitle: urlTitle[0],
        },
      },
      makeRequest: true,
      isFetching: true,
      isLoaded: false,
    })
  }

  if (product.isLoaded && productOptions.isLoaded && !skuOptions.isFetching && !skuOptions.isLoaded) {
    console.log('skuCodesToSkuIds(search)', search, skuCodesToSkuIds(search))
    getSkuOptionsRequest({
      ...skuOptions,
      isFetching: true,
      isLoaded: false,
      params: {
        productID: product.data.productID,
        selectedOptionIDList: skuCodesToSkuIds(search),
      },
      makeRequest: true,
    })
  }
  // let skuOptionSelection = {}
  // if (sku.isLoaded && sku.data.options) {
  //   sku.data.options.forEach(({ optionGroupID, optionID }) => {
  //     skuOptionSelection[optionGroupID] = optionID
  //   })
  // }
  // console.log(`ProductPageContent: params.skuid: ${params.skuid} skuID: ${sku.data.skuID}`)
  console.log('skuOptions', skuOptions)
  return (
    <Layout>
      <div className="bg-light p-0">
        <ProductPageHeader title={product.data.calculatedTitle} />
        <Helmet title={product.data.calculatedTitle} />
        {product.data.productID && <ProductPageContent {...product.data} sku={skuOptions.data.sku} skuID={skuOptions.data.skuID} availableSkuOptions={skuOptions.data.availableSkuOptions} productOptions={productOptions.data} isFetching={skuOptions.isFetching || productOptions.isFetching || product.isFetching} />}
        {product.data.productID && <ProductDetailSlider productID={product.data.productID} />}
      </div>
    </Layout>
  )
}

export default ProductDetail
