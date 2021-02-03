// import PropTypes from 'prop-types'
import React, { useEffect, useState } from 'react'

import { Layout } from '../../components'
import ProductPageHeader from './ProductPageHeader'
import ProductPageContent from './ProductPageContent'
import { SlatwalApiService } from '../../services'
import ProductDetailSlider from './ProductDetailSlider'

const ProductDetail = props => {
  const { state = {}, pathname } = props.location
  const [product, setProduct] = useState({ ...state, isLoaded: false })

  if (product.productID !== null && state.productID !== product.productID) {
    setProduct({ ...state })
  }
  useEffect(() => {
    let didCancel = false

    if (product.productID == null && !product.isLoaded) {
      const urlTitle = pathname.split('/').reverse()
      SlatwalApiService.products
        .list({
          filter: {
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
              err: 'opps',
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
        <ProductPageHeader />
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
