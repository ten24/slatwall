import { useEffect } from 'react'
import { AccountLayout, OrderDetails, OrderShipments, OrderToolbar } from '../../'
import { useGetOrderDetails } from '../../../hooks/'

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
  }, [order, orderID, setRequest])
  return (
    <AccountLayout title={`Order: ${(order.isLoaded && order.data.orderInfo[0].orderNumber) || ''}`}>
      <OrderToolbar delivered={order.isLoaded && order.data.orderInfo[0].orderStatusType_typeName} />
      {order.isLoaded && <OrderDetails orderInfo={order.data.orderInfo[0]} orderFulfillments={order.data.orderFulfillments[0]} orderPayments={order.data.orderPayments[0]} />}
      {order.isLoaded && <OrderShipments shipments={[{ orderItems: order.data.orderItems }]} orderFulfillments={order.data.orderFulfillments[0]} orderPayments={order.data.orderPayments[0]} />}
    </AccountLayout>
  )
}
export { AccountOrderDetail }
