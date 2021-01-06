import { Link } from 'react-router-dom'
import { BreadCrumb } from '../..'
import { logoutUser } from '../../../actions/authActions'
import { connect } from 'react-redux'

const AccountSidebar = ({ logout }) => {
  return (
    <aside className="col-lg-4 pt-4 pt-lg-0">
      <div className="cz-sidebar-static rounded-lg box-shadow-lg px-0 pb-0 mb-5 mb-lg-0">
        <div className="px-4 mb-4">
          <div className="media align-items-center">
            <div className="media-body">
              <h3 className="font-size-base mb-0">Susan Gardner</h3>
              <a
                href="#"
                onClick={() => {
                  logout()
                }}
                className="text-accent font-size-sm"
              >
                Logout
              </a>
            </div>
          </div>
        </div>
        <div className="bg-secondary px-4 py-3">
          <h3 className="font-size-sm mb-0 text-muted">
            <Link to="/my-account" className="nav-link-style active">
              Overview
            </Link>
          </h3>
        </div>
        <ul className="list-unstyled mb-0">
          <li className="border-bottom mb-0">
            <Link
              to="/my-account/order-history"
              className="nav-link-style d-flex align-items-center px-4 py-3"
            >
              <i className="far fa-shopping-bag pr-2" /> Order History
            </Link>
          </li>
          <li className="border-bottom mb-0">
            <Link
              to="/my-account/profile"
              className="nav-link-style d-flex align-items-center px-4 py-3"
            >
              <i className="far fa-user pr-2" /> Profile Info
            </Link>
          </li>
          <li className="border-bottom mb-0">
            <Link
              to="/my-account/favorites"
              className="nav-link-style d-flex align-items-center px-4 py-3"
            >
              <i className="far fa-heart pr-2" /> Favorties
            </Link>
          </li>
          <li className="border-bottom mb-0">
            <Link
              to="/my-account/addresses"
              className="nav-link-style d-flex align-items-center px-4 py-3"
            >
              <i className="far fa-map-marker-alt pr-2" /> Addresses
            </Link>
          </li>
          <li className="mb-0">
            <Link
              to="/my-account/cards"
              className="nav-link-style d-flex align-items-center px-4 py-3"
            >
              <i className="far fa-credit-card pr-2" /> Payment Methods
            </Link>
          </li>
        </ul>
      </div>
    </aside>
  )
}

const AccountHeader = ({ crumbs, title }) => {
  return (
    <div className="page-title-overlap bg-lightgray pt-4">
      <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <BreadCrumb crumbs={crumbs} />
        </div>
        <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 className="h3 mb-0">{title}</h1>
        </div>
      </div>
    </div>
  )
}

const AccountLayout = ({ crumbs, children, title, logout }) => {
  return (
    <>
      <AccountHeader crumbs={crumbs} title={title} />
      <div className="container pb-5 mb-2 mb-md-3">
        <div className="row">
          <AccountSidebar logout={logout} />
          <section className="col-lg-8">{children}</section>
        </div>
      </div>
    </>
  )
}
const mapStateToProps = state => {
  return {}
}
const mapDispatchToProps = dispatch => {
  return {
    logout: async () => dispatch(logoutUser()),
  }
}
export default connect(mapStateToProps, mapDispatchToProps)(AccountLayout)
