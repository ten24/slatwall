import { useSelector } from 'react-redux'
import defaultImg from '../../assets/images/default.png'

const DefaultImage = ({ alt = '', style }) => {
  return <img style={style} src={defaultImg} alt={alt} />
}
const SWImage = ({ className, customPath, src, alt = '', style = {} }) => {
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
          e.target.src = defaultImg
        }}
      />
    )
  }
  return <DefaultImage style={style} />
}

export default SWImage
