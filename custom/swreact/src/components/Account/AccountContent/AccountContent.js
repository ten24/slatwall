import { useSelector } from 'react-redux'
import { useHistory, useLocation } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { getAllAccountAddresses } from '../../../selectors/userSelectors'


const AccountContent = () => {
  const { t } = useTranslation()
  let history = useHistory()
  let loc = useLocation()
  const content = useSelector(state => state.content[loc.pathname.substring(1)])
  const { accountPaymentMethods } = useSelector(state => state.userReducer)
  const accountAddresses = useSelector(getAllAccountAddresses)
  const { customBody = '', contentTitle = '' } = content || {}
 
  let alertMesage = (accountPaymentMethods.length === 0 && accountAddresses.length === 0) ? 'frontend.account.missing_address_paymentMethod' :
                    accountPaymentMethods.length === 0 ? 'frontend.account.payment_methods.none' :
                    accountAddresses.length === 0 ? 'frontend.account.address.none' :
                    ''
  return (
    <>
      <div className="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
        <div className="d-flex justify-content-between w-100">
          <div className="alert alert-info" role="alert">
            { t(alertMesage) }
         </div>
        </div>
      </div>
      
      <div
        onClick={event => {
          event.preventDefault()
          if (event.target.getAttribute('href')) {
            history.push(event.target.getAttribute('href'))
          }
        }}
        dangerouslySetInnerHTML={{
          __html: customBody,
        }}
      />
    </>
  )
}
export default AccountContent
