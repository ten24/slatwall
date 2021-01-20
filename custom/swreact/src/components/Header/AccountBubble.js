import { connect } from 'react-redux'
const AccountBubble = ({ isAuthenticated, name }) => {
  return (
    <>
      <div className="navbar-tool-icon-box">
        <i className="far fa-user"></i>
      </div>
      <div className="navbar-tool-text ml-n3">
        <small>
          Hello, {isAuthenticated && name}
          {!isAuthenticated && 'Sign in'}
        </small>
        My Account
      </div>
    </>
  )
}

function mapStateToProps(state) {
  return {
    isAuthenticated: state.accountID,
    name: state.userReducer.name,
  }
}
export default connect(mapStateToProps)(AccountBubble)
