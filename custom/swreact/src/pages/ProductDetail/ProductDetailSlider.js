import React, { useEffect, useState } from 'react'
import { SlatwalApiService } from '../../services'
import ProductSlider from '../../components/ProductSlider/ProductSlider'
import { renameKeysInArrayOfObjects } from '../../utils'

const ProductDetailSlider = ({ productID }) => {
  const [relatedProducts, setRelatedProducts] = useState({ products: [], isLoaded: false, err: '', productID })
  if (relatedProducts.productID !== productID) {
    setRelatedProducts({ products: [], isLoaded: false, err: '', productID })
  }
  useEffect(() => {
    let didCancel = false
    const loginToken = localStorage.getItem('loginToken')
    if (!relatedProducts.isLoaded) {
      SlatwalApiService.products
        .getRelatedProducts(
          {
            bearerToken: loginToken,
            contentType: 'application/json',
          },
          { productID }
        )
        .then(response => {
          if (response.isSuccess() && !didCancel) {
            let newProducts = response.success().products
            // TODO: Fix this.....
            renameKeysInArrayOfObjects(newProducts, 'relatedProduct_', '')

            setRelatedProducts({
              ...relatedProducts,
              isLoaded: true,
              products: newProducts,
            })
          } else {
            setRelatedProducts({
              ...relatedProducts,
              isLoaded: true,
              err: 'oops',
            })
          }
        })
    }

    return () => {
      didCancel = true
    }
  }, [relatedProducts, setRelatedProducts, productID])

  return <ProductSlider title="Related Products" sliderData={relatedProducts.products} />
}
export default ProductDetailSlider
