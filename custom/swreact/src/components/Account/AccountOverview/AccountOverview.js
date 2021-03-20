import { AccountLayout } from '../AccountLayout/AccountLayout'
import AccountContent from '../AccountContent/AccountContent'
import { useGetAllOrders } from '../../../hooks/useAPI'
import { useEffect } from 'react'
import useFormatCurrency from '../../../hooks/useFormatCurrency'
import { Link } from 'react-router-dom'
import { useFormatDateTime } from '../../../hooks/useFormatDate'

const AccountRecentOrders = () => {
  let [orders, setRequest] = useGetAllOrders()
  const [formatCurrency] = useFormatCurrency({})
  const [formateDate] = useFormatDateTime()

  useEffect(() => {
    let didCancel = false
    if (!orders.isFetching && !orders.isLoaded && !didCancel) {
      setRequest({ ...orders, isFetching: true, isLoaded: false, params: {}, makeRequest: true })
    }
    return () => {
      didCancel = true
    }
  }, [orders, setRequest])

  return (
    <>
      {orders.data && orders.data.ordersOnAccount && orders.data.ordersOnAccount.length > 0 && (
        <>
          <h3 className="h4 mt-5 mb-3">Most Recent Order</h3>
          <div className="row bg-lightgray rounded align-items-center justify-content-between mb-4">
            <div className="col-xs-4 p-3">
              <h6>Order {orders.data.ordersOnAccount[0].orderNumber}</h6>
              <span>{formateDate(orders.data.ordersOnAccount[0].createdDateTime)}</span>
            </div>
            <div className="col-xs-3 p-3">
              <h6>Status</h6>
              <span>{orders.data.ordersOnAccount[0].orderStatusType_typeName}</span>
            </div>
            <div className="col-xs-3 p-3">
              <h6>Order Total</h6>
              <span>{formatCurrency(orders.data.ordersOnAccount[0].calculatedTotal)}</span>
            </div>
            <div className="p-3">
              <Link className="btn btn-outline-secondary" to={`/my-account/orders/${orders.data.ordersOnAccount[0].orderID}`}>
                View
              </Link>
            </div>
          </div>
          <Link className="btn btn-primary" to={`/my-account/orders`}>
            View All Orders
          </Link>
        </>
      )}
    </>
  )
}

const AccountOverview = ({ customBody, crumbs, title, contentTitle }) => {
  return (
    <AccountLayout crumbs={crumbs} title={title}>
      <AccountContent contentTitle={contentTitle} customBody={customBody} />
      <AccountRecentOrders />
    </AccountLayout>
  )
}

export default AccountOverview
