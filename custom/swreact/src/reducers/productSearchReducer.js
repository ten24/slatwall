import { SET_PAGE, REQUEST_OPTIONS, RECIVE_OPTIONS, RECIVE_FEATURED_PRODUCTS, REQUEST_FEATURED_PRODUCTS, UPDATE_ATTRIBUTE, ADD_FILTER, REMOVE_FILTER, SET_SORT, SET_KEYWORD, CLEAR_KEYWORD, REQUEST_PRODUCTS, RECIVE_PRODUCTS } from '../actions/productSearchActions'

const initState = {
  pageRecords: [],
  limitCountTotal: '',
  currentPage: '',
  pageRecordsCount: '',
  pageRecordsEnd: '',
  pageRecordsShow: '',
  pageRecordsStart: '',
  recordsCount: '',
  totalPages: '',
  possibleFilters: [],
  attributes: [],
  appliedFilters: [],
  keyword: '',
  sortBy: 'calculatedSalePrice|ASC',
  sortingOptions: [],
  isFetching: false,
  err: null,
}

const productSearch = (state = initState, action) => {
  switch (action.type) {
    case SET_PAGE:
      const { pageNumber } = action
      return { ...state, currentPage: pageNumber }

    case SET_SORT:
      const { sortBy } = action
      return { ...state, sortBy }

    case UPDATE_ATTRIBUTE:
      state.attributes.map(attribute => attribute.options.map(option => (option.isSelected = option.name === action.attribute.name ? !option.isSelected : option.isSelected))) //.filter(filter => filter.name !== action.filter.name)
      return { ...state, attributes: [...state.attributes] }
    case ADD_FILTER:
      return { ...state, appliedFilters: [...state.appliedFilters, action.filter].filter((v, i, a) => a.findIndex(t => JSON.stringify(t) === JSON.stringify(v)) === i) }

    case REMOVE_FILTER:
      return { ...state, appliedFilters: state.appliedFilters.filter(filter => filter.name !== action.filter.name) }

    case SET_KEYWORD:
      const { keyword } = action
      return { ...state, keyword }

    case CLEAR_KEYWORD:
      return { ...state }

    case REQUEST_PRODUCTS:
      return { ...state, isFetching: true }

    case RECIVE_PRODUCTS:
      return { ...state, ...action.payload, isFetching: false }

    case REQUEST_OPTIONS:
      return { ...state, isFetching: true }

    case RECIVE_OPTIONS:
      return { ...state, ...action.payload, isFetching: false }

    case REQUEST_FEATURED_PRODUCTS:
      return { ...state, isFetching: true }

    case RECIVE_FEATURED_PRODUCTS:
      const { featuredProducts } = action
      return { ...state, featuredProducts, isFetching: false }
    default:
      return state
  }
}

export default productSearch
