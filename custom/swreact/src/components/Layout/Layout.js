import React, { useEffect } from 'react'
import { Footer } from '..'
import { ToastContainer } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'

const Layout = ({ children, actionBannerDisable }) => {
  return (
    <>
      <ToastContainer />
      {children}
      <Footer actionBannerDisable={actionBannerDisable} />
    </>
  )
}
// function mapStateToProps(state) {

//   return preload.navigation
// }

export default Layout
// export default connect(mapStateToProps)(Layout)
