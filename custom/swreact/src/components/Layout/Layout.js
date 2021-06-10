import { Footer } from '..'
import { ToastContainer } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'

const Layout = ({ classNameList, children }) => {
  return (
    <>
      <ToastContainer />
      <div style={{ minHeight: '800px' }} className={classNameList}>{children}</div>
      <Footer />
    </>
  )
}

export default Layout
