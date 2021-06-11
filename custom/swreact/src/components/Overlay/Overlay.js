import LoadingOverlay from 'react-loading-overlay'

const Overlay = ({ children, ...props }) => {
  return <LoadingOverlay {...props}>{children}</LoadingOverlay>
}

export { Overlay }
