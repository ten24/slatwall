import { Layout, ProductTypeList } from '../../components'
import BrandBanner from './BrandBanner'
import ListingPage from '../../components/Listing/Listing'
import { Redirect, useHistory, useLocation } from 'react-router'
import { useGetProductType } from '../../hooks/useAPI'
import { useSelector } from 'react-redux'
import queryString from 'query-string'
import { useEffect } from 'react'

const Brand = props => {
  const path = props.location.pathname.split('/').reverse()
  const loc = useLocation()
  let params = queryString.parse(loc.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
  const brandFilter = {
    brand: path[0],
  }
  const history = useHistory()

  const [request, setRequest] = useGetProductType()
  const productTypeBase = useSelector(state => state.configuration.filtering.productTypeBase)
  const productTypeUrl = params['productType'] || productTypeBase

  useEffect(() => {
    if (!request.isFetching && !request.isLoaded) {
      setRequest({ ...request, isFetching: true, isLoaded: false, params: { urlTitle: productTypeUrl }, makeRequest: true })
    }
  }, [request, setRequest, productTypeUrl])

  if (!request.isFetching && request.isLoaded && Object.keys(request.data).length === 0) {
    return <Redirect to="/404" />
  }
  history.listen(location => {
    params = queryString.parse(location.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
    setRequest({ ...request, data: {}, isFetching: true, isLoaded: false, params: { urlTitle: params['productType'] || productTypeBase }, makeRequest: true })
  })

  return (
    <Layout>
      {request.data.childProductTypes?.length > 0 && (
        <ProductTypeList
          data={request.data}
          onSelect={urlTitle => {
            params['productType'] = urlTitle
            history.push(`${loc.pathname}?${queryString.stringify(params, { arrayFormat: 'comma' })}`)
          }}
        />
      )}
      {request.data.showProducts && (
        <ListingPage preFilter={brandFilter} hide={['productType', 'brands']}>
          <BrandBanner brandCode={path[0]} />
        </ListingPage>
      )}
    </Layout>
  )
}

export default Brand
