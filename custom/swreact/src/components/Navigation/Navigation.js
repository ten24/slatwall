import React, { useState } from "react";

function Navigation(props) {
  const [isNavCollapsed, setIsNavCollapsed] = useState(true);
  const handleNavCollapse = () => setIsNavCollapsed(!isNavCollapsed);

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
            <a className="nav-link" href="/">
              Home
            </a>
          </li>
          <li className="nav-item">
            <a className="nav-link" href="/products">
              All Products
            </a>
          </li>
          <li className="nav-item">
            <a className="nav-link" href="/product/1">
              product 2
            </a>
          </li>
          <li className="nav-item">
            <a className="nav-link" href="/product/2">
              product 2
            </a>
          </li>
        </ul>
        <span className="navbar-text">
          <a className="nav-link" href="/cart">
            Cart <span>({props.cartLength})</span>
          </a>
        </span>
      </div>
    </nav>
  );
}

export default Navigation;
