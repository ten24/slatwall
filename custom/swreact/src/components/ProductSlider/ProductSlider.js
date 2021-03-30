import Slider from 'react-slick'
import ProductCard from '../ProductCard/ProductCard'
const ProductSlider = ({ children, sliderData = [], settings, title, slidesToShow = 4 }) => {
  settings = settings
    ? settings
    : {
        dots: false,
        infinite: sliderData && sliderData.length >= slidesToShow,
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
  if (!sliderData.length) {
    return <></>
  }
  return (
    <div className="container">
      <div className="featured-products bg-white text-center pb-5 pt-5">
        <h3 className="h3 mb-0">{title}</h3>
        {children}
        <Slider style={{ margin: '0 4rem', height: 'fit-content' }} className="row mt-4" {...settings}>
          {sliderData.map((slide, index) => {
            return <ProductCard {...slide} skuID={slide.defaultSku_skuID} listPrice={slide.defaultSku_listPrice} key={index} />
          })}
        </Slider>
      </div>
    </div>
  )
}
export default ProductSlider
