// import PropTypes from 'prop-types'
import React, { useEffect, useState } from 'react'

import { Layout } from '../../components'
import ProductPageHeader from './ProductPageHeader'
import ProductPageContent from './ProductPageContent'
import { SlatwalApiService } from '../../services'
import ProductDetailSlider from './ProductDetailSlider'
import { useLocation } from 'react-router-dom'
import useRedirect from '../../hooks/useRedirect'

const ProductDetail = props => {
  let { pathname } = useLocation()
  const [product, setProduct] = useState({ isLoaded: false })
  const [redirect, setRedirect] = useRedirect({ location: '/notfound' })

  useEffect(() => {
    let didCancel = false
    if (!product.isLoaded) {
      const urlTitle = pathname.split('/').reverse()
      SlatwalApiService.products
        .list({
          filter: {
            current: 1,
            urlTitle: urlTitle[0],
          },
        })
        .then(response => {
          if (response.isSuccess() && !didCancel && response.success().pageRecords && response.success().pageRecords.length) {
            setProduct({
              ...product,
              isLoaded: true,
              ...response.success().pageRecords[0],
            })
          } else if (!didCancel) {
            // setRedirect({ ...redirect, shouldRedirect: true })
            // setProduct({
            //   ...product,
            //   isLoaded: true,
            // })
          }
        })
    }

    return () => {
      didCancel = true
    }
  }, [product, setProduct, pathname])

  return (
    <Layout>
      <div className="bg-light p-0">
        <ProductPageHeader title={product.calculatedTitle} />
        {product.productID && <ProductPageContent {...product} />}
        {product.productID && <ProductDetailSlider productID={product.productID} />}
      </div>
    </Layout>
  )
}

// ProductDetail.defaultProps = {
//   productID: '',
// }
export default ProductDetail
