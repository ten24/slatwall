import { useDispatch, useSelector } from 'react-redux'
import { addShippingMethod } from '../../../actions/cartActions'
import { SwRadioSelect } from '../../../components'
import { fulfillmentSelector, shippingMethodSelector } from '../../../selectors/orderSelectors'
import { useTranslation } from 'react-i18next'

const ShippingMethodPicker = () => {
  const dispatch = useDispatch()
  const orderFulfillments = useSelector(state => state.cart.orderFulfillments)
  const selectedShippingMethod = useSelector(shippingMethodSelector)
  const orderFulfillment = useSelector(fulfillmentSelector)
  const { t } = useTranslation()

  return (
    <div className="row mb-3">
      <div className="col-sm-12">
        {orderFulfillments.length > 0 && (
          <SwRadioSelect
            label={t('frontend.checkout.delivery_option')}
            options={orderFulfillment.shippingMethodOptions}
            onChange={value => {
              dispatch(
                addShippingMethod({
                  shippingMethodID: value,
                  fulfillmentID: orderFulfillment.orderFulfillmentID,
                })
              )
            }}
            selectedValue={selectedShippingMethod.shippingMethodID}
          />
        )}
        {orderFulfillment.shippingMethodOptions.length === 0 && (
          <div className="alert alert-info" role="alert">
            {t('frontend.checkout.fulfilment.shipping.no_eligible_options')}
          </div>
        )}
      </div>
    </div>
  )
}

export { ShippingMethodPicker }
