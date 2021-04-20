import { useEffect } from 'react'
import { useGetEntityByID } from '../../hooks'
import { isString, isBoolean, booleanToString, containsHTML } from '../../utils'

const propertyBlackList = ['productID', 'productName', 'productCode']

// TODO: Migrate to reactstrap accordion
const ProductPagePanels = ({ productID }) => {
  let [request, setRequest] = useGetEntityByID()
  let propertiesToDisplay = []
  useEffect(() => {
    let didCancel = false
    if (!request.isFetching && !request.isLoaded && !didCancel) {
      setRequest({ ...request, isFetching: true, isLoaded: false, entity: 'product', params: { entityID: productID }, makeRequest: true })
    }
    return () => {
      didCancel = true
    }
  }, [request, setRequest, productID])

  if (request.isLoaded) {
    propertiesToDisplay = Object.keys(request.data)
      .filter(property => {
        return property.startsWith('product') && !propertyBlackList.includes(property)
      })
      .map(property => {
        return { key: property.replace('product', ''), value: isBoolean(request.data[property]) ? booleanToString(request.data[property]) : request.data[property] }
      })
      .filter(({ key, value }) => {
        return isString(value) && value.trim().length > 0
      })
  }
  return (
    <div className="accordion mb-4" id="productPanels">
      {/* <div className="alert alert-danger" role="alert">
        <i className="far fa-exclamation-circle"></i> This item is not eligable for free freight
      </div> */}
      <div className="card">
        <div className="card-header">
          <h3 className="accordion-heading">
            <a href="#productInfo" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="productInfo">
              <i className="far fa-key font-size-lg align-middle mt-n1 mr-2"></i>
              Product info<span className="accordion-indicator"></span>
            </a>
          </h3>
        </div>
        <div className="collapse show" id="productInfo" data-parent="#productPanels">
          <div className="card-body">
            <div className="font-size-sm row">
              <div className="col-6">
                <ul>
                  {request.isLoaded &&
                    propertiesToDisplay.map(({ key }) => {
                      return <li key={key}>{key}:</li>
                    })}
                </ul>
              </div>
              <div className="col-6 text-muted">
                <ul>
                  {request.isLoaded &&
                    propertiesToDisplay.map(({ key, value }) => {
                      return <li key={key}>{containsHTML(value) ? <div dangerouslySetInnerHTML={{ __html: value }} /> : value}</li>
                    })}
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="card">
        <div className="card-header">
          <h3 className="accordion-heading">
            <a className="collapsed" href="#technicalinfo" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="technicalinfo">
              <i className="far fa-drafting-compass align-middle mt-n1 mr-2"></i>
              Technical Info<span className="accordion-indicator"></span>
            </a>
          </h3>
        </div>
        <div className="collapse" id="technicalinfo" data-parent="#productPanels">
          <div className="card-body font-size-sm">
            <div className="d-flex justify-content-between border-bottom py-2">
              <div className="font-weight-semibold text-dark">Document Title</div>
              <a href="?=doc">Download</a>
            </div>
            <div className="d-flex justify-content-between border-bottom py-2">
              <div className="font-weight-semibold text-dark">Document Title</div>
              <a href="?=doc">Download</a>
            </div>
          </div>
        </div>
      </div>
      <div className="card">
        <div className="card-header">
          <h3 className="accordion-heading">
            <a className="collapsed" href="#questions" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="questions">
              <i className="far fa-question-circle font-size-lg align-middle mt-n1 mr-2"></i>
              Questions?<span className="accordion-indicator"></span>
            </a>
          </h3>
        </div>
        <div className="collapse" id="questions" data-parent="#productPanels">
          <div className="card-body">
            <p>Have questions about this product?</p>
            <a href="/contact">Contact Us</a>
          </div>
        </div>
      </div>
    </div>
  )
}

export default ProductPagePanels
