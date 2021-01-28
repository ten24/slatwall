import Slider from 'react-slick'
import ProductCard from '../Account/ProductCard/ProductCard'
const ProductSlider = ({ children, sliderData, settings, title, slidesToShow = 4 }) => {
  settings = settings
    ? settings
    : {
        dots: false,
        infinite: sliderData && sliderData >= slidesToShow,
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
  console.log('sliderData', sliderData)

  return (
    <div className="container">
      <div className="featured-products bg-white text-center pb-5 pt-5">
        <h3 className="h3 mb-0">{title}</h3>
        {children}
        <Slider style={{ margin: '0 4rem', height: 'fit-content' }} className="row mt-4" {...settings}>
          {sliderData &&
            sliderData.map((slide, index) => {
              return <ProductCard {...slide} key={index} />
            })}
        </Slider>
      </div>
    </div>
  )
}
export default ProductSlider
