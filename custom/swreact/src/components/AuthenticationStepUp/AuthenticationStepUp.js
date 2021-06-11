import { useTranslation } from 'react-i18next'
import { useSelector } from 'react-redux'
import { useLocation } from 'react-router'
import { Link } from 'react-router-dom'
import { orderItemsCountSelector } from '../../selectors'
import { isAuthenticated } from '../../utils'

const AuthenticationStepUp = ({ messageKey = 'frontend.account.auth.price' }) => {
  const loc = useLocation()
  const { t } = useTranslation()
  const orderItemsCount = useSelector(orderItemsCountSelector)
  if (isAuthenticated() || orderItemsCount === 0) return null

  return (
    <div className="alert alert-warning" role="alert">
      {t(messageKey)} <Link to={`/my-account?redirect=${loc.pathname}`}>{t('frontend.account.login')}</Link>
    </div>
  )
}

export { AuthenticationStepUp }
