import { useDispatch, useSelector } from 'react-redux'
import { useFormik } from 'formik'
import { SwSelect } from '../..'
import { useTranslation } from 'react-i18next'
import { addPayment } from '../../../actions/cartActions'
import { axios, sdkURL, SlatwalApiService } from '../../../services'
import { toast } from 'react-toastify'
import { PaymentAddressSelector } from './PaymentAddressSelector'
import { Button } from '../../Button/Button'

export const CREDIT_CARD = '444df303dedc6dab69dd7ebcc9b8036a'
export const GIFT_CARD = '50d8cd61009931554764385482347f3a'
const months = Array.from({ length: 12 }, (_, i) => {
  return { key: i + 1, value: i + 1 }
})
const years = Array(10)
  .fill(new Date().getFullYear())
  .map((year, index) => {
    return { key: year + index, value: year + index }
  })

/* see: userAction addPaymentMethod */
const addPaymentMethodAndSetAsPayment = async (newPaymentMethod, callback, dispatch, t) => {
  const response = await SlatwalApiService.account.addPaymentMethod({ ...newPaymentMethod, returnJSONObjects: 'account' })

  if (response.isSuccess()) {
    const { accountPaymentMethod } = response.success()
    dispatch(addPayment({ accountPaymentMethodID: accountPaymentMethod.accountPaymentMethodID }))
  } else {
    toast.error(t('frontend.core.save_failed'))
  }
  callback()
}

