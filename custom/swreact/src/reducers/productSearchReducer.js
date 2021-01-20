import { RECIVE_FEATURED_PRODUCTS, REQUEST_FEATURED_PRODUCTS, UPDATE_ATTRIBUTE, ADD_FILTER, REMOVE_FILTER, SET_SORT, SET_KEYWORD, CLEAR_KEYWORD, REQUEST_PRODUCTS, RECIVE_PRODUCTS } from '../actions/productSearchActions'

const initState = {
  products: [],
  potentialFilters: [
    {
      filterName: 'Product Type',
      type: 'single',
      options: [
        {
          name: 'View all',
          link: '#',
          count: '1,953',
        },
        {
          name: 'Pumps & High Heels',
          link: '#',
          count: '247',
        },
        {
          name: 'Ballerinas & Flats',
          link: '#',
          count: '156',
        },
      ],
    },
    {
      filterName: 'Brand',
      type: 'single',
      options: [
        {
          name: 'View all',
          link: '#',
          sub: '',
          count: '1,953',
        },
        {
          name: 'Pumps & High Heels',
          link: '#',
          sub: '',
          count: '247',
        },
        {
          name: 'Ballerinas & Flats',
          link: '#',
          sub: '',
          count: '156',
        },
      ],
    },
    {
      filterName: 'Stye',
      type: 'single',
      options: [
        {
          name: 'View all',
          link: '#',
          count: '1,953',
        },
        {
          name: 'Pumps & High Heels',
          link: '#',
          count: '247',
        },
        {
          name: 'Ballerinas & Flats',
          link: '#',
          count: '156',
        },
      ],
    },
  ],
  attributes: [
    {
      filterName: 'Finish',
      type: 'multi',
      options: [
        {
          name: 'Lifetime Brass',
          sub: '505',
          isSelected: true,
          link: '',
          count: '',
        },
        {
          name: 'Bright Brass',
          sub: '605 | US3',
          isSelected: false,
          link: '',
          count: '',
        },
        {
          name: 'Satin Brass',
          sub: '606 | US4',
          isSelected: false,
          link: '',
          count: '',
        },
      ],
    },
  ],
  appliedFilters: [],
  keyword: '',
  sortBy: 'Popularity',
  sortOptions: ['Popularity', 'Low - High Price', 'High - Low Price', 'Average Rating', 'A - Z Order', 'Z - A Order'],
  page: 1,
  pageLimit: 8,
  isFetching: false,
  err: null,
}

const productSearch = (state = initState, action) => {
  switch (action.type) {
    case SET_SORT:
      const { sortBy } = action
      return { ...state, sortBy }

    case UPDATE_ATTRIBUTE:
      state.attributes.map(attribute => attribute.options.map(option => (option.isSelected = option.name === action.attribute.name ? !option.isSelected : option.isSelected))) //.filter(filter => filter.name !== action.filter.name)
      return { ...state, attributes: [...state.attributes] }
    case ADD_FILTER:
      return { ...state, appliedFilters: [...state.appliedFilters, action.filter] }

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
      const { products } = action
      return { ...state, products, isFetching: false }

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
