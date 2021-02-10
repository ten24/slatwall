import React, { useEffect } from 'react'
import { Layout } from '../../components'
import { useDispatch } from 'react-redux'
import capitalize from 'lodash/capitalize'

import ProductListingGrid from '../../components/ProductListing/ProductListingGrid'
import ProductListingToolBar from '../../components/ProductListing/ProductListingToolBar'
import ProductListingPagination from '../../components/ProductListing/ProductListingPagination'
import ProductListingSidebar from '../../components/ProductListing/ProductListingSidebar'
import { getProductListingOptions, search } from '../../actions/productSearchActions'
import ProductListingHeader from '../../components/ProductListing/ProductListingHeader'
import BrandBanner from './BrandBanner'

const Brand = props => {
  const dispatch = useDispatch()
  const path = props.location.pathname.split('/').reverse()

  useEffect(() => {
    dispatch(
      search({
        'brand.urlTitle:eq': path[0],
      })
    )
    dispatch(getProductListingOptions())
  }, [dispatch, path])

  return (
    <Layout>
      <ProductListingHeader customTitle={capitalize(path[0])}>
        <BrandBanner brandCode={path[0]} />
      </ProductListingHeader>
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

export default Brand
