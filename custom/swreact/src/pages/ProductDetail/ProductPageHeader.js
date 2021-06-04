const ProductPageHeader = ({ title = '', children }) => {
  return (
    <div className="page-title-overlap bg-lightgray pt-4">
      <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 className="h3 text-dark mb-0 font-accent">{title}</h1>
        </div>
        <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">{children}</div>
      </div>
    </div>
  )
}

export default ProductPageHeader
