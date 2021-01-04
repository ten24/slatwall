import React from 'react'
import { Footer, Header } from '..'
import SEO from '../SEO/SEO'

const Layout = ({ children }) => {
  return (
    <>
      <SEO />
      <Header />
      {children}
      <Footer />
    </>
  )
}
// function mapStateToProps(state) {

//   return preload.navigation
// }

export default Layout
// export default connect(mapStateToProps)(Layout)
