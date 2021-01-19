import React, { useState, useCallback } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { Link } from 'react-router-dom'
import _ from 'lodash'
import { setKeyword } from '../../actions/productSearchActions'
import { getUser } from '../../actions/userActions'
import { useHistory } from 'react-router-dom'
import SWImage from '../SWImage/SWImage'
import { filterLinks } from '../../utils'

const CartMenuItem = ({ orderCount, total }) => {
  return (
    <div className="navbar-tool ml-3">
      <Link className="navbar-tool-icon-box bg-secondary" to="/cart">
        {orderCount > 0 && <span className="navbar-tool-label">{orderCount}</span>}
        <i className="far fa-shopping-cart"></i>
      </Link>
      <Link className="navbar-tool-text" to="/cart">
        <small>My Cart</small>${total}
      </Link>
    </div>
  )
}

const MegaMenu = props => {
  let history = useHistory()

  return (
    <li className="nav-item dropdown">
      <a className="nav-link dropdown-toggle" href={props.linkUrl} data-toggle="dropdown">
        {props.title}
      </a>
      <div className="dropdown-menu pt-0 pb-3">
        <div className="nav-shop-all">
          <a href={props.linkUrl}>
            Shop All {props.title}
            <i className="far fa-arrow-right ml-2"></i>
          </a>
        </div>
        <div className="d-flex flex-wrap flex-lg-nowrap px-2">
          {props.subMenu.map((productCategory, index) => {
            return (
              <div key={index} className="mega-dropdown-column py-4 px-3">
                <div
                  className="widget widget-links mb-3"
                  onClick={event => {
                    event.preventDefault()
                    history.push(event.target.getAttribute('href'))
                  }}
                  dangerouslySetInnerHTML={{
                    __html: productCategory['customBody'],
                  }}
                />
              </div>
            )
          })}
        </div>
      </div>
    </li>
  )
}

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

function Header({ mobileLogo, logo, setKeywordAction, productCategories, user, mainNavigation, orderCount, total }) {
  let menuItems = new Map()
  productCategories.forEach(item => {
    if (menuItems.has(item.parentContent_title)) {
      let exisitingItems = menuItems.get(item.parentContent_title)
      exisitingItems.push(item)
      menuItems.set(item.parentContent_title, exisitingItems)
    } else {
      menuItems.set(item.parentContent_title, [item])
    }
  })
  const [searchTerm, setSearchTerm] = useState('')
  let history = useHistory()

  const slowlyRequest = useCallback(
    _.debounce(value => {
      setKeywordAction(value)
    }, 500),
    []
  )
  return (
    <header className="shadow-sm">
      <div className="navbar-sticky bg-light">
        <div className="navbar navbar-expand-lg navbar-light">
          <div className="container">
            <Link className="navbar-brand d-none d-md-block mr-3 flex-shrink-0" to="/">
              <SWImage src={logo} alt="Stone & Berg Logo" />
            </Link>
            <Link className="navbar-brand d-md-none mr-2" to="/">
              <SWImage src={mobileLogo} style={{ minWidth: '90px' }} alt="Stone & Berg Logo" />
            </Link>

            <div className="navbar-right">
              <div className="navbar-topright">
                <div className="input-group-overlay d-none d-lg-flex">
                  <input
                    className="form-control appended-form-control"
                    type="text"
                    value={searchTerm}
                    onKeyDown={e => {
                      if (e.key === 'Enter') {
                        history.push('/products')
                      }
                    }}
                    onChange={e => {
                      setSearchTerm(e.target.value)
                      slowlyRequest(e.target.value)
                    }}
                    placeholder="Search for products"
                  />
                  <div className="input-group-append-overlay">
                    <span className="input-group-text">
                      <i
                        style={{ cursor: 'pointer' }}
                        onClick={() => {
                          history.push('/products')
                        }}
                        className="far fa-search"
                      ></i>
                    </span>
                  </div>
                </div>
                <div className="navbar-toolbar d-flex flex-shrink-0 align-items-center">
                  <button className="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse">
                    <span className="navbar-toggler-icon"></span>
                  </button>
                  <a className="navbar-tool navbar-stuck-toggler" href="#">
                    <span className="navbar-tool-tooltip">Expand menu</span>
                    <div className="navbar-tool-icon-box">
                      <i className="far fa-bars"></i>
                    </div>
                  </a>
                  <Link className="navbar-tool ml-1 ml-lg-0 mr-n1 mr-lg-2" to="/my-account" data-toggle="modal">
                    <AccountBubble isAuthenticated={user.accountID} name={user.firstName} />
                  </Link>

                  <CartMenuItem orderCount={orderCount} total={total} />
                </div>
              </div>

              <div
                className="navbar-main-links"
                onClick={event => {
                  event.preventDefault()
                  history.push(event.target.getAttribute('href'))
                }}
                dangerouslySetInnerHTML={{
                  __html: mainNavigation,
                }}
              />
            </div>
          </div>
        </div>

        <div className="navbar navbar-expand-lg navbar-dark bg-dark navbar-stuck-menu mt-2 pt-0 pb-0">
          <div className="container p-0">
            <div className="collapse navbar-collapse" id="navbarCollapse">
              <div className="input-group-overlay d-lg-none my-3 ml-0">
                <div className="input-group-prepend-overlay">
                  <span className="input-group-text">
                    <i className="far fa-search"></i>
                  </span>
                </div>
                <input className="form-control prepended-form-control" type="text" placeholder="Search for products" />
              </div>

              <ul className="navbar-nav nav-categories">
                {[...menuItems.values()].map((menuItem, index) => {
                  return <MegaMenu key={index} subMenu={menuItem} title={menuItem[0]['parentContent_title']} linkUrl={menuItem[0]['linkUrl']} />
                })}
              </ul>
              <ul className="navbar-nav mega-nav ml-lg-2">
                <li className="nav-item">
                  <Link className="nav-link" to="/">
                    <i className="far fa-industry-alt mr-2"></i>Shop by Manufacturer
                  </Link>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </header>
  )
}
Header.propTypes = {
  mainNavigation: PropTypes.string,
  productCategories: PropTypes.array,
  orderCount: PropTypes.number,
}
function mapStateToProps(state) {
  const { preload, cartReducer } = state
  return {
    ...preload.navigation,
    orderCount: cartReducer.orderItems.length,
    total: cartReducer.total,
    user: state.userReducer,
  }
}
const mapDispatchToProps = dispatch => {
  return {
    getUser: async () => dispatch(getUser()),
    setKeywordAction: async keyword => dispatch(setKeyword(keyword)),
  }
}
export default connect(mapStateToProps, mapDispatchToProps)(Header)
