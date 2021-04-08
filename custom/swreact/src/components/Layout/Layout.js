import { Footer } from '..'
import { ToastContainer } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'

const Layout = ({ children }) => {
  return (
    <>
      <ToastContainer />
      <div style={{ minHeight: '800px' }}>{children}</div>
      <Footer />
    </>
  )
}

export default Layout
