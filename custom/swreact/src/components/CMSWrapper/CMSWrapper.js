import React, { useEffect, useState } from 'react'
import { useDispatch } from 'react-redux'
import { getPageContent } from '../../actions/contentActions'
import { useHistory, useLocation } from 'react-router'
import { getFavouriteProducts } from '../../actions/userActions'

const CMSWrapper = ({ children }) => {
  const dispatch = useDispatch()
  const { pathname } = useLocation()
  const history = useHistory()
  const [isLoaded, setIsLoaded] = useState(false)
  let basePath = pathname.split('/')[1].toLowerCase()
  basePath = basePath.length ? basePath : 'home'

  useEffect(() => {
    if (!isLoaded) {
      dispatch(getFavouriteProducts())
      dispatch(
        getPageContent(
          {
            'f:urlTitlePath:like': `header%`,
          },
          'header'
        )
      )
      dispatch(
        getPageContent(
          {
            'f:urlTitlePath:like': `404%`,
          },
          '404'
        )
      )
      dispatch(
        getPageContent(
          {
            'f:urlTitlePath:like': `footer%`,
          },
          'footer'
        )
      )
      dispatch(
        getPageContent(
          {
            'f:urlTitlePath:like': `${basePath}%`,
          },
          basePath
        )
      )
      setIsLoaded(true)
    }
  }, [dispatch, history, basePath, isLoaded])

  useEffect(() => {
    const unload = history.listen(location => {
      let newPath = location.pathname.split('/').reverse()[0].toLowerCase()
      newPath = newPath.length ? newPath : 'home'
      dispatch(
        getPageContent(
          {
            'f:urlTitlePath:like': `${newPath}%`,
          },
          newPath
        )
      )
    })
    return () => {
      unload()
    }
  }, [dispatch, history, basePath])

  return <>{children}</>
}

export default CMSWrapper
