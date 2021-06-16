const data = {
  site: { hibachiInstanceApplicationScopeKey: '', siteName: 'Stone & Berg', siteID: '2c9680847491ce86017491f46ec50036', siteCode: process.env.REACT_APP_SITE_CODE },
  router: [
    { URLKeyType: 'Product', URLKey: 'product' },
    { URLKeyType: 'ProductType', URLKey: 'products' },
    { URLKeyType: 'Category', URLKey: 'cat' },
    { URLKeyType: 'Brand', URLKey: 'brand' },
    { URLKeyType: 'Account', URLKey: 'ac' },
    { URLKeyType: 'Address', URLKey: 'ad' },
    { URLKeyType: 'Attribute', URLKey: 'att' },
  ],
  cmsProvider: 'slatwallCMS',
  enforceVerifiedAccountFlag: true,
  products: {
    fallbackImageCall: false,
  },
  shopByManufacturer: {
    slug: '/brands',
    showInMenu: true,
    gridSize: 1000,
    maxCount: 1000,
  },
  seo: {
    title: 'Stone & Berg',
    titleMeta: '',
  },
  filtering: {
    productTypeBase: 'merchandise',
    requireKeyword: true,
  },
  footer: {
    formLink: 'https://stoneandberg.us3.list-manage.com/subscribe/post?u=8eee6b8b93baf1968074021ef&id=ddc565ac59',
  },
  theme: {
    host: process.env.REACT_APP_ADMIN_URL,
    basePath: '/custom/client/assets/images/',
    primaryColor: '5f1018',
  },
  formatting: {
    dateFormat: 'MMM DD, YYYY',
    timeFormat: 'HH:MM a',
  },
  analytics: {
    tagManager: {
      gtmId: 'G-QCNMEP30GL',
    },
    googleAnalytics: {
      id: '',
    },
    reportWebVitals: false,
  },
  forms: {
    contact: '2c91808575030b800175064d31680010',
  },
}

export default data
