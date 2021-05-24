import { Helmet } from 'react-helmet'
import { Layout, ProductTypeList } from '../../components'
import ListingPage from '../../components/Listing/Listing'
import { Redirect, useHistory, useLocation } from 'react-router'
import { useGetProductTypeLegacy } from '../../hooks/useAPI'
import { useSelector } from 'react-redux'
import queryString from 'query-string'
import { useEffect } from 'react'

const Search = () => {
  const loc = useLocation()
  let params = queryString.parse(loc.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })

  const history = useHistory()

  const [request, setRequest] = useGetProductTypeLegacy()
  const productTypeBase = useSelector(state => state.configuration.filtering.productTypeBase)
  const productTypeUrl = params['key'] || productTypeBase

  useEffect(() => {
    if (!request.isFetching && !request.isLoaded) {
      setRequest({ ...request, isFetching: true, isLoaded: false, params: { urlTitle: productTypeUrl }, makeRequest: true })
    }
  }, [request, setRequest, productTypeUrl])

  if (!request.isFetching && request.isLoaded && Object.keys(request.data).length === 0) {
    return <Redirect to="/404" />
  }
  history.listen(location => {
    let params = queryString.parse(location.search, { arrayFormat: 'separator', arrayFormatSeparator: ',' })
    setRequest({ ...request, data: {}, isFetching: true, isLoaded: false, params: { urlTitle: params['key'] || productTypeBase }, makeRequest: true })
  })

  return (
    <Layout>
      <div className="container pb-2 pt-5 border-bottom d-none">
        <div className="product-section mb-3">
          <h2 className="h5">Keyblanks & Automotive</h2>
          <div className="row">
            <div className="col-xl-4 col-md-6 col-12 mb-3">
              <div className="card bg-lightgray border-0">
                <div className="card-body">
                  <h3 className="h5">
                    <button className="link-button">Electronic Hardware</button>
                  </h3>
                  <ul className="two-cols d-flex flex-wrap list-unstyled font-size-sm mb-0">
                    <li className="d-flex">
                      <button className="link-button nav-link-style">
                        <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Locks
                      </button>
                    </li>
                    <li className="d-flex">
                      <button className="link-button nav-link-style">
                        <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Parts &amp; Accessories
                      </button>
                    </li>
                    <li className="d-flex">
                      <button className="link-button nav-link-style">
                        <i className="far fa-chevron-circle-right pr-2"></i>Electronic Standalone
                      </button>
                    </li>
                    <li className="d-flex">
                      <button className="link-button nav-link-style">
                        <i className="far fa-chevron-circle-right pr-2"></i>Electronic Networked
                      </button>
                    </li>
                    <li className="d-flex">
                      <button className="link-button nav-link-style">
                        <i className="far fa-chevron-circle-right pr-2"></i>Access Control
                      </button>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div className="col-xl-4 col-md-6 col-12 mb-3">
              <div className="card bg-lightgray border-0">
                <div className="card-body">
                  <h3 className="h5">
                    <button className="link-button">Electronic Hardware</button>
                  </h3>
                  <ul className="two-cols d-flex flex-wrap list-unstyled font-size-sm mb-0">
                    <li className="d-flex">
                      <button className="link-button nav-link-style">
                        <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Locks
                      </button>
                    </li>
                    <li className="d-flex">
                      <button className="link-button nav-link-style">
                        <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Parts &amp; Accessories
                      </button>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div className="col-xl-4 col-md-6 col-12 mb-3">
              <div className="card bg-lightgray border-0">
                <div className="card-body">
                  <h3 className="h5">
                    <button className="link-button">Electronic Hardware</button>
                  </h3>
                  <ul className="two-cols d-flex flex-wrap list-unstyled font-size-sm mb-0">
                    <li className="d-flex">
                      <button className="link-button nav-link-style">
                        <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Locks
                      </button>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="product-section mb-3">
          <h2 className="h5">Keyblanks & Automotive</h2>
          <div className="row">
            <div className="col-xl-4 col-md-6 col-12 mb-3">
              <div className="card bg-lightgray border-0">
                <div className="card-body">
                  <h3 className="h5">
                    <button className="link-button">Electronic Hardware</button>
                  </h3>
                  <ul className="two-cols d-flex flex-wrap list-unstyled font-size-sm mb-0">
                    <li className="d-flex">
                      <button className="link-button nav-link-style">
                        <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Locks
                      </button>
                    </li>
                    <li className="d-flex">
                      <button className="link-button nav-link-style">
                        <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Parts &amp; Accessories
                      </button>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div className="col-xl-4 col-md-6 col-12 mb-3">
              <div className="card bg-lightgray border-0">
                <div className="card-body">
                  <h3 className="h5">
                    <button className="link-button">Electronic Hardware</button>
                  </h3>
                  <ul className="two-cols d-flex flex-wrap list-unstyled font-size-sm mb-0">
                    <li className="d-flex">
                      <button className="link-button nav-link-style">
                        <i className="far fa-chevron-circle-right pr-2"></i>Pushbutton Locks
                      </button>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <Helmet title={`Search - ${params['keyword']}`} />
      {request.data.childProductTypes?.length > 0 && (
        <ProductTypeList
          data={request.data}
          onSelect={urlTitle => {
            params['key'] = urlTitle
            history.push(`${loc.pathname}?${queryString.stringify(params, { arrayFormat: 'comma' })}`)
          }}
        />
      )}
      {request.data.showProducts && <ListingPage preFilter={{ productType_id: request.data.productTypeID }} hide={['productType']} />}
    </Layout>
  )
}

export default Search
