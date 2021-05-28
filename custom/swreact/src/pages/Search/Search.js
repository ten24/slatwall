import { Helmet } from 'react-helmet'
import { Layout, PageHeader, ProductTypeList } from '../../components'
import ListingPage from '../../components/Listing/Listing'
import { useHistory, useLocation } from 'react-router'
import { useGetEntity } from '../../hooks/useAPI'
import { useSelector } from 'react-redux'
import queryString from 'query-string'
import { useEffect } from 'react'
import { augmentProductType } from '../../utils'
import { useTranslation } from 'react-i18next'

const Search = () => {
  const loc = useLocation()
  const { t } = useTranslation()
  let params = queryString.parse(loc.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })

  const history = useHistory()

  const [productTypeListRequest, setProductTypeListRequest] = useGetEntity()
  const productTypeBase = useSelector(state => state.configuration.filtering.productTypeBase)
  const productTypeUrl = params['key'] || productTypeBase

  useEffect(() => {
    if (!productTypeListRequest.isFetching && !productTypeListRequest.isLoaded) {
      setProductTypeListRequest({ ...productTypeListRequest, isFetching: true, isLoaded: false, entity: 'ProductType', params: { searchKeyword: params?.keyword, 'p:show': 250, includeSettingsInList: true }, makeRequest: true })
    }
  }, [productTypeUrl, params, productTypeListRequest, setProductTypeListRequest])

  useEffect(() => {
    const unload = history.listen(location => {
      let newParams = queryString.parse(location.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
      if (Object.keys(newParams).length === 1) {
        setProductTypeListRequest({ ...productTypeListRequest, isFetching: true, isLoaded: false, entity: 'ProductType', params: { searchKeyword: newParams?.keyword, 'p:show': 250, includeSettingsInList: true }, makeRequest: true })
      }
    })
    return () => {
      unload()
    }
  }, [productTypeListRequest, setProductTypeListRequest, history])

  const productTypeData = augmentProductType(productTypeUrl, productTypeListRequest.data)

  return (
    <Layout>
      <Helmet title={`Search - ${params['keyword']}`} />

      {productTypeListRequest.isLoaded && (
        <PageHeader
          title={''}
          crumbs={productTypeListRequest.data
            .filter(productType => {
              return productTypeData?.productTypeIDPath?.includes(productType.productTypeID)
            })
            .map(crumb => {
              return { title: crumb.productTypeName, urlTitle: crumb.urlTitle }
            })
            .filter(crumb => crumb.urlTitle !== productTypeBase)
            .filter(crumb => crumb.urlTitle !== params['key'])
            .map(crumb => {
              return { ...crumb, urlTitle: `${loc.pathname}?${queryString.stringify({ ...params, key: crumb.urlTitle }, { arrayFormat: 'comma' })}` }
            })}
        />
      )}
      <div className="container bg-light box-shadow-lg rounded-lg p-5">
        {/* <!--- Product Type grid ---> */}
        <div className="row">
          {productTypeListRequest.isLoaded && productTypeData.childProductTypes?.length > 0 && (
            <ProductTypeList
              data={productTypeData}
              onSelect={urlTitle => {
                params['key'] = urlTitle
                history.push(`${loc.pathname}?${queryString.stringify(params, { arrayFormat: 'comma' })}`)
              }}
            />
          )}
          {!productTypeListRequest.isFetching && productTypeListRequest.isLoaded && Object.keys(productTypeListRequest.data).length === 0 && (
            <div className="alert alert-info" role="alert">
              {`${t('frontend.search.no_results')} ${params?.keyword}`}
            </div>
          )}
        </div>
      </div>
      {productTypeListRequest.isLoaded && productTypeData?.childProductTypes?.length === 0 && <ListingPage preFilter={{ productType_slug: productTypeUrl }} hide={['productType']} />}
    </Layout>
  )
}

export default Search

