import React, { useEffect, useState } from 'react'
import { SlatwalApiService } from '../../services'

const GeneralDataComponent = ({ ID }) => {
  const [data, setData] = useState({ content: [], isLoaded: false, ID })
  if (data.productID !== ID) {
    setData({ content: [], isLoaded: false, ID })
  }
  useEffect(() => {
    let didCancel = false
    // if (!data.isLoaded) {
    //   SlatwalApiService.products.getGallery({ ID }).then(response => {
    //     if (response.isSuccess() && !didCancel) {
    //       setData({
    //         ...data,
    //         isLoaded: true,
    //         content: response.success().data,
    //       })
    //     } else if (response.isFail() && !didCancel) {
    //       setData({
    //         ...data,
    //         isLoaded: true,
    //       })
    //     }
    //   })
    // }

    return () => {
      didCancel = true
    }
  }, [data, ID, setData])

  return <></>
}
export default GeneralDataComponent
