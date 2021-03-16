import { createSelector } from 'reselect'

export const getAllOrderFulfillments = state => state.cart.orderFulfillments
export const getAllAccountAddresses = state => state.userReducer.accountAddresses

export const fulfillmentMethodSelector = createSelector(getAllOrderFulfillments, orderFulfillments => {
  let selectedFulfillmentMethod = { fulfillmentMethodID: '' }
  if (orderFulfillments[0] && orderFulfillments[0].fulfillmentMethod) {
    selectedFulfillmentMethod = orderFulfillments[0].fulfillmentMethod
  }
  return selectedFulfillmentMethod
})

export const fulfillmentSelector = createSelector(getAllOrderFulfillments, orderFulfillments => {
  let selectedFulfillment = { fulfillmentMethodID: '', fulfillmentMethod: { fulfillmentMethodType: '' } }
  if (orderFulfillments[0]) {
    selectedFulfillment = orderFulfillments[0]
  }
  return selectedFulfillment
})

export const shippingMethodSelector = createSelector(getAllOrderFulfillments, orderFulfillments => {
  let selectedFulfillmentMethod = { shippingMethodID: '' }
  if (orderFulfillments[0] && orderFulfillments[0].shippingMethod) {
    selectedFulfillmentMethod = orderFulfillments[0].shippingMethod
  }
  return selectedFulfillmentMethod
})

export const accountAddressSelector = createSelector([getAllAccountAddresses, getAllOrderFulfillments], (accountAddresses, orderFulfillments) => {
  let selectedAccountID = ''
  if (orderFulfillments.length && accountAddresses.length && orderFulfillments[0].accountAddress) {
    const selectAccount = accountAddresses
      .filter(({ accountAddressID }) => {
        return accountAddressID === orderFulfillments[0].accountAddress.accountAddressID
      })
      .map(({ accountAddressID }) => {
        return accountAddressID
      })
    selectedAccountID = selectAccount.length ? selectAccount[0] : ''
  }

  return selectedAccountID
})
