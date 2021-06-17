import React from 'react'
// import PropTypes from 'prop-types'
import { useDispatch, useSelector } from 'react-redux'
import { AccountContent, AccountLayout } from '../../'
import { Link } from 'react-router-dom'
import Swal from 'sweetalert2'
import withReactContent from 'sweetalert2-react-content'
import { deleteAccountAddress } from '../../../actions/'
import { useTranslation } from 'react-i18next'
import { getAllAccountAddresses, getPrimaryAddress } from '../../../selectors/'
import { Redirect } from 'react-router-dom'

const Address = props => {
  const { accountAddressID, address, isPrimary } = props
  const { streetAddress, addressID, city, stateCode, postalCode } = address
  const MySwal = withReactContent(Swal)
  const dispatch = useDispatch()
  const { t } = useTranslation()

  return (
    <tr>
      <td className="py-3 align-middle">
        {`${streetAddress} ${city},${stateCode} ${postalCode}`} {isPrimary && <span className="align-middle badge badge-info ml-2">{t('frontend.core.prinary')}</span>}
      </td>
      <td className="py-3 align-middle">
        <Link
          className="nav-link-style mr-2"
          to={{
            pathname: `/my-account/addresses/${addressID}`,
            state: { ...props },
          }}
          data-toggle="tooltip"
        >
          <i className="far fa-edit"></i>
        </Link>
        <button
          type="button"
          className="link-button nav-link-style text-primary"
          onClick={() => {
            MySwal.fire({
              icon: 'info',
              title: <p>{t('frontend.account.address.remove')}</p>,
              showCloseButton: true,
              showCancelButton: true,
              focusConfirm: false,
              confirmButtonText: t('frontend.core.delete'),
            }).then(data => {
              if (data.isConfirmed) {
                dispatch(deleteAccountAddress(accountAddressID))
              }
            })
          }}
        >
          <i className="far fa-trash-alt"></i>
        </button>
      </td>
    </tr>
  )
}

const AccountAddresses = ({ title }) => {
  const { t } = useTranslation()
  const isLoaded = useSelector(state => state.userReducer.isLoaded)
  const accountAddresses = useSelector(getAllAccountAddresses)
  const primaryAddress = useSelector(getPrimaryAddress)

  if (isLoaded && accountAddresses.length === 0) {
    return <Redirect to="/my-account/addresses/new" />
  }
  return (
    <AccountLayout title={title}>
      <AccountContent />
      {accountAddresses.length > 0 && (
        <div className="table-responsive font-size-md">
          <table className="table table-hover mb-0">
            <thead>
              <tr>
                <th>{t('frontend.account.address.heading')}</th>
                <th>{t('frontend.core.actions')}</th>
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
      )}
      <hr className="pb-4" />
      <div className="text-sm-right">
        <Link className="btn btn-primary" to="/my-account/addresses/new">
          {t('frontend.account.address.add')}
        </Link>
      </div>
    </AccountLayout>
  )
}

export { AccountAddresses }
