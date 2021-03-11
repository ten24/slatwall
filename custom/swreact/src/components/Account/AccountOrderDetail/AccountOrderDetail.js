import React, { useEffect, useState } from 'react'
import { SlatwalApiService } from '../../../services'
import { AccountLayout } from '../AccountLayout/AccountLayout'
import OrderShipments from './OrderShipments'
import OrderNav from './OrderNav'
import OrderToolbar from './OrderToolbar'
import { useGetOrderDetails } from '../../../hooks/useAPI'

const AccountOrderDetail = props => {
  const orderID = props.path
  let [order, setRequest] = useGetOrderDetails()

  useEffect(() => {
    let didCancel = false
    if (!order.isFetching && !order.isLoaded && !didCancel) {
      setRequest({ ...order, isFetching: true, isLoaded: false, params: { orderID }, makeRequest: true })
    }
    return () => {
      didCancel = true
    }
  }, [order, setRequest])

  return (
    <AccountLayout title={`Order: ${(order.isLoaded && order.data.orderInfo[0].orderNumber) || ''}`}>
      <OrderToolbar delivered={order.isLoaded && order.data.orderInfo[0].orderStatusType_typeName} />
      <OrderNav />
      {order.isLoaded && <OrderShipments order={order.data} />}{' '}
    </AccountLayout>
  )
}
export default AccountOrderDetail
