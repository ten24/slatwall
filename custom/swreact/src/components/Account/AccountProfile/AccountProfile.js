import { logout } from '../../../actions/authActions'
import { connect } from 'react-redux'
import AccountLayout from '../AccountLayout/AccountLayout'
import AccountContent from '../AccountContent/AccountContent'
import { useFormik } from 'formik'

const AccountProfile = ({ crumbs, title, customBody, contentTitle, getMyUser, user }) => {
  const formik = useFormik({
    enableReinitialize: true,
    initialValues: {
      accountFirstName: user.firstName,
      accountLastName: user.lastName,
      accountEmailAddress: user.primaryEmailAddress ? user.primaryEmailAddress.emailAddress : '',
      accountPhoneNumber: user.primaryPhoneNumber ? user.primaryPhoneNumber.phoneNumber : '',
      accountExt: '',
      accountCompany: user.company,
    },
    onSubmit: values => {
      alert(JSON.stringify(values, null, 2))
    },
  })

  return (
    <AccountLayout crumbs={crumbs} title={title}>
      <AccountContent customBody={customBody} contentTitle={contentTitle} />
      <form onSubmit={formik.handleSubmit}>
        <div className="row">
          <div className="col-sm-6">
            <div className="form-group">
              <label htmlFor="accountFirstName">First Name</label>
              <input className="form-control" type="text" id="accountFirstName" value={formik.values.accountFirstName} onChange={formik.handleChange} />
            </div>
          </div>
          <div className="col-sm-6">
            <div className="form-group">
              <label htmlFor="accountLastName">Last Name</label>
              <input className="form-control" type="text" id="accountLastName" value={formik.values.accountLastName} onChange={formik.handleChange} />
            </div>
          </div>
          <div className="col-sm-6">
            <div className="form-group">
              <label htmlFor="accountEmailAddress">Email Address</label>
              <input className="form-control" type="accountEmailAddress" id="accountEmailAddress" value={formik.values.accountEmailAddress} onChange={formik.handleChange} disabled="" />
            </div>
          </div>
          <div className="col-sm-4">
            <div className="form-group">
              <label htmlFor="accountPhoneNumber">Phone Number</label>
              <input className="form-control" type="text" id="accountPhoneNumber" value={formik.values.accountPhoneNumber} onChange={formik.handleChange} required="" />
            </div>
          </div>
          <div className="col-sm-2">
            <div className="form-group">
              <label htmlFor="accountExt">Ext.</label>
              <input className="form-control" type="text" id="accountExt" value={formik.values.accountExt} onChange={formik.handleChange} required="" />
            </div>
          </div>
          <div className="col-sm-6">
            <div className="form-group">
              <label htmlFor="accountCompany">Company</label>
              <input className="form-control" value={formik.values.accountCompany} type="text" onChange={formik.handleChange} id="accountCompany" />
            </div>
          </div>
          <div className="col-12">
            <hr className="mt-2 mb-3" />
            <div className="d-flex flex-wrap justify-content-end">
              <button className="btn btn-secondary mt-3 mt-sm-0 mr-3" type="submit">
                Update password
              </button>
              <button type="submit" className="btn btn-primary mt-3 mt-sm-0">
                Update profile
              </button>
            </div>
          </div>
        </div>
      </form>
    </AccountLayout>
  )
}
const mapStateToProps = state => {
  return {
    ...state.preload.accountProfile,
    user: state.userReducer,
  }
}

const mapDispatchToProps = dispatch => {
  return {
    logout: async () => dispatch(logout()),
  }
}
export default connect(mapStateToProps, mapDispatchToProps)(AccountProfile)
