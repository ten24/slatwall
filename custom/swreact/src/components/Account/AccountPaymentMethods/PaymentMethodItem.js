import Swal from 'sweetalert2'
import withReactContent from 'sweetalert2-react-content'
import { Link } from 'react-router-dom'
import { useDispatch } from 'react-redux'
import { deletePaymentMethod } from '../../../actions/userActions'
import { useTranslation } from 'react-i18next'

const PaymentMethodItem = props => {
  const { accountPaymentMethodID, accountPaymentMethodName, nameOnCreditCard, isPrimary = false, creditCardType, expirationYear, expirationMonth } = props
  const MySwal = withReactContent(Swal)
  const dispatch = useDispatch()
  const { t } = useTranslation()

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
        <button
          type="button"
          className="link-button nav-link-style text-primary"
          onClick={() => {
            MySwal.fire({
              icon: 'info',
              title: <p>{t('frontend.account.payment_method.remove')}</p>,
              showCloseButton: true,
              showCancelButton: true,
              focusConfirm: false,
              confirmButtonText: t('frontend.core.delete'),
            }).then(data => {
              if (data.isConfirmed) {
                dispatch(deletePaymentMethod(accountPaymentMethodID))
              }
            })
          }}
          data-toggle="tooltip"
          title=""
          data-original-title="Remove"
        >
          <i className="far fa-trash-alt"></i>
        </button>
      </td>
    </tr>
  )
}
export default PaymentMethodItem
