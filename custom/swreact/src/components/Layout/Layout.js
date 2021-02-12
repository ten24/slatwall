import React, { useEffect } from 'react'
import { connect, useDispatch } from 'react-redux'

import { Footer } from '..'
import { ToastContainer } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'
import { getContent } from '../../actions/contentActions'

const Layout = ({ children, actionBannerDisable }) => {
  const dispatch = useDispatch()

  useEffect(() => {
    dispatch(
      getContent({
        content: {
          footer: ['contentID', 'urlTitle', 'title', 'sortOrder', 'customBody'],
          header: ['contentID', 'urlTitle', 'title', 'sortOrder', 'customBody'],
        },
      })
    )
  }, [dispatch])

  return (
    <>
      <ToastContainer />
      <div style={{ minHeight: '800px' }}>{children}</div>
      <Footer actionBannerDisable={actionBannerDisable} />
    </>
  )
}

export default Layout
