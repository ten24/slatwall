import { Link, Redirect, useHistory, useParams } from 'react-router-dom'
import { Layout, BreadCrumb, SWImage } from '../../components'
import ListingPage from '../../components/Listing/Listing'
// import PageHeader from '../../components/PageHeader/PageHeader'
import { Helmet } from 'react-helmet'

import { useGetProductType } from '../../hooks/useAPI'
import defaultImg from '../../assets/images/category-img-1.png'
import { getProductTypeProductListRoute } from '../../selectors/configurationSelectors'
import { useSelector } from 'react-redux'

const ProductTypeList = ({ data }) => {
  const productsRoute = useSelector(getProductTypeProductListRoute)

  return (
    <Layout>
      {/* TODO: can be replaced with page-header? */}
      <div className="page-title-overlap bg-lightgray pt-4">
        <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
          <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
            <BreadCrumb />
          </div>
          <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
            <h1 className="h3 text-dark mb-0 font-accent">{data.title || ''}</h1>
          </div>
        </div>
      </div>

      <div className="container pb-4 pb-sm-5">
        {/* <!--- Product Type grid ---> */}
        <div className="row pt-5">
          {/* <!--- Product Type ---> */}
          {data.childProductTypes &&
            data.childProductTypes.map(({ productTypeID, title, imageFile, urlTitle, childProductTypes }, index) => {
              let customImagePath = ''
              let imageFileName = defaultImg
              if (imageFile !== '') {
                imageFileName = imageFile.split('/').reverse()[0]
                customImagePath = imageFile.split('/').slice(0, -1).join('/') + '/'
              }

              urlTitle = childProductTypes.length === 0 ? `/${productsRoute}/${urlTitle}` : urlTitle

              return (
                <div className="col-md-4 col-sm-6 mb-3" key={productTypeID}>
                  <div className="card border-0">
                    <Link className="d-block overflow-hidden rounded-lg" to={urlTitle}>
                      <SWImage className="d-block w-100" customPath={customImagePath} src={imageFileName} alt={title} />
                    </Link>
                    <div className="card-body">
                      <h2 className="h5">
                        <Link to={urlTitle}>{title}</Link>
                      </h2>
                      <ul className="list-unstyled font-size-sm mb-0">
                        {childProductTypes.map(({ productTypeID, title, urlTitle, showProducts }, index) => {
                          urlTitle = showProducts ? `/${productsRoute}/${urlTitle}` : urlTitle

                          return (
                            <li className="d-flex align-items-center justify-content-between" key={productTypeID}>
                              <Link className="nav-link-style" to={urlTitle}>
                                <i className="far fa-chevron-circle-right pr-2"></i>
                                {title}
                              </Link>
                            </li>
                          )
                        })}
                      </ul>
                    </div>
                  </div>
                </div>
              )
            })}
        </div>
      </div>
    </Layout>
  )
}

const ProductType = () => {
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
      <Helmet title={request.data.htmlTitle} />
      {request.data.childProductTypes?.length > 0 && <ProductTypeList data={request.data} />}
      {request.data.showProducts && (
        <ListingPage preFilter={{ productType_id: request.data.productTypeID }} hide={'productType'}>
          <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
            <h5 className="h4 text-dark mb-0 font-accent">{request.data.title}</h5>
          </div>
        </ListingPage>
      )}
    </Layout>
  )
}

export default ProductType
