import React from 'react'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import AccountLayout from '../AccountLayout/AccountLayout'

const AccountOrderHistoryToolBar = () => {
  return (
    <div className="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
      <div className="d-flex justify-content-between w-100">
        <div className="input-group-overlay d-lg-flex mr-3 w-50">
          <input className="form-control appended-form-control" type="text" placeholder="Search item ##, order ##, or PO" />
          <div className="input-group-append-overlay">
            <span className="input-group-text">
              <i className="far fa-search" />
            </span>
          </div>
        </div>
        <a href="##" className="btn btn-outline-secondary">
          <i className="far fa-file-alt mr-2"></i> Request Statement
        </a>
      </div>
    </div>
  )
}
const AccountOrderHistoryListItemTracking = ({ trackingNumbers }) => {
  return (
    <div className="btn-group">
      <button type="button" className="btn bg-white dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <i className="far fa-shipping-fast"></i>
      </button>
      <div className="dropdown-menu dropdown-menu-right">
        <span>Tracking Numbers:</span>
        {trackingNumbers.map((trackingNumber, index) => {
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

const Status = ({ type, text }) => {
  return <span className={`badge badge-${type} m-0`}>{text}</span>
}

const AccountOrderHistoryListItem = ({ number, location, datePurchased, status, total, trackingNumbers, statusType }) => {
  return (
    <tr>
      <td className="py-3">
        <a className="nav-link-style font-weight-medium font-size-sm" href="##" data-toggle="modal">
          {number}
        </a>
        <br />
        {location}
      </td>
      <td className="py-3">{datePurchased}</td>
      <td className="py-3">
        <Status type={statusType} text={status} />
      </td>
      <td className="py-3">{total}</td>
      <td className="py-3">
        <AccountOrderHistoryListItemTracking trackingNumbers={trackingNumbers} />
      </td>
    </tr>
  )
}
// TODO: THis is so not right but fine for now. Should move to a library
const SortArrows = () => {
  return (
    <a href="" className="s-sort-arrows">
      <svg data-ng-show="swListingDisplay.showOrderBy" className="nc-icon outline" xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="20px" height="20px" viewBox="0 0 64 64">
        <g transform="translate(0.5, 0.5)">
          <polygon className="s-ascending" data-ng-class="{'s-active':swListingDisplay.columnOrderByIndex(column) == 'DESC'}" fill="none" stroke="##cccccc" strokeWidth="3" strokeLinecap="square" strokeMiterlimit="10" points="20,26 44,26 32,12 " strokeLinejoin="round"></polygon>
          <polygon className="s-descending" data-ng-class="{'s-active':swListingDisplay.columnOrderByIndex(column) == 'ASC'}" fill="none" stroke="##cccccc" strokeWidth="3" strokeLinecap="square" strokeMiterlimit="10" points="44,38 20,38 32,52 " strokeLinejoin="round"></polygon>
        </g>
      </svg>
    </a>
  )
}

const AccountOrderHistoryList = ({ orders }) => {
  return (
    <>
      <div className="table-responsive font-size-md">
        <table className="table table-hover mb-0">
          <thead>
            <tr>
              <th>Order #</th>
              <th>
                Date Purchased
                <SortArrows />
              </th>
              <th>
                Status
                <SortArrows />
              </th>
              <th>Order Total</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {orders &&
              orders.map((order, index) => {
                return <AccountOrderHistoryListItem key={index} {...order} />
              })}
          </tbody>
        </table>
      </div>

      <hr className="pb-4" />
      <nav className="d-flex justify-content-between pt-2" aria-label="Page navigation">
        <ul className="pagination">
          <li className="page-item">
            <a className="page-link" href="##">
              <i className="far fa-chevron-left mr-2"></i> Prev
            </a>
          </li>
        </ul>
        <ul className="pagination">
          <li className="page-item d-sm-none">
            <span className="page-link page-link-static">1 / 5</span>
          </li>
          <li className="page-item active d-none d-sm-block" aria-current="page">
            <span className="page-link">
              1<span className="sr-only">(current)</span>
            </span>
          </li>
          <li className="page-item d-none d-sm-block">
            <a className="page-link" href="##">
              2
            </a>
          </li>
          <li className="page-item d-none d-sm-block">
            <a className="page-link" href="##">
              3
            </a>
          </li>
          <li className="page-item d-none d-sm-block">
            <a className="page-link" href="##">
              4
            </a>
          </li>
          <li className="page-item d-none d-sm-block">
            <a className="page-link" href="##">
              5
            </a>
          </li>
        </ul>
        <ul className="pagination">
          <li className="page-item">
            <a className="page-link" href="##" aria-label="Next">
              Next <i className="far fa-chevron-right ml-2"></i>
            </a>
          </li>
        </ul>
      </nav>
    </>
  )
}

const AccountOrderHistory = ({ crumbs, title, orders }) => {
  return (
    <AccountLayout crumbs={crumbs} title={title}>
      <AccountOrderHistoryToolBar />
      <AccountOrderHistoryList orders={orders} />
    </AccountLayout>
  )
}

const mapStateToProps = state => {
  return {
    ...state.preload.accountOrderHistory,
    user: state.userReducer,
  }
}

AccountOrderHistory.propTypes = {}
export default connect(mapStateToProps)(AccountOrderHistory)
