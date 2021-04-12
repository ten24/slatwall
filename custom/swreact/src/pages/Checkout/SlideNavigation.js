import { Link, useHistory } from 'react-router-dom'

const SlideNavigation = ({ currentStep, nextActive = true }) => {
  let history = useHistory()

  return (
    <>
      <div className="d-lg-flex pt-4 mt-3">
        <div className="w-50 pr-3">
          <Link className="btn btn-secondary btn-block" to={currentStep.previous}>
            <i className="far fa-chevron-left"></i> <span className="d-none d-sm-inline">Back</span>
            <span className="d-inline d-sm-none">Back</span>
          </Link>
        </div>
        {currentStep.next.length > 0 && (
          <div className="w-50 pl-2">
            <button
              className="btn btn-primary btn-block"
              disabled={!nextActive}
              onClick={e => {
                e.preventDefault()
                history.push(currentStep.next)
              }}
            >
              <span className="d-none d-sm-inline">Continue</span>
              <span className="d-inline d-sm-none">Next</span> <i className="far fa-chevron-right"></i>
            </button>
          </div>
        )}
      </div>
    </>
  )
}

export default SlideNavigation
