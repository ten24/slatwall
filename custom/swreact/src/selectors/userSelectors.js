import { createSelector } from 'reselect'

export const getAllAccountPaymentMethods = state => state.userReducer.accountPaymentMethods
export const getAllAccountAddresses = state => state.userReducer.accountAddresses
export const getPrimaryAddress = state => state.userReducer.primaryAddress
export const getWishlists = state => state.userReducer.wishList.lists
export const getWishlistsItems = state => state.userReducer.wishList.items

export const accountPaymentMethods = createSelector(getAllAccountPaymentMethods, (accountPaymentMethods = []) => {
  return accountPaymentMethods.map(({ accountPaymentMethodName, creditCardType, creditCardLastFour, accountPaymentMethodID }) => {
    return { name: `${accountPaymentMethodName} | ${creditCardType} - *${creditCardLastFour}`, value: accountPaymentMethodID }
  })
})

export const getDefaultWishlist = createSelector(getWishlists, (lists = []) => {
  return lists.length > 0 ? lists[0] : {}
})

export const getItemsForDefaultWishList = createSelector(getDefaultWishlist, getWishlistsItems, (defaultWishlist = {}, items = []) => {
  return items
    .filter(item => {
      return item.orderTemplate_orderTemplateID === defaultWishlist?.value
    })
    .map(item => item.sku_skuID)
})
