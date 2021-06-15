import Slider from 'react-slick'
import ProductCard from '../ProductCard/ProductCard'
import { useGetProductsByEntity } from '../../hooks/useAPI'
import { useEffect } from 'react'

const ProductSlider = ({ children, params = {}, settings, title, slidesToShow = 4 }) => {
  let [request, setRequest] = useGetProductsByEntity()

  useEffect(() => {
    let didCancel = false
    if (!didCancel && !request.isFetching && !request.isLoaded) {
      setRequest({
        ...request,
        params,
        entity: 'product',
        makeRequest: true,
        isFetching: true,
        isLoaded: false,
      })
    }
    return () => {
      didCancel = true
    }
  }, [request, setRequest, params])
  if (!request.data.length) {
    return null
  }
  settings = settings
    ? settings
    : {
        dots: false,
        infinite: request.data && request.data.length >= slidesToShow,
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
        <h3 className="h3 mb-0">{title}</h3>
        {children}
        <Slider style={{ margin: '0 4rem', height: 'fit-content' }} className="row mt-4" {...settings}>
          {request.data.map((slide, index) => {
            return <ProductCard {...slide} imagePath={slide.defaultSku_imagePath} skuID={slide.defaultSku_skuID} listPrice={slide.defaultSku_listPrice} key={index} />
          })}
        </Slider>
      </div>
    </div>
  )
}
export { ProductSlider }
