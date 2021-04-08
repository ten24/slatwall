import ProductCard from '../ProductCard/ProductCard'
import ContentLoader from 'react-content-loader'

const ListingGridLoader = props => (
  <ContentLoader viewBox="0 0 1200 500" height={400} width={1000} {...props}>
    <rect x="100" y="20" rx="8" ry="8" width="300" height="300" />
    <rect x="100" y="350" rx="0" ry="0" width="300" height="32" />
    <rect x="100" y="400" rx="0" ry="0" width="180" height="36" />

    <rect x="500" y="20" rx="8" ry="8" width="300" height="300" />
    <rect x="500" y="350" rx="0" ry="0" width="300" height="36" />
    <rect x="500" y="400" rx="0" ry="0" width="180" height="30" />

    <rect x="900" y="20" rx="8" ry="8" width="300" height="300" />
    <rect x="900" y="350" rx="0" ry="0" width="300" height="32" />
    <rect x="900" y="400" rx="0" ry="0" width="180" height="36" />
  </ContentLoader>
)

const Grid = ({ isFetching, products = [] }) => {
  return (
    <div className="row mx-n2">
      {isFetching && (
        <>
          <ListingGridLoader /> <ListingGridLoader /> <ListingGridLoader />
        </>
      )}
      {!isFetching &&
        products.map(({ urlTitle, productID, productName, sku_imageFile, sku_price, skuID }) => {
          return (
            <div key={productID} className="col-md-4 col-sm-6 px-2 mb-4">
              <ProductCard urlTitle={urlTitle} productID={productID} productName={productName} listPrice={sku_price} skuID={skuID} defaultProductImageFiles={[sku_imageFile]} />
            </div>
          )
        })}
    </div>
  )
}
export default Grid
