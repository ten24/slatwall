import React, { useEffect } from 'react'
import { useDispatch } from 'react-redux'
import { getContent } from '../../actions/contentActions'
import { useHistory, useLocation } from 'react-router'
import { getFavouriteProducts } from '../../actions/userActions'

const basicProperties = ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage', 'parentContentID', 'productListingPageFlag', 'displayInNavigation']

let payload = {
  header: basicProperties,
  footer: basicProperties,
  '404': basicProperties,
}

const CMSWrapper = ({ children }) => {
  const dispatch = useDispatch()
  const { pathname } = useLocation()
  const history = useHistory()

  let path = pathname.split('/').reverse()[0].toLowerCase()
  let basePath = pathname.split('/')[1].toLowerCase()
  path = path.length ? path : 'home'
  basePath = basePath.length ? basePath : 'home'
  if (path !== basePath) {
    payload[basePath] = basicProperties
  }
  payload[path] = basicProperties

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
      NewPayload[newPath] = basicProperties
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
