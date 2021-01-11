import { login } from '../../../actions/authActions'
import { getUser } from '../../../actions/userActions'
import { connect } from 'react-redux'
import { useFormik } from 'formik'

// const NewAccountForm = () => {
//   return (
//     <div className="col-md-8 pt-4 mt-3 mt-md-0 card box-shadow">
//       <h2 className="h4 mb-3">Request Account</h2>
//       <p className="font-size-sm text-muted mb-4">
//         Already have an account. <a href="##">Sign in here</a>.
//       </p>
//       <form onSubmit={formik.handleSubmit}>
//         <div className="row mb-3">
//           <div className="col-sm-6">
//             <div className="form-group">
//               <label htmlFor="reg-fn">First Name</label>
//               <input className="form-control" type="text" required="" id="reg-fn" />
//               <div className="invalid-feedback">Please enter your first name!</div>
//             </div>
//           </div>
//           <div className="col-sm-6">
//             <div className="form-group">
//               <label htmlFor="reg-ln">Last Name</label>
//               <input className="form-control" type="text" required="" id="reg-ln" />
//               <div className="invalid-feedback">Please enter your last name!</div>
//             </div>
//           </div>
//           <div className="col-sm-6">
//             <div className="form-group">
//               <label htmlFor="reg-email">E-mail Address</label>
//               <input className="form-control" type="email" required="" id="reg-email" />
//               <div className="invalid-feedback">Please enter valid email address!</div>
//             </div>
//           </div>
//           <div className="col-sm-6">
//             <div className="form-group">
//               <label htmlFor="company">Company</label>
//               <input className="form-control" type="text" required="" id="company" />
//             </div>
//           </div>
//           <div className="col-sm-6">
//             <div className="form-group">
//               <label htmlFor="reg-password">Password</label>
//               <input className="form-control" type="password" required="" id="reg-password" />
//               <div className="invalid-feedback">Please enter password!</div>
//             </div>
//           </div>
//           <div className="col-sm-6">
//             <div className="form-group">
//               <label htmlFor="reg-password-confirm">Confirm Password</label>
//               <input className="form-control" type="password" required="" id="reg-password-confirm" />
//               <div className="invalid-feedback">Passwords do not match!</div>
//             </div>
//           </div>
//           <div className="col-sm-4">
//             <div className="form-group">
//               <label htmlFor="reg-phone">Phone Number</label>
//               <input className="form-control" type="text" required="" id="reg-phone" />
//               <div className="invalid-feedback">Please enter your phone number!</div>
//             </div>
//           </div>
//           <div className="col-sm-2">
//             <div className="form-group">
//               <label fhtmlForor="ext-phone">Ext.</label>
//               <input className="form-control" type="text" required="" id="ext-phone" />
//             </div>
//           </div>
//         </div>
//         <hr />
//         <ol className="p-3 mt-3">
//           <li>
//             <p className="mb-2">Download the application form</p>
//             <p className="font-size-sm text-muted mb-2">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar sic tempor. Sociis natoque penatibus et magnis dis parturient montes.</p>
//             <p className="font-size-sm text-muted">
//               <a href="##">Download Application Here</a>.
//             </p>
//           </li>
//           <li>
//             <p className="mb-2">Upload your filled out form</p>
//             <input type="file" id="application" name="application" accept="image/png, image/jpeg" />
//           </li>
//         </ol>
//         <hr />
//         <div className="text-right mb-4 mt-3">
//           <button className="btn btn-primary" type="submit">
//             Request Account
//           </button>
//         </div>
//       </form>
//     </div>
//   )
// }

const LoginForm = ({ login }) => {
  const formik = useFormik({
    initialValues: {
      loginEmail: '',
      loginPassword: '',
    },
    onSubmit: values => {
      login(values.loginEmail, values.loginPassword)
    },
  })
  return (
    <div className="col-md-6">
      <div className="card box-shadow">
        <div className="card-body">
          <h2 className="h4 mb-1">Sign in</h2>
          <p className="font-size-sm text-muted mb-4">
            Don't have an account? <a href="##">Request account</a>.
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
              <a className="nav-link-inline font-size-sm" href="account-password-recovery.html">
                Forgot password?
              </a>
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

const AccountLogin = ({ login, auth }) => {
  return (
    <div className="container py-4 py-lg-5 my-4">
      <div className="row d-flex justify-content-center">
        <LoginForm login={login} />
        {/* <input
        value={email}
        onChange={event => {
          setEmail(event.target.value)
        }}
      />
      <span>Password</span>
      <input
        value={password}
        type="password"
        onChange={event => {
          setPassword(event.target.value)
        }}
      />
      <button
        type="button"
        className="btn btn-outline-primary"
        disabled={auth.isFetching}
        onClick={() => {
          login(email, password)
        }}
      >
        use SDK
      </button> */}
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

const mapDispatchToProps = dispatch => {
  return {
    getUser: async () => dispatch(getUser()),
    login: async (email, password) => dispatch(login(email, password)),
  }
}
export default connect(mapStateToProps, mapDispatchToProps)(AccountLogin)
