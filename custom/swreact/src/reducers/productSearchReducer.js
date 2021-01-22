import { RECIVE_FEATURED_PRODUCTS, REQUEST_FEATURED_PRODUCTS, UPDATE_ATTRIBUTE, ADD_FILTER, REMOVE_FILTER, SET_SORT, SET_KEYWORD, CLEAR_KEYWORD, REQUEST_PRODUCTS, RECIVE_PRODUCTS } from '../actions/productSearchActions'

const products = [
 {
      brand_brandName: 'Sargent',
      urlTitle: 'sargent-spindle-kit-2-1-4-door579-3',
      brand_urlTitle: '',
      listPrice: '',
      defaultProductImageFiles: [
        {
          imageFile: '579-3-.jpeg',
          skuDefinition: ''
        }
      ],
      calculatedTitle: 'Sargent Sargent Spindle Kit, 2-1/4" Door',
      calculatedSalePrice: 40,
      productName: 'Sargent Spindle Kit, 2-1/4" Door',
      livePrice: '',
      productClearance: '',
      productID: '2c918082765161ad0176517911fb008a',
      productFeatured: true
    },
    {
      brand_brandName: 'Sargent',
      urlTitle: 'sargent-30-series-exit-device-trim-dummy-ll-design-26d28-d-ll-26d',
      brand_urlTitle: '',
      listPrice: '',
      defaultProductImageFiles: [
        {
          imageFile: '28-D__LL__26D-.jpeg',
          skuDefinition: ''
        }
      ],
      calculatedTitle: 'Sargent Sargent 30 Series Exit Device Trim, Dummy, LL Design, 26D',
      calculatedSalePrice: 370,
      productName: 'Sargent 30 Series Exit Device Trim, Dummy, LL Design, 26D',
      livePrice: '',
      productClearance: '',
      productID: '2c918082765161ad017651790f2a007c',
      productFeatured: true
    },
    {
      brand_brandName: 'Sargent',
      urlTitle: 'sargent-knob-hub-retainer97-0043',
      brand_urlTitle: '',
      listPrice: '',
      defaultProductImageFiles: [
        {
          imageFile: '97-0043-.jpeg',
          skuDefinition: ''
        }
      ],
      calculatedTitle: 'Sargent Sargent Knob Hub Retainer',
      calculatedSalePrice: 8.4,
      productName: 'Sargent Knob Hub Retainer',
      livePrice: '',
      productClearance: '',
      productID: '2c918082765161ad0176517910970083',
      productFeatured: true
    },
    {
      brand_brandName: 'Sargent',
      urlTitle: 'sargent-30-series-surface-vertical-rod-device-48-en-689-3727-48-pen',
      brand_urlTitle: '',
      listPrice: '',
      defaultProductImageFiles: [
        {
          imageFile: '3727__48__PEN-.jpeg',
          skuDefinition: ''
        }
      ],
      calculatedTitle: 'Sargent Sargent 30 Series Surface Vertical Rod Device, 48", EN (689)',
      calculatedSalePrice: 999,
      productName: 'Sargent 30 Series Surface Vertical Rod Device, 48", EN (689)',
      livePrice: '',
      productClearance: '',
      productID: '2c918082765161ad017651790d550075',
      productFeatured: true
    },
    {
      brand_brandName: 'Lucky Line',
      urlTitle: 'precision-pen-screwdriveru12201',
      brand_urlTitle: '',
      listPrice: '',
      defaultProductImageFiles: [
        {
          imageFile: 'U12201-.jpeg',
          skuDefinition: ''
        }
      ],
      calculatedTitle: 'Lucky Line Precision Pen Screwdriver',
      calculatedSalePrice: 8.63,
      productName: 'Precision Pen Screwdriver',
      livePrice: '',
      productClearance: '',
      productID: '40289084765102130176511521d200f7',
      productFeatured: true
    }
]

const initState = {
  products: products,
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
