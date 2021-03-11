// import PropTypes from 'prop-types'
import React, { useEffect, useState } from 'react'

import { Layout } from '../../components'
import ProductPageHeader from './ProductPageHeader'
import ProductPageContent from './ProductPageContent'
import { SlatwalApiService } from '../../services'
import ProductDetailSlider from './ProductDetailSlider'
import { useLocation } from 'react-router-dom'
import useRedirect from '../../hooks/useRedirect'
import { useGetProductDetails } from '../../hooks/useAPI'

const ProductDetail = props => {
  let loc = useLocation()
  const [redirect, setRedirect] = useRedirect({ location: '/404', time: 300 })
  let [request, setRequest] = useGetProductDetails()
  const [path, setPath] = useState(loc.pathname)
  useEffect(() => {
    let didCancel = false
    if (!didCancel && ((!request.isFetching && !request.isLoaded) || loc.pathname !== path)) {
      const urlTitle = loc.pathname.split('/').reverse()
      setPath(loc.pathname)
      setRequest({
        ...request,
        data: {},
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
  }, [request, setRequest, loc, path.setPath])

  return (
    <Layout>
      <div className="bg-light p-0">
        <ProductPageHeader title={request.data.calculatedTitle} />
        {request.data.productID && <ProductPageContent {...request.data} />}
        {request.data.productID && <ProductDetailSlider productID={request.data.productID} />}
      </div>
    </Layout>
  )
}

export default ProductDetail
