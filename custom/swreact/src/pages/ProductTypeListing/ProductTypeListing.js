import React, { useEffect, useState } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { Layout, BreadCrumb, SWImage } from '../../components'
import useRedirect from '../../hooks/useRedirect'
import { useGetProductType } from '../../hooks/useAPI'
import defaultImg from '../../assets/images/category-img-1.png'
import { getProductTypeProductListRoute } from '../../selectors/configurationSelectors'
import { useSelector } from 'react-redux'

const ProductTypeList = ({ productTypes }) => {
  
  const productsRoute = useSelector(getProductTypeProductListRoute);
  
  return (
    <div className="container pb-4 pb-sm-5">
      {/* <!--- Product Type grid ---> */}
      <div className="row pt-5">
        {/* <!--- Product Type ---> */}
        {productTypes &&
          productTypes.map(({ productTypeID, title, imageFile, urlTitle, subTypes }, index) => {
            
            let customImagePath = "";
            let imageFileName = defaultImg;
            if( imageFile != "") {
              imageFileName = imageFile.split('/').reverse()[0];
              customImagePath = imageFile.split('/').slice(0, -1).join('/') +"/";
              
              console.log(imageFileName, customImagePath, "product type list");
            }
            
            urlTitle = subTypes.length == 0 ? `/${productsRoute}/${urlTitle}` : urlTitle ;
            
            return (
              <div className="col-md-4 col-sm-6 mb-3" key={productTypeID}>
                <div className="card border-0">
                  <Link className="d-block overflow-hidden rounded-lg" to={urlTitle}>
                    <SWImage className="d-block w-100" customPath={customImagePath} src={imageFileName} alt={title} />
                  </Link>
                  <div className="card-body">
                    <h2 className="h5">
                      <Link to={urlTitle}>
                        {title}
                      </Link>
                    </h2>
                    <ul className="list-unstyled font-size-sm mb-0">
                      {subTypes.map(({ productTypeID, title, urlTitle, showProducts }, index) => {
                      
                        urlTitle = showProducts ? `/${productsRoute}/${urlTitle}` : urlTitle ;
                      
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
  )
}


const ProductTypeListing = props => {
  
  //get slug from url
  let slug = props.match.params.slug;
  
  let { pathname } = useLocation()
  const [path, setPath] = useState(pathname)
  
  const [redirect, setRedirect] = useRedirect({ location: '/404', time: 300 });
  const [request, setRequest] = useGetProductType()
  
  useEffect(() => {
    
    let didCancel = false
    
    //get product Type data from Server
    if (!request.isFetching && !request.isLoaded && !didCancel || ( path != pathname ) ) {
      setRequest({ ...request, isFetching: true, isLoaded: false, params: { 'urlTitle': props.match.params.slug }, makeRequest: true })
    }
    return () => {
      didCancel = true
    }
    
    if (!request.isFetching && request.isLoaded && Object.keys(request.data).length === 0) {
      setRedirect({ ...redirect, shouldRedirect: true })
    }
    
  }, [ props.match.params.slug ]);
  
  return (
    <Layout>
      <div className="bg-secondary py-4">
        <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
          <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
            <BreadCrumb crumbs={request.data.title} />
          </div>
          <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
            <h1 className="h3 mb-0">{request.data.title}</h1>
          </div>
        </div>
      </div>

      { request.data.subProductTypes && 
      <ProductTypeList productTypes={ request.data.subProductTypes } />
      }
    </Layout>
  )
}

export default ProductTypeListing
