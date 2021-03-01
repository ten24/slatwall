import React from 'react'
import Slider from 'react-slick'
import { SWImage } from '..'
import { useSelector } from 'react-redux'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useGetBrands } from '../../hooks/useAPI'
import { useEffect } from 'react'


const BandSlide = ({ associatedImage, linkUrl = '/all', title, slideKey }) => {
  return (
    <div index={slideKey} className="repeater">
      <div className="brand-box bg-white box-shadow-sm rounded-lg m-3">
        <Link className="d-block p-4" to={linkUrl}>
          <SWImage className="d-block mx-auto" customPath="/custom/assets/files/associatedimage/" src={associatedImage} alt={title} />
        </Link>
      </div>
    </div>
  )
}

const HomeBrand = (props) => {
  const { t, i18n } = useTranslation()
  let [brand, setRequest] = useGetBrands()
  console.log(brand);
  useEffect(() => {
    let didCancel = false
    if (!brand.isFetching && !brand.isLoaded && !didCancel) {
      setRequest({ ...brand, isFetching: true, isLoaded: false, params: { 'f:featuredBrand': 1 , 'f:activeFlag' : 1}, makeRequest: true })
    } 
    return () => {
      didCancel = true
    }
  }, [brand, setRequest])

  const homeBrand = useSelector(state => {
    return Object.keys(brand.data)
      .map(key => {
        return brand.data[key]
      })
  })

  const shopBy = useSelector(state => {
    return Object.keys(state.content)
      .filter(key => {
        return key === 'home/shop-by'
      })
      .map(key => {
        return state.content[key]
      })
  })
  const settings = {
    dots: false,
    infinite: true,
    slidesToShow: 4,
    slidesToScroll: 1,
    autoplay: true,
    autoplaySpeed: 3000,
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
    <div style={{ height: 'fit-content' }} className="home-brand container-slider container py-lg-4 mb-4 mt-4 text-center">
      <h3 className="h3">{shopBy.length > 0 && shopBy[0].title}</h3>
      <Slider {...settings}>
        {homeBrand &&
          homeBrand.map((slide, index) => {
          console.log('slide',slide);
            return <BandSlide {...slide} key={index} slideKey={index} />
          })}
      </Slider>
      {shopBy.length > 0 && (
        <Link className="btn btn-primary mt-3 btn-long" to={shopBy[0].linkUrl || '/'}>
          {t('frontend.home.more_brands')}
        </Link>
      )}
    </div>
  )
}

export default HomeBrand
