import React, { useEffect } from 'react'
import { SWImage } from '../../components'
import { useGetEntity } from '../../hooks/useAPI'
const BrandBanner = ({ brandCode }) => {
  let [request, setRequest] = useGetEntity()

  useEffect(() => {
    let didCancel = false
    if (!request.isFetching && !request.isLoaded && !didCancel) {
      setRequest({ ...request, isFetching: true, isLoaded: false, entity: 'brand', params: { 'f:urlTitle': brandCode }, makeRequest: true })
    }
    return () => {
      didCancel = true
    }
  }, [request, brandCode, setRequest])

  return (
    <>
      {request.isLoaded && request.data[0] && (
        <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
          <SWImage style={{ maxHeight: '150px', marginRight: '50px' }} customPath="/custom/assets/images/brand/logo/" src={request.data[0].imageFile} alt={request.data.brandName} />
          <p dangerouslySetInnerHTML={{ __html: request.data[0].brandDescription }} />
        </div>
      )}
    </>
  )
}

export default BrandBanner
