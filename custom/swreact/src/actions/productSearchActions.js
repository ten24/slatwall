import axios from 'axios'
import { sdkURL } from '../services'
export const ADD_FILTER = 'ADD_FILTER'
export const REMOVE_FILTER = 'REMOVE_FILTER'
export const UPDATE_ATTRIBUTE = 'UPDATE_ATTRIBUTE'

export const SET_SORT = 'SET_SORT'

export const SET_KEYWORD = 'SET_KEYWORD'
export const CLEAR_KEYWORD = 'SET_KEYWORD'

export const REQUEST_PRODUCTS = 'REQUEST_PRODUCTS'
export const RECIVE_PRODUCTS = 'RECIVE_PRODUCTS'

export const REQUEST_FEATURED_PRODUCTS = 'REQUEST_FEATURED_PRODUCTS'
export const RECIVE_FEATURED_PRODUCTS = 'RECIVE_FEATURED_PRODUCTS'

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

export const reciveProducts = products => {
  return {
    type: RECIVE_PRODUCTS,
    products,
  }
}

export const search = () => {
  return async (dispatch, getState) => {
    const { appliedFilters, keyword, sortBy, products } = getState().productSearchReducer
    dispatch(requestProducts())

    //   const req = await SlatwalApiService.auth.login({
    //     emailAddress: email,
    //     password: password,
    //   })

    //   if (req.isFail()) {
    //     dispatch(errorLogin(req.toString()))
    //   } else {
    //     dispatch(receiveLogin(req.success().token))
    //     dispatch(receiveUser(req))
    //   }
    dispatch(reciveProducts(products))
  }
}

export const getFeaturedItems = () => {
  return async (dispatch, getState) => {
    const { home } = getState().preload
    let featuredProducts = home.featuredSlider
    dispatch(requestFeaturedProducts())

    if (false) {
      const req = await axios({
        method: 'GET',
        withCredentials: true, // default

        url: `${sdkURL}api/scope/getFeaturedItems`,
        data: {},
      })
      console.log(req)
    }

    //   const req = await SlatwalApiService.auth.login({
    //     emailAddress: email,
    //     password: password,
    //   })

    //   if (req.isFail()) {
    //     dispatch(errorLogin(req.toString()))
    //   } else {
    //     dispatch(receiveLogin(req.success().token))
    //     dispatch(receiveUser(req))
    //   }
    dispatch(reciveFeaturedProducts(featuredProducts))
  }
}
