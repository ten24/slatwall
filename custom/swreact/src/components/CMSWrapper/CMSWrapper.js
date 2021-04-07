import React, { useEffect } from 'react'
import { useDispatch } from 'react-redux'
import { getContent } from '../../actions/contentActions'
import { useHistory, useLocation } from 'react-router'
import { getFavouriteProducts } from '../../actions/userActions'

let payload = {
  header: ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID'],
  footer: ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID'],
  '404': ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID'],
}

const CMSWrapper = ({ children }) => {
  const dispatch = useDispatch()
  const { pathname } = useLocation()
  const history = useHistory()

  let path = pathname.split('/').reverse()[0].toLowerCase()
  path = path.length ? path : 'home'

  payload[path] = ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID']

  useEffect(() => {
    dispatch(getFavouriteProducts())
    dispatch(
      getContent({
        content: payload,
      })
    )
    history.listen(location => {
      let NewPayload = {}
      let newPath = location.pathname.split('/').reverse()[0].toLowerCase()
      newPath = newPath.length ? newPath : 'home'
      NewPayload[newPath] = ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID']
      dispatch(getFavouriteProducts())
      dispatch(
        getContent({
          content: NewPayload,
        })
      )
    })
  }, [dispatch, history])

  return <>{children}</>
}

export default CMSWrapper
