import MailchimpSubscribe from 'react-mailchimp-subscribe'

const MyForm = ({ status, message, onValidated }) => {
  let email, fName, lName, company
  const submit = () => {
    email &&
      lName &&
      fName &&
      company &&
      email.value.indexOf('@') > -1 &&
      onValidated({
        EMAIL: email.value,
        LNAME: lName.value,
        FNAME: fName.value,
        COMPANY: company.value,
      })
  }

  return (
    <>
      <div className="input-group input-group-overlay flex-nowrap">
        <div className="input-group-prepend-overlay">
          <span className="input-group-text text-muted font-size-base"></span>
        </div>
        <div className="row">
          <div className="col-12 d-flex">
            <input className="form-control prepended-form-control mr-2" type="text" ref={node => (fName = node)} placeholder="First Name" required />
            <input className="form-control prepended-form-control mr-2" type="text" ref={node => (lName = node)} placeholder="Last Name" required />
            <input className="form-control prepended-form-control" type="text" ref={node => (company = node)} placeholder="Company" required />
          </div>
          <div className="col-12 d-flex pt-2">
            <input className="form-control prepended-form-control" type="email" ref={node => (email = node)} placeholder="Your email" required />
            <div className="input-group-append">
              <button className="btn btn-primary" type="submit" onClick={submit}>
                Subscribe*
              </button>
            </div>
          </div>
        </div>
      </div>
      <small className="form-text text-light opacity-50" id="mc-helper">
        *Subscribe to our newsletter to receive early discount offers, updates and new products info.
      </small>
      <div className="subscribe-status">
        {status === 'sending' && <div style={{ color: 'blue' }}>sending...</div>}
        {status === 'error' && <div style={{ color: 'red' }} dangerouslySetInnerHTML={{ __html: message }} />}
        {status === 'success' && <div style={{ color: 'green' }} dangerouslySetInnerHTML={{ __html: message }} />}
      </div>
    </>
  )
}

const SignUpForm = () => {
  const url = 'https://jster.us7.list-manage.com/subscribe/post?u=XXXX&id=XXXXXX'
  return (
    <MailchimpSubscribe
      url={url}
      render={({ subscribe, status, message }) => (
        <div>
          <MyForm
            status={status}
            message={message}
            onValidated={formData => {
              subscribe(formData)
            }}
          />
        </div>
      )}
    />
  )
}
export default SignUpForm
