import { SWImage } from '../../components'

const ProductTypeList = ({ data, onSelect, brand = {} }) => {
  return (
    <div className="container pb-4 pb-sm-5">
      {/* <!--- Product Type grid ---> */}
      <div className="row pt-5">
        {/* <!--- Product Type ---> */}
        {data.childProductTypes &&
          data.childProductTypes.map(({ productTypeID, title, imageFile, urlTitle, childProductTypes }, index) => {
            let customImagePath = ''
            let imageFileName = ''
            if (imageFile !== '') {
              imageFileName = imageFile.split('/').reverse()[0]
              customImagePath = imageFile.split('/').slice(0, -1).join('/') + '/'
            }

            return (
              <div className="col-lg-3 col-md-4 col-sm-6 col-xs-12 mb-3" key={productTypeID}>
                <div className="card border-0">
                  <div
                    className="d-block overflow-hidden rounded-lg typelisting-image"
                    onClick={e => {
                      e.preventDefault()
                      onSelect(urlTitle)
                    }}
                  >
                    <SWImage className="d-block w-100" customPath={customImagePath} src={imageFileName} alt={title} type="productType" />
                  </div>
                  <div className="card-body">
                    <h2 className="h5">
                      <button
                        className="link-button text-left"
                        onClick={e => {
                          e.preventDefault()
                          onSelect(urlTitle)
                        }}
                      >
                        {title}
                      </button>
                    </h2>
                    <ul className="list-unstyled font-size-sm mb-0">
                      {childProductTypes.map(({ productTypeID, title, urlTitle, showProducts }, index) => {
                        return (
                          <li key={productTypeID}>
                            <button
                              className="link-button nav-link-style d-flex align-items-center justify-content-between text-left"
                              onClick={e => {
                                e.preventDefault()
                                onSelect(urlTitle)
                              }}
                            >
                              <i className="far fa-chevron-circle-right pr-2"></i>
                              {title}
                            </button>
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

export { ProductTypeList }
