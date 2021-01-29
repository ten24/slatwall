import React from 'react'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import AccountLayout from '../AccountLayout/AccountLayout'
import AccountContent from '../AccountContent/AccountContent'

const PaymentMethodItem = ({ accountPaymentMethodName, nameOnCreditCard, isPrimary = false, creditCardType, activeFlag, expirationYear, expirationMonth }) => {
  return (
    <tr>
      <td className="py-3 align-middle">
        <div className="media align-items-center">
          <div className="media-body">
            <span className="font-weight-medium text-heading mr-1">{creditCardType}</span>
            {accountPaymentMethodName}
            {isPrimary && <span className="align-middle badge badge-info ml-2">Primary</span>}
          </div>
        </div>
      </td>
      <td className="py-3 align-middle">{nameOnCreditCard}</td>
      <td className="py-3 align-middle">{`${expirationMonth}/${expirationYear}`}</td>
      <td className="py-3 align-middle">
        <a className="nav-link-style mr-2" href="##" data-toggle="tooltip" title="" data-original-title="Edit">
          <i className="far fa-edit"></i>
        </a>
        <a className="nav-link-style text-primary" href="##" data-toggle="tooltip" title="" data-original-title="Remove">
          <i className="far fa-trash-alt"></i>
        </a>
      </td>
    </tr>
  )
}

const AccountPaymentMethods = ({ primaryPaymentMethod, accountPaymentMethods, title, customBody, contentTitle }) => {
  return (
    <AccountLayout title={title}>
      <AccountContent customBody={customBody} contentTitle={contentTitle} />
      <div className="table-responsive font-size-md">
        <table className="table table-hover mb-0">
          <thead>
            <tr>
              <th>Your credit / debit cards</th>
              <th>Name on card</th>
              <th>Expires on</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {accountPaymentMethods &&
              accountPaymentMethods.map((card, index) => {
                return <PaymentMethodItem key={index} {...card} isPrimary={card.accountPaymentMethodID === primaryPaymentMethod.accountPaymentMethodID} />
              })}
          </tbody>
        </table>
      </div>
      <hr className="pb-4" />
      <div className="text-sm-right">
        <a className="btn btn-primary" href="##add-address" data-toggle="modal">
          Add new address
        </a>
      </div>
    </AccountLayout>
  )
}

function mapStateToProps(state) {
  return state.userReducer
}

AccountPaymentMethods.propTypes = {}
export default connect(mapStateToProps)(AccountPaymentMethods)
