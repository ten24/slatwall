const AccountToolBar = ({ term, updateTerm, search }) => {
  return (
    <div className="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
      <div className="d-flex justify-content-between w-100">
        <div className="input-group-overlay d-lg-flex mr-3 w-50">
          <input
            className="form-control appended-form-control"
            type="text"
            value={term}
            required
            onKeyDown={e => {
              if (e.key === 'Enter') {
                e.preventDefault()
                if (e.target.checkValidity()) {
                  search()
                }
              }
            }}
            onChange={event => {
              event.preventDefault()
              updateTerm(event.target.value)
            }}
            placeholder="Search item #, order #, or PO"
          />
          <div className="input-group-append-overlay">
            <span className="input-group-text">
              <i
                className="far fa-search"
                style={{ cursor: 'pointer' }}
                onClick={event => {
                  event.preventDefault()
                  search()
                }}
              />
            </span>
          </div>
        </div>
        {/* <a href="##" className="btn btn-outline-secondary">
            <i className="far fa-file-alt mr-2"></i> {t('frontend.account.request_statement')}
          </a> */}
      </div>
    </div>
  )
}

export { AccountToolBar }
