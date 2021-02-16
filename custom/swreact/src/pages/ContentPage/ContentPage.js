import { useSelector, useDispatch } from 'react-redux'
import { Layout } from '../../components'
import React, { useEffect, useState } from 'react'
import { addContent } from '../../actions/contentActions'
import { sdkURL } from '../../services'
import axios from 'axios'
import { useLocation } from 'react-router'
import NotFound from '../NotFound/NotFound'
import BasicPageWithSidebar from '../BasicPageWithSidebar/BasicPageWithSidebar'
import BasicPage from '../BasicPage/BasicPage'

const pageComponents = {
  BasicPageWithSidebar,
  BasicPage,
  NotFound,
}

const Loading = () => {
  return <Layout></Layout>
}
const ContentPage = () => {
  let loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const dispatch = useDispatch()
  const { siteCode } = useSelector(state => state.configuration.site)
  const [content, setContent] = useState({ isFetching: false, isLoaded: false, component: Loading, path })

  // this is needed to make sure we refresh if page location changes
  if (path !== content.path && content.isLoaded && !content.isFetching) {
    setContent({ component: Loading, isFetching: false, isLoaded: false, path })
  }
  useEffect(() => {
    let payload = {}
    let didCancel = false

    payload[path] = ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage']
    if (!content.isFetching && !content.isLoaded) {
      axios({
        method: 'POST',
        withCredentials: true,
        url: `${sdkURL}api/scope/getSlatwallContent`,
        headers: {
          'Content-Type': 'application/json',
        },
        data: { siteCode, content: payload },
      }).then(response => {
        if (response.status === 200 && response.data.content[path]) {
          dispatch(addContent(response.data.content))
          if (!didCancel) {
            const template = response.data.content[path].setting.contentTemplateFile.replace('.cfm', '')

            if (Object.keys(pageComponents).includes(template)) {
              setContent({ component: pageComponents[template], isFetching: false, isLoaded: true, path })
            } else {
              setContent({ component: NotFound, isFetching: false, isLoaded: true, path })
            }
          }
        } else {
          setContent({ component: NotFound, isFetching: false, isLoaded: true, path })
        }
      })
    }
    return () => {
      didCancel = true
    }
  }, [dispatch, setContent, content, siteCode, path])
  return <Layout>{!content.isFetching && content.isLoaded && React.createElement(content.component)}</Layout>
}

export default ContentPage
