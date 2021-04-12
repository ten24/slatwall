import { useSelector } from 'react-redux'
import { useHistory, useLocation } from 'react-router-dom'
import Sidebar from './Sidebar'
import ContactForm from './ContactForm'

const BasicPageWithSidebar = () => {
  let history = useHistory()
  let loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const contentStore = useSelector(state => state.content[path]) || {}
  const { title, customSummary } = contentStore

  return (
    <>
      <div className="page-title-overlap bg-lightgray pt-4 pb-5">
        <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
          <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
            <h1 className="h3 mb-0">{title || ''}</h1>
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
                  __html: customSummary || '',
                }}
              />

              <ContactForm />
            </div>
          </section>
          <Sidebar />
        </div>
      </div>
    </>
  )
}

export default BasicPageWithSidebar
