const OrderToolbar = ({ delivered }) => {
  return (
    <div className="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5">
      <div className="row justify-content-between w-100 align-items-center">
        <div className="col-sm-6">
          Status <span className="badge badge-success m-0 p-2 ml-2">{delivered}</span>
        </div>
        <div className="col-sm-6">
          <div className="row justify-content-end">
            {/* <div className="mr-3">
              <a href="#" className="btn btn-outline-secondary">
                <i className="far fa-box-full mr-2"></i> Request RMA
              </a>
            </div> */}
            <div>
              <button className="btn btn-outline-secondary">
                <i className="far fa-print mr-2"></i> Print
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default OrderToolbar
