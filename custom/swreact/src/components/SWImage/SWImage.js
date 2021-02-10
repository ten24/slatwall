import { connect } from 'react-redux'
import PropTypes from 'prop-types'
import defaultImg from '../../assets/images/default.png'

const DefaultImage = ({ alt = '', style }) => {
  return <img style={style} src={defaultImg} alt={alt} />
}
const SWImage = ({ className, host, customPath, src, alt = '', basePath, style = {} }) => {
  basePath = customPath ? customPath : basePath
  if (src) {
    return (
      <img
        className={className}
        src={basePath ? host + basePath + src : host + src}
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
SWImage.propTypes = {
  src: PropTypes.string,
  alt: PropTypes.string,
  className: PropTypes.string,
  host: PropTypes.string,
  basePath: PropTypes.string,
  customPath: PropTypes.string,
}

function mapStateToProps(state) {
  return state.preload.theme
}
export default connect(mapStateToProps)(SWImage)
