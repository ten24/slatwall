import { ADD_FILTER, REMOVE_FILTER, SET_SORT, SET_KEYWORD, CLEAR_KEYWORD, REQUEST_PRODUCTS, RECIVE_PRODUCTS } from '../actions/productSearchActions'

const products = [
  {
    brand: 'Brand A',
    productTile: 'Title 1',
    price: '$209.24',
    displayPrice: '$156.99',
    imgUrl: 'product-img-1.png',
    linkUrl: '/hop-single-v1.html',
  },
  {
    brand: 'Brand A',
    productTile: 'Title 1',
    price: '$209.24',
    displayPrice: '$156.99',
    imgUrl: 'product-img-2.png',
    linkUrl: '/shop-single-v1.html',
  },
  {
    brand: 'Brand A',
    productTile: 'Title 1',
    price: '$209.24',
    displayPrice: '$156.99',
    imgUrl: 'product-img-3.png',
    linkUrl: '/shop-single-v1.html',
  },
  {
    brand: 'Brand A',
    productTile: 'Title 1',
    price: '$209.24',
    displayPrice: '$156.99',
    imgUrl: 'product-img-4.png',
    linkUrl: '/shop-single-v1.html',
  },
  {
    brand: 'Brand A',
    productTile: 'Title 1',
    price: '$209.24',
    displayPrice: '$156.99',
    linkUrl: '/shop-single-v1.html',
  },
  {
    brand: 'Brand A',
    productTile: 'Title 1',
    price: '$209.24',
    displayPrice: '$156.99',
    linkUrl: '/shop-single-v1.html',
  },
]

const initState = {
  products: products,
  potentialFilters: [
    {
      name: 'Product Type',
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
      name: 'Brand',
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
      name: 'Stye',
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
      name: 'Finish',
      type: 'multi',
      options: [
        {
          name: 'Lifetime Brass',
          sub: '505',
          link: '',
          count: '',
        },
        {
          name: 'Bright Brass',
          sub: '605 | US3',
          link: '',
          count: '',
        },
        {
          name: 'Satin Brass',
          sub: '606 | US4',
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

    case ADD_FILTER:
      const filterToAdd = action.filter
      return { ...state }

    case REMOVE_FILTER:
      const filterToRemove = action.filter
      return { ...state }

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
    default:
      return state
  }
}

export default productSearch
