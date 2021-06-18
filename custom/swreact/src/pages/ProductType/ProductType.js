import { Redirect, useHistory, useParams } from 'react-router-dom'
import { Layout, PageHeader, ProductTypeList, Listing } from '../../components'
import { Helmet } from 'react-helmet'
import { useGetEntity } from '../../hooks/useAPI'
import { useSelector } from 'react-redux'
import { getProductTypeRoute } from '../../selectors/configurationSelectors'
import { augmentProductType } from '../../utils'
import { useEffect } from 'react'

const ProductType = () => {
  const productTypeRoute = useSelector(getProductTypeRoute)
  const productTypeBase = useSelector(state => state.configuration.filtering.productTypeBase)

  let { id } = useParams()
  const history = useHistory()
  const [productTypeRequest, setProductTypeRequest] = useGetEntity()
  const [productTypeListRequest, setProductTypeListRequest] = useGetEntity()

  useEffect(() => {
    const unload = history.listen(location => {
      const urlTitle = location.pathname.split('/').reverse()[0]
      const hasData = !!productTypeListRequest.data.filter(pt => pt.urlTitle === urlTitle).length
      if (!hasData && productTypeListRequest.data.length > 0) {
        setProductTypeRequest({ ...productTypeRequest, data: {}, isFetching: false, isLoaded: false, params: { urlTitle }, makeRequest: true })
        setProductTypeListRequest({ ...productTypeListRequest, data: [], isFetching: false, isLoaded: false, params: {}, makeRequest: false })
      } else {
      }
    })
    return () => {
      unload()
    }
  }, [history, setProductTypeRequest, productTypeRequest, setProductTypeListRequest, productTypeListRequest])

  if (!productTypeRequest.isFetching && !productTypeRequest.isLoaded) {
    setProductTypeRequest({ ...productTypeRequest, isFetching: true, isLoaded: false, entity: 'productType', params: { urlTitle: id }, makeRequest: true })
  }
  if (!productTypeRequest.isFetching && productTypeRequest.isLoaded && Object.keys(productTypeRequest.data).length === 0) {
    return <Redirect to="/404" />
  }
  if (!productTypeListRequest.isFetching && !productTypeListRequest.isLoaded && productTypeRequest.isLoaded) {
    setProductTypeListRequest({ ...productTypeListRequest, data: [], isFetching: true, isLoaded: false, entity: 'productType', params: { 'f:productTypeIDPath:like': `%${productTypeRequest.data.productTypeID}%`, 'p:show': 250, includeSettingsInList: true }, makeRequest: true })
  }
  const productTypeData = augmentProductType(id, productTypeListRequest.data)

  return (
    <Layout>
      {productTypeRequest.isLoaded && <Helmet title={productTypeRequest.data.settings.productHTMLTitleString} />}
      {productTypeRequest.isLoaded && (
        <PageHeader
          title={productTypeData?.childProductTypes?.length !== 0 && productTypeRequest.data.productTypeName}
          crumbs={productTypeRequest.data.ancestors
            .map(crumb => {
              return { title: crumb.productTypeName, urlTitle: crumb.urlTitle }
            })
            .filter(crumb => crumb.urlTitle !== productTypeBase)
            .filter(crumb => crumb.urlTitle !== id)
            .map(crumb => {
              return { ...crumb, urlTitle: `/${productTypeRoute}/${crumb.urlTitle}` }
            })}
        />
      )}
      {productTypeData?.childProductTypes?.length > 0 && (
        <ProductTypeList
          onSelect={urlTitle => {
            history.push(`/${productTypeRoute}/${urlTitle}`)
          }}
          data={productTypeData}
        />
      )}
      {productTypeData?.childProductTypes?.length === 0 && (
        <Listing preFilter={{ productType_slug: id }} hide={['productType']}>
          <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
            <h5 className="h4 text-dark mb-0 font-accent">{productTypeRequest.data.title}</h5>
          </div>
        </Listing>
      )}
    </Layout>
  )
}

export default ProductType
