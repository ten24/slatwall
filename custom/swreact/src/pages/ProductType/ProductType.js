import { Redirect, useHistory, useParams } from 'react-router-dom'
import { Layout, PageHeader, ProductTypeList } from '../../components'
import ListingPage from '../../components/Listing/Listing'
import { Helmet } from 'react-helmet'
import { useGetProductType } from '../../hooks/useAPI'
import { useSelector } from 'react-redux'
import { getProductTypeRoute } from '../../selectors/configurationSelectors'

const ProductType = () => {
  const productTypeRoute = useSelector(getProductTypeRoute)
  const productTypeBase = useSelector(state => state.configuration.filtering.productTypeBase)

  let { id } = useParams()
  const history = useHistory()
  const [request, setRequest] = useGetProductType()

  if (!request.isFetching && !request.isLoaded) {
    setRequest({ ...request, isFetching: true, isLoaded: false, params: { urlTitle: id }, makeRequest: true })
  }
  if (!request.isFetching && request.isLoaded && Object.keys(request.data).length === 0) {
    return <Redirect to="/404" />
  }
  history.listen(location => {
    const urlTitle = location.pathname.split('/').reverse()[0]
    setRequest({ ...request, data: {}, isFetching: false, isLoaded: false, params: { urlTitle }, makeRequest: true })
  })

  return (
    <Layout>
      {request.isLoaded && <Helmet title={request.data.settings.productHTMLTitleString} />}
      {request.isLoaded && (
        <PageHeader
          title={!request.data.showProducts && request.data.title}
          crumbs={request.data.breadcrumbs
            .map(crumb => {
              return { title: crumb.productTypeName, urlTitle: `/${productTypeRoute}/${crumb.urlTitle}` }
            })
            .filter(crumb => crumb.urlTitle !== `/${productTypeRoute}/${productTypeBase}`)
            .filter(crumb => crumb.urlTitle !== `/${productTypeRoute}/${id}`)}
        />
      )}
      {request.data.childProductTypes?.length > 0 && (
        <ProductTypeList
          onSelect={urlTitle => {
            history.push(`/${productTypeRoute}/${urlTitle}`)
          }}
          data={request.data}
        />
      )}
      {request.data.showProducts && (
        <ListingPage preFilter={{ productType_id: request.data.productTypeID }} hide={['productType']}>
          <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
            <h5 className="h4 text-dark mb-0 font-accent">{request.data.title}</h5>
          </div>
        </ListingPage>
      )}
    </Layout>
  )
}

export default ProductType
