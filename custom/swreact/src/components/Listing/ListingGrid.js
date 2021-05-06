import ProductCard from '../ProductCard/ProductCard'
import ContentLoader from 'react-content-loader'

import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'

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

const ListingGrid = ({ isFetching, pageRecords }) => {
  const { t } = useTranslation()

  return (
    <div className="row mx-n2">
      {isFetching && (
        <>
          <ListingGridLoader /> <ListingGridLoader /> <ListingGridLoader />
        </>
      )}
      {!isFetching &&
        pageRecords.length > 0 &&
        pageRecords.map(({ product_urlTitle, product_productID, product_productName, product_productCode, sku_imageFile, listPrice, sku_skuID }, index) => {
          return (
            <div key={sku_skuID + `${index}`} className="col-md-4 col-sm-6 px-2 mb-4">
              <ProductCard urlTitle={product_urlTitle} productID={product_productID} productName={product_productName} productCode={product_productCode} listPrice={listPrice} skuID={sku_skuID} imageFile={sku_imageFile} />
            </div>
          )
        })}
      {!isFetching && pageRecords.length === 0 && (
        <div className="col">
          {t('frontend.listing.noProductsFound')}
          <br />
          {t('frontend.listing.needAssistance')} <Link to="/contact">{t('frontend.nav.contact')}</Link>
        </div>
      )}
    </div>
  )
}
export default ListingGrid
