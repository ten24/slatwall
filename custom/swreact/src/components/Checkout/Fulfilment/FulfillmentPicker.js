import { useDispatch, useSelector } from 'react-redux'
import { changeOrderFulfillment } from '../../../actions/'
import { SwRadioSelect } from '../../'
import { fulfillmentMethodSelector } from '../../../selectors/'
import { useTranslation } from 'react-i18next'

const FulfillmentPicker = () => {
  const dispatch = useDispatch()
  const { eligibleFulfillmentMethods, orderItems } = useSelector(state => state.cart)
  let selectedFulfillmentMethod = useSelector(fulfillmentMethodSelector)
  const { t } = useTranslation()

  return (
    <div className="row mb-3">
      <div className="col-sm-12">
        {eligibleFulfillmentMethods && eligibleFulfillmentMethods.length > 0 && (
          <SwRadioSelect
            label={t('frontend.checkout.receive_option')}
            options={eligibleFulfillmentMethods}
            onChange={fulfillmentMethodID => {
              const orderItemIDList = orderItems
                .map(orderItem => {
                  return orderItem.orderItemID
                })
                .join()
              dispatch(changeOrderFulfillment({ fulfillmentMethodID, orderItemIDList }))
            }}
            selectedValue={selectedFulfillmentMethod.fulfillmentMethodID}
          />
        )}
      </div>
    </div>
  )
}

export { FulfillmentPicker }
