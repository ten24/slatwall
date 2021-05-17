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
  const { customBody = '', contentTitle = '', contentSubTitle = '' } = content || {}
  const noPaymentMethods = accountPaymentMethods.length === 0 
  const noAddresses = accountAddresses.length === 0
  let alertMesage = '';
 
  if(noPaymentMethods && noAddresses) {
    alertMesage = 'frontend.account.missing_address_paymentMethod' 
  }else if(noPaymentMethods){
    alertMesage = 'frontend.account.payment_methods.none'
  }else if(noAddresses){
    alertMesage = 'frontend.account.address.none'
  }
    
    
  return (
    <>
      <div className="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
        <div className="d-flex justify-content-between w-100">
        <h3 className="h5">{contentSubTitle}</h3>
        <h2 className="h5">{contentSubtitle}</h2>
         { alertMesage.length > 0 &&
         	<div className="alert alert-info" role="alert">
            	{ t(alertMesage) }
         	</div>  
        }
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
