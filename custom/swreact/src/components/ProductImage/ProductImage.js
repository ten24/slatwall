import React, { useEffect } from 'react'
import { SWImage } from '..'
import { useGetProductImageGallery } from '../../hooks/useAPI'

const ProductImage = ({ productID, skuID }) => {
  let [productImageGallery, setRequest] = useGetProductImageGallery()

  let filterImages = productImageGallery.isLoaded
    ? productImageGallery.data.images.filter(({ ASSIGNEDSKUIDLIST = false, TYPE }) => {
        return TYPE === 'skuDefaultImage' || (ASSIGNEDSKUIDLIST && ASSIGNEDSKUIDLIST.includes(skuID))
      })
    : []
  if (filterImages.length === 0) {
    filterImages = [{ ORIGINALPATH: '', NAME: '' }]
  }

  useEffect(() => {
    let didCancel = false

    if (!productImageGallery.isLoaded && !productImageGallery.isFetching && !didCancel) {
      setRequest({ ...productImageGallery, isFetching: true, isLoaded: false, params: { productID }, makeRequest: true })
    }
    return () => {
      didCancel = true
    }
  }, [productImageGallery, setRequest, productID])

  return <>{productImageGallery.isLoaded && <SWImage key={productImageGallery.data.images[0].NAME} customPath="/" src={productImageGallery.data.images[0].ORIGINALPATH} />}</>
}

export default ProductImage
