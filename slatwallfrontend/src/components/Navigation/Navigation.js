import React, { useState } from "react"
import { Link } from "react-router-dom"
import { connect } from "react-redux"

function Navigation(props) {
  const [isNavCollapsed, setIsNavCollapsed] = useState(true)
  const handleNavCollapse = () => setIsNavCollapsed(!isNavCollapsed)

  return (
    <nav className="navbar navbar-expand-lg navbar-light bg-light">
      <button
        className="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navbarNav"
        aria-controls="navbarNav"
        aria-expanded="false"
        aria-label="Toggle navigation"
        onClick={handleNavCollapse}
      >
        <span className="navbar-toggler-icon"></span>
      </button>
      <div
        className={`${isNavCollapsed ? "collapse" : ""} navbar-collapse`}
        id="navbarNav"
      >
        <ul className="navbar-nav mr-auto mt-2 mt-lg-0">
          <li className="nav-item active">
            <Link className="nav-link" to="/">
              Home
            </Link>
          </li>
          <li className="nav-item">
            <Link className="nav-link" to="/about">
              about
            </Link>
          </li>
          <li className="nav-item">
            <Link className="nav-link" to="/products">
              All Products
            </Link>
          </li>
          <li className="nav-item">
            <Link className="nav-link" to="/product/1">
              product 2
            </Link>
          </li>
          <li className="nav-item">
            <Link className="nav-link" to="/product/2">
              product 2
            </Link>
          </li>
        </ul>
        <span className="navbar-text">
          <Link className="nav-link" to="/cart">
            Cart <span>({props.cartLength})</span>
          </Link>
        </span>
      </div>
    </nav>
  )
}
const mapStateToProps = state => {
  return {
    cartLength: state.shop.cart.reduce((accumulator, lineItem) => {
      return accumulator + lineItem.quantity
    }, 0),
  }
}

export default connect(mapStateToProps, null)(Navigation)
