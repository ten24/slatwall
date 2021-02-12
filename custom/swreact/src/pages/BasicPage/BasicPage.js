import React, { useEffect, useState } from 'react'
import { Layout } from '../../components'
import { useSelector, useDispatch } from 'react-redux'
import { useHistory, useLocation } from 'react-router-dom'
import { getPageContent } from '../../actions/contentActions'

const BasicPage = () => {
  let history = useHistory()
  const dispatch = useDispatch()
  let loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0]
  const contentStore = useSelector(state => state.content)

  const [content, setContent] = useState({ isFetching: false, isLoaded: false, path })
  if (contentStore[path] && content.isFetching) {
    setContent({ ...contentStore[path], isFetching: false, isLoaded: true, path })
  }

  useEffect(() => {
    let payload = {}
    payload[path] = ['title', 'customSummary', 'customBody', 'contentID', 'urlTitlePath', 'urlTitle', 'sortOrder', 'linkUrl', 'linkLabel', 'associatedImage']
    if (!content.isFetching && !content.isLoaded) {
      dispatch(
        getPageContent(
          {
            content: payload,
          },
          `${path}`
        )
      )
      setContent({ ...content, isFetching: true })
    }
  }, [dispatch, path, setContent, content])
  return (
    <Layout>
      <div className="bg-light p-0">
        <div className="page-title-overlap bg-lightgray pt-4">
          <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
            <div className="order-lg-1 pr-lg-4 text-center">{content.isLoaded && <h1 className="h3 text-dark mb-0 font-accent">{content.title || ''}</h1>} </div>
          </div>
        </div>
        {content.isLoaded && (
          <div
            className="container bg-light box-shadow-lg rounded-lg p-5"
            onClick={event => {
              event.preventDefault()
              if (event.target.getAttribute('href')) {
                history.push(event.target.getAttribute('href'))
              }
            }}
            dangerouslySetInnerHTML={{
              __html: content.customBody || '',
            }}
          ></div>
        )}
      </div>
    </Layout>
  )
}

export default BasicPage
