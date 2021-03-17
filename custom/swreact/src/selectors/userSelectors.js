import { createSelector } from 'reselect'

export const getAllAccountPaymentMethods = state => state.userReducer.accountPaymentMethods

export const accountPaymentMethods = createSelector(getAllAccountPaymentMethods, (accountPaymentMethods = []) => {
  return accountPaymentMethods.map(({ accountPaymentMethodName, creditCardType, creditCardLastFour, accountPaymentMethodID }) => {
    return { name: `${accountPaymentMethodName} | ${creditCardType} - *${creditCardLastFour}`, value: accountPaymentMethodID }
  })
})
