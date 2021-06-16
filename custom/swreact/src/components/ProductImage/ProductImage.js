import React, { useEffect } from 'react'
import { SWImage } from '..'
import { useResizedImageByProfileName } from '../../hooks/'
import { useSelector } from 'react-redux'
import { getImageFallbackFlag } from '../../selectors'
import ContentLoader from 'react-content-loader'

const ImageSkeleton = props => {
  return (
    <ContentLoader speed={2} width={200} height={200} viewBox="0 0 200 200" backgroundColor="#f3f3f3" foregroundColor="#dedede" {...props}>
      <rect x="0" y="0" rx="44" ry="44" width="200" height="200" />
    </ContentLoader>
  )
}

const ProductImage = ({ skuID, imageFile, defaultSku_imageFile, customPath, forceImageCall = false }) => {
  const imageFallbackFlag = useSelector(getImageFallbackFlag)
  let [request, setRequest] = useResizedImageByProfileName()
  const callForImage = (!imageFile || !defaultSku_imageFile) && (imageFallbackFlag || forceImageCall)
  useEffect(() => {
    let didCancel = false
    if (!didCancel && !request.isFetching && !request.isLoaded && callForImage) {
      setRequest({
        ...request,
        params: { skuIDs: skuID, profileName: 'listing' },
        makeRequest: true,
        isFetching: true,
        isLoaded: false,
      })
    }
    return () => {
      didCancel = true
    }
  }, [request, setRequest, skuID, callForImage])

  return (
    <>
      {!callForImage && <SWImage customPath={customPath ? customPath : 'custom/assets/images/product/default/'} src={imageFile || defaultSku_imageFile} alt="Product" />}
      {callForImage && request.isLoaded && <SWImage customPath="/" src={request.data[skuID]} alt="Product" />}
      {/* {callForImage && request.isFetching && <ImageSkeleton />} */}
    </>
  )
}

export { ProductImage }
