import React, { useEffect, useState } from 'react'
// import PropTypes from 'prop-types'
import { AccountLayout, ListingPagination, AccountToolBar } from '../../'
import { useTranslation } from 'react-i18next'
import { useFormatCurrency, useFormatDate, useGetAccountCartsAndQuotes } from '../../../hooks'
import { Link } from 'react-router-dom'
import { useDispatch } from 'react-redux'
import { setOrderOnCart } from '../../../actions'

const OrderStatus = ({ type = 'info', text }) => {
  return <span className={`badge badge-${type} m-0`}>{text}</span>
}
const OrderListItem = props => {
  const [formatCurrency] = useFormatCurrency({})
  const [formateDate] = useFormatDate()
  const dispatch = useDispatch()
  const { t } = useTranslation()

  const { orderID, createdDateTime, orderStatusType_typeName, calculatedTotal } = props
  return (
    <tr>
      <td className="py-3">{formateDate(createdDateTime)}</td>
      <td className="py-3">
        <OrderStatus text={orderStatusType_typeName} />
      </td>
      <td className="py-3">{formatCurrency(calculatedTotal)}</td>
      <td className="py-3">
        <Link
          className="text-link"
          onClick={event => {
            dispatch(setOrderOnCart(orderID))
            window.scrollTo({
              top: 0,
              behavior: 'smooth',
            })
          }}
        >
          {t('frontend.account.order.change_order')}
        </Link>
        <br />
      </td>
    </tr>
  )
}

const AccountCarts = ({ customBody, crumbs, title, contentTitle }) => {
  const [keyword, setSearchTerm] = useState('')
  const { t } = useTranslation()
  let [orders, setRequest] = useGetAccountCartsAndQuotes()
  const search = (currentPage = 1) => {
    setRequest({ ...orders, params: { currentPage, pageRecordsShow: 10, keyword }, makeRequest: true, isFetching: true, isLoaded: false })
  }
  useEffect(() => {
    let didCancel = false
    if (!orders.isFetching && !orders.isLoaded && !didCancel) {
      setRequest({ ...orders, isFetching: true, isLoaded: false, params: { pageRecordsShow: 20, keyword }, makeRequest: true })
    }
    return () => {
      didCancel = true
    }
  }, [orders, keyword, setRequest])

  return (
    <AccountLayout crumbs={crumbs} title={title}>
      <AccountToolBar term={keyword} updateTerm={setSearchTerm} search={search} />

      <div className="table-responsive font-size-md">
        <table className="table table-hover mb-0">
          <thead>
            <tr>
              <th>{t('frontend.core.date_created')}</th>
              <th>{t('frontend.account.order.status')}</th>
              <th> {t('frontend.account.order.total')}</th>
              <th>{t('frontend.account.order.select_order')}</th>
            </tr>
          </thead>
          <tbody>
            {orders.isLoaded &&
              orders.data.map((order, index) => {
                return <OrderListItem key={index} {...order} />
              })}
          </tbody>
        </table>
      </div>
      <hr className="pb-4" />
      <ListingPagination recordsCount={orders.data.records} currentPage={orders.data.currentPage} totalPages={Math.ceil(orders.data.records / 20)} setPage={search} />
    </AccountLayout>
  )
}

export { AccountCarts }
