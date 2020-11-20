import React from "react";
import PropTypes from "prop-types";

function Header(props) {
  console.log(props)
  return (
    <header class="shadow-sm">

    <div class="navbar-sticky bg-light">
      <div class="navbar navbar-expand-lg navbar-light">
      
        <div class="container">
          <a class="navbar-brand d-none d-md-block mr-3 flex-shrink-0" href="/">
            <img src="/custom/client/assets/images/sb-logo.png" alt="Stone & Berg Logo"/>
          </a>
          <a class="navbar-brand d-md-none mr-2" href="/">
            <img src="/custom/client/assets/images/sb-logo-mobile.png" style="min-width: 90px;" alt="Stone & Berg Logo"/>
          </a>
          
          <div class="navbar-right">
            <div class="navbar-topright">
              <div class="input-group-overlay d-none d-lg-flex">
                <input class="form-control appended-form-control" type="text" placeholder="Search for products"/>
                <div class="input-group-append-overlay"><span class="input-group-text"><i class="far fa-search"></i></span></div>
              </div>
              <div class="navbar-toolbar d-flex flex-shrink-0 align-items-center">
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="##navbarCollapse"><span class="navbar-toggler-icon"></span></button><a class="navbar-tool navbar-stuck-toggler" href="##"><span class="navbar-tool-tooltip">Expand menu</span>
                  <div class="navbar-tool-icon-box"><i class="far fa-bars"></i></div></a><a class="navbar-tool ml-1 ml-lg-0 mr-n1 mr-lg-2" href="##" data-toggle="modal">
                  <div class="navbar-tool-icon-box"><i class="far fa-user"></i></div>
                  <div class="navbar-tool-text ml-n3"><small>Hello, Sign in</small>My Account</div></a>
                <div class="navbar-tool ml-3"><a class="navbar-tool-icon-box bg-secondary" href="##"><span class="navbar-tool-label">4</span><i class="far fa-shopping-cart"></i></a><a class="navbar-tool-text" href="shop-cart.html"><small>My Cart</small>$265.00</a>
                </div>
              </div>
            </div>
            
            <div class="navbar-main-links" dangerouslySetInnerHTML={{__html: props.mainNavigation}}> </div>
          </div>
        </div>
      </div>
      
      <div class="navbar navbar-expand-lg navbar-dark bg-dark navbar-stuck-menu mt-2 pt-0 pb-0">
        <div class="container p-0">
          <div class="collapse navbar-collapse" id="navbarCollapse">
            <div class="input-group-overlay d-lg-none my-3 ml-0">
              <div class="input-group-prepend-overlay"><span class="input-group-text"><i class="far fa-search"></i></span></div>
              <input class="form-control prepended-form-control" type="text" placeholder="Search for products"/>
            </div>
            
            <ul class="navbar-nav nav-categories">
              <h1>dfgdfgfg</h1>
            </ul>
            <ul class="navbar-nav mega-nav ml-lg-2">
              <li class="nav-item"><a class="nav-link" href="##"><i class="far fa-industry-alt mr-2"></i>Shop by Manufacturer</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </header>
  );
}
Header.propTypes = {
  themePath: PropTypes.string,
  mainNavigation: PropTypes.string,
  productCategories: PropTypes.string,
};

export default Header;
