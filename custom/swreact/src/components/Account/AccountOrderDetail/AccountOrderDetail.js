import React, { useEffect, useState } from 'react'
import { SlatwalApiService } from '../../../services'
import { AccountLayout } from '../AccountLayout/AccountLayout'
import OrderShipments from './OrderShipments'
import OrderNav from './OrderNav'
import OrderToolbar from './OrderToolbar'

const AccountOrderDetail = props => {
  const orderID = props.path
  const orderReff = props.forwardState || { orderID: '' }
  const [order, setOrder] = useState({ ...orderReff, isLoaded: false })

  useEffect(() => {
    let didCancel = false
    if (!order.isLoaded) {
      SlatwalApiService.account.orders({ orderID }).then(response => {
        if (response.isSuccess() && !didCancel) {
          if (response.success().ordersOnAccount.ordersOnAccount.length) {
            setOrder({ ...response.success().ordersOnAccount.ordersOnAccount[0], isLoaded: true })
            return
          }
        }
        setOrder({ ...order, isLoaded: true })
      })
    }

    return () => {
      didCancel = true
    }
  }, [order, orderID, setOrder])

  return (
    <AccountLayout title={`Order: ${order.orderNumber || ''}`}>
      <OrderToolbar delivered={order.orderStatusType_typeName} />
      <OrderNav />
      <OrderShipments order={order} />
    </AccountLayout>
  )
}
export default AccountOrderDetail
