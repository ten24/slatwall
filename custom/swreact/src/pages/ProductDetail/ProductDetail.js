// import PropTypes from 'prop-types'
import React, { useEffect, useState } from 'react'

import { Layout } from '../../components'
import ProductPageHeader from './ProductPageHeader'
import ProductPageContent from './ProductPageContent'
import ProductDetailSlider from './ProductDetailSlider'
import { useLocation } from 'react-router-dom'
import useRedirect from '../../hooks/useRedirect'
import { useGetProductDetails } from '../../hooks/useAPI'
import queryString from 'query-string'
import { Helmet } from 'react-helmet'

const ProductDetail = props => {
  let { pathname, search } = useLocation()
  const [redirect, setRedirect] = useRedirect({ location: '/404', time: 300 })
  let [request, setRequest] = useGetProductDetails()
  const [path, setPath] = useState(pathname)
  const params = queryString.parse(search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
  useEffect(() => {
    let didCancel = false
    if (!didCancel && ((!request.isFetching && !request.isLoaded) || pathname !== path)) {
      const urlTitle = pathname.split('/').reverse()
      setPath(pathname)

      setRequest({
        ...request,
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
    if (!request.isFetching && request.isLoaded && Object.keys(request.data).length === 0) {
      setRedirect({ ...redirect, shouldRedirect: true })
    }
    return () => {
      didCancel = true
    }
  }, [request, setRequest, pathname, search, path, redirect, setRedirect])

  return (
    <Layout>
      <div className="bg-light p-0">
        <ProductPageHeader title={request.data.calculatedTitle} />
        <Helmet title={request.data.calculatedTitle} />
        {request.data.productID && <ProductPageContent {...request.data} skuID={params.skuid} />}
        {request.data.productID && <ProductDetailSlider productID={request.data.productID} />}
      </div>
    </Layout>
  )
}

export default ProductDetail
