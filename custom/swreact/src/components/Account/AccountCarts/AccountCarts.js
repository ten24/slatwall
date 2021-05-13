import React, { useEffect, useState } from 'react'
// import PropTypes from 'prop-types'
import { AccountLayout } from '../AccountLayout/AccountLayout'
import AccountContent from '../AccountContent/AccountContent'
import { useTranslation } from 'react-i18next'
import { useGetAccountCartsAndQuotes } from '../../../hooks/useAPI'
import { useFormatCurrency, useFormatDate } from '../../../hooks'
import { Button } from '../../Button/Button'
import { useDispatch } from 'react-redux'
import { setOrderOnCart } from '../../../actions'
import { ListingPagination } from '../..'
import { AccountToolBar } from '../AccountToolBar/AccountToolBar'
const OrderStatus = ({ type = 'info', text }) => {
  return <span className={`badge badge-${type} m-0`}>{text}</span>
}
const OrderListItem = props => {
  const [formatCurrency] = useFormatCurrency({})
  const [formateDate] = useFormatDate()
  const dispatch = useDispatch()

  const { orderID, createdDateTime, orderStatusType_typeName, calculatedTotal } = props
  return (
    <tr>
      <td className="py-3">{formateDate(createdDateTime)}</td>
      <td className="py-3">
        <OrderStatus text={orderStatusType_typeName} />
      </td>
      <td className="py-3">{formatCurrency(calculatedTotal)}</td>
      <td className="py-3">
        <Button
          onClick={event => {
            dispatch(setOrderOnCart(orderID))
            window.scrollTo({
              top: 0,
              behavior: 'smooth',
            })
          }}
        >
          Change Order
        </Button>
        <br />
      </td>
    </tr>
  )
}

const AccountCarts = () => {
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
    <AccountLayout>
      <AccountContent />
      <AccountToolBar term={keyword} updateTerm={setSearchTerm} search={search} />

      <div className="table-responsive font-size-md">
        <table className="table table-hover mb-0">
          <thead>
            <tr>
              <th>Date Created</th>
              <th>{t('frontend.account.order.status')}</th>
              <th> {t('frontend.account.order.total')}</th>
              <th>Select Order</th>
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

export default AccountCarts
