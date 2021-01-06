import { useEffect } from 'react'
import { getUser } from '../../../actions/userActions'
import { logout } from '../../../actions/authActions'
import { connect } from 'react-redux'
import AccountLayout from '../AccountLayout/AccountLayout'
import AccountContent from '../AccountContent/AccountContent'

const AccountRecentOrders = () => {
  return (
    <>
      <h3 className="h4 mt-5 mb-3">Most Recent Order</h3>
      <div className="row bg-lightgray rounded align-items-center justify-content-between mb-4">
        <div className="col-xs-4 p-3">
          <h6>Order ##43810583021</h6>
          <span>10/12/2020</span>
        </div>
        <div className="col-xs-3 p-3">
          <h6>Status</h6>
          <span>New</span>
        </div>
        <div className="col-xs-3 p-3">
          <h6>Order Total</h6>
          <span>$1,293.95</span>
        </div>
        <div className="p-3">
          <a href="##" className="btn btn-outline-secondary">
            View
          </a>
        </div>
      </div>
      <a href="/my-account/orders" className="btn btn-primary">
        View All Orders
      </a>
    </>
  )
}

const AccountOverview = ({ customBody, crumbs, title, contentTitle }) => {
  useEffect(() => {
    getUser()
  }, [])

  return (
    <AccountLayout crumbs={crumbs} title={title}>
      <AccountContent contentTitle={contentTitle} customBody={customBody} />
      <AccountRecentOrders />
    </AccountLayout>
  )
}
const mapStateToProps = state => {
  return {
    ...state.preload.accountOverview,
    user: state.userReducer,
  }
}

const mapDispatchToProps = dispatch => {
  return {
    getUser: async () => dispatch(getUser()),
    logout: async () => dispatch(dispatch(logout())),
  }
}
export default connect(mapStateToProps, mapDispatchToProps)(AccountOverview)
