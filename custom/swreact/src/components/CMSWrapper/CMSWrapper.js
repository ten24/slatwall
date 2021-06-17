import React, { useEffect, useState } from 'react'
import { useDispatch } from 'react-redux'
import { useHistory, useLocation } from 'react-router'
import { getWishLists, getPageContent } from '../../actions/'

const CMSWrapper = ({ children }) => {
  const dispatch = useDispatch()
  const { pathname } = useLocation('home')
  const history = useHistory()
  const [isLoaded, setIsLoaded] = useState(false)
  const [currentPath, setCurrentPath] = useState(pathname)

  useEffect(() => {
    if (!isLoaded) {
      let basePath = pathname.split('/')[1].toLowerCase()
      basePath = basePath.length ? basePath : 'home'
      dispatch(getWishLists())
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
  }, [dispatch, history, pathname, isLoaded])

  useEffect(() => {
    const unload = history.listen(location => {
      if (location.pathname !== currentPath) {
        let newPath = location.pathname.split('/').reverse()[0].toLowerCase()
        newPath = newPath.length ? newPath : 'home'
        setCurrentPath(location.pathname)
        dispatch(
          getPageContent(
            {
              'f:urlTitlePath:like': `${newPath}%`,
            },
            newPath
          )
        )
      }
    })
    return () => {
      unload()
    }
  }, [dispatch, history, setCurrentPath, currentPath])

  return <>{children}</>
}

export { CMSWrapper }
