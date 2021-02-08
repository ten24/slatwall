import React from 'react'
// import PropTypes from 'prop-types'
import { connect, useDispatch } from 'react-redux'
import { AccountLayout } from '../AccountLayout/AccountLayout'
import AccountContent from '../AccountContent/AccountContent'
import { Link } from 'react-router-dom'
import Swal from 'sweetalert2'
import withReactContent from 'sweetalert2-react-content'
import { deleteAccountAddress } from '../../../actions/userActions'

const Address = props => {
  const { accountAddressID, address } = props
  const { streetAddress, addressID, city, stateCode, postalCode, isPrimary } = address
  const MySwal = withReactContent(Swal)
  const dispatch = useDispatch()

  return (
    <tr>
      <td className="py-3 align-middle">
        {`${streetAddress} ${city},${stateCode} ${postalCode}`} {isPrimary && <span className="align-middle badge badge-info ml-2">Primary</span>}
      </td>
      <td className="py-3 align-middle">
        <Link
          className="nav-link-style mr-2"
          to={{
            pathname: `/my-account/addresses/${addressID}`,
            state: { ...props },
          }}
          data-toggle="tooltip"
          title=""
          data-original-title="Edit"
        >
          <i className="far fa-edit"></i>
        </Link>
        <a
          className="nav-link-style text-primary"
          onClick={() => {
            MySwal.fire({
              icon: 'info',
              title: <p>Remove Address?</p>,
              showCloseButton: true,
              showCancelButton: true,
              focusConfirm: false,
              confirmButtonText: 'Delete',
            }).then(data => {
              if (data.isConfirmed) {
                dispatch(deleteAccountAddress(accountAddressID))
              }
            })
          }}
        >
          <i className="far fa-trash-alt"></i>
        </a>
      </td>
    </tr>
  )
}

const AccountAddresses = props => {
  const { primaryAddress, accountAddresses, title, customBody, contentTitle } = props
  return (
    <AccountLayout title={title}>
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
            {accountAddresses &&
              accountAddresses.map((address, index) => {
                return <Address key={index} {...address} isPrimary={address.accountAddressID === primaryAddress.accountAddressID} />
              })}
          </tbody>
        </table>
      </div>
      <hr className="pb-4" />
      <div className="text-sm-right">
        <Link className="btn btn-primary" to="/my-account/addresses/new">
          Add new address
        </Link>
      </div>
    </AccountLayout>
  )
}

function mapStateToProps(state) {
  return state.userReducer
}

AccountAddresses.propTypes = {}
export default connect(mapStateToProps)(AccountAddresses)
