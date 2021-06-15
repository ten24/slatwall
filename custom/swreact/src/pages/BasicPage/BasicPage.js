import { useEffect, useState } from 'react'
import { useSelector } from 'react-redux'
import { useHistory, useLocation } from 'react-router-dom'
import { ListingGrid, ListingPagination } from '../../components'
import { useGetProducts } from '../../hooks/useAPI'
import queryString from 'query-string'

const BasicPage = () => {
  let history = useHistory()
  let loc = useLocation()
  let params = queryString.parse(loc.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
  const content = useSelector(state => state.content[loc.pathname.substring(1)])
  const { title, customBody } = content || {}
  const [path, setPath] = useState(loc.search)
  let [request, setRequest] = useGetProducts(params)
  const setPage = pageNumber => {
    params['currentPage'] = pageNumber
    request.data.currentPage = pageNumber
    setRequest({ ...request, params: { currentPage: pageNumber, content_id: content.contentID, includePotentialFilters: false }, makeRequest: true, isFetching: true, isLoaded: false })
  }

  useEffect(() => {
    let didCancel = false
    if (!didCancel && ((!request.isFetching && !request.isLoaded) || loc.search !== path) && content.productListingPageFlag) {
      setPath(loc.search)
      setRequest({ ...request, params: { ...params, content_id: content.contentID, includePotentialFilters: false }, makeRequest: true, isFetching: true, isLoaded: false })
    }
    return () => {
      didCancel = true
    }
  }, [request, setRequest, params, loc, path, content])

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
          className="content-body mb-5"
          onClick={event => {
            event.preventDefault()
            if (event.target.getAttribute('href')) {
              if (event.target.getAttribute('href').includes('http')) {
                window.location.href = event.target.getAttribute('href')
              } else {
                history.push(event.target.getAttribute('href'))
              }
            }
          }}
          dangerouslySetInnerHTML={{
            __html: customBody || '',
          }}
        />
        {content.productListingPageFlag && (
          <div className="col">
            <ListingGrid isFetching={request.isFetching} pageRecords={request.data.pageRecords} />
            <ListingPagination recordsCount={request.data.recordsCount} currentPage={request.data.currentPage} totalPages={request.data.totalPages} setPage={setPage} />
          </div>
        )}
      </div>
    </div>
  )
}

export default BasicPage
