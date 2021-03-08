import { Link } from 'react-router-dom'

const SlideNavigation = ({ currentStep, handleSubmit }) => {
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
            <a className="btn btn-primary btn-block" onClick={handleSubmit}>
              <span className="d-none d-sm-inline">Save & Continue</span>
              <span className="d-inline d-sm-none">Next</span> <i className="far fa-chevron-right"></i>
            </a>
          </div>
        )}
      </div>
    </>
  )
}

export default SlideNavigation
