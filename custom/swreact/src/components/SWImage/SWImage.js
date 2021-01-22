import { connect } from 'react-redux'
import PropTypes from 'prop-types'

const LoadingImage = () => {
  return (
    <svg width="100%" height="100%" viewBox="0 0 100 100">
      <rect width="100" height="100" rx="10" ry="10" fill="#CCC" />
    </svg>
  )
}

const SWImage = ({ className, host, customPath, src, alt, basePath }) => {
  basePath = customPath ? customPath : basePath
  if (src) {
    return <img className={className} src={basePath ? host + basePath + src : host + src} alt={alt} />
  }
  return <LoadingImage />
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
  const { preload } = state
  return preload.theme
}
export default connect(mapStateToProps)(SWImage)
