import React, { useEffect, useState } from 'react'
// import PropTypes from 'prop-types'
import { Link } from 'react-router-dom'

import { AccountLayout } from '../AccountLayout/AccountLayout'
import { useTranslation } from 'react-i18next'
import useFormatCurrency from '../../../hooks/useFormatCurrency'
import { useFormatDateTime } from '../../../hooks/useFormatDate'

import { useGetAllOrders } from '../../../hooks/useAPI'
import ListingPagination from '../../Listing/ListingPagination'

const ToolBar = ({ term, updateTerm, search }) => {
  const { t, i18n } = useTranslation()

  return (
    <div className="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
      <div className="d-flex justify-content-between w-100">
        <div className="input-group-overlay d-lg-flex mr-3 w-50">
          <input
            className="form-control appended-form-control"
            type="text"
            value={term}
            onChange={event => {
              event.preventDefault()
              updateTerm(event.target.value)
            }}
            placeholder="Search item #, order #, or PO"
          />
          <div className="input-group-append-overlay">
            <span className="input-group-text">
              <i
                className="far fa-search"
                style={{ cursor: 'pointer' }}
                onClick={event => {
                  event.preventDefault()
                  search()
                }}
              />
            </span>
          </div>
        </div>
        {/* <a href="##" className="btn btn-outline-secondary">
          <i className="far fa-file-alt mr-2"></i> {t('frontend.account.request_statement')}
        </a> */}
      </div>
    </div>
  )
}

const OrderStatus = ({ type = 'info', text }) => {
  return <span className={`badge badge-${type} m-0`}>{text}</span>
}

const OrderListItem = props => {
  const [formatCurrency] = useFormatCurrency({})
  const [formateDate] = useFormatDateTime()

  const { orderNumber, orderID, createdDateTime, orderStatusType_typeName, calculatedTotal } = props
  return (
    <tr>
      <td className="py-3">
        <Link className="nav-link-style font-weight-medium font-size-sm" to={`/my-account/orders/${orderID}`}>
          {orderNumber}
        </Link>
        <br />
      </td>
      <td className="py-3">{formateDate(createdDateTime)}</td>
      <td className="py-3">
        <OrderStatus text={orderStatusType_typeName} />
      </td>
      <td className="py-3">{formatCurrency(calculatedTotal)}</td>
    </tr>
  )
}

const OrderHistoryList = () => {
  const [keyword, setSearchTerm] = useState('')
  let [orders, setRequest] = useGetAllOrders()
  const { t, i18n } = useTranslation()
  const search = (currentPage = 1) => {
    setRequest({ ...orders, params: { currentPage, pageRecordsShow: 10, keyword }, makeRequest: true, isFetching: true, isLoaded: false })
  }

  useEffect(() => {
    let didCancel = false
    if (!orders.isFetching && !orders.isLoaded && !didCancel) {
      setRequest({ ...orders, isFetching: true, isLoaded: false, params: { pageRecordsShow: 10, keyword }, makeRequest: true })
    }
    return () => {
      didCancel = true
    }
  }, [orders, setRequest])

  return (
    <>
      <ToolBar term={keyword} updateTerm={setSearchTerm} search={search} />

      <div className="table-responsive font-size-md">
        <table className="table table-hover mb-0">
          <thead>
            <tr>
              <th>{t('frontend.account.order.heading')} #</th>
              <th>{t('frontend.account.order.date')}</th>
              <th>{t('frontend.account.order.status')}</th>
              <th> {t('frontend.account.order.total')}</th>
            </tr>
          </thead>
          <tbody>
            {orders.isLoaded &&
              orders.data.ordersOnAccount.map((order, index) => {
                return <OrderListItem key={index} {...order} />
              })}
          </tbody>
        </table>
      </div>

      <hr className="pb-4" />
      <ListingPagination recordsCount={orders.data.records} currentPage={orders.data.currentPage} totalPages={Math.ceil(orders.data.records / 10)} setPage={search} />
    </>
  )
}

const AccountOrderHistory = ({ crumbs, title, orders }) => {
  const { t, i18n } = useTranslation()

  return (
    <AccountLayout title={t('frontend.account.account_order_history')}>
      <OrderHistoryList orders={orders} />
    </AccountLayout>
  )
}

export default AccountOrderHistory
