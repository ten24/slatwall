import React from 'react'
import PropTypes from 'prop-types'

function Header(props) {
  console.log(props)
  return (
    <header className="shadow-sm">
      <div className="navbar-sticky bg-light">
        <div className="navbar navbar-expand-lg navbar-light">
          <div className="container">
            <a
              className="navbar-brand d-none d-md-block mr-3 flex-shrink-0"
              href="/"
            >
              <img
                src="/custom/client/assets/images/sb-logo.png"
                alt="Stone & Berg Logo"
              />
            </a>
            <a className="navbar-brand d-md-none mr-2" href="/">
              <img
                src="/custom/client/assets/images/sb-logo-mobile.png"
                style={{ minWidth: '90px' }}
                alt="Stone & Berg Logo"
              />
            </a>

            <div className="navbar-right">
              <div className="navbar-topright">
                <div className="input-group-overlay d-none d-lg-flex">
                  <input
                    className="form-control appended-form-control"
                    type="text"
                    placeholder="Search for products"
                  />
                  <div className="input-group-append-overlay">
                    <span className="input-group-text">
                      <i className="far fa-search"></i>
                    </span>
                  </div>
                </div>
                <div className="navbar-toolbar d-flex flex-shrink-0 align-items-center">
                  <button
                    className="navbar-toggler"
                    type="button"
                    data-toggle="collapse"
                    data-target="##navbarCollapse"
                  >
                    <span className="navbar-toggler-icon"></span>
                  </button>
                  <a className="navbar-tool navbar-stuck-toggler" href="##">
                    <span className="navbar-tool-tooltip">Expand menu</span>
                    <div className="navbar-tool-icon-box">
                      <i className="far fa-bars"></i>
                    </div>
                  </a>
                  <a
                    className="navbar-tool ml-1 ml-lg-0 mr-n1 mr-lg-2"
                    href="##"
                    data-toggle="modal"
                  >
                    <div className="navbar-tool-icon-box">
                      <i className="far fa-user"></i>
                    </div>
                    <div className="navbar-tool-text ml-n3">
                      <small>Hello, Sign in</small>My Account
                    </div>
                  </a>
                  <div className="navbar-tool ml-3">
                    <a className="navbar-tool-icon-box bg-secondary" href="##">
                      <span className="navbar-tool-label">4</span>
                      <i className="far fa-shopping-cart"></i>
                    </a>
                    <a className="navbar-tool-text" href="shop-cart.html">
                      <small>My Cart</small>$265.00
                    </a>
                  </div>
                </div>
              </div>

              <div
                className="navbar-main-links"
                dangerouslySetInnerHTML={{ __html: props.mainNavigation }}
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
                <input
                  className="form-control prepended-form-control"
                  type="text"
                  placeholder="Search for products"
                />
              </div>

              <ul className="navbar-nav nav-categories">
                <h1>dfgdfgfg</h1>
              </ul>
              <ul className="navbar-nav mega-nav ml-lg-2">
                <li className="nav-item">
                  <a className="nav-link" href="##">
                    <i className="far fa-industry-alt mr-2"></i>Shop by
                    Manufacturer
                  </a>
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
  themePath: PropTypes.string,
  mainNavigation: PropTypes.string,
  productCategories: PropTypes.string,
}

export default Header
