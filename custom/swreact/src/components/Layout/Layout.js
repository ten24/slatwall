import React, { useEffect } from 'react'
import { useDispatch } from 'react-redux'

import { Footer } from '..'
import { ToastContainer } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'
import { getContent } from '../../actions/contentActions'
import { useLocation } from 'react-router'

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
