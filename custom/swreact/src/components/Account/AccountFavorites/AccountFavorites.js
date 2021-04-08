import React from 'react'
// import PropTypes from 'prop-types'
import { useSelector } from 'react-redux'
import { AccountLayout } from '../AccountLayout/AccountLayout'
import { useGetProductList } from '../../../hooks/useAPI'
import Grid from '../../Listing/Grid'
import ListingPagination from '../../Listing/ListingPagination'

const AccountFavorites = () => {
  const favouriteSkus = useSelector(state => state.userReducer.favouriteSkus)
  let [productList, setRequest] = useGetProductList()

  if (favouriteSkus.isLoaded && !productList.isFetching && !productList.isLoaded) {
    setRequest({ ...productList, params: { 'f:skus.skuid:eq': favouriteSkus.skusList.join() }, makeRequest: true, isFetching: true, isLoaded: false })
  }
  const setPage = pageNumber => {
    setRequest({ ...productList, params: { 'f:skus.skuid:eq': favouriteSkus.skusList.join(), currentPage: pageNumber }, makeRequest: true, isFetching: true, isLoaded: false })
  }

  return (
    <AccountLayout>
      <div className="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
        <div className="d-flex justify-content-between w-100">&nbsp;</div>
      </div>
      <Grid
        isFetching={productList.isFetching}
        products={productList.data.map(({ urlTitle, productID, productName, defaultSku_imageFile, defaultSku_price, defaultSku_skuID }) => {
          return { urlTitle, productID, productName, sku_imageFile: defaultSku_imageFile, sku_price: defaultSku_price, skuID: defaultSku_skuID }
        })}
      />
      <ListingPagination recordsCount={productList.data} currentPage={productList.currentPage} totalPages={productList.totalPages} setPage={setPage} />
    </AccountLayout>
  )
}

export default AccountFavorites
