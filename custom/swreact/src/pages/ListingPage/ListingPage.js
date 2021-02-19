import React, { useEffect, useState } from 'react'
import { Layout } from '../../components'
import { useDispatch } from 'react-redux'

import ProductListingHeader from './ProductListingHeader'
import ProductListingGrid from './ProductListingGrid'
import ProductListingToolBar from './ProductListingToolBar'
import ProductListingPagination from './ProductListingPagination'
import ProductListingSidebar from './ProductListingSidebar'
import PageHeader from '../../components/PageHeader/PageHeader'

const ListingPage = () => {
  const dispatch = useDispatch()
  const [products, setProducts] = useState([])

  useEffect(() => {
    // dispatch(search())
    // dispatch(getProductListingOptions())
  }, [dispatch])

  return (
    <Layout>
      <PageHeader />
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

export default ListingPage
