import { BreadCrumb } from '../../components'
import { useSelector } from 'react-redux'
import { useLocation } from 'react-router-dom'

const PageHeader = ({ children }) => {
  let loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const contentStore = useSelector(state => state.content[path]) || {}
  return (
    <div className="page-title-overlap bg-lightgray pt-4">
      <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <BreadCrumb />
        </div>
        <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 className="h3 text-dark mb-0 font-accent">{contentStore.title || ''}</h1>
        </div>
      </div>
      {children}
    </div>
  )
}

export default PageHeader
