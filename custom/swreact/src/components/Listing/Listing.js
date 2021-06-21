import React, { useEffect, useState } from 'react'
import { useHistory, useLocation } from 'react-router-dom'

import { ListingSidebar, ListingPaginationModern, ListingToolBar, ListingGrid } from '..'
import queryString from 'query-string'
import { useGetProducts } from '../../hooks/'

const processQueryParameters = params => {
  return queryString.parse(params, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
}
const buildPath = params => {
  return queryString.stringify(params, { arrayFormat: 'comma' })
}
const initialData = { brand: '', orderBy: 'product.productFeaturedFlag|DESC,product.productName|ASC', pageSize: 12, currentPage: 1, keyword: '' }

const Listing = ({ preFilter, hide = [] }) => {
  const loc = useLocation()
  let history = useHistory()
  let params = processQueryParameters(loc.search)
  params = { ...initialData, ...params, ...preFilter }
  const [path, setPath] = useState(loc.search)
  let [request, setRequest] = useGetProducts(params)

  const setPage = pageNumber => {
    params['currentPage'] = pageNumber
    history.push({
      pathname: loc.pathname,
      search: buildPath(params, { arrayFormat: 'comma' }),
    })
  }
  const setKeyword = keyword => {
    params['keyword'] = keyword
    params['currentPage'] = 1
    history.push({
      pathname: loc.pathname,
      search: buildPath(params, { arrayFormat: 'comma' }),
    })
  }
  const setSort = orderBy => {
    params['orderBy'] = orderBy
    params['currentPage'] = 1
    history.push({
      pathname: loc.pathname,
      search: buildPath(params, { arrayFormat: 'comma' }),
    })
  }
  const updateAttribute = attribute => {
    if (params[attribute.filterName]) {
      if (params[attribute.filterName].includes(attribute.name)) {
        if (Array.isArray(params[attribute.filterName])) {
          params[attribute.filterName] = params[attribute.filterName].filter(item => item !== attribute.name)
        } else {
          delete params[attribute.filterName]
        }
      } else {
        if (Array.isArray(params[attribute.filterName])) {
          params[attribute.filterName] = [...params[attribute.filterName], attribute.name]
        } else {
          params[attribute.filterName] = [params[attribute.filterName], attribute.name]
        }
      }
    } else {
      params[attribute.filterName] = [attribute.name]
    }
    params['currentPage'] = 1
    history.push({
      pathname: loc.pathname,
      search: buildPath(params, { arrayFormat: 'comma' }),
    })
  }

  useEffect(() => {
    let didCancel = false
    if (!didCancel && ((!request.isFetching && !request.isLoaded) || loc.search !== path)) {
      setPath(loc.search)
      setRequest({ ...request, params, makeRequest: true, isFetching: true, isLoaded: false })
    }
    return () => {
      didCancel = true
    }
  }, [request, setRequest, params, loc, path])
  return (
    <>
      <div className="container pb-5 mb-2 mb-md-4">
        <div className="row">
          <aside className="col-lg-4">
            <ListingSidebar isFetching={request.isFetching} hide={hide} qs={loc.search} {...request.filtering} recordsCount={request.data.recordsCount} keyword={params['keyword']} setKeyword={setKeyword} updateAttribute={updateAttribute} />
          </aside>
          <div className="col-lg-8">
            <ListingToolBar hide={hide} {...request.filtering} removeFilter={updateAttribute} setSort={setSort} />
            <ListingGrid isFetching={request.isFetching} pageRecords={request.data.pageRecords} />
            <ListingPaginationModern currentPage={params['currentPage']} setPage={setPage} />
          </div>
        </div>
      </div>
    </>
  )
}

export { Listing }
