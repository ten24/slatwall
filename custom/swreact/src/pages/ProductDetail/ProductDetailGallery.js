import React, { useEffect, useState } from 'react'
import { SlatwalApiService } from '../../services'

const ProductDetailGallery = ({ productID }) => {
  const [productImageGallery, setProductImageGallery] = useState({ imageGallery: {}, isLoaded: false, productID })
  if (productImageGallery.productID !== productID) {
    setProductImageGallery({ imageGallery: [], isLoaded: false, err: '', productID })
  }
  useEffect(() => {
    let didCancel = false
    if (!productImageGallery.isLoaded) {
      SlatwalApiService.products.getGallery({ productID }).then(response => {
        if (response.isSuccess() && !didCancel) {
          setProductImageGallery({
            ...productImageGallery,
            isLoaded: true,
            products: response.success().productImageGallery,
          })
        } else if (response.isFail() && !didCancel) {
          setProductImageGallery({
            ...productImageGallery,
            isLoaded: true,
            err: 'opps',
          })
        }
      })
    }

    return () => {
      didCancel = true
    }
  }, [productImageGallery, setProductImageGallery, productID])

  return (
    <div className="col-lg-6 pr-lg-5 pt-0">
      <div className="cz-product-gallery">
        <div className="cz-preview order-sm-2">
          <div className="cz-preview-item active" id="first">
            <img className="cz-image-zoom w-100 mx-auto" src="#$.getThemePath()#/custom/client/assets/images/product-img-1.png" data-zoom="#$.getThemePath()#/custom/client/assets/images/product-img-1.png" alt="Product" style={{ maxWidth: '500px' }} />
            <div className="cz-image-zoom-pane"></div>
          </div>
        </div>
      </div>
    </div>
  )
}
export default ProductDetailGallery
