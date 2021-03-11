import React, { useEffect, useState } from 'react'
import { useDispatch } from 'react-redux'
import { getContent } from '../../actions/contentActions'
import { useHistory, useLocation } from 'react-router'

const CMSWrapper = ({ children }) => {
  const dispatch = useDispatch()
  const { pathname } = useLocation()
  const history = useHistory()

  let path = pathname.split('/').reverse()[0].toLowerCase()
  path = path.length ? path : 'home'
  let payload = {}
  payload.header = ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID']
  payload.footer = ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID']
  payload[path] = ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID']
  payload['404'] = ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID']

  useEffect(() => {
    dispatch(
      getContent({
        content: payload,
      })
    )
    history.listen(location => {
      payload = {}
      path = location.pathname.split('/').reverse()[0].toLowerCase()
      payload[path] = ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID']
      dispatch(
        getContent({
          content: payload,
        })
      )
    })
  }, [dispatch])

  return <>{children}</>
}

export default CMSWrapper
