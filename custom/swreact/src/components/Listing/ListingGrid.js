import ProductCard from '../Account/ProductCard/ProductCard'

const ListingGrid = ({ pageRecords }) => {
  return (
    <div className="row mx-n2">
      {pageRecords &&
        pageRecords.map(({ product_urlTitle, product_productID, product_productName, sku_imageFile }, index) => {
          return (
            <div key={product_productID} className="col-md-4 col-sm-6 px-2 mb-4">
              <ProductCard urlTitle={product_urlTitle} productID={product_productID} calculatedTitle={product_productName} defaultProductImageFiles={[sku_imageFile]} />
            </div>
          )
        })}
    </div>
  )
}
export default ListingGrid
