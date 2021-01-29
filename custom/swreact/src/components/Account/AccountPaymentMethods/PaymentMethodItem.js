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
        <a className="nav-link-style mr-2" href="#" data-toggle="tooltip" title="" data-original-title="Edit">
          <i className="far fa-edit"></i>
        </a>
        <a className="nav-link-style text-primary" href="#" data-toggle="tooltip" title="" data-original-title="Remove">
          <i className="far fa-trash-alt"></i>
        </a>
      </td>
    </tr>
  )
}
export default PaymentMethodItem
