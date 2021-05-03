import { useFormik } from 'formik'
import { toast } from 'react-toastify'
import { SlatwalApiService } from '../../../services'
import { SWForm, SWInput } from '../../SWForm/SWForm'
import { PromptLayout } from '../AccountLayout/AccountLayout'
import useRedirect from '../../../hooks/useRedirect'
import { Link } from 'react-router-dom';

const ForgotPassword = () => {
  // eslint-disable-next-line no-unused-vars
  const [redirect, setRedirect] = useRedirect({ location: '/my-account' })

  const formik = useFormik({
    initialValues: {
      emailAddress: '',
    },
    onSubmit: values => {
      SlatwalApiService.account.forgotPassword(values).then(response => {
        if (response.isSuccess()) {
          if (!response.success().failureActions.length) {
            toast.success('Success')
            setRedirect({ shouldRedirect: true })
          }
          toast.error(JSON.stringify(response.success().errors))
        } else {
          toast.success('Failure')
        }
      })
    },
  })
  return (
  
    <PromptLayout>
      <SWForm formik={formik} title="Forgot Password" primaryButtontext="Send Me Reset Email">
        <SWInput required={true} formik={formik} token="emailAddress" label="Email Address" type="email" />
        <Link to='/my-account'>Go to Login</Link>
      </SWForm>
    </PromptLayout>
    
  
  )
}
//
export default ForgotPassword
