import React, { useEffect, useRef, useState } from 'react'
import Slider from 'react-slick'
import { SWImage } from '../../components'
import { useGetProductImageGallery } from '../../hooks/useAPI'

/*

Probably should move to this eventually 
https://react-slick.neostack.com/docs/example/custom-paging
*/
const ProductDetailGallery = ({ productID, skuID }) => {
  let [productImageGallery, setRequest] = useGetProductImageGallery()
  const [sliders, setSliders] = useState({
    nav1: null,
    nav2: null,
  })
  const slider1 = useRef()
  const slider2 = useRef()
  useEffect(() => {
    setSliders({
      nav1: slider1.current,
      nav2: slider2.current,
    })
    if (!productImageGallery.isLoaded && !productImageGallery.isFetching) {
      setRequest({ ...productImageGallery, isFetching: true, isLoaded: false, params: { productID }, makeRequest: true })
    }
  }, [productImageGallery, setRequest, productID])
  let filterImages = productImageGallery.isLoaded
    ? productImageGallery.data.images.filter(({ ASSIGNEDSKUIDLIST = false, TYPE }) => {
        return TYPE === 'skuDefaultImage' || (ASSIGNEDSKUIDLIST && ASSIGNEDSKUIDLIST.includes(skuID))
      })
    : []
  if (filterImages.length === 0) {
    filterImages = [{ ORIGINALPATH: '', NAME: '' }]
  }

  return (
    <div className="col-lg-6 pr-lg-5 pt-0">
      <div className="cz-product-gallery">
        <div className="cz-preview order-sm-2">
          <div className="cz-preview-item active" id="first">
            <div>
              <Slider arrows={false} asNavFor={sliders.nav2} ref={slider => (slider1.current = slider)}>
                {productImageGallery.isLoaded &&
                  filterImages.map(({ ORIGINALPATH, NAME }) => {
                    return <SWImage key={NAME} customPath="/" src={ORIGINALPATH} className="cz-image-zoom w-100 mx-auto" alt="Product" style={{ maxWidth: '500px' }} />
                  })}
              </Slider>
            </div>
            <div className="cz-image-zoom-pane"></div>
          </div>
        </div>
      </div>
      <div className="cz-product-gallery">
        <div className="cz-preview order-sm-2">
          <div className="cz-preview-item active" id="first">
            <div>
              {filterImages.length > 1 && (
                <Slider arrows={false} infinite={filterImages.length > 3} asNavFor={sliders.nav1} ref={slider => (slider2.current = slider)} slidesToShow={3} swipeToSlide={true} focusOnSelect={true}>
                  {productImageGallery.isLoaded &&
                    filterImages.map(({ ORIGINALPATH, NAME }) => {
                      return <SWImage key={NAME} customPath="/" src={ORIGINALPATH} className="cz-image-zoom w-100 mx-auto" alt="Product" style={{ maxWidth: '100px' }} />
                    })}
                </Slider>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
export default ProductDetailGallery
