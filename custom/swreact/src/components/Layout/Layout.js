import React from 'react'
import { Footer } from '..'

const Layout = ({ children, actionBannerDisable }) => {
  return (
    <>
      {children}
      <Footer actionBannerDisable={actionBannerDisable} />
    </>
  )
}

export default Layout
