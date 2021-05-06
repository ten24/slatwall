import { useEffect, useState } from 'react'
import { useSelector } from 'react-redux'
import { useHistory, useLocation } from 'react-router-dom'
import { Layout, ListingPagination, SWImage } from '../../components'
import { useGetEntity } from '../../hooks'
import { Link } from 'react-router-dom'
import { getBrandRoute } from '../../selectors/configurationSelectors'

const Manufacturer = () => {
  let history = useHistory()
  let loc = useLocation()
  const gridSize = 3
  const countToDisplay = gridSize * 4
  const content = useSelector(state => state.content[loc.pathname.substring(1)])
  const brandRoute = useSelector(getBrandRoute)
  const [currentPage, setPage] = useState(1)
  const { title, customBody } = content || {}
  let [request, setRequest] = useGetEntity()

  useEffect(() => {
    let didCancel = false
    if (!request.isFetching && !request.isLoaded && !didCancel) {
      setRequest({ ...request, isFetching: true, isLoaded: false, entity: 'brand', params: { 'P:Show': 500, 'f:activeFlag': 1 }, makeRequest: true })
    }
    return () => {
      didCancel = true
    }
  }, [request, setRequest])

  const sortedList = [
    ...request.data
      .filter(element => {
        return element.brandFeatured === true
      })
      .sort((a, b) => (a.brandName > b.brandName ? 1 : -1)),
    ...request.data
      .filter(element => {
        return element.brandFeatured !== true
      })
      .sort((a, b) => (a.brandName > b.brandName ? 1 : -1)),
  ]
  const start = (currentPage - 1) * countToDisplay
  const end = start + countToDisplay
  return (
    <Layout>
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
          <div className="pb-4 pb-sm-5">
            <div className="row">
              {request.isLoaded &&
                sortedList.slice(start, end).map(brand => {
                  return (
                    <div key={brand.brandID} className="d-flex col-6 col-sm-4 col-md-3 col-lg-2 mb-4">
                      <Link className="card border-1 shadow-sm text-center d-flex flex-column rounded-lg hover-shadow-none" to={`/${brandRoute}/${brand.urlTitle}`}>
                        <div className="d-flex align-items-center flex-1">
                          <SWImage className="d-block w-100 p-2" customPath="/custom/assets/images/brand/logo/" src={brand.imageFile} alt={brand.brandName} />
                        </div>
                        <h2 className="h6 mx-1">{brand.brandName}</h2>
                      </Link>
                    </div>
                  )
                })}
            </div>
          </div>
          <div className="container">
            <ListingPagination recordsCount={sortedList.length} currentPage={currentPage} totalPages={Math.ceil(sortedList.length / countToDisplay)} setPage={setPage} />
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default Manufacturer
