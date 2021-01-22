import React from 'react'
import { Footer, Header } from '..'
import SEO from '../SEO/SEO'
import { ToastContainer } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'

const Layout = ({ children, actionBannerDisable }) => {
  return (
    <>
      <SEO />
      <Header />
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
