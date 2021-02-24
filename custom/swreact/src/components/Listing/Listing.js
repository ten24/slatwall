import React, { useEffect, useState } from 'react'
import { useDispatch } from 'react-redux'
import { useHistory, useLocation } from 'react-router-dom'
import ProductListingGrid from './ListingGrid'
import ProductListingToolBar from './ListingToolBar'
import ProductListingPagination from './ListingPagination'
import ProductListingSidebar from './ListingSidebar'
import PageHeader from '../PageHeader/PageHeader'
import axios from 'axios'
import { sdkURL, SlatwalApiService } from '../../services/index'
const ListingPage = ({ children, preFilter = {} }) => {
  const dispatch = useDispatch()
  const loc = useLocation()
  let history = useHistory()

  console.log('loc', loc)

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
    possibleFilters: [],
    attributes: [],
    appliedFilters: [],
    keyword: '',
    sortBy: 'calculatedSalePrice|ASC',
    sortingOptions: [],
  })

  const getFilters = () => {
    axios({
      method: 'GET',
      withCredentials: true, // default

      url: `${sdkURL}api/scope/getProductListingOptions`,
      headers: {
        'Content-Type': 'application/json',
      },
    }).then(response => {
      if (response.status === 200) {
        setFiltering({ ...filtering, ...response.data })
      }
    })
  }
  const setPage = pageNumber => {
    getProducts(pageNumber)
  }
  const removeFilter = filter => {
    //   return { ...state, appliedFilters: state.appliedFilters.filter(filter => filter.name !== action.filter.name) }
    console.log('removeFilter, filter')
    history.push({
      pathname: '',
      search: '?color=blue',
    })
  }
  const setKeyword = keyword => {
    //   return { ...state, appliedFilters: state.appliedFilters.filter(filter => filter.name !== action.filter.name) }
    console.log('setKeyword', keyword)
  }
  const setSort = (sortBy = filtering.sortBy) => {
    const sortCriteria = sortBy.split('|')
    console.log('setSort', sortCriteria)
  }
  const addFilter = filter => {
    //      return { ...state, appliedFilters: [...state.appliedFilters, action.filter].filter((v, i, a) => a.findIndex(t => JSON.stringify(t) === JSON.stringify(v)) === i) }
    history.push({
      pathname: '',
      search: '?color=blue',
    })
    console.log('addFilter', filter)
  }
  const updateAttribute = attribute => {
    //      state.attributes.map(attribute => attribute.options.map(option => (option.isSelected = option.name === action.attribute.name ? !option.isSelected : option.isSelected))) //.filter(filter => filter.name !== action.filter.name)
    console.log('updateAttribute', attribute)
  }
  const getProducts = ({ pageNumber, sortBy }) => {
    const sortCriteria = sortBy?.split('|') ? sortBy : filtering.sortBy.split('|')

    SlatwalApiService.products
      .list({
        perPage: 9,
        page: pageNumber || data.currentPage,
        sort: sortCriteria[0],
        sortOrder: sortCriteria[1],
        filter: {
          ...preFilter,
          publishedFlag: true,
          'productName:like': `%${filtering.keyword}%`,
        },
      })
      .then(response => {
        console.log('response', response)
        if (!response.isFail()) {
          const request = response.success()
          console.log('request', request)
          setData({
            ...data,
            ...request,
          })
        }
      })
  }
  useEffect(() => {
    getFilters()
    getProducts({})
  }, [dispatch])

  return (
    <>
      <PageHeader> {children}</PageHeader>
      <div className="container pb-5 mb-2 mb-md-4">
        <div className="row">
          <aside className="col-lg-4">
            <ProductListingSidebar {...filtering} recordsCount={data.recordsCount} setKeyword={setKeyword} addFilter={addFilter} updateAttribute={updateAttribute} />
          </aside>
          <div className="col-lg-8">
            <ProductListingToolBar {...filtering} removeFilter={removeFilter} setSort={setSort} />
            <ProductListingGrid pageRecords={data.pageRecords} />
            <ProductListingPagination recordsCount={data.recordsCount} currentPage={data.currentPage} totalPages={data.totalPages} setPage={setPage} />
          </div>
        </div>
      </div>
    </>
  )
}

export default ListingPage
