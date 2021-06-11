import React, { useEffect, useState } from 'react'
import { SlatwalApiService } from '../../services'
import { renameKeysInArrayOfObjects } from '../../utils'
import { useTranslation } from 'react-i18next'
import Slider from 'react-slick'
import { ProductCard } from '..'

const RelatedProductsSlider = ({ productID }) => {
  const { t } = useTranslation()
  const slidesToShow = 4
  const [relatedProducts, setRelatedProducts] = useState({ products: [], isLoaded: false, err: '', productID })
  if (relatedProducts.productID !== productID) {
    setRelatedProducts({ products: [], isLoaded: false, err: '', productID })
  }
  useEffect(() => {
    let didCancel = false
    if (!relatedProducts.isLoaded) {
      SlatwalApiService.products.getRelatedProducts({ productID }).then(response => {
        if (response.isSuccess() && !didCancel) {
          let newProducts = response.success().relatedProducts

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
  if (!relatedProducts.products.length) {
    return null
  }
  const settings = {
    dots: false,
    infinite: relatedProducts.products && relatedProducts.products.length >= slidesToShow,
    // infinite: true,
    slidesToShow: slidesToShow,
    slidesToScroll: 1,
    responsive: [
      {
        breakpoint: 1200,
        settings: {
          slidesToShow: 3,
        },
      },
      {
        breakpoint: 800,
        settings: {
          slidesToShow: 2,
        },
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 1,
        },
      },
    ],
  }
  return (
    <div className="container">
      <div className="featured-products shadow bg-white text-center my-5 py-3">
        <h3 className="h3 mb-0">{t('frontend.product.related')}</h3>
        <Slider style={{ margin: '0 4rem', height: 'fit-content' }} className="row mt-4" {...settings}>
          {relatedProducts.products.map((slide, index) => {
            return <ProductCard {...slide} imageFile={slide.defaultSku_imageFile} skuID={slide.defaultSku_skuID} listPrice={slide.defaultSku_listPrice} key={index} />
          })}
        </Slider>
      </div>
    </div>
  )
}
export { RelatedProductsSlider }