// <div className="container pb-2 pt-5 border-bottom d-none">
// <div className="product-section mb-3">
//   <h2 className="h5">Keyblanks & Automotive</h2>
//   <div className="row">
//     <div className="col-xl-4 col-md-6 col-12 mb-3">
//       <div className="card bg-lightgray border-0">
//         <div className="card-body">
//           <h3 className="h5">
//             <button className="link-button">Electronic Hardware</button>
//           </h3>
//           <ul className="two-cols d-flex flex-wrap list-unstyled font-size-sm mb-0">
//             <li className="d-flex">
//               <button className="link-button nav-link-style">
//                 <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Locks
//               </button>
//             </li>
//             <li className="d-flex">
//               <button className="link-button nav-link-style">
//                 <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Parts &amp; Accessories
//               </button>
//             </li>
//             <li className="d-flex">
//               <button className="link-button nav-link-style">
//                 <i className="far fa-chevron-circle-right pr-2"></i>Electronic Standalone
//               </button>
//             </li>
//             <li className="d-flex">
//               <button className="link-button nav-link-style">
//                 <i className="far fa-chevron-circle-right pr-2"></i>Electronic Networked
//               </button>
//             </li>
//             <li className="d-flex">
//               <button className="link-button nav-link-style">
//                 <i className="far fa-chevron-circle-right pr-2"></i>Access Control
//               </button>
//             </li>
//           </ul>
//         </div>
//       </div>
//     </div>
//     <div className="col-xl-4 col-md-6 col-12 mb-3">
//       <div className="card bg-lightgray border-0">
//         <div className="card-body">
//           <h3 className="h5">
//             <button className="link-button">Electronic Hardware</button>
//           </h3>
//           <ul className="two-cols d-flex flex-wrap list-unstyled font-size-sm mb-0">
//             <li className="d-flex">
//               <button className="link-button nav-link-style">
//                 <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Locks
//               </button>
//             </li>
//             <li className="d-flex">
//               <button className="link-button nav-link-style">
//                 <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Parts &amp; Accessories
//               </button>
//             </li>
//           </ul>
//         </div>
//       </div>
//     </div>
//     <div className="col-xl-4 col-md-6 col-12 mb-3">
//       <div className="card bg-lightgray border-0">
//         <div className="card-body">
//           <h3 className="h5">
//             <button className="link-button">Electronic Hardware</button>
//           </h3>
//           <ul className="two-cols d-flex flex-wrap list-unstyled font-size-sm mb-0">
//             <li className="d-flex">
//               <button className="link-button nav-link-style">
//                 <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Locks
//               </button>
//             </li>
//           </ul>
//         </div>
//       </div>
//     </div>
//   </div>
// </div>

// <div className="product-section mb-3">
//   <h2 className="h5">Keyblanks & Automotive</h2>
//   <div className="row">
//     <div className="col-xl-4 col-md-6 col-12 mb-3">
//       <div className="card bg-lightgray border-0">
//         <div className="card-body">
//           <h3 className="h5">
//             <button className="link-button">Electronic Hardware</button>
//           </h3>
//           <ul className="two-cols d-flex flex-wrap list-unstyled font-size-sm mb-0">
//             <li className="d-flex">
//               <button className="link-button nav-link-style">
//                 <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Locks
//               </button>
//             </li>
//             <li className="d-flex">
//               <button className="link-button nav-link-style">
//                 <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Parts &amp; Accessories
//               </button>
//             </li>
//           </ul>
//         </div>
//       </div>
//     </div>
//     <div className="col-xl-4 col-md-6 col-12 mb-3">
//       <div className="card bg-lightgray border-0">
//         <div className="card-body">
//           <h3 className="h5">
//             <button className="link-button">Electronic Hardware</button>
//           </h3>
//           <ul className="two-cols d-flex flex-wrap list-unstyled font-size-sm mb-0">
//             <li className="d-flex">
//               <button className="link-button nav-link-style">
//                 <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Locks
//               </button>
//             </li>
//           </ul>
//         </div>
//       </div>
//     </div>
//   </div>
// </div>
// </div>
