import React from 'react'
import Slider from 'react-slick'
import { SWImage } from '..'
import { useSelector } from 'react-redux'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useGetBrands } from '../../hooks/useAPI'
import { useEffect } from 'react'
import { getShopBy } from '../../selectors/contentSelectors'
import { getBrandRoute } from '../../selectors/configurationSelectors'

const BandSlide = ({ brandLogo, urlTitle = '', title, customPath = '/custom/assets/files/associatedimage/' }) => {
  const brand = useSelector(getBrandRoute)
  return (
    <div className="repeater">
      <div className="brand-box bg-white box-shadow-sm rounded-lg m-3">
        <Link className="d-block p-4" to={`/${brand}/${urlTitle}`}>
          <SWImage className="d-block mx-auto" customPath={customPath} src={brandLogo} alt={title} />
        </Link>
      </div>
    </div>
  )
}

const getBrandLogo = brand => {
  const attr = brand.attributes.filter(attribute => {
    return attribute.attributeCode === 'brandLogo'
  })
  if (attr.length > 0) {
    return attr[0].attributeValue
  } else if (brand.imagePath) {
    return brand.imagePath.split('/').reverse()[0]
  }
  return ''
}

const HomeBrand = props => {
  const { t } = useTranslation()
  let [brand, setRequest] = useGetBrands()
  const shopBy = useSelector(getShopBy)

  useEffect(() => {
    let didCancel = false
    if (!brand.isFetching && !brand.isLoaded && !didCancel) {
      setRequest({ ...brand, isFetching: true, isLoaded: false, params: { 'f:brandFeatured': 1, 'f:activeFlag': 1 }, makeRequest: true })
    }
    return () => {
      didCancel = true
    }
  }, [brand, setRequest])

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
      <h3 className="h3">{shopBy.title}</h3>
      <Slider {...settings}>
        {brand.isLoaded &&
          brand.data.map((slide, index) => {
            return <BandSlide key={slide.brandID} {...slide} customPath="/custom/assets/images/brand/logo/" brandLogo={getBrandLogo(slide)} />
          })}
      </Slider>

      <Link className="btn btn-primary mt-3 btn-long" to={shopBy.linkUrl}>
        {t('frontend.home.more_brands')}
      </Link>
    </div>
  )
}

export default HomeBrand
