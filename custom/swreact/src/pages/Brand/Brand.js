import { Layout, PageHeader, ProductTypeList } from '../../components'
import BrandBanner from './BrandBanner'
import ListingPage from '../../components/Listing/Listing'
import { Redirect, useHistory, useLocation } from 'react-router'
import { useGetEntity, useGetProductType } from '../../hooks/useAPI'
import { useSelector } from 'react-redux'
import queryString from 'query-string'
import { useEffect } from 'react'
import { Helmet } from 'react-helmet'
import { getBrandRoute } from '../../selectors/configurationSelectors'

const Brand = props => {
  const brandRoute = useSelector(getBrandRoute)
  const productTypeBase = useSelector(state => state.configuration.filtering.productTypeBase)

  const path = props.location.pathname.split('/').reverse()
  const loc = useLocation()
  let params = queryString.parse(loc.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
  const brandFilter = {
    brand: path[0],
  }
  const history = useHistory()
  let [brandResponse, setBrandRequest] = useGetEntity()
  const [request, setRequest] = useGetProductType()
  const productTypeUrl = params['key'] || productTypeBase

  useEffect(() => {
    if (!request.isFetching && !request.isLoaded) {
      setRequest({ ...request, isFetching: true, isLoaded: false, params: { urlTitle: productTypeUrl, brandUrlTitle: path[0] }, makeRequest: true })
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
    setRequest({ ...request, data: {}, isFetching: true, isLoaded: false, params: { urlTitle: params['key'] || productTypeBase, brandUrlTitle: path[0] }, makeRequest: true })
  })

  return (
    <Layout>
      {brandResponse.isLoaded && brandResponse.data.length > 0 && <Helmet title={brandResponse.data[0].settings.brandHTMLTitleString} />}
      {brandResponse.isLoaded && request.isLoaded && (
        <PageHeader
          title={!request.data.showProducts && request.data.title}
          includeHome={true}
          brand={params['key'] && [{ title: brandResponse.data[0].brandName, urlTitle: `/${brandRoute}/${brandResponse.data[0].urlTitle}` }]}
          crumbs={request.data.breadcrumbs
            .map(crumb => {
              return { title: crumb.productTypeName, urlTitle: crumb.urlTitle }
            })
            .filter(crumb => crumb.urlTitle !== productTypeBase)
            .filter(crumb => crumb.urlTitle !== productTypeUrl)
            .map(crumb => {
              return { ...crumb, urlTitle: `${loc.pathname}?${queryString.stringify({ key: crumb.urlTitle }, { arrayFormat: 'comma' })}` }
            })}
        >
          <BrandBanner brandName={brandResponse.data[0].brandName} imageFile={brandResponse.data[0].imageFile} brandDescription={brandResponse.data[0].brandDescription} />
        </PageHeader>
      )}
      {brandResponse.isLoaded && request.data.childProductTypes?.length > 0 && (
        <ProductTypeList
          data={request.data}
          onSelect={urlTitle => {
            params['key'] = urlTitle
            history.push(`${loc.pathname}?${queryString.stringify(params, { arrayFormat: 'comma' })}`)
          }}
        />
      )}
      {request.data.showProducts && <ListingPage preFilter={{ brand: brandResponse.data[0].brandName, productType_id: request.data.productTypeID }} hide={['productType', 'brands']}></ListingPage>}
    </Layout>
  )
}

export default Brand
