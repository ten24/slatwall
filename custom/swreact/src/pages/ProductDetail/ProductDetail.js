// import PropTypes from 'prop-types'
import React, { useEffect, useReducer, useState } from 'react'

import { Layout } from '../../components'
import { connect } from 'react-redux'
import ProductPageHeader from './ProductPageHeader'
import ProductPageContent from './ProductPageContent'
import ProductSlider from '../../components/ProductSlider/ProductSlider'
import { SlatwalApiService } from '../../services'
import ProductDetailSlider from './ProductDetailSlider'

function reducer(state, action) {
  switch (action.type) {
    case 'SET_PRODUCT':
      const { productImageGallery } = action
      return { ...state, productImageGallery }
    case 'SET_PRODUCT_IMAGE_GALLERY':
      const { product } = action
      return { ...state, product }
    case 'SET_RELATED_PRODUCTS':
      const { relatedProducts } = action
      return { ...state, relatedProducts }
    default:
      throw new Error()
  }
}

const ProductDetail = ({ location, productID = '2c92808476e1c29f0176e1e2c5c71191' }) => {
  const [product, setProduct] = useState({ productID, isLoaded: false })
  console.log('product', product)
  useEffect(() => {
    let didCancel = false
    const loginToken = localStorage.getItem('loginToken')

    if (product.productID && !product.isLoaded) {
      SlatwalApiService.products
        .get(
          {
            bearerToken: loginToken,
            contentType: 'application/json',
          },
          product.productID
        )
        .then(response => {
          if (response.isSuccess() && !didCancel) {
            console.log(response.success())
            setProduct({
              ...product,
              isLoaded: true,
              ...response.success(),
            })
          } else if (response.isFail() && !didCancel) {
            setProduct({
              ...product,
              isLoaded: true,
              err: 'opps',
            })
          }
        })
    } else if (product.productID == null && !product.isLoaded) {
      const urlTitle = location.pathname.split('/').reverse()
      SlatwalApiService.products
        .list(
          {
            bearerToken: loginToken,
            contentType: 'application/json',
          },
          {
            filter: {
              urlTitle: urlTitle[0],
            },
          }
        )
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
  }, [product, setProduct])

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

ProductDetail.propTypes = {}
export default ProductDetail
