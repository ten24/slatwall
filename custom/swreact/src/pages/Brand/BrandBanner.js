import React, { useEffect, useState } from 'react'
import axios from 'axios'
import { sdkURL } from '../../services'
import { SWImage } from '../../components'
const BrandBanner = ({ brandCode }) => {
  const [data, setData] = useState({ brand: {}, isLoaded: false, brandCode })

  useEffect(() => {
    let didCancel = false
    if (!data.isLoaded) {
      axios({
        method: 'POST',
        withCredentials: true,
        url: `${sdkURL}api/scope/getBrand`,
        headers: {
          'Content-Type': 'application/json',
        },
        data: {
          urlPath: data.brandCode,
        },
      }).then(response => {
        if (response.status === 200 && !didCancel) {
          setData({
            brand: response.data.brand,
            isLoaded: true,
          })
        } else {
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
      <p>{data.brandDescription}</p>
    </div>
  )
}

export default BrandBanner
