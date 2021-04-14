import { login } from '../../../actions/authActions'
import { useDispatch } from 'react-redux'
import { useFormik } from 'formik'
import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'
import { useRouteMatch } from 'react-router-dom'
import * as Yup from 'yup'

const LoginForm = () => {
  const dispatch = useDispatch()
  let match = useRouteMatch()
  const { t } = useTranslation()

  const formik = useFormik({
    initialValues: {
      loginEmail: '',
      loginPassword: '',
    },
    validateOnChange: false,
    validationSchema: Yup.object().shape({
      loginEmail: Yup.string().email('Invalid email').required('Required'),
      loginPassword: Yup.string().required('Required'),
    }),
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
              <input value={formik.values.loginEmail} onBlur={formik.handleBlur} onChange={formik.handleChange} autoComplete="email" className="form-control" type="email" id="loginEmail" />
              {formik.errors.loginEmail && <span className="form-error-msg">{formik.errors.loginEmail}</span>}
            </div>
            <div className="form-group">
              <label htmlFor="loginPassword">{t('frontend.account.password')}</label>
              <input value={formik.values.loginPassword} onBlur={formik.handleBlur} onChange={formik.handleChange} autoComplete="current-password" className="form-control" type="password" id="loginPassword" />
              {formik.errors.loginPassword && formik.touched.loginPassword && <span className="form-error-msg">{formik.errors.loginPassword}</span>}
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
