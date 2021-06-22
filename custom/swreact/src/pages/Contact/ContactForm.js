import { useSelector } from 'react-redux'
import { sdkURL, axios } from '../../services'
import { useTranslation } from 'react-i18next'
import { useFormik } from 'formik'
import queryString from 'query-string'

/*
This is a really good example of how forms should be done.
Not This is a custom form on the front end that will push data back to SlatwallCMS
This is not ment to be dynamic so any any custom forms will be custom created pages.
*/

const ContactForm = () => {
  const { t } = useTranslation()
  const contactFormID = useSelector(state => state.configuration.forms.contact)

  const formik = useFormik({
    enableReinitialize: false,
    initialValues: {
      'formResponse.formID': contactFormID,
      context: 'addFormResponse',
      firstName: '',
      lastName: '',
      emailAddress: '',
      phoneNumber: '',
      subject: '',
      contactMethod: '',
      message: '',
    },
    initialStatus: { showForm: true, message: '' },
    onSubmit: values => {
      axios({
        method: 'POST',
        withCredentials: true, // default
        url: `${sdkURL}api/scope/addFormResponse`,
        data: queryString.stringify(values, { arrayFormat: 'comma' }),
        headers: {
          'Content-Type': `application/x-www-form-urlencoded`,
        },
      })
        .then(response => {
          formik.setStatus({ showForm: false, message: t('frontend.contact.success') })
        })
        .catch(error => {
          formik.setStatus({ showForm: true, message: error.message })
        })
    },
  })
  return (
    <>
      {!formik.status.showForm && <p>{formik.status.message}</p>}
      {formik.status.showForm && (
        <form name="contact-us" onSubmit={formik.handleSubmit}>
          <div className="row">
            <div className="col-md-6">
              <div className="form-group">
                <label htmlFor="firstName">{t('frontend.contact.firstName')}</label>
                <input className="form-control" type="text" id="firstName" value={formik.values.firstName} onChange={formik.handleChange} />
              </div>
            </div>
            <div className="col-md-6">
              <div className="form-group">
                <label htmlFor="lastName">{t('frontend.contact.lastName')}</label>
                <input className="form-control" type="text" id="lastName" value={formik.values.lastName} onChange={formik.handleChange} />
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-md-6">
              <div className="form-group">
                <label htmlFor="emailAddress">{t('frontend.contact.emailAddress')}</label>
                <input className="form-control" type="text" id="emailAddress" value={formik.values.emailAddress} onChange={formik.handleChange} />
              </div>
            </div>
            <div className="col-md-6">
              <div className="form-group">
                <label htmlFor="phoneNumber">{t('frontend.contact.phoneNumber')}</label>
                <input className="form-control" type="tel" id="phoneNumber" value={formik.values.phoneNumber} onChange={formik.handleChange} />
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-md-6">
              <div className="form-group">
                <label htmlFor="subject">{t('frontend.contact.subject')}</label>
                <input className="form-control" type="text" id="subject" value={formik.values.subject} onChange={formik.handleChange} />
              </div>
            </div>
            <div className="col-md-6">
              <div className="form-group">
                <label htmlFor="contactMethod">{t('frontend.contact.contactMethod')}</label>
                <br />
                {[
                  { name: 'Email', value: 'email' },
                  { name: 'Phone', value: 'phone' },
                ].map(({ name, value }) => {
                  return (
                    <div key={value} className="form-check form-check-inline custom-control custom-radio d-inline-flex">
                      <input name="contactMethod" className="custom-control-input" type="radio" id={value} value={value} onChange={formik.handleChange} checked={formik.values.contactMethod === value} />
                      <label className="custom-control-label" htmlFor={value}>
                        {name}
                      </label>
                    </div>
                  )
                })}
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-md-12">
              <div className="form-group">
                <label htmlFor="message">{t('frontend.contact.message')}</label>
                <textarea className="form-control" type="text" id="message" value={formik.values.message} onChange={formik.handleChange} />
              </div>
            </div>
          </div>
          <button className="btn btn-primary btn-block">
            <span className="d-none d-sm-inline">{t('frontend.core.submit')}</span>
          </button>
        </form>
      )}
    </>
  )
}
export default ContactForm
