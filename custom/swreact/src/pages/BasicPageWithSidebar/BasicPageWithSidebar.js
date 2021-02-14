import React, { useEffect, useState } from 'react'
import { Layout } from '../../components'
import { useSelector, useDispatch } from 'react-redux'
import { useHistory, useLocation } from 'react-router-dom'
import { getPageContent } from '../../actions/contentActions'
import Sidebar from './Sidebar'
import ContactForm from './ContactForm'

const BasicPageWithSidebar = () => {
  let history = useHistory()
  const dispatch = useDispatch()
  let loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0]
  const contentStore = useSelector(state => state.content)

  const [content, setContent] = useState({ isFetching: false, isLoaded: false, path })
  if (contentStore[path] && content.isFetching) {
    setContent({ ...contentStore[path], isFetching: false, isLoaded: true, path })
  }
  const { form } = contentStore

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
      {content.isLoaded && (
        <>
          <div className="page-title-overlap bg-lightgray pt-4 pb-5">
            <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
              <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
                <h1 className="h3 mb-0">{content.title}</h1>
              </div>
            </div>
          </div>
          <div className="container pb-5 mb-2 mb-md-3">
            <div className="row">
              <section className="col-lg-8">
                <div className="mt-5 pt-5">
                  <div
                    onClick={event => {
                      event.preventDefault()
                      if (event.target.getAttribute('href')) {
                        history.push(event.target.getAttribute('href'))
                      }
                    }}
                    dangerouslySetInnerHTML={{
                      __html: content.customSummary || '',
                    }}
                  />

                  <ContactForm />
                </div>
              </section>
              <Sidebar />
            </div>
          </div>
        </>
      )}
    </Layout>
  )
}

export default BasicPageWithSidebar
