import { Layout, PageHeader, ProductTypeList } from '../../components'
import BrandBanner from './BrandBanner'
import ListingPage from '../../components/Listing/Listing'
import { Redirect, useHistory, useLocation } from 'react-router'
import { useGetEntity } from '../../hooks/useAPI'
import { useSelector } from 'react-redux'
import queryString from 'query-string'
import { useEffect } from 'react'
import { Helmet } from 'react-helmet'
import { getBrandRoute } from '../../selectors/configurationSelectors'
import { augmentProductType } from '../../utils'

const Brand = props => {
  const brandRoute = useSelector(getBrandRoute)
  const productTypeBase = useSelector(state => state.configuration.filtering.productTypeBase)

  const path = props.location.pathname.split('/').reverse()
  const loc = useLocation()
  let params = queryString.parse(loc.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })

  const history = useHistory()
  let [brandResponse, setBrandRequest] = useGetEntity()
  const [productTypeRequest, setProductTypeRequest] = useGetEntity()
  const productTypeUrl = params['key'] || productTypeBase

  useEffect(() => {
    if (!productTypeRequest.isFetching && !productTypeRequest.isLoaded) {
      setProductTypeRequest({
        ...productTypeRequest,
        isFetching: true,
        isLoaded: false,
        entity: 'ProductType',
        params: { brandUrlTitle: path[0], 'p:show': 250, includeSettingsInList: true },
        makeRequest: true,
      })
    }
    if (!brandResponse.isFetching && !brandResponse.isLoaded) {
      setBrandRequest({ ...brandResponse, isFetching: true, isLoaded: false, entity: 'brand', params: { 'f:urlTitle': path[0] }, makeRequest: true })
    }
  }, [productTypeUrl, setBrandRequest, brandResponse, path, setProductTypeRequest, productTypeRequest])

  if (!productTypeRequest.isFetching && productTypeRequest.isLoaded && Object.keys(productTypeRequest.data).length === 0) {
    return <Redirect to="/404" />
  }

  const productTypeData = augmentProductType(productTypeUrl, productTypeRequest.data)
  const isNonBasePTAndListing = productTypeData?.childProductTypes?.length !== 0 && productTypeUrl !== productTypeBase

  return (
    <Layout>
      {brandResponse.isLoaded && brandResponse.data.length > 0 && <Helmet title={brandResponse.data[0].settings.brandHTMLTitleString} />}
      {brandResponse.isLoaded && productTypeRequest.isLoaded && (
        <PageHeader
          title={isNonBasePTAndListing && productTypeData?.productTypeName}
          includeHome={true}
          brand={params['key'] && [{ title: brandResponse.data[0].brandName, urlTitle: `/${brandRoute}/${brandResponse.data[0].urlTitle}` }]}
          crumbs={productTypeRequest.data
            .filter(productType => {
              return productTypeData?.productTypeIDPath?.includes(productType.productTypeID)
            })
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
      {brandResponse.isLoaded && productTypeData.childProductTypes?.length > 0 && (
        <ProductTypeList
          data={productTypeData}
          onSelect={urlTitle => {
            params['key'] = urlTitle
            history.push(`${loc.pathname}?${queryString.stringify(params, { arrayFormat: 'comma' })}`)
          }}
        />
      )}
      {productTypeData?.childProductTypes?.length === 0 && <ListingPage preFilter={{ brand: brandResponse.data[0].brandName, productType_slug: productTypeData.urlTitle }} hide={['productType', 'brands']}></ListingPage>}
    </Layout>
  )
}

export default Brand
