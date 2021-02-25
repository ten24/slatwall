import React, { useEffect, useState } from 'react'
import { SlatwalApiService } from '../../services'
import { SWImage } from '../../components'
const BrandBanner = ({ brandCode }) => {
  const [data, setData] = useState({ brand: {}, isLoaded: false, brandCode })

  useEffect(() => {
    let didCancel = false
    if (!data.isLoaded) {
      SlatwalApiService.brand
        .list({
          perPage: 20,
          page: 1,
          filter: {
            urlTitle: data.brandCode,
          },
        })
        .then(response => {
          if (response.isSuccess() && response.success().pageRecords.length && !didCancel) {
            setData({
              brand: response.success().pageRecords[0],
              isLoaded: true,
            })
          } else if (!didCancel) {
            setData({
              ...data,
              isLoaded: true,
            })
          }
        })
    }

    return () => {
      didCancel = true
    }
  }, [data, setData])

  return (
    <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
      <SWImage style={{ maxHeight: '150px', marginRight: '50px' }} customPath="/custom/assets/files/associatedimage/" src={data.associatedImage} alt={data.brandCode} />
      <p>{data.brand.brandName}</p>
    </div>
  )
}

export default BrandBanner
