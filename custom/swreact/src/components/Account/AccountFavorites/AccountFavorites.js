import React, { useState } from 'react'
// import PropTypes from 'prop-types'
import { useSelector } from 'react-redux'
import { AccountLayout } from '../AccountLayout/AccountLayout'
import { useGetProductsByEntity } from '../../../hooks/useAPI'
import Grid from '../../Listing/Grid'
import ListingPagination from '../../Listing/ListingPagination'
import { getItemsForDefaultWishList } from '../../../selectors/userSelectors'

const AccountFavorites = () => {
  const items = useSelector(getItemsForDefaultWishList)
  const isListItemsLoaded = useSelector(state => state.userReducer.wishList.isListItemsLoaded)
  let [productList, setRequest] = useGetProductsByEntity()
  let [skuList, setSkuList] = useState(items)
  const [currentPage, setPage] = useState(1)
  const countToDisplay = 6

  if (isListItemsLoaded && !productList.isFetching && !productList.isLoaded) {
    setSkuList(items)
    setRequest({ ...productList, entity: 'product', params: { 'f:skus.skuID:in': items.join() }, makeRequest: true, isFetching: true, isLoaded: false })
  }

  if (skuList !== items) {
    setSkuList(items)
    setRequest({ ...productList, entity: 'product', params: { 'f:skus.skuID:in': items.join() }, makeRequest: true, isFetching: true, isLoaded: false })
  }
  const start = (currentPage - 1) * countToDisplay
  const end = start + countToDisplay
  return (
    <AccountLayout>
      <div className="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
        <div className="d-flex justify-content-between w-100">&nbsp;</div>
      </div>
      <Grid
        isFetching={productList.isFetching}
        products={productList.data.slice(start, end).map(({ urlTitle, productID, productName, defaultSku_imageFile, calculatedSalePrice, defaultSku_listPrice, defaultSku_skuID }) => {
          return { urlTitle, productID, calculatedSalePrice, productName, sku_imageFile: defaultSku_imageFile, sku_price: defaultSku_listPrice, skuID: defaultSku_skuID }
        })}
      />
      <ListingPagination recordsCount={productList.data.length} totalPages={Math.ceil(productList.data.length / countToDisplay)} setPage={setPage} />
    </AccountLayout>
  )
}

export default AccountFavorites
