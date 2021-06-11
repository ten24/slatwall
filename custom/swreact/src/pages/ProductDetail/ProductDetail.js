// import PropTypes from 'prop-types'
import React, { useEffect, useState } from 'react'

import { BreadCrumb, Layout, RelatedProductsSlider } from '../../components'
import ProductPageHeader from './ProductPageHeader'
import ProductPageContent from './ProductPageContent'
import { Redirect, useHistory, useLocation } from 'react-router-dom'
import { useGetProductAvailableSkuOptions, useGetEntityByUrlTitle } from '../../hooks/useAPI'
import queryString from 'query-string'
import { Helmet } from 'react-helmet'
import { useSelector } from 'react-redux'
import { getProductTypeRoute } from '../../selectors/configurationSelectors'
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
  let location = useLocation()
  let history = useHistory()
  let [skuOptions, getSkuOptionsRequest] = useGetProductAvailableSkuOptions()
  let [newproduct, getPublicProduct] = useGetEntityByUrlTitle()
  const [currentPath, setCurrentPath] = useState(location.pathname)
  const productTypeRoute = useSelector(getProductTypeRoute)
  const params = queryString.parse(location.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
  const productTypeBase = useSelector(state => state.configuration.filtering.productTypeBase)

  useEffect(() => {
    // Redirect to default sku if not provided
    if (newproduct.isLoaded && !Object.keys(params).length) {
      console.log('Redirect to Default Sku')
      const cals = skuIdsToSkuCodes(newproduct.data.defaultSelectedOptions, newproduct.data.optionGroups)
      history.push({
        pathname: location.pathname,
        search: queryString.stringify(Object.assign(...cals), { arrayFormat: 'comma' }),
      })
    }
  }, [history, params, location.pathname, newproduct])
  useEffect(() => {
    if (!newproduct.isFetching && !newproduct.isLoaded) {
      console.log('First and only product request')
      const urlTitle = location.pathname.split('/').reverse()
      getPublicProduct({
        data: [],
        error: '',
        entity: 'product',
        params: {
          urlTitle: urlTitle[0],
        },
        makeRequest: true,
        isFetching: true,
        isLoaded: false,
      })
    }
  }, [location.pathname, getPublicProduct, newproduct.isFetching, newproduct.isLoaded])

  useEffect(() => {
    // get the sku
    if (newproduct.isLoaded && !skuOptions.isFetching && !skuOptions.isLoaded && !skuOptions.isFetching) {
      console.log('First and only option request')
      const selectedOptionIDList = skuCodesToSkuIds(location.search, newproduct.data.optionGroups)
      getSkuOptionsRequest({
        ...skuOptions,
        isFetching: true,
        isLoaded: false,
        params: {
          productID: newproduct.data.productID,
          skuID: params.skuid,
          // Accounts for First Load
          selectedOptionIDList: selectedOptionIDList.length ? selectedOptionIDList : newproduct.data.defaultSelectedOptions,
        },
        makeRequest: true,
      })
    }
  }, [getSkuOptionsRequest, skuOptions, params.skuid, location.search, newproduct])

  // this will only get called on change
  useEffect(() => {
    const unload = history.listen(loc => {
      if (currentPath !== loc.pathname) {
        console.log('product change')
        const urlTitle = loc.pathname.split('/').reverse()
        setCurrentPath(loc.pathname)
        getPublicProduct({
          data: [],
          error: '',
          entity: 'product',
          params: {
            urlTitle: urlTitle[0],
          },
          makeRequest: true,
          isFetching: true,
          isLoaded: false,
        })
        getSkuOptionsRequest({
          data: { sku: {} },
          error: '',
          params: {},
          makeRequest: false,
          isFetching: false,
          isLoaded: false,
        })
        window.scrollTo({
          top: 0,
          behavior: 'smooth',
        })
      } else if (!newproduct.isFetching && newproduct.isLoaded && !skuOptions.isLoaded && !skuOptions.isFetching) {
        console.log('option change')
        const selectedOptionIDList = skuCodesToSkuIds(loc.search, newproduct.data.optionGroups)
        getSkuOptionsRequest({
          data: { sku: {} },
          error: '',
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
    return () => {
      unload()
    }
  }, [currentPath, setCurrentPath, history, getPublicProduct, newproduct, getSkuOptionsRequest, skuOptions])

  // Do we have a valid product?
  if (!newproduct.isFetching && newproduct.isLoaded && newproduct.data && Object.keys(newproduct.data).length === 0) {
    return <Redirect to="/404" />
  }

  return (
    <Layout>
      <div className="bg-light p-0">
        {newproduct.isLoaded && (
          <ProductPageHeader title={newproduct.data.productSeries}>
            <BreadCrumb
              crumbs={newproduct.data.breadcrumbs
                .map(crumb => {
                  return { title: crumb.productTypeName, urlTitle: `/${productTypeRoute}/${crumb.urlTitle}` }
                })
                .filter(crumb => crumb.urlTitle !== `/${productTypeRoute}/${productTypeBase}`)}
            />
          </ProductPageHeader>
        )}
        {newproduct.isLoaded && <Helmet title={newproduct.data.settings.productHTMLTitleString} />}
        {newproduct.isLoaded && newproduct.data.productID && skuOptions.isLoaded && <ProductPageContent attributeSets={newproduct.attributeSets} product={newproduct.data} sku={skuOptions.data.sku[0]} skuID={skuOptions.data.skuID} availableSkuOptions={skuOptions.data.availableSkuOptions} productOptions={newproduct.data.optionGroups} isFetching={skuOptions.isFetching || newproduct.isFetching} />}
        {newproduct.isLoaded && newproduct.data.productID && <RelatedProductsSlider productID={newproduct.data.productID} />}
      </div>
    </Layout>
  )
}

export default ProductDetail