const CreditCardDetails = ({ onSubmit }) => {
  const { t } = useTranslation()
  const dispatch = useDispatch()
  const billingAccountAddress = useSelector(state => state.cart.billingAccountAddress)

  const formik = useFormik({
    enableReinitialize: false,
    initialValues: {
      creditCardNumber: '',
      nameOnCreditCard: '',
      expirationMonth: new Date().getMonth() + 1,
      expirationYear: new Date().getFullYear().toString().substring(2),
      securityCode: '',
      accountPaymentMethodName: '',
      accountAddressID: billingAccountAddress ? billingAccountAddress.accountAddressID : '',
      saveShippingAsBilling: false,
      savePaymentMethodToAccount: false,
      returnJSONObjects: 'cart',
    },
    onSubmit: values => {
      let payload = {
        accountPaymentMethodName: values.accountPaymentMethodName,
        paymentMethodType: 'creditCard',
        nameOnCreditCard: values.nameOnCreditCard,
        creditCardNumber: values.creditCardNumber,
        expirationMonth: values.expirationMonth,
        expirationYear: values.expirationYear,
        securityCode: values.securityCode,
        billingAccountAddress: {
          accountAddressID: values.accountAddressID,
        },
      }
      if (values.saveShippingAsBilling) {
        payload.newOrderPayment['saveShippingAsBilling'] = 1
        delete payload.newOrderPayment.accountAddressID
      }

      addPaymentMethodAndSetAsPayment(payload, onSubmit, dispatch, t)
    },
  })

  let validCreditCard = formik.values.accountPaymentMethodName.length > 0 && formik.values.nameOnCreditCard.length > 0 && formik.values.creditCardNumber.length > 0 && formik.values.securityCode.length > 0
  return (
    <>
      <div className="row mb-3">
        <div className="col-sm-12">
          <h2 className="h6 pt-1 pb-3 mb-3 border-bottom">Credit Card Information</h2>
          <div className="row">
            <div className="col-sm-6">
              <div className="form-group">
                <label htmlFor="accountPaymentMethodName">{t('frontend.account.payment_method.nickname')}</label>
                <input className="form-control" type="text" id="accountPaymentMethodName" value={formik.values.accountPaymentMethodName} onChange={formik.handleChange} />{' '}
              </div>
            </div>

            <div className="col-sm-6">
              <div className="form-group">
                <label htmlFor="nameOnCreditCard">{t('frontend.account.payment_method.name')}</label>
                <input className="form-control" type="text" id="nameOnCreditCard" value={formik.values.nameOnCreditCard} onChange={formik.handleChange} />
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-sm-5">
              <div className="form-group">
                <label htmlFor="creditCardNumber">{t('frontend.account.payment_method.ccn')}</label>
                <input className="form-control" type="text" id="creditCardNumber" value={formik.values.creditCardNumber} onChange={formik.handleChange} />
              </div>
            </div>
            <div className="col-sm-2">
              <div className="form-group">
                <label htmlFor="securityCode">{t('frontend.account.payment_method.cvv')}</label>
                <input className="form-control" type="text" id="securityCode" value={formik.values.securityCode} onChange={formik.handleChange} />
              </div>
            </div>
            <div className="col-sm-3">
              <div className="form-group">
                <label htmlFor="expirationMonth">{t('frontend.account.payment_method.expiration_month')}</label>
                <SwSelect id="expirationMonth" value={formik.values.expirationMonth} onChange={formik.handleChange} options={months} />
              </div>
            </div>
            <div className="col-sm-2">
              <div className="form-group">
                <label htmlFor="expirationYear">{t('frontend.account.payment_method.expiration_year')}</label>
                <SwSelect id="expirationYear" value={formik.values.expirationYear} onChange={formik.handleChange} options={years} />
              </div>
            </div>
          </div>

          <div className="row mb-3">
            <div className="col-sm-12">
              <div className="row">
                <div className="col-sm-6">
                  <div className="custom-control custom-checkbox">
                    <input className="custom-control-input" type="checkbox" id="saveShippingAsBilling" checked={formik.values.saveShippingAsBilling} onChange={formik.handleChange} />
                    <label className="custom-control-label" htmlFor="saveShippingAsBilling">
                      {t('frontend.checkout.shipping_address_clone')}
                    </label>
                  </div>
                  {/* do we have a shipping address ?*/}
                  {/* <div className="custom-control custom-checkbox">
                    <input className="custom-control-input" type="checkbox" id="savePaymentMethodToAccount" checked={formik.values.savePaymentMethodToAccount} onChange={formik.handleChange} />
                    <label className="custom-control-label" htmlFor="savePaymentMethodToAccount">
                    {t('frontend.checkout.payment.save_to_account')}
                    </label>
                  </div> */}
                </div>
                <div className="col-sm-6">
                  {formik.values.saveShippingAsBilling && validCreditCard && (
                    <Button
                      label="Submit"
                      onClick={e => {
                        e.preventDefault()
                        //TODO: BROKEN
                        if (formik.values.savePaymentMethodToAccount && formik.values.saveShippingAsBilling) {
                          // Create account Payment and use cloned shpiing address
                          // Payment with Account  CC
                        } else {
                          // Payment with Single use CC and address cloned from billing
                          //  TODO: broken
                          dispatch(
                            addPayment({
                              newOrderPayment: {
                                saveShippingAsBilling: 1,
                                nameOnCreditCard: formik.values.nameOnCreditCard,
                                creditCardNumber: formik.values.creditCardNumber,
                                expirationMonth: formik.values.expirationMonth,
                                expirationYear: formik.values.expirationYear,
                                securityCode: formik.values.securityCode,
                                paymentMethod: {
                                  paymentMethodID: CREDIT_CARD,
                                },
                              },
                            })
                          )
                        }
                      }}
                    />
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {validCreditCard && !formik.values.saveShippingAsBilling && (
        <div className="row mb-3">
          <div className="col-sm-12">
            {!formik.values.saveShippingAsBilling && (
              <PaymentAddressSelector
                isShipping={false}
                addressTitle={'Billing Address'}
                selectedAccountID={formik.values.accountAddressID}
                onSelect={value => {
                  dispatch(
                    addPayment({
                      newOrderPayment: {
                        accountAddressID: value,
                        nameOnCreditCard: formik.values.nameOnCreditCard,
                        creditCardNumber: formik.values.creditCardNumber,
                        expirationMonth: formik.values.expirationMonth,
                        expirationYear: formik.values.expirationYear,
                        securityCode: formik.values.securityCode,
                        paymentMethod: {
                          paymentMethodID: CREDIT_CARD,
                        },
                      },
                    })
                  )
                }}
                onSave={values => {
                  if (formik.values.savePaymentMethodToAccount && values.saveAddress) {
                    // Create account address
                    // Create account Payment
                    // Payment with new Account Address and new Account Payment Method
                  } else if (values.saveAddress) {
                    // Create account address
                    // Payment with new Account Address and Single use CC
                    axios({
                      method: 'POST',
                      withCredentials: true, // default
                      url: `${sdkURL}api/scope/addEditAccountAddress,addBillingAddressUsingAccountAddress`,
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      data: {
                        name: values.name,
                        streetAddress: values.streetAddress,
                        street2Address: values.street2Address,
                        city: values.city,
                        statecode: values.stateCode,
                        postalcode: values.postalCode,
                        countrycode: values.countryCode,
                        returnJSONObjects: 'account',
                      },
                    }).then(response => {
                      if (response.status === 200 && response.data) {
                        dispatch(
                          addPayment({
                            newOrderPayment: {
                              nameOnCreditCard: formik.values.nameOnCreditCard,
                              creditCardNumber: formik.values.creditCardNumber,
                              expirationMonth: formik.values.expirationMonth,
                              expirationYear: formik.values.expirationYear,
                              securityCode: formik.values.securityCode,
                              paymentMethod: {
                                paymentMethodID: CREDIT_CARD,
                              },
                            },
                          })
                        )
                      }
                    })
                  } else {
                    // and payment with new single use CC and Single use address
                    dispatch(
                      addPayment({
                        newOrderPayment: {
                          billingAddress: {
                            name: values.name,
                            streetAddress: values.streetAddress,
                            street2Address: values.street2Address,
                            city: values.city,
                            statecode: values.stateCode,
                            postalcode: values.postalCode,
                            countrycode: values.countryCode,
                          },
                          nameOnCreditCard: formik.values.nameOnCreditCard,
                          creditCardNumber: formik.values.creditCardNumber,
                          expirationMonth: formik.values.expirationMonth,
                          expirationYear: formik.values.expirationYear,
                          securityCode: formik.values.securityCode,
                          paymentMethod: {
                            paymentMethodID: CREDIT_CARD,
                          },
                        },
                      })
                    )
                  }
                }}
              />
            )}
          </div>
        </div>
      )}
    </>
  )
}

export { CreditCardDetails }
