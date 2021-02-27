import React, { useEffect, useState } from 'react'
import { useHistory, useLocation } from 'react-router-dom'
import ProductListingGrid from './ListingGrid'
import ProductListingToolBar from './ListingToolBar'
import ProductListingPagination from './ListingPagination'
import ProductListingSidebar from './ListingSidebar'
import PageHeader from '../PageHeader/PageHeader'
import axios from 'axios'
import { sdkURL } from '../../services/index'
import queryString from 'query-string'
import { useGetProducts } from '../../hooks/useAPI'

const processQueryParamters = params => {
  return queryString.parse(params, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
}
const buildPath = params => {
  return queryString.stringify(params, { arrayFormat: 'comma' })
}
const initalData = { brands: '', orderBy: 'product.productName|ASC', pageSize: 12, currentPage: 1, keyword: '' }

const ListingPage = ({ children, preFilter, hide }) => {
  const loc = useLocation()
  let history = useHistory()
  let params = processQueryParamters(loc.search)
  params = { ...initalData, ...params, ...preFilter }
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
    history.push({
      pathname: loc.pathname,
      search: buildPath(params, { arrayFormat: 'comma' }),
    })
  }
  const setSort = orderBy => {
    params['orderBy'] = orderBy

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

    history.push({
      pathname: loc.pathname,
      search: buildPath(params, { arrayFormat: 'comma' }),
    })
  }

  useEffect(() => {
    let didCancel = false
    if (!didCancel && ((!request.isFetching && !request.isLoaded) || loc.search !== path)) {
      setRequest({ ...request, params, makeRequest: true, isFetching: true, isLoaded: false })
    }
    return () => {
      didCancel = true
    }
  }, [request, setRequest, params])

  console.log('request', request)
  return (
    <>
      <PageHeader> {children}</PageHeader>
      <div className="container pb-5 mb-2 mb-md-4">
        <div className="row">
          <aside className="col-lg-4">
            <ProductListingSidebar hide={hide} qs={loc.search} {...request.filtering} recordsCount={request.data.recordsCount} setKeyword={setKeyword} updateAttribute={updateAttribute} />
          </aside>
          <div className="col-lg-8">
            <ProductListingToolBar hide={hide} {...request.filtering} removeFilter={updateAttribute} setSort={setSort} />
            <ProductListingGrid pageRecords={request.data.pageRecords} />
            <ProductListingPagination recordsCount={request.data.recordsCount} currentPage={request.data.currentPage} totalPages={request.data.totalPages} setPage={setPage} />
          </div>
        </div>
      </div>
    </>
  )
}

export default ListingPage
