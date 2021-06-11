import Slider from 'react-slick'
import { useSelector } from 'react-redux'
import { useHistory } from 'react-router-dom'

const BannerSlide = ({ customBody, title, linkUrl, linkLabel, slideKey }) => {
  let history = useHistory()

  return (
    <div index={slideKey} className="repeater">
      <h2 className="h2">{title}</h2>
      <p
        onClick={event => {
          event.preventDefault()
          if (event.target.getAttribute('href')) {
            history.push(event.target.getAttribute('href'))
          }
        }}
        dangerouslySetInnerHTML={{ __html: customBody }}
      />
      {linkUrl && linkUrl.length > 0 && (
        <a href={linkUrl} className="btn btn-light btn-long">
          {linkLabel}
        </a>
      )}
    </div>
  )
}

const ContentSlider = () => {
  const contentStore = useSelector(state => state.content)
  const { host } = useSelector(state => state.configuration.theme)
  let homeMainBanner = []
  Object.keys(contentStore).forEach(key => {
    if (key.includes('main-banner-slider/')) {
      homeMainBanner.push(contentStore[key])
    }
  })
  const settings = {
    dots: true,
    infinite: false,
    slidesToShow: 1,
    slidesToScroll: 1,
    responsive: [
      {
        breakpoint: 768,
        settings: {
          arrows: false,
        },
      },
    ],
  }
  return (
    <div className="hero" style={{ backgroundImage: `linear-gradient(rgba(0, 0, 0, 0.6),rgba(0, 0, 0, 0.6)), url(${host}/custom/assets/files/associatedimage/${contentStore['home/main-banner-slider'] && contentStore['home/main-banner-slider'].associatedImage}` }}>
      <div className="container">
        <div style={{ height: 'fit-content' }} className="main-banner text-white text-center mx-md-5 pb-4">
          <Slider className="slider-dark" {...settings}>
            {homeMainBanner.length > 0 &&
              homeMainBanner.map((slideData, index) => {
                return <BannerSlide {...slideData} key={index} slideKey={index} />
              })}
          </Slider>
        </div>
      </div>
    </div>
  )
}

export { ContentSlider }
