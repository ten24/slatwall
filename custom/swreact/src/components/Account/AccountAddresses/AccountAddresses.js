import React from 'react'
// import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import AccountLayout from '../AccountLayout/AccountLayout'
import AccountContent from '../AccountContent/AccountContent'

const Address = ({ location, isPrimary }) => {
  return (
    <tr>
      <td className="py-3 align-middle">
        {location} {isPrimary && <span className="align-middle badge badge-info ml-2">Primary</span>}
      </td>
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

const AccountAddresses = ({ crumbs, title, customBody, contentTitle, addresses }) => {
  return (
    <AccountLayout crumbs={crumbs} title={title}>
      <AccountContent customBody={customBody} contentTitle={contentTitle} />

      <div className="table-responsive font-size-md">
        <table className="table table-hover mb-0">
          <thead>
            <tr>
              <th>Address</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {addresses &&
              addresses.map((address, index) => {
                return <Address key={index} {...address} />
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
  const { preload } = state
  return preload.accountAddresses
}

AccountAddresses.propTypes = {}
export default connect(mapStateToProps)(AccountAddresses)
