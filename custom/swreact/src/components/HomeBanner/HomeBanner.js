import React, { useEffect } from 'react'
import Background from '../../assets/images/main-bg-img.jpg'
import Slider from 'react-slick'
import { useSelector } from 'react-redux'
import { useHistory } from 'react-router-dom'
import ProductSlider from '../ProductSlider/ProductSlider'
import { useGetEntity } from '../../hooks/useAPI'

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
      <a href={linkUrl} className="btn btn-light btn-long">
        {linkLabel}
      </a>
    </div>
  )
}

const MainBanner = () => {
  const contentStore = useSelector(state => state.content)

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
  )
}

const HomeBanner = () => {
  const home = useSelector(state => state.content['home'])
  let [request, setRequest] = useGetEntity()

  useEffect(() => {
    let didCancel = false
    if (!didCancel && !request.isFetching && !request.isLoaded) {
      setRequest({
        ...request,
        params: {
          'f:publishedFlag': 1,
          'f:productFeatured': 1,
        },
        entity: 'product',
        makeRequest: true,
        isFetching: true,
        isLoaded: false,
      })
    }
    return () => {
      didCancel = true
    }
  }, [request, setRequest])
  return (
    <div className="hero" style={{ backgroundImage: `linear-gradient(rgba(0, 0, 0, 0.6),rgba(0, 0, 0, 0.6)), url(${Background})` }}>
      <ProductSlider sliderData={request.data}>{home && <div dangerouslySetInnerHTML={{ __html: home.customBody }} />}</ProductSlider>
      <MainBanner />
    </div>
  )
}

export default HomeBanner
