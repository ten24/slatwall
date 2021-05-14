// import PropTypes from 'prop-types'
import React, { useEffect, useState } from 'react'

import { Layout } from '../../components'
import ProductPageHeader from './ProductPageHeader'
import ProductPageContent from './ProductPageContent'
import ProductDetailSlider from './ProductDetailSlider'
import { Redirect, useHistory, useLocation } from 'react-router-dom'
import { useGetProductAvailableSkuOptions, useGetEntityByUrlTitle } from '../../hooks/useAPI'
import queryString from 'query-string'
import { Helmet } from 'react-helmet'
const skuCodesToSkuIds = (params, productOptionGroups) => {
  const parsedOptions = queryString.parse(params, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
  const temp = Object.keys(parsedOptions).map(optionGroupCode => {
    return productOptionGroups
      .map(optionGroup => {
        const optCount = optionGroup.options.filter(option => {
          return option.optionCode === parsedOptions[optionGroupCode]
        })[0]
        return optCount ? optCount.optionID : null
      })
      .filter(option => option)
  })
  return temp.join()
}

const skuIdsToSkuCodes = (idList, productOptionGroups) => {
  return productOptionGroups
    .map(optionGroup =>
      optionGroup.options
        .filter(option => {
          return idList.includes(option.optionID)
        })
        .map(option => {
          let payload = {}
          payload[optionGroup.optionGroupCode] = option.optionCode
          return payload
        })
    )
    .flat()
}
const ProductDetail = props => {
  let { pathname, search } = useLocation()
  let [skuOptions, getSkuOptionsRequest] = useGetProductAvailableSkuOptions()
  let [newproduct, getPublicProduct] = useGetEntityByUrlTitle()

  let location = useLocation()
  let history = useHistory()
  const [path, setPath] = useState(pathname)
  const params = queryString.parse(search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })

  useEffect(() => {
    // Redirect to default sku if not provided
    if (newproduct.isLoaded && !Object.keys(params).length) {
      console.log('Redirect to Default Sku')
      const cals = skuIdsToSkuCodes(newproduct.data.defaultSelectedOptions, newproduct.data[0].optionGroups)
      history.push({
        pathname: location.pathname,
        search: queryString.stringify(Object.assign(...cals), { arrayFormat: 'comma' }),
      })
    }
    // get the sku
    if (newproduct.isLoaded && !skuOptions.isFetching && !skuOptions.isLoaded) {
      const selectedOptionIDList = skuCodesToSkuIds(search, newproduct.data.optionGroups)
      getSkuOptionsRequest({
        ...skuOptions,
        isFetching: true,
        isLoaded: false,
        params: {
          productID: newproduct.data.productID,
          skuID: params['skuid'],
          // Accounts for First Load
          selectedOptionIDList: selectedOptionIDList.length ? selectedOptionIDList : newproduct.data.defaultSelectedOptions,
        },
        makeRequest: true,
      })
    }
    // http://localhost:3006/product/demo-product?skuid=2c91808278f0fded0178f5d49b860da8

    history.listen(location => {
      if (!newproduct.isFetching && newproduct.isLoaded) {
        const selectedOptionIDList = skuCodesToSkuIds(location.search, newproduct.data.optionGroups)
        getSkuOptionsRequest({
          ...skuOptions,
          isFetching: true,
          isLoaded: false,
          params: {
            productID: newproduct.data.productID,
            // Accounts for First Load
            selectedOptionIDList,
          },
          makeRequest: true,
        })
      }
    })
  }, [history, getSkuOptionsRequest, skuOptions, params, search, location, newproduct])

  // Do we have a valid product?
  if (!newproduct.isFetching && newproduct.isLoaded && newproduct.data && Object.keys(newproduct.data).length === 0) {
    return <Redirect to="/404" />
  }
  // Get the Product on page chnage
  if (pathname !== path) {
    console.log('Refresh all')
    setPath(pathname)

    // getSkuOptionsRequest({
    //   ...skuOptions,
    //   isFetching: false,
    //   isLoaded: false,
    //   params: {
    //     productID: newproduct.data[0].productID,
    //     selectedOptionIDList: Object.keys(parsedOptions)
    //       .map(optionGroupCode => {
    //         return newproduct.data[0].optionGroups
    //           .map(optionGroup => {
    //             const optCount = optionGroup.options.filter(option => {
    //               return option.optionCode === parsedOptions[optionGroupCode]
    //             })[0]
    //             return optCount ? optCount.optionID : null
    //           })
    //           .filter(option => option)[0]
    //       })
    //       .join(),
    //   },
    //   makeRequest: false,
    // })
  }
  if (!newproduct.isFetching && !newproduct.isLoaded) {
    const urlTitle = pathname.split('/').reverse()
    setPath(pathname)
    getPublicProduct({
      ...newproduct,
      params: {
        urlTitle: urlTitle[0],
      },
      entity: 'product',
      makeRequest: true,
      isFetching: true,
      isLoaded: false,
    })
  }

  return (
    <Layout>
      <div className="bg-light p-0">
        {newproduct.isLoaded && <ProductPageHeader title={newproduct.data.productSeries} />}
        {newproduct.isLoaded && <Helmet title={newproduct.data.settings.productHTMLTitleString} />}
        {newproduct.isLoaded && newproduct.data.productID && <ProductPageContent attributeSets={newproduct.attributeSets} product={newproduct.data} sku={skuOptions.data.sku[0]} skuID={skuOptions.data.skuID} availableSkuOptions={skuOptions.data.availableSkuOptions} productOptions={newproduct.data.optionGroups} isFetching={skuOptions.isFetching || newproduct.isFetching} />}
        {newproduct.isLoaded && newproduct.data.productID && <ProductDetailSlider productID={newproduct.data.productID} />}
      </div>
    </Layout>
  )
}

export default ProductDetail
