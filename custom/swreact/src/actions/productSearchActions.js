export const ADD_FILTER = 'ADD_FILTER'
export const REMOVE_FILTER = 'REMOVE_FILTER'

export const SET_SORT = 'SET_SORT'

export const SET_KEYWORD = 'SET_KEYWORD'
export const CLEAR_KEYWORD = 'SET_KEYWORD'

export const REQUEST_PRODUCTS = 'REQUEST_PRODUCTS'
export const RECIVE_PRODUCTS = 'RECIVE_PRODUCTS'

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
