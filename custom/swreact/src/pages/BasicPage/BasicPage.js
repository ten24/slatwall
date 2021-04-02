import { useSelector } from 'react-redux'
import { useHistory, useLocation } from 'react-router-dom'

const BasicPage = () => {
  let history = useHistory()
  let loc = useLocation()
  const content = useSelector(state => state.content[loc.pathname.substring(1)])
  const { title, customBody } = content || {}

  return (
    <div className="bg-light p-0">
      <div className="page-title-overlap bg-lightgray pt-4">
        <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
          <div className="order-lg-1 pr-lg-4 text-center">
            <h1 className="h3 text-dark mb-0 font-accent">{title || ''}</h1>
          </div>
        </div>
      </div>
      <div
        className="container bg-light box-shadow-lg rounded-lg p-5"
        onClick={event => {
          event.preventDefault()
          if (event.target.getAttribute('href')) {
            history.push(event.target.getAttribute('href'))
          }
        }}
        dangerouslySetInnerHTML={{
          __html: customBody || '',
        }}
      ></div>
    </div>
  )
}

export default BasicPage
