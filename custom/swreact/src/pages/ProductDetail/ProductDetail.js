// import PropTypes from 'prop-types'
import React, { useEffect, useState } from 'react'

import { Layout } from '../../components'
import ProductPageHeader from './ProductPageHeader'
import ProductPageContent from './ProductPageContent'
import { SlatwalApiService } from '../../services'
import ProductDetailSlider from './ProductDetailSlider'
import { useLocation } from 'react-router-dom'

const ProductDetail = props => {
  let { pathname } = useLocation()
  const [product, setProduct] = useState({ isLoaded: false })

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
          if (response.isSuccess() && !didCancel) {
            const records = response.success().pageRecords
            setProduct({
              ...product,
              isLoaded: true,
              ...records[0],
            })
          } else if (response.isFail() && !didCancel) {
            setProduct({
              ...product,
              isLoaded: true,
            })
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
