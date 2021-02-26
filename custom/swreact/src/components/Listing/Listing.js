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
import { useGetSku } from '../../hooks/useAPI'

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
  let [request, setRequest] = useGetSku()
  let params = processQueryParamters(loc.search)
  params = { ...initalData, ...params, ...preFilter }
  const [path, setPath] = useState(loc.search)

  const [data, setData] = useState({
    pageRecords: [],
    limitCountTotal: '',
    currentPage: '',
    pageRecordsCount: '',
    pageRecordsEnd: '',
    pageRecordsShow: '',
    pageRecordsStart: '',
    recordsCount: '',
    totalPages: '',
    isFetching: false,
    err: null,
  })
  const [filtering, setFiltering] = useState({
    keyword: params.keyword,
    orderBy: params.orderBy,
    isLoaded: false,
  })

  const getFilters = didCancel => {
    axios({
      method: 'GET',
      withCredentials: true, // default
      url: `${sdkURL}api/scope/getProducts?${buildPath(params)}`,
      headers: {
        'Content-Type': 'application/json',
      },
    }).then(response => {
      if (response.status === 200 && !didCancel) {
        const { currentPage, pageSize, potentialFilters, products, total } = response.data
        const totalPages = Math.ceil(total / pageSize)
        setFiltering({ ...filtering, ...potentialFilters, isLoaded: true })
        setData({ ...data, currentPage, pageSize, recordsCount: total, totalPages, pageRecords: products, isLoaded: true })
      } else if (!didCancel) {
        setFiltering({ ...filtering, isLoaded: true })
      }
    })
  }
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
  console.log('path', path)
  console.log('render1', filtering)
  useEffect(() => {
    let didCancel = false
    console.log('render2', filtering)
    if (!filtering.isLoaded) {
      console.log('render3', filtering)
      getFilters(didCancel)
    } else if (loc.search !== path) {
      setPath(loc.search)
      setFiltering({ ...filtering, isLoaded: false })
    }
    return () => {
      didCancel = true
    }
  }, [filtering, getFilters])
  return (
    <>
      <PageHeader> {children}</PageHeader>
      <div className="container pb-5 mb-2 mb-md-4">
        <div className="row">
          <aside className="col-lg-4">
            <ProductListingSidebar hide={hide} qs={loc.search} {...filtering} recordsCount={data.recordsCount} setKeyword={setKeyword} updateAttribute={updateAttribute} hideBrand={preFilter.brands.length > 0} />
          </aside>
          <div className="col-lg-8">
            <ProductListingToolBar hide={hide} {...filtering} removeFilter={updateAttribute} setSort={setSort} />
            <ProductListingGrid pageRecords={data.pageRecords} />
            <ProductListingPagination recordsCount={data.recordsCount} currentPage={data.currentPage} totalPages={data.totalPages} setPage={setPage} />
          </div>
        </div>
      </div>
    </>
  )
}

export default ListingPage
