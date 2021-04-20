import { createSelector } from 'reselect'

export const getRoutes = state => state.configuration.router

export const getBrandRoute = createSelector(getRoutes, routes => {
  return routes
    .map(route => {
      return route.URLKeyType === 'Brand' ? route.URLKey : null
    })
    .filter(item => {
      return item
    })[0]
})
export const getProductRoute = createSelector(getRoutes, routes => {
  return routes
    .map(route => {
      return route.URLKeyType === 'Product' ? route.URLKey : null
    })
    .filter(item => {
      return item
    })[0]
})

export const getProductTypeProductListRoute = createSelector(getRoutes, routes => {
  return routes
    .map(route => {
      return route.URLKeyType === 'ProductType' ? route.URLKey : null
    })
    .filter(item => {
      return item
    })[0]
})
