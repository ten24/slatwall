import { useTranslation } from 'react-i18next'
import { useLocation } from 'react-router'
import { Link } from 'react-router-dom'
import { isAuthenticated } from '../../utils'

const AuthenticationStepUp = ({ messageKey = 'frontend.account.auth' }) => {
  const loc = useLocation()
  const { t } = useTranslation()
  if (isAuthenticated()) return null

  return (
    <div className="alert alert-warning" role="alert">
      {t(messageKey)} <Link to={`/my-account?redirect=${loc.pathname}`}>{t('frontend.account.login')}</Link>
    </div>
  )
}

export { AuthenticationStepUp }
