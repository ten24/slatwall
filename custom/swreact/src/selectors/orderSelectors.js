import { createSelector } from 'reselect'

export const getAllOrderFulfillments = state => state.cart.orderFulfillments
export const getAllAccountAddresses = state => state.userReducer.accountAddresses
export const getAllAccountPaymentMethods = state => state.userReducer.accountPaymentMethods
export const getAllPickupLocations = state => state.cart.pickupLocations
export const getAllOrderPayments = state => state.cart.orderPayments
export const getAllEligiblePaymentMethodDetails = state => state.cart.eligiblePaymentMethodDetails
export const getAllOrderItems = state => state.cart.orderItems
export const isFetching = state => state.cart.isFetching

export const hasOrderItems = createSelector(getAllOrderItems, orderItems => {
  return orderItems.length ? true : false
})

export const orderItemsCountSelector = createSelector(getAllOrderItems, orderItems => {
  return orderItems.length
})
export const disableInteractionSelector = createSelector([hasOrderItems, isFetching], (validOI, fetching) => {
  return !(validOI && !fetching)
})

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

export const shippingAddressSelector = createSelector(fulfillmentSelector, orderFulfillment => {
  return orderFulfillment.shippingAddress || {}
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

export const pickupLocationOptions = createSelector(getAllPickupLocations, (locations = []) => {
  return locations.map(location => {
    return { name: location['NAME'], value: location['VALUE'] }
  })
})

export const pickupLocationSelector = createSelector(fulfillmentSelector, fulfillment => {
  let location = { locationID: '' }
  if (fulfillment.pickupLocation) {
    location = fulfillment.pickupLocation
  }
  return location
})

export const orderPayment = createSelector(getAllOrderPayments, orderPayments => {
  let orderPayment = { paymentMethod: { paymentMethodID: '' }, accountPaymentMethod: { accountPaymentMethodID: '' } }
  if (orderPayments.length) {
    orderPayment = orderPayments[0]
  }
  return orderPayment
})

export const eligiblePaymentMethodDetailSelector = createSelector(getAllEligiblePaymentMethodDetails, (eligiblePaymentMethodDetails = []) => {
  return eligiblePaymentMethodDetails.map(({ paymentMethod }) => {
    return { name: paymentMethod.paymentMethodName, value: paymentMethod.paymentMethodID }
  })
})

export const billingAccountAddressSelector = createSelector([getAllAccountAddresses, orderPayment], (accountAddresses, paymentOnOrder) => {
  let selectedAccountID = ''
  if (accountAddresses.length && paymentOnOrder && paymentOnOrder.billingAccountAddress) {
    const selectAccount = accountAddresses
      .filter(({ accountAddressID }) => {
        return accountAddressID === paymentOnOrder.billingAccountAddress.accountAddressID
      })
      .map(({ accountAddressID }) => {
        return accountAddressID
      })
    selectedAccountID = selectAccount.length ? selectAccount[0] : ''
  }

  return selectedAccountID
})

export const billingAddressNickname = createSelector([getAllAccountPaymentMethods, orderPayment], (accountPaymentMethods, payment) => {
  let billingAddressNickname = ''
  if (payment && payment.accountPaymentMethod) {
    billingAddressNickname = accountPaymentMethods
      .filter(({ accountPaymentMethodID }) => {
        return accountPaymentMethodID === payment.accountPaymentMethod.accountPaymentMethodID
      })
      .map(({ accountPaymentMethodName }) => {
        return accountPaymentMethodName
      })
    billingAddressNickname = billingAddressNickname.length ? billingAddressNickname[0] : ''
  }
  return billingAddressNickname
})
export const shippingAddressNicknameSelector = createSelector([fulfillmentSelector, getAllAccountAddresses], (fulfillment, accountAddresses = []) => {
  let shippingAddressNickname = accountAddresses
    .filter(accountAddress => {
      return fulfillment.shippingAddress && accountAddress.address.addressID === fulfillment.shippingAddress.addressID
    })
    .map(({ accountAddressName }) => {
      return accountAddressName
    })
  shippingAddressNickname = shippingAddressNickname.length ? shippingAddressNickname[0] : ''

  return shippingAddressNickname
})
