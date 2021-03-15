import React, { useEffect } from 'react'
import { SWImage } from '../../components'
import { useGetBrand } from '../../hooks/useAPI'
const BrandBanner = ({ brandCode }) => {
  let [brand, setRequest] = useGetBrand()

  useEffect(() => {
    let didCancel = false
    if (!brand.isFetching && !brand.isLoaded && !didCancel) {
      setRequest({ ...brand, isFetching: true, isLoaded: false, params: { 'f:urlTitle': brandCode }, makeRequest: true })
    } else {
    }
    return () => {
      didCancel = true
    }
  }, [brand, setRequest])

  return (
    <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
      <SWImage style={{ maxHeight: '150px', marginRight: '50px' }} customPath="/custom/assets/files/associatedimage/" src={brand.data.associatedImage} alt={brand.data.brandCode} />
      <p>{brand.data.brandName}</p>
    </div>
  )
}

export default BrandBanner
