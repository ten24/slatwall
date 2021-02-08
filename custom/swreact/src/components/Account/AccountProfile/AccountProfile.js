import { connect, useDispatch } from 'react-redux'
import { AccountLayout } from '../AccountLayout/AccountLayout'
import AccountContent from '../AccountContent/AccountContent'
import { useFormik } from 'formik'
import { updateUser } from '../../../actions/userActions'
import Swal from 'sweetalert2'
import withReactContent from 'sweetalert2-react-content'
import { toast } from 'react-toastify'
import { SlatwalApiService } from '../../../services'
const AccountProfile = ({ crumbs, title, customBody, contentTitle, user }) => {
  const dispatch = useDispatch()
  const MySwal = withReactContent(Swal)

  const formik = useFormik({
    enableReinitialize: true,
    initialValues: {
      accountFirstName: user.firstName,
      accountLastName: user.lastName,
      accountEmailAddress: user.primaryEmailAddress.emailAddress,
      // accountPhoneNumber: user.primaryPhoneNumber.phoneNumber,
      // accountExt: '',
      accountCompany: user.company,
    },
    onSubmit: values => {
      dispatch(
        updateUser({
          firstName: values.accountFirstName,
          lastName: values.accountLastName,
          emailAddress: values.accountEmailAddress,
          company: values.accountCompany,
          returnJSONObjects: 'account',
        })
      )
    },
  })

  const updatePassword = event => {
    event.preventDefault()
    MySwal.fire({
      title: 'Update Password',
      html: '<input id="accountPassword" placeholder="Password" class="swal2-input"><input id="accountPasswordConfirm" placeholder="Confirm Password" class="swal2-input">',
      focusConfirm: false,
      showCancelButton: true,
      preConfirm: () => {
        return [document.getElementById('accountPassword').value, document.getElementById('accountPasswordConfirm').value]
      },
    }).then(data => {
      if (data.isConfirmed) {
        if (data.value.length === 2 && data.value[0] === data.value[1]) {
          SlatwalApiService.account
            .changePassword({
              password: data.value[0],
              passwordConfirm: data.value[1],
            })
            .then(response => {
              if (response.isSuccess()) {
                if (response.success().successfulActions.length) {
                  toast.success('Password Update Successful')
                } else {
                  toast.error(response.success().errors.password.join(' '))
                }
              } else {
                toast.error('Network Error')
              }
            })
        } else {
          toast.error('Password Mismatch')
        }
      }
    })
  }

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
          {/* <div className="col-sm-4">
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
          </div> */}
          <div className="col-sm-6">
            <div className="form-group">
              <label htmlFor="accountCompany">Company</label>
              <input className="form-control" value={formik.values.accountCompany} type="text" onChange={formik.handleChange} id="accountCompany" />
            </div>
          </div>
          <div className="col-12">
            <hr className="mt-2 mb-3" />
            <div className="d-flex flex-wrap justify-content-end">
              <button className="btn btn-secondary mt-3 mt-sm-0 mr-3" onClick={updatePassword} type="submit">
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
    user: state.userReducer,
  }
}

export default connect(mapStateToProps)(AccountProfile)
