const ProductPageHeader = () => {
  return (
    <div className="page-title-overlap bg-lightgray pt-4">
      <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <nav aria-label="breadcrumb">
            <ol className="breadcrumb text-small bg-lightgray flex-lg-nowrap justify-content-center justify-content-lg-start">
              <li className="breadcrumb-item">
                <a className="text-nowrap" href="index.html">
                  <i className="fa fa-home"></i>Home
                </a>
              </li>
              <li className="breadcrumb-item text-nowrap">
                <a href="#">Shop</a>
              </li>
              <li className="breadcrumb-item text-nowrap active" aria-current="page">
                Product Page v.1
              </li>
            </ol>
          </nav>
        </div>
        <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 className="h3 text-dark mb-0 font-accent">Gardell 1812 Series</h1>
        </div>
      </div>
    </div>
  )
}

export default ProductPageHeader
