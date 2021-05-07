import { Layout, ProductTypeList } from '../../components'
import BrandBanner from './BrandBanner'
import ListingPage from '../../components/Listing/Listing'
import { Redirect, useHistory, useLocation } from 'react-router'
import { useGetEntity, useGetProductType } from '../../hooks/useAPI'
import { useSelector } from 'react-redux'
import queryString from 'query-string'
import { useEffect } from 'react'
import { Helmet } from 'react-helmet'

const Brand = props => {
  const path = props.location.pathname.split('/').reverse()
  const loc = useLocation()
  let params = queryString.parse(loc.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
  const brandFilter = {
    brand: path[0],
  }
  const history = useHistory()
  let [brandResponse, setBrandRequest] = useGetEntity()

  const [request, setRequest] = useGetProductType()
  const productTypeBase = useSelector(state => state.configuration.filtering.productTypeBase)
  const productTypeUrl = params['key'] || productTypeBase

  useEffect(() => {
    if (!request.isFetching && !request.isLoaded) {
      setRequest({ ...request, isFetching: true, isLoaded: false, params: { urlTitle: productTypeUrl }, makeRequest: true })
    }
    if (!brandResponse.isFetching && !brandResponse.isLoaded) {
      setBrandRequest({ ...brandResponse, isFetching: true, isLoaded: false, entity: 'brand', params: { 'f:urlTitle': path[0] }, makeRequest: true })
    }
  }, [request, setRequest, productTypeUrl, setBrandRequest, brandResponse, path])

  if (!request.isFetching && request.isLoaded && Object.keys(request.data).length === 0) {
    return <Redirect to="/404" />
  }
  history.listen(location => {
    params = queryString.parse(location.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
    setRequest({ ...request, data: {}, isFetching: true, isLoaded: false, params: { urlTitle: params['key'] || productTypeBase }, makeRequest: true })
  })

  return (
    <Layout>
      {brandResponse.isLoaded && brandResponse.data.length > 0 && <Helmet title={brandResponse.data[0].settings.brandHTMLTitleString} />}
      {request.data.childProductTypes?.length > 0 && (
        <ProductTypeList
          data={request.data}
          onSelect={urlTitle => {
            params['key'] = urlTitle
            history.push(`${loc.pathname}?${queryString.stringify(params, { arrayFormat: 'comma' })}`)
          }}
        />
      )}
      {request.data.showProducts && (
        <ListingPage preFilter={{ ...brandFilter, productType_id: request.data.productTypeID }} hide={['productType', 'brands']}>
          {brandResponse.isLoaded && brandResponse.data.length > 0 && <BrandBanner brandName={brandResponse.data[0].brandName} imageFile={brandResponse.data[0].imageFile} brandDescription={brandResponse.data[0].brandDescription} />}{' '}

        </ListingPage>
      )}
    </Layout>
  )
}

export default Brand
