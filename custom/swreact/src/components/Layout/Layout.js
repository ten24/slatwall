import React, { useEffect } from 'react'
import { useDispatch } from 'react-redux'

import { Footer } from '..'
import { ToastContainer } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css'
import { getContent } from '../../actions/contentActions'
import { useLocation } from 'react-router'

const Layout = ({ children, actionBannerDisable }) => {
  const dispatch = useDispatch()
  let loc = useLocation()
  let path = loc.pathname.split('/').reverse()[0].toLowerCase()
  path = path.length ? path : 'home'
  let payload = {}
  payload.header = ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID']
  payload.footer = ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID']
  payload[path] = ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID']
  useEffect(() => {
    dispatch(
      getContent({
        content: payload,
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
