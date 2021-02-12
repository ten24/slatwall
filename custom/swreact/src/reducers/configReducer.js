import { REQUEST_CONFIGURATION, RECIVE_CONFIGURATION, SET_TITLE, SET_TITLE_META } from '../actions/configActions'

const initState = {
  site: {
    hibachiInstanceApplicationScopeKey: '',
    siteName: '',
    siteID: '',
    siteCode: '',
    hibachiConfig: '',
  },
  router: {
    globalURLKeyProduct: '',
    globalURLKeyProductType: '',
    globalURLKeyCategory: '',
    globalURLKeyBrand: '',
    globalURLKeyAccount: '',
    globalURLKeyAddress: '',
    globalURLKeyAttribute: '',
  },
  seo: {
    title: '',
    titleMeta: '',
  },
  isFetching: false,
  err: null,
}

const configuration = (state = initState, action) => {
  switch (action.type) {
    case REQUEST_CONFIGURATION:
      return { ...state, isFetching: true }

    case RECIVE_CONFIGURATION:
      return { ...state, isFetching: false }

    case SET_TITLE:
      const { title } = action
      return { ...state, seo: { title } }

    case SET_TITLE_META:
      return { ...state }

    default:
      return state
  }
}

export default configuration
