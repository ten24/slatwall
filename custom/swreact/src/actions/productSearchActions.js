import axios from 'axios'
import { sdkURL, SlatwalApiService } from '../services'
export const ADD_FILTER = 'ADD_FILTER'
export const REMOVE_FILTER = 'REMOVE_FILTER'
export const UPDATE_ATTRIBUTE = 'UPDATE_ATTRIBUTE'

export const SET_PAGE = 'SET_PAGE'

export const SET_SORT = 'SET_SORT'

export const SET_KEYWORD = 'SET_KEYWORD'
export const CLEAR_KEYWORD = 'SET_KEYWORD'

export const REQUEST_PRODUCTS = 'REQUEST_PRODUCTS'
export const RECIVE_PRODUCTS = 'RECIVE_PRODUCTS'

export const REQUEST_FEATURED_PRODUCTS = 'REQUEST_FEATURED_PRODUCTS'
export const RECIVE_FEATURED_PRODUCTS = 'RECIVE_FEATURED_PRODUCTS'

export const REQUEST_OPTIONS = 'REQUEST_OPTIONS'
export const RECIVE_OPTIONS = 'RECIVE_OPTIONS'

export const setCurrentPage = pageNumber => {
  return {
    type: SET_PAGE,
    pageNumber,
  }
}

export const setSort = sortBy => {
  return {
    type: SET_SORT,
    sortBy,
  }
}

export const addFilter = filter => {
  return {
    type: ADD_FILTER,
    filter,
  }
}
export const removeFilter = filter => {
  return {
    type: REMOVE_FILTER,
    filter,
  }
}
export const updateAttribute = attribute => {
  return {
    type: UPDATE_ATTRIBUTE,
    attribute,
  }
}

export const requestFeaturedProducts = () => {
  return {
    type: REQUEST_FEATURED_PRODUCTS,
  }
}
export const reciveFeaturedProducts = featuredProducts => {
  return {
    type: RECIVE_FEATURED_PRODUCTS,
    featuredProducts,
  }
}

export const setKeyword = keyword => {
  return {
    type: SET_KEYWORD,
    keyword,
  }
}
export const clearKeyword = () => {
  return {
    type: CLEAR_KEYWORD,
  }
}

export const requestProducts = () => {
  return {
    type: REQUEST_PRODUCTS,
  }
}

export const reciveProducts = payload => {
  return {
    type: RECIVE_PRODUCTS,
    payload,
  }
}
export const requestOptions = () => {
  return {
    type: REQUEST_OPTIONS,
  }
}

export const reciveOptions = payload => {
  return {
    type: RECIVE_OPTIONS,
    payload,
  }
}

export const search = () => {
  return async (dispatch, getState) => {
    const { keyword, sortBy, currentPage } = getState().productSearchReducer
    dispatch(requestProducts())
    const sortCriteria = sortBy.split('|')

    const response = await SlatwalApiService.products.list({
      perPage: 9,
      page: currentPage,
      sort: sortCriteria[0],
      sortOrder: sortCriteria[1],
      filter: {
        publishedFlag: true,
        'productName:like': `%${keyword}%`,
      },
    })

    if (!response.isFail()) {
      const { pageRecords, limitCountTotal, currentPage, pageRecordsCount, pageRecordsEnd, pageRecordsShow, pageRecordsStart, recordsCount, totalPages } = response.success()

      dispatch(
        reciveProducts({
          pageRecords,
          limitCountTotal,
          currentPage,
          pageRecordsCount,
          pageRecordsEnd,
          pageRecordsShow,
          pageRecordsStart,
          recordsCount,
          totalPages,
        })
      )
    } else {
      dispatch(reciveProducts({}))
    }
  }
}

export const getProductListingOptions = () => {
  return async (dispatch, getState) => {
    dispatch(requestOptions())
    const response = await axios({
      method: 'GET',
      withCredentials: true, // default

      url: `${sdkURL}api/scope/getProductListingOptions`,
      headers: {
        'Content-Type': 'application/json',
      },
    })
    if (response.status === 200) {
      if (!getState().productSearchReducer.sortBy.length) {
        dispatch(setSort(response.data.sortingOptions[0].value))
      }
      dispatch(
        reciveOptions({
          sortingOptions: response.data.sortingOptions,
          possibleFilters: response.data.possibleFilters,
          attributes: response.data.attributes,
        })
      )
    } else {
      dispatch(reciveOptions({}))
    }
  }
}

export const getFeaturedItems = () => {
  return async (dispatch, getState) => {
    dispatch(requestFeaturedProducts())

    // const response = await axios({
    //   method: 'GET',
    //   withCredentials: true, // default

    //   url: `${sdkURL}api/scope/getFeaturedItems`,
    //   data: {},
    // })
    // if (response.status === 200) {
    //   dispatch(reciveFeaturedProducts(response.data.content))
    // } else {
    //   dispatch(reciveFeaturedProducts({}))
    // }
    dispatch(reciveFeaturedProducts({}))

    //   if (req.isFail()) {
    //     dispatch(errorLogin(req.toString()))
    //   } else {
    //     dispatch(receiveLogin(req.success().token))
    //     dispatch(receiveUser(req))
    //   }
  }
}
