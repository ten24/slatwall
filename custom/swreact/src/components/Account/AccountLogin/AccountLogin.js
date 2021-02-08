import { login } from '../../../actions/authActions'
import { connect, useDispatch } from 'react-redux'
import { useFormik } from 'formik'
import { Link } from 'react-router-dom'
import { useRouteMatch } from 'react-router-dom'

const LoginForm = () => {
  const dispatch = useDispatch()
  let match = useRouteMatch()

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
          <h2 className="h4 mb-1">Sign in</h2>
          <p className="font-size-sm text-muted mb-4">
            Don't have an account? <Link to={`${match.path}/createAccount`}>Request account</Link>.
          </p>
          <form onSubmit={formik.handleSubmit}>
            <div className="form-group">
              <label htmlFor="loginEmail">E-mail Address</label>
              <input value={formik.values.loginEmail} onChange={formik.handleChange} autoComplete="email" required className="form-control" type="email" id="loginEmail" />
            </div>
            <div className="form-group">
              <label htmlFor="loginPassword">Password</label>
              <input value={formik.values.loginPassword} onChange={formik.handleChange} autoComplete="current-password" required className="form-control" type="password" id="loginPassword" />
            </div>
            <div className="text-right">
              <Link to={`${match.path}/forgotPassword`} className="nav-link-inline font-size-sm">
                Forgot password?
              </Link>
            </div>
            <hr className="mt-4" />
            <div className="text-right pt-4">
              <button className="btn btn-primary" type="submit">
                Sign In
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  )
}

const AccountLogin = ({ auth }) => {
  return (
    <div className="container py-4 py-lg-5 my-4">
      <div className="row d-flex justify-content-center">
        <LoginForm />
      </div>
    </div>
  )
}
const mapStateToProps = state => {
  return {
    auth: state.authReducer,
    user: state.userReducer,
  }
}

export default connect(mapStateToProps)(AccountLogin)
