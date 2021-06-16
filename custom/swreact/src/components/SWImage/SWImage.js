import { useSelector } from 'react-redux'
import defaultMissing from '../../assets/images/missing.png'
import defaultMissingBrand from '../../assets/images/missing-brand.png'
import defaultMissingProductType from '../../assets/images/missing-product-type.png'
import defaultMissingProduct from '../../assets/images/missing-product.png'

const DefaultImage = ({ alt = '', style, type, className = '' }) => {
  if (type === 'product') {
    return <img className={className} style={style} src={defaultMissingProduct} alt={alt} />
  } else if (type === 'productType') {
    return <img className={className} style={style} src={defaultMissingProductType} alt={alt} />
  } else if (type === 'brand') {
    return <img className={className} style={style} src={defaultMissingBrand} alt={alt} />
  }
  return <img className={className} style={style} src={defaultMissing} alt={alt} />
}
const SWImage = ({ className, customPath, src, alt = '', style = {}, type = 'product' }) => {
  const { host, basePath } = useSelector(state => state.configuration.theme)

  const path = customPath ? customPath : basePath
  if (src) {
    return (
      <img
        className={className}
        src={path ? host + path + src : host + src}
        alt={alt}
        style={style}
        onError={e => {
          e.preventDefault()
          e.target.onerror = null
          if (type === 'product') {
            e.target.src = defaultMissingProduct
          } else if (type === 'productType') {
            e.target.src = defaultMissingProductType
          } else if (type === 'brand') {
            e.target.src = defaultMissingBrand
          } else {
            e.target.src = defaultMissing
          }
        }}
      />
    )
  }
  return <DefaultImage className={className} style={style} type={type} />
}

export { SWImage }
