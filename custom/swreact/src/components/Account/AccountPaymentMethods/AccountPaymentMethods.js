import React from 'react'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import AccountLayout from '../AccountLayout/AccountLayout'
import AccountContent from '../AccountContent/AccountContent'
import PaymentMethodItem from './PaymentMethodItem'

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
