import { useHistory } from 'react-router'

const SWForm = ({ formik, children, title = '', subTitle = '', primaryButtontext = '' }) => {
  let history = useHistory()

  return (
    <>
      <h2 className="h4 mb-1">{title}</h2>
      <p
        className="font-size-sm text-muted mb-4"
        onClick={event => {
          event.preventDefault()
          if (event.target.getAttribute('href')) {
            history.push(event.target.getAttribute('href'))
          }
        }}
        dangerouslySetInnerHTML={{
          __html: subTitle,
        }}
      />
      <form onSubmit={formik.handleSubmit}>
        {children}
        <hr className="mt-4" />
        <div className="text-right pt-4">
          <button className="btn btn-primary" type="submit">
            {primaryButtontext}
          </button>
        </div>
      </form>
    </>
  )
}

const SWInput = ({ required = false, formik, token = '', label = '', wrapperClasses = 'row', type = 'text', showErrors = true }) => {
  return (
    <div className={wrapperClasses}>
      <div className="col form-group">
        <label className="control-label" htmlFor={token}>
          {label}
        </label>
        <input className="form-control" type={type} id={token} value={formik.values[token]} onChange={formik.handleChange} onBlur={formik.handleBlur} />
        {showErrors && formik.touched[token] && formik.errors[token] && <span className="form-error-msg">{formik.errors[token]}</span>}
      </div>
    </div>
  )
}

export { SWForm, SWInput }
