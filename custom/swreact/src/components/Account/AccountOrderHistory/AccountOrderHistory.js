import React, { useEffect, useState } from 'react'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { Link } from 'react-router-dom'
import { SlatwalApiService } from '../../../services'
import Pagination from '../../ListingOld/Pagination'
import { AccountLayout } from '../AccountLayout/AccountLayout'
import { useTranslation } from 'react-i18next'

const ToolBar = ({ term, updateTerm }) => {
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
              updateTerm(event.target.value)
            }}
            placeholder="Search item #, order #, or PO"
          />
          <div className="input-group-append-overlay">
            <span className="input-group-text">
              <i className="far fa-search" />
            </span>
          </div>
        </div>
        <a href="##" className="btn btn-outline-secondary">
          <i className="far fa-file-alt mr-2"></i> {t('frontend.account.request_statement')}
        </a>
      </div>
    </div>
  )
}
const AccountOrderHistoryListItemTracking = ({ trackingNumbers }) => {
  const { t, i18n } = useTranslation()

  return (
    <div className="btn-group">
      <button type="button" className="btn bg-white dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <i className="far fa-shipping-fast"></i>
      </button>
      <div className="dropdown-menu dropdown-menu-right">
        <span>{t('frontend.account.tracking_numbers')}:</span>
        {trackingNumbers &&
          trackingNumbers.map((trackingNumber, index) => {
            return (
              <a key={index} className="dropdown-item" href="##">
                {trackingNumber}
              </a>
            )
          })}
      </div>
    </div>
  )
}

const OrderStatus = ({ type = 'info', text }) => {
  return <span className={`badge badge-${type} m-0`}>{text}</span>
}

const OrderListItem = props => {
  const { orderNumber, orderID, createdDateTime, orderStatusType_typeName, calculatedTotal, trackingNumbers } = props
  return (
    <tr>
      <td className="py-3">
        <Link
          className="nav-link-style font-weight-medium font-size-sm"
          to={{
            pathname: `/my-account/orders/${orderID}`,
            state: { ...props },
          }}
        >
          {orderNumber}
        </Link>
        <br />
        {/* {location} */}
      </td>
      <td className="py-3">{createdDateTime}</td>
      <td className="py-3">
        <OrderStatus text={orderStatusType_typeName} />
      </td>
      <td className="py-3">{calculatedTotal}</td>
      <td className="py-3">
        <AccountOrderHistoryListItemTracking trackingNumbers={trackingNumbers} />
      </td>
    </tr>
  )
}
// TODO: THis is so not right but fine for now. Should move to a library
const SortArrows = ({ sortDirection = '', setSortDirection }) => {
  return (
    <span className="s-sort-arrows">
      <svg className="nc-icon outline" xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="20px" height="20px" viewBox="0 0 64 64">
        <g transform="translate(0.5, 0.5)">
          <polygon
            onClick={() => {
              if (setSortDirection) {
                setSortDirection('ASC')
              }
            }}
            className="s-ascending"
            fill={sortDirection === 'ASC' ? 'black' : 'gray'}
            stroke="#cccccc"
            strokeWidth="3"
            strokeLinecap="square"
            strokeMiterlimit="10"
            points="20,26 44,26 32,12 "
            strokeLinejoin="round"
          ></polygon>
          <polygon
            onClick={() => {
              if (setSortDirection) {
                setSortDirection('DESC')
              }
            }}
            className="s-descending"
            fill={sortDirection === 'DESC' ? 'black' : 'gray'}
            stroke="#cccccc"
            strokeWidth="3"
            strokeLinecap="square"
            strokeMiterlimit="10"
            points="44,38 20,38 32,52 "
            strokeLinejoin="round"
          ></polygon>
        </g>
      </svg>
    </span>
  )
}

const OrderHistoryList = () => {
  const [currentPage, setCurrentPage] = useState(1)
  const [dateSort, setDateSort] = useState('ASC')
  const [statusSort, setStatusSort] = useState('')
  const [searchTerm, setSearchTerm] = useState('')
  const [ordersOnAccount, setOrdersOnAccount] = useState({ orders: [], records: 0, isLoaded: false })
  const { t, i18n } = useTranslation()

  useEffect(() => {
    if (!ordersOnAccount.isLoaded) {
      SlatwalApiService.account.orders().then(req => {
        if (req.isFail()) {
          setOrdersOnAccount({ ...ordersOnAccount, isLoaded: true })
        } else {
          setOrdersOnAccount({ orders: req.success().ordersOnAccount.ordersOnAccount, records: req.success().ordersOnAccount.records, isLoaded: true })
        }
      })
    }
  }, [ordersOnAccount, SlatwalApiService])

  return (
    <>
      <ToolBar term={searchTerm} updateTerm={setSearchTerm} />

      <div className="table-responsive font-size-md">
        <table className="table table-hover mb-0">
          <thead>
            <tr>
              <th>{t('frontend.account.order.heading')} #</th>
              <th>
                {t('frontend.account.order.date')}
                <SortArrows sortDirection={dateSort} setSortDirection={setDateSort} />
              </th>
              <th>
                {t('frontend.account.order.status')}
                <SortArrows sortDirection={statusSort} setSortDirection={setStatusSort} />
              </th>
              <th> {t('frontend.account.order.total')}</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {ordersOnAccount &&
              ordersOnAccount.orders.map((order, index) => {
                return <OrderListItem key={index} {...order} />
              })}
          </tbody>
        </table>
      </div>

      <hr className="pb-4" />
      <Pagination recordsCount={ordersOnAccount.records} currentPage={currentPage} setCurrentPage={setCurrentPage} />
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

const mapStateToProps = state => {
  return {
    ...state.configuration.accountOrderHistory,
    user: state.userReducer,
  }
}

AccountOrderHistory.propTypes = {}
export default connect(mapStateToProps)(AccountOrderHistory)
