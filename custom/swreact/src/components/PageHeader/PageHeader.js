import { BreadCrumb } from '../../components'
import { useSelector } from 'react-redux'
import { useLocation } from 'react-router-dom'

const PageHeader = ({ title, children, ...props }) => {
  let loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const contentStore = useSelector(state => state.content[path]) || {}
  return (
    <div className="page-title-overlap bg-lightgray pt-4">
      <div className="container d-lg-flex justify-content-between">
        <BreadCrumb {...props} />
        <div className="order-lg-1 pr-lg-4 text-center text-lg-left flex-1">
          <h1 className="h3 text-dark mb-0 font-accent">{title || contentStore.title || ''}</h1>
          {children}
        </div>
      </div>
    </div>
  )
}

export { PageHeader }
