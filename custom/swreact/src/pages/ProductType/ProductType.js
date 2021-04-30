import { Redirect, useHistory, useParams } from 'react-router-dom'
import { Layout, ProductTypeList } from '../../components'
import ListingPage from '../../components/Listing/Listing'
import { Helmet } from 'react-helmet'
import { useGetProductType } from '../../hooks/useAPI'
import { useSelector } from 'react-redux'
import { getProductTypeProductListRoute } from '../../selectors/configurationSelectors'

const ProductType = () => {
  let { id } = useParams()
  const history = useHistory()
  const [request, setRequest] = useGetProductType()
  const productsRoute = useSelector(getProductTypeProductListRoute)

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
      <Helmet title={request.data.htmlTitle} />
      {request.data.childProductTypes?.length > 0 && (
        <ProductTypeList
          onSelect={urlTitle => {
            history.push(`/${productsRoute}/${urlTitle}`)
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
