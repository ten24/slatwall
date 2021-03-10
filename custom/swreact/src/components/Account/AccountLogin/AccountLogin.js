import { login } from '../../../actions/authActions'
import { useDispatch } from 'react-redux'
import { useFormik } from 'formik'
import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'
import { useRouteMatch } from 'react-router-dom'

const LoginForm = () => {
  const dispatch = useDispatch()
  let match = useRouteMatch()
  const { t, i18n } = useTranslation()

  const formik = useFormik({
    initialValues: {
      loginEmail: '',
      loginPassword: '',
    },
    onSubmit: values => {
      dispatch(login(values.loginEmail, values.loginPassword))
    },
  })
  return (
    <div className="col-md-6">
      <div className="card box-shadow">
        <div className="card-body">
          <h2 className="h4 mb-1">{t('frontend.account.sign_in')}</h2>
          <p className="font-size-sm text-muted mb-4">
            {`${t('frontend.account.no_account')} `} <Link to={`${match.path}/createAccount`}>{t('frontend.account.request')}</Link>.
          </p>
          <form onSubmit={formik.handleSubmit}>
            <div className="form-group">
              <label htmlFor="loginEmail">{t('frontend.account.email')}</label>
              <input value={formik.values.loginEmail} onChange={formik.handleChange} autoComplete="email" required className="form-control" type="email" id="loginEmail" />
            </div>
            <div className="form-group">
              <label htmlFor="loginPassword">{t('frontend.account.password')}</label>
              <input value={formik.values.loginPassword} onChange={formik.handleChange} autoComplete="current-password" required className="form-control" type="password" id="loginPassword" />
            </div>
            <div className="text-right">
              <Link to={`${match.path}/forgotPassword`} className="nav-link-inline font-size-sm">
                {t('frontend.account.forgot_password')}
              </Link>
            </div>
            <hr className="mt-4" />
            <div className="text-right pt-4">
              <button className="btn btn-primary" type="submit">
                {t('frontend.account.sign_in')}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  )
}

const AccountLogin = () => {
  return (
    <div className="container py-4 py-lg-5 my-4">
      <div className="row d-flex justify-content-center">
        <LoginForm />
      </div>
    </div>
  )
}

export default AccountLogin
