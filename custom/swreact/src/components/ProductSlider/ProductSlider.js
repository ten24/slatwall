import Slider from 'react-slick'
import ProductCard from '../Account/ProductCard/ProductCard'

const ProductSlider = ({ children, sliderData, settings, title }) => {
  settings = settings
    ? settings
    : {
        dots: false,
        infinite: true,
        slidesToShow: 4,
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
      <div className="featured-products bg-white text-center pb-5 pt-5">
        <h3 className="h3 mb-0">{title}</h3>
        {/* <a href="/All" className="text-link">
                  Shop All Specials
        </a> */}
        {children}

        <Slider style={{ margin: '0 4rem', height: 'fit-content' }} className="row mt-4" {...settings}>
          {sliderData.map((slide, index) => {
            return <ProductCard {...slide} key={index} imgKey={index} />
          })}
        </Slider>
      </div>
    </div>
  )
}
export default ProductSlider
