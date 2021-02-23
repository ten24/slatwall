import ProductCard from '../../components/Account/ProductCard/ProductCard'

const ProductListingGrid = ({ pageRecords }) => {
  return (
    <div className="row mx-n2">
      {pageRecords &&
        pageRecords.map((product, index) => {
          return (
            <div key={index} className="col-md-4 col-sm-6 px-2 mb-4">
              <ProductCard {...product} />
            </div>
          )
        })}
    </div>
  )
}
export default ProductListingGrid
