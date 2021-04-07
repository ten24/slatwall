import { useEffect } from 'react'
import { useSelector } from 'react-redux'
import { useHistory, useLocation } from 'react-router-dom'
import { SWImage } from '../../components'
import { useGetEntity } from '../../hooks'
import { Link } from 'react-router-dom'
import { getBrandRoute } from '../../selectors/configurationSelectors'

const Manufacturer = () => {
  let history = useHistory()
  let loc = useLocation()
  const content = useSelector(state => state.content[loc.pathname.substring(1)])
  const brandRoute = useSelector(getBrandRoute)
  const { title, customBody } = content || {}
  let [request, setRequest] = useGetEntity()

  useEffect(() => {
    let didCancel = false
    if (!request.isFetching && !request.isLoaded && !didCancel) {
      setRequest({ ...request, isFetching: true, isLoaded: false, entity: 'brand', params: { pageSize: 500 }, makeRequest: true })
    }
    return () => {
      didCancel = true
    }
  }, [request, setRequest])

  return (
    <div className="bg-light p-0">
      <div className="page-title-overlap bg-lightgray pt-4">
        <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
          <div className="order-lg-1 pr-lg-4 text-center">
            <h1 className="h3 text-dark mb-0 font-accent">{title || ''}</h1>
          </div>
        </div>
      </div>
      <div className="container bg-light box-shadow-lg rounded-lg p-5">
        <div
          className="content-body"
          onClick={event => {
            event.preventDefault()
            if (event.target.getAttribute('href')) {
              history.push(event.target.getAttribute('href'))
            }
          }}
          dangerouslySetInnerHTML={{
            __html: customBody || '',
          }}
        />
        {customBody && <hr />}
        <div className="container pb-4 pb-sm-5">
          <div className="row pt-5">
            {request.isLoaded &&
              request.data
                .sort((a, b) => (a.brandName > b.brandName ? 1 : -1))
                .reduce((acc, element) => {
                  if (element.brandFeatured.trim() === 'Yes') {
                    return [element, ...acc]
                  }
                  return [...acc, element]
                }, [])
                .map(brand => {
                  return (
                    <div key={brand.brandID} className="col-md-4 col-sm-6 mb-3">
                      <div className="card border-0">
                        <Link className="d-block overflow-hidden rounded-lg" to={`/${brandRoute}/${brand.urlTitle}`}>
                          <SWImage className="d-block w-100" customPath="/custom/assets/files/brandlogo/" src={brand.brandLogo} alt={brand.brandName} />
                        </Link>
                      </div>
                    </div>
                  )
                })}
          </div>
        </div>
      </div>
    </div>
  )
}

export default Manufacturer
