import React, { useEffect } from 'react'
import { Layout } from '../../components'
import { useDispatch } from 'react-redux'

import ProductListingGrid from '../../components/ProductListing/ProductListingGrid'
import ProductListingToolBar from '../../components/ProductListing/ProductListingToolBar'
import ProductListingPagination from '../../components/ProductListing/ProductListingPagination'
import ProductListingSidebar from '../../components/ProductListing/ProductListingSidebar'
import { getProductListingOptions, search } from '../../actions/productSearchActions'
import ProductListingHeader from '../../components/ProductListing/ProductListingHeader'

const ProductListing = () => {
  const dispatch = useDispatch()

  useEffect(() => {
    dispatch(search())
    dispatch(getProductListingOptions())
  }, [dispatch])

  return (
    <Layout>
      <ProductListingHeader />
      <div className="container pb-5 mb-2 mb-md-4">
        <div className="row">
          <aside className="col-lg-4">
            <ProductListingSidebar />
          </aside>
          <div className="col-lg-8">
            <ProductListingToolBar r />
            <ProductListingGrid />
            <ProductListingPagination />
          </div>
        </div>
      </div>
    </Layout>
  )
}

export default ProductListing
