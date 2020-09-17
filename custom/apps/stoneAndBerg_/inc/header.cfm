<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
	<cfinclude template="scripts/head.cfm" />
</head>
  
  <!-- Body-->
  <body class="toolbar-enabled">
    <!-- Sign in / sign up modal-->
    <div class="modal fade" id="signin-modal" tabindex="-1" role="dialog">
      <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <ul class="nav nav-tabs card-header-tabs" role="tablist">
              <li class="nav-item"><a class="nav-link active" href="##signin-tab" data-toggle="tab" role="tab" aria-selected="true"><i class="czi-unlocked mr-2 mt-n1"></i>Sign in</a></li>
              <li class="nav-item"><a class="nav-link" href="##signup-tab" data-toggle="tab" role="tab" aria-selected="false"><i class="czi-user mr-2 mt-n1"></i>Sign up</a></li>
            </ul>
            <button class="close" type="button" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          </div>
          <div class="modal-body tab-content py-4">
            <form class="needs-validation tab-pane fade show active" autocomplete="off" novalidate id="signin-tab">
              <div class="form-group">
                <label for="si-email">Email address</label>
                <input class="form-control" type="email" id="si-email" placeholder="johndoe@example.com" required>
                <div class="invalid-feedback">Please provide a valid email address.</div>
              </div>
              <div class="form-group">
                <label for="si-password">Password</label>
                <div class="password-toggle">
                  <input class="form-control" type="password" id="si-password" required>
                  <label class="password-toggle-btn">
                    <input class="custom-control-input" type="checkbox"><i class="czi-eye password-toggle-indicator"></i><span class="sr-only">Show password</span>
                  </label>
                </div>
              </div>
              <div class="form-group d-flex flex-wrap justify-content-between">
                <div class="custom-control custom-checkbox mb-2">
                  <input class="custom-control-input" type="checkbox" id="si-remember">
                  <label class="custom-control-label" for="si-remember">Remember me</label>
                </div><a class="font-size-sm" href="##">Forgot password?</a>
              </div>
              <button class="btn btn-primary btn-block btn-shadow" type="submit">Sign in</button>
            </form>
            <form class="needs-validation tab-pane fade" autocomplete="off" novalidate id="signup-tab">
              <div class="form-group">
                <label for="su-name">Full name</label>
                <input class="form-control" type="text" id="su-name" placeholder="John Doe" required>
                <div class="invalid-feedback">Please fill in your name.</div>
              </div>
              <div class="form-group">
                <label for="su-email">Email address</label>
                <input class="form-control" type="email" id="su-email" placeholder="johndoe@example.com" required>
                <div class="invalid-feedback">Please provide a valid email address.</div>
              </div>
              <div class="form-group">
                <label for="su-password">Password</label>
                <div class="password-toggle">
                  <input class="form-control" type="password" id="su-password" required>
                  <label class="password-toggle-btn">
                    <input class="custom-control-input" type="checkbox"><i class="czi-eye password-toggle-indicator"></i><span class="sr-only">Show password</span>
                  </label>
                </div>
              </div>
              <div class="form-group">
                <label for="su-password-confirm">Confirm password</label>
                <div class="password-toggle">
                  <input class="form-control" type="password" id="su-password-confirm" required>
                  <label class="password-toggle-btn">
                    <input class="custom-control-input" type="checkbox"><i class="czi-eye password-toggle-indicator"></i><span class="sr-only">Show password</span>
                  </label>
                </div>
              </div>
              <button class="btn btn-primary btn-block btn-shadow" type="submit">Sign up</button>
            </form>
          </div>
        </div>
      </div>
    </div>
    <!-- Quick View Modal-->
    <div class="modal-quick-view modal fade" id="quick-view" tabindex="-1">
      <div class="modal-dialog modal-xl">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title product-title"><a href="shop-single-v1.html" data-toggle="tooltip" data-placement="right" title="Go to product page">Sports Hooded Sweatshirt<i class="czi-arrow-right font-size-lg ml-2"></i></a></h4>
            <button class="close" type="button" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          </div>
          <div class="modal-body">
            <div class="row">
              <!-- Product gallery-->
              <div class="col-lg-7 pr-lg-0">
                <div class="cz-product-gallery">
                  <div class="cz-preview order-sm-2">
                    <div class="cz-preview-item active" id="first"><img class="cz-image-zoom" src="img/shop/single/gallery/01.jpg" data-zoom="img/shop/single/gallery/01.jpg" alt="Product image">
                      <div class="cz-image-zoom-pane"></div>
                    </div>
                    <div class="cz-preview-item" id="second"><img class="cz-image-zoom" src="img/shop/single/gallery/02.jpg" data-zoom="img/shop/single/gallery/02.jpg" alt="Product image">
                      <div class="cz-image-zoom-pane"></div>
                    </div>
                    <div class="cz-preview-item" id="third"><img class="cz-image-zoom" src="img/shop/single/gallery/03.jpg" data-zoom="img/shop/single/gallery/03.jpg" alt="Product image">
                      <div class="cz-image-zoom-pane"></div>
                    </div>
                    <div class="cz-preview-item" id="fourth"><img class="cz-image-zoom" src="img/shop/single/gallery/04.jpg" data-zoom="img/shop/single/gallery/04.jpg" alt="Product image">
                      <div class="cz-image-zoom-pane"></div>
                    </div>
                  </div>
                  <div class="cz-thumblist order-sm-1"><a class="cz-thumblist-item active" href="##first"><img src="img/shop/single/gallery/th01.jpg" alt="Product thumb"></a><a class="cz-thumblist-item" href="##second"><img src="img/shop/single/gallery/th02.jpg" alt="Product thumb"></a><a class="cz-thumblist-item" href="##third"><img src="img/shop/single/gallery/th03.jpg" alt="Product thumb"></a><a class="cz-thumblist-item" href="##fourth"><img src="img/shop/single/gallery/th04.jpg" alt="Product thumb"></a></div>
                </div>
              </div>
              <!-- Product details-->
              <div class="col-lg-5 pt-4 pt-lg-0 cz-image-zoom-pane">
                <div class="product-details ml-auto pb-3">
                  <div class="d-flex justify-content-between align-items-center mb-2"><a href="shop-single-v1.html##reviews">
                      <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i>
                      </div><span class="d-inline-block font-size-sm text-body align-middle mt-1 ml-1">74 Reviews</span></a>
                    <button class="btn-wishlist" type="button" data-toggle="tooltip" title="Add to wishlist"><i class="czi-heart"></i></button>
                  </div>
                  <div class="mb-3"><span class="h3 font-weight-normal text-accent mr-1">$18.<small>99</small></span>
                    <del class="text-muted font-size-lg mr-3">$25.<small>00</small></del><span class="badge badge-danger badge-shadow align-middle mt-n2">Sale</span>
                  </div>
                  <div class="font-size-sm mb-4"><span class="text-heading font-weight-medium mr-1">Color:</span><span class="text-muted">Red/Dark blue/White</span></div>
                  <div class="position-relative mr-n4 mb-3">
                    <div class="custom-control custom-option custom-control-inline mb-2">
                      <input class="custom-control-input" type="radio" name="color" id="color1" checked>
                      <label class="custom-option-label rounded-circle" for="color1"><span class="custom-option-color rounded-circle" style="background-image: url(img/shop/single/color-opt-1.png)"></span></label>
                    </div>
                    <div class="custom-control custom-option custom-control-inline mb-2">
                      <input class="custom-control-input" type="radio" name="color" id="color2">
                      <label class="custom-option-label rounded-circle" for="color2"><span class="custom-option-color rounded-circle" style="background-image: url(img/shop/single/color-opt-2.png)"></span></label>
                    </div>
                    <div class="custom-control custom-option custom-control-inline mb-2">
                      <input class="custom-control-input" type="radio" name="color" id="color3">
                      <label class="custom-option-label rounded-circle" for="color3"><span class="custom-option-color rounded-circle" style="background-image: url(img/shop/single/color-opt-3.png)"></span></label>
                    </div>
                    <div class="product-badge product-available mt-n1"><i class="czi-security-check"></i>Product available</div>
                  </div>
                  <form class="mb-grid-gutter">
                    <div class="form-group">
                      <label class="font-weight-medium pb-1" for="product-size">Size:</label>
                      <select class="custom-select" required id="product-size">
                        <option value="">Select size</option>
                        <option value="xs">XS</option>
                        <option value="s">S</option>
                        <option value="m">M</option>
                        <option value="l">L</option>
                        <option value="xl">XL</option>
                      </select>
                    </div>
                    <div class="form-group d-flex align-items-center">
                      <select class="custom-select mr-3" style="width: 5rem;">
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                      </select>
                      <button class="btn btn-primary btn-shadow btn-block" type="submit"><i class="czi-cart font-size-lg mr-2"></i>Add to Cart</button>
                    </div>
                  </form>
                  <h5 class="h6 mb-3 pb-2 border-bottom"><i class="czi-announcement text-muted font-size-lg align-middle mt-n1 mr-2"></i>Product info</h5>
                  <h6 class="font-size-sm mb-2">Style</h6>
                  <ul class="font-size-sm pl-4">
                    <li>Hooded top</li>
                  </ul>
                  <h6 class="font-size-sm mb-2">Composition</h6>
                  <ul class="font-size-sm pl-4">
                    <li>Elastic rib: Cotton 95%, Elastane 5%</li>
                    <li>Lining: Cotton 100%</li>
                    <li>Cotton 80%, Polyester 20%</li>
                  </ul>
                  <h6 class="font-size-sm mb-2">Art. No.</h6>
                  <ul class="font-size-sm pl-4 mb-0">
                    <li>183260098</li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Navbar 3 Level (Light)-->
    
    <header class="box-shadow-sm">
    <!-- Topbar-->
    <div class="topbar topbar-dark bg-dark">
      <div class="container">
        <div class="topbar-text dropdown d-md-none"><a class="topbar-link dropdown-toggle" href="##" data-toggle="dropdown">Useful links</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="tel:00331697720"><i class="czi-support text-muted mr-2"></i>(00) 33 169 7720</a></li>
            <li><a class="dropdown-item" href="order-tracking.html"><i class="czi-location text-muted mr-2"></i>Order tracking</a></li>
          </ul>
        </div>
        <div class="topbar-text text-nowrap d-none d-md-inline-block"><i class="czi-support"></i><span class="text-muted mr-1">Support</span><a class="topbar-link" href="tel:00331697720">(00) 33 169 7720</a></div>
        <div class="cz-carousel cz-controls-static d-none d-md-block">
          <div class="cz-carousel-inner" data-carousel-options="{&quot;mode&quot;: &quot;gallery&quot;, &quot;nav&quot;: false}">
            <div class="topbar-text">Free shipping for order over $200</div>
            <div class="topbar-text">We return money within 30 days</div>
            <div class="topbar-text">Friendly 24/7 customer support</div>
          </div>
        </div>
        <div class="ml-3 text-nowrap"><a class="topbar-link mr-4 d-none d-md-inline-block" href="order-tracking.html"><i class="czi-location"></i>Order tracking</a>
          <div class="topbar-text dropdown disable-autohide"><a class="topbar-link dropdown-toggle" href="##" data-toggle="dropdown"><img class="mr-2" width="20" src="img/flags/en.png" alt="English"/>Eng / $</a>
            <ul class="dropdown-menu dropdown-menu-right">
              <li class="dropdown-item">
                <select class="custom-select custom-select-sm">
                  <option value="usd">$ USD</option>
                  <option value="eur">€ EUR</option>
                  <option value="ukp">£ UKP</option>
                  <option value="jpy">¥ JPY</option>
                </select>
              </li>
              <li><a class="dropdown-item pb-1" href="##"><img class="mr-2" width="20" src="img/flags/fr.png" alt="Français"/>Français</a></li>
              <li><a class="dropdown-item pb-1" href="##"><img class="mr-2" width="20" src="img/flags/de.png" alt="Deutsch"/>Deutsch</a></li>
              <li><a class="dropdown-item" href="##"><img class="mr-2" width="20" src="img/flags/it.png" alt="Italiano"/>Italiano</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <!-- Remove "navbar-sticky" class to make navigation bar scrollable with the page.-->
    <div class="navbar-sticky bg-light">
      <div class="navbar navbar-expand-lg navbar-light">
        <div class="container"><a class="navbar-brand d-none d-sm-block mr-3 flex-shrink-0" href="index.html" style="min-width: 7rem;"><img width="142" src="img/logo-dark.png" alt="Cartzilla"/></a><a class="navbar-brand d-sm-none mr-2" href="index.html" style="min-width: 4.625rem;"><img width="74" src="img/logo-icon.png" alt="Cartzilla"/></a>
          <div class="input-group-overlay d-none d-lg-flex mx-4">
            <input class="form-control appended-form-control" type="text" placeholder="Search for products">
            <div class="input-group-append-overlay"><span class="input-group-text"><i class="czi-search"></i></span></div>
          </div>
          <div class="navbar-toolbar d-flex flex-shrink-0 align-items-center">
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="##navbarCollapse"><span class="navbar-toggler-icon"></span></button><a class="navbar-tool navbar-stuck-toggler" href="##"><span class="navbar-tool-tooltip">Expand menu</span>
              <div class="navbar-tool-icon-box"><i class="navbar-tool-icon czi-menu"></i></div></a><a class="navbar-tool d-none d-lg-flex" href="account-wishlist.html"><span class="navbar-tool-tooltip">Wishlist</span>
              <div class="navbar-tool-icon-box"><i class="navbar-tool-icon czi-heart"></i></div></a><a class="navbar-tool ml-1 ml-lg-0 mr-n1 mr-lg-2" href="##signin-modal" data-toggle="modal">
              <div class="navbar-tool-icon-box"><i class="navbar-tool-icon czi-user"></i></div>
              <div class="navbar-tool-text ml-n3"><small>Hello, Sign in</small>My Account</div></a>
            <div class="navbar-tool dropdown ml-3"><a class="navbar-tool-icon-box bg-secondary dropdown-toggle" href="shop-cart.html"><span class="navbar-tool-label">4</span><i class="navbar-tool-icon czi-cart"></i></a><a class="navbar-tool-text" href="shop-cart.html"><small>My Cart</small>$265.00</a>
              <!-- Cart dropdown-->
              <div class="dropdown-menu dropdown-menu-right" style="width: 20rem;">
                <div class="widget widget-cart px-3 pt-2 pb-3">
                  <div style="height: 15rem;" data-simplebar data-simplebar-auto-hide="false">
                    <div class="widget-cart-item pb-2 border-bottom">
                      <button class="close text-danger" type="button" aria-label="Remove"><span aria-hidden="true">&times;</span></button>
                      <div class="media align-items-center"><a class="d-block mr-2" href="shop-single-v1.html"><img width="64" src="img/shop/cart/widget/01.jpg" alt="Product"/></a>
                        <div class="media-body">
                          <h6 class="widget-product-title"><a href="shop-single-v1.html">Women Colorblock Sneakers</a></h6>
                          <div class="widget-product-meta"><span class="text-accent mr-2">$150.<small>00</small></span><span class="text-muted">x 1</span></div>
                        </div>
                      </div>
                    </div>
                    <div class="widget-cart-item py-2 border-bottom">
                      <button class="close text-danger" type="button" aria-label="Remove"><span aria-hidden="true">&times;</span></button>
                      <div class="media align-items-center"><a class="d-block mr-2" href="shop-single-v1.html"><img width="64" src="img/shop/cart/widget/02.jpg" alt="Product"/></a>
                        <div class="media-body">
                          <h6 class="widget-product-title"><a href="shop-single-v1.html">TH Jeans City Backpack</a></h6>
                          <div class="widget-product-meta"><span class="text-accent mr-2">$79.<small>50</small></span><span class="text-muted">x 1</span></div>
                        </div>
                      </div>
                    </div>
                    <div class="widget-cart-item py-2 border-bottom">
                      <button class="close text-danger" type="button" aria-label="Remove"><span aria-hidden="true">&times;</span></button>
                      <div class="media align-items-center"><a class="d-block mr-2" href="shop-single-v1.html"><img width="64" src="img/shop/cart/widget/03.jpg" alt="Product"/></a>
                        <div class="media-body">
                          <h6 class="widget-product-title"><a href="shop-single-v1.html">3-Color Sun Stash Hat</a></h6>
                          <div class="widget-product-meta"><span class="text-accent mr-2">$22.<small>50</small></span><span class="text-muted">x 1</span></div>
                        </div>
                      </div>
                    </div>
                    <div class="widget-cart-item py-2 border-bottom">
                      <button class="close text-danger" type="button" aria-label="Remove"><span aria-hidden="true">&times;</span></button>
                      <div class="media align-items-center"><a class="d-block mr-2" href="shop-single-v1.html"><img width="64" src="img/shop/cart/widget/04.jpg" alt="Product"/></a>
                        <div class="media-body">
                          <h6 class="widget-product-title"><a href="shop-single-v1.html">Cotton Polo Regular Fit</a></h6>
                          <div class="widget-product-meta"><span class="text-accent mr-2">$9.<small>00</small></span><span class="text-muted">x 1</span></div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="d-flex flex-wrap justify-content-between align-items-center py-3">
                    <div class="font-size-sm mr-2 py-2"><span class="text-muted">Subtotal:</span><span class="text-accent font-size-base ml-1">$265.<small>00</small></span></div><a class="btn btn-outline-secondary btn-sm" href="shop-cart.html">Expand cart<i class="czi-arrow-right ml-1 mr-n1"></i></a>
                  </div><a class="btn btn-primary btn-sm btn-block" href="checkout-details.html"><i class="czi-card mr-2 font-size-base align-middle"></i>Checkout</a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="navbar navbar-expand-lg navbar-light navbar-stuck-menu mt-n2 pt-0 pb-2">
        <div class="container">
          <div class="collapse navbar-collapse" id="navbarCollapse">
            <!-- Search-->
            <div class="input-group-overlay d-lg-none my-3">
              <div class="input-group-prepend-overlay"><span class="input-group-text"><i class="czi-search"></i></span></div>
              <input class="form-control prepended-form-control" type="text" placeholder="Search for products">
            </div>
            <!-- Departments menu-->
            <ul class="navbar-nav mega-nav pr-lg-2 mr-lg-2">
              <li class="nav-item dropdown"><a class="nav-link dropdown-toggle pl-0" href="##" data-toggle="dropdown"><i class="czi-view-grid mr-2"></i>Departments</a>
                <div class="dropdown-menu px-2 pl-0 pb-4">
                  <div class="d-flex flex-wrap flex-md-nowrap">
                    <div class="mega-dropdown-column pt-4 px-3">
                      <div class="widget widget-links"><a class="d-block overflow-hidden rounded-lg mb-3" href="##"><img src="img/shop/departments/01.jpg" alt="Shoes"/></a>
                        <h6 class="font-size-base mb-2">Clothing</h6>
                        <ul class="widget-list">
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Women's clothing</a></li>
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Men's clothing</a></li>
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Kid's clothing</a></li>
                        </ul>
                      </div>
                    </div>
                    <div class="mega-dropdown-column pt-4 px-3">
                      <div class="widget widget-links"><a class="d-block overflow-hidden rounded-lg mb-3" href="##"><img src="img/shop/departments/02.jpg" alt="Shoes"/></a>
                        <h6 class="font-size-base mb-2">Shoes</h6>
                        <ul class="widget-list">
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Women's shoes</a></li>
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Men's shoes</a></li>
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Kid's shoes</a></li>
                        </ul>
                      </div>
                    </div>
                    <div class="mega-dropdown-column pt-4 px-3">
                      <div class="widget widget-links"><a class="d-block overflow-hidden rounded-lg mb-3" href="##"><img src="img/shop/departments/03.jpg" alt="Shoes"/></a>
                        <h6 class="font-size-base mb-2">Gadgets</h6>
                        <ul class="widget-list">
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Smartphones &amp; Tablets</a></li>
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Wearable gadgets</a></li>
                          <li class="widget-list-item"><a class="widget-list-link" href="##">E-book readers</a></li>
                        </ul>
                      </div>
                    </div>
                  </div>
                  <div class="d-flex flex-wrap flex-md-nowrap">
                    <div class="mega-dropdown-column pt-4 px-3">
                      <div class="widget widget-links"><a class="d-block overflow-hidden rounded-lg mb-3" href="##"><img src="img/shop/departments/04.jpg" alt="Shoes"/></a>
                        <h6 class="font-size-base mb-2">Furniture &amp; Decor</h6>
                        <ul class="widget-list">
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Home furniture</a></li>
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Office furniture</a></li>
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Lighting and decoration</a></li>
                        </ul>
                      </div>
                    </div>
                    <div class="mega-dropdown-column pt-4 px-3">
                      <div class="widget widget-links"><a class="d-block overflow-hidden rounded-lg mb-3" href="##"><img src="img/shop/departments/05.jpg" alt="Shoes"/></a>
                        <h6 class="font-size-base mb-2">Accessories</h6>
                        <ul class="widget-list">
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Hats</a></li>
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Sunglasses</a></li>
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Bags</a></li>
                        </ul>
                      </div>
                    </div>
                    <div class="mega-dropdown-column pt-4 px-3">
                      <div class="widget widget-links"><a class="d-block overflow-hidden rounded-lg mb-3" href="##"><img src="img/shop/departments/06.jpg" alt="Shoes"/></a>
                        <h6 class="font-size-base mb-2">Entertainment</h6>
                        <ul class="widget-list">
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Kid's toys</a></li>
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Video games</a></li>
                          <li class="widget-list-item"><a class="widget-list-link" href="##">Outdoor / Camping</a></li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>
              </li>
            </ul>
            <!-- Primary menu-->
            <ul class="navbar-nav">
              <li class="nav-item dropdown active"><a class="nav-link dropdown-toggle" href="##" data-toggle="dropdown">Home</a>
                <ul class="dropdown-menu">
                  <li class="dropdown position-static mb-0"><a class="dropdown-item py-2 border-bottom" href="home-fashion-store-v1.html"><span class="d-block text-heading">Fashion Store v.1</span><small class="d-block text-muted">Classic shop layout</small></a>
                    <div class="dropdown-menu h-100 animation-0 mt-0 p-3"><a class="d-block" href="home-fashion-store-v1.html" style="width: 250px;"><img src="img/home/preview/th01.jpg" alt="Fashion Store v.1"/></a></div>
                  </li>
                  <li class="dropdown position-static mb-0"><a class="dropdown-item py-2 border-bottom" href="home-fashion-store-v2.html"><span class="d-block text-heading">Fashion Store v.2</span><small class="d-block text-muted">Slider + Featured categories</small></a>
                    <div class="dropdown-menu h-100 animation-0 mt-0 p-3"><a class="d-block" href="home-fashion-store-v2.html" style="width: 250px;"><img src="img/home/preview/th02.jpg" alt="Fashion Store v.2"/></a></div>
                  </li>
                  <li class="dropdown position-static mb-0"><a class="dropdown-item py-2 border-bottom" href="home-electronics-store.html"><span class="d-block text-heading">Electronics Store</span><small class="d-block text-muted">Slider + Promo banners</small></a>
                    <div class="dropdown-menu h-100 animation-0 mt-0 p-3"><a class="d-block" href="home-electronics-store.html" style="width: 250px;"><img src="img/home/preview/th03.jpg" alt="Electronics Store"/></a></div>
                  </li>
                  <li class="dropdown position-static mb-0"><a class="dropdown-item py-2 border-bottom" href="home-marketplace.html"><span class="d-block text-heading">Marketplace</span><small class="d-block text-muted">Multi-vendor, digital goods</small></a>
                    <div class="dropdown-menu h-100 animation-0 mt-0 p-3"><a class="d-block" href="home-marketplace.html" style="width: 250px;"><img src="img/home/preview/th04.jpg" alt="Marketplace"/></a></div>
                  </li>
                  <li class="dropdown position-static mb-0"><a class="dropdown-item py-2 border-bottom" href="home-single-store.html"><span class="d-block text-heading">Single Product Store</span><small class="d-block text-muted">Single product / mono brand</small></a>
                    <div class="dropdown-menu h-100 animation-0 mt-0 p-3"><a class="d-block" href="home-single-store.html" style="width: 250px;"><img src="img/home/preview/th05.jpg" alt="Single Product / Brand Store"/></a></div>
                  </li>
                  <li class="dropdown position-static mb-0"><a class="dropdown-item py-2" href="home-grocery-store.html"><span class="d-block text-heading">Grocery Store</span><small class="d-block text-muted">Full width + Side menu</small></a>
                    <div class="dropdown-menu h-100 animation-0 mt-0 p-3"><a class="d-block" href="home-grocery-store.html" style="width: 250px;"><img src="img/home/preview/th06.jpg" alt="Grocery Store"/></a></div>
                  </li>
                </ul>
              </li>
              <li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="##" data-toggle="dropdown">Shop</a>
                <div class="dropdown-menu p-0">
                  <div class="d-flex flex-wrap flex-md-nowrap px-2">
                    <div class="mega-dropdown-column py-4 px-3">
                      <div class="widget widget-links mb-3">
                        <h6 class="font-size-base mb-3">Shop layouts</h6>
                        <ul class="widget-list">
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="shop-grid-ls.html">Shop Grid - Left Sidebar</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="shop-grid-rs.html">Shop Grid - Right Sidebar</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="shop-grid-ft.html">Shop Grid - Filters on Top</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="shop-list-ls.html">Shop List - Left Sidebar</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="shop-list-rs.html">Shop List - Right Sidebar</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="shop-list-ft.html">Shop List - Filters on Top</a></li>
                        </ul>
                      </div>
                      <div class="widget widget-links">
                        <h6 class="font-size-base mb-3">Marketplace</h6>
                        <ul class="widget-list">
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="marketplace-category.html">Category Page</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="marketplace-single.html">Single Item Page</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="marketplace-vendor.html">Vendor Page</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="marketplace-cart.html">Cart</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="marketplace-checkout.html">Checkout</a></li>
                        </ul>
                      </div>
                    </div>
                    <div class="mega-dropdown-column py-4 px-3">
                      <div class="widget widget-links">
                        <h6 class="font-size-base mb-3">Shop pages</h6>
                        <ul class="widget-list">
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="shop-categories.html">Shop Categories</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="shop-single-v1.html">Product Page v.1</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="shop-single-v2.html">Product Page v.2</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="shop-cart.html">Cart</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="checkout-details.html">Checkout - Details</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="checkout-shipping.html">Checkout - Shipping</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="checkout-payment.html">Checkout - Payment</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="checkout-review.html">Checkout - Review</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="checkout-complete.html">Checkout - Complete</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="order-tracking.html">Order Tracking</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="comparison.html">Product Comparison</a></li>
                        </ul>
                      </div>
                    </div>
                    <div class="mega-dropdown-column py-4 pr-3">
                      <div class="widget widget-links mb-3">
                        <h6 class="font-size-base mb-3">Grocery store</h6>
                        <ul class="widget-list">
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="grocery-catalog.html">Product Catalog</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="grocery-single.html">Single Product Page</a></li>
                          <li class="widget-list-item pb-1"><a class="widget-list-link" href="grocery-checkout.html">Checkout</a></li>
                        </ul>
                      </div><a class="d-block" href="##"><img src="img/shop/menu-banner.jpg" alt="Promo banner"/></a>
                    </div>
                  </div>
                </div>
              </li>
              <li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="##" data-toggle="dropdown">Account</a>
                <ul class="dropdown-menu">
                  <li class="dropdown"><a class="dropdown-item dropdown-toggle" href="##" data-toggle="dropdown">Shop User Account</a>
                    <ul class="dropdown-menu">
                      <li><a class="dropdown-item" href="account-orders.html">Orders History</a></li>
                      <li><a class="dropdown-item" href="account-profile.html">Profile Settings</a></li>
                      <li><a class="dropdown-item" href="account-address.html">Account Addresses</a></li>
                      <li><a class="dropdown-item" href="account-payment.html">Payment Methods</a></li>
                      <li><a class="dropdown-item" href="account-wishlist.html">Wishlist</a></li>
                      <li><a class="dropdown-item" href="account-tickets.html">My Tickets</a></li>
                      <li><a class="dropdown-item" href="account-single-ticket.html">Single Ticket</a></li>
                    </ul>
                  </li>
                  <li class="dropdown"><a class="dropdown-item dropdown-toggle" href="##" data-toggle="dropdown">Vendor Dashboard</a>
                    <ul class="dropdown-menu">
                      <li><a class="dropdown-item" href="dashboard-settings.html">Settings</a></li>
                      <li><a class="dropdown-item" href="dashboard-purchases.html">Purchases</a></li>
                      <li><a class="dropdown-item" href="dashboard-favorites.html">Favorites</a></li>
                      <li><a class="dropdown-item" href="dashboard-sales.html">Sales</a></li>
                      <li><a class="dropdown-item" href="dashboard-products.html">Products</a></li>
                      <li><a class="dropdown-item" href="dashboard-add-new-product.html">Add New Product</a></li>
                      <li><a class="dropdown-item" href="dashboard-payouts.html">Payouts</a></li>
                    </ul>
                  </li>
                  <li><a class="dropdown-item" href="account-signin.html">Sign In / Sign Up</a></li>
                  <li><a class="dropdown-item" href="account-password-recovery.html">Password Recovery</a></li>
                </ul>
              </li>
              <li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="##" data-toggle="dropdown">Pages</a>
                <ul class="dropdown-menu">
                  <li class="dropdown"><a class="dropdown-item dropdown-toggle" href="##" data-toggle="dropdown">Navbar Variants</a>
                    <ul class="dropdown-menu">
                      <li><a class="dropdown-item" href="navbar-1-level-light.html">1 Level Light</a></li>
                      <li><a class="dropdown-item" href="navbar-1-level-dark.html">1 Level Dark</a></li>
                      <li><a class="dropdown-item" href="navbar-2-level-light.html">2 Level Light</a></li>
                      <li><a class="dropdown-item" href="navbar-2-level-dark.html">2 Level Dark</a></li>
                      <li><a class="dropdown-item" href="navbar-3-level-light.html">3 Level Light</a></li>
                      <li><a class="dropdown-item" href="navbar-3-level-dark.html">3 Level Dark</a></li>
                      <li><a class="dropdown-item" href="home-electronics-store.html">Electronics Store</a></li>
                      <li><a class="dropdown-item" href="home-marketplace.html">Marketplace</a></li>
                      <li><a class="dropdown-item" href="home-grocery-store.html">Side Menu (Grocery)</a></li>
                      <li><a class="dropdown-item" href="home-single-store.html">Transparent</a></li>
                    </ul>
                  </li>
                  <li class="dropdown-divider"></li>
                  <li><a class="dropdown-item" href="about.html">About Us</a></li>
                  <li><a class="dropdown-item" href="contacts.html">Contacts</a></li>
                  <li class="dropdown"><a class="dropdown-item dropdown-toggle" href="##" data-toggle="dropdown">Help Center</a>
                    <ul class="dropdown-menu">
                      <li><a class="dropdown-item" href="help-topics.html">Help Topics</a></li>
                      <li><a class="dropdown-item" href="help-single-topic.html">Single Topic</a></li>
                      <li><a class="dropdown-item" href="help-submit-request.html">Submit a Request</a></li>
                    </ul>
                  </li>
                  <li class="dropdown"><a class="dropdown-item dropdown-toggle" href="##" data-toggle="dropdown">404 Not Found</a>
                    <ul class="dropdown-menu">
                      <li><a class="dropdown-item" href="404-simple.html">404 - Simple Text</a></li>
                      <li><a class="dropdown-item" href="404-illustration.html">404 - Illustration</a></li>
                    </ul>
                  </li>
                </ul>
              </li>
              <li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="##" data-toggle="dropdown">Blog</a>
                <ul class="dropdown-menu">
                  <li class="dropdown"><a class="dropdown-item dropdown-toggle" href="##" data-toggle="dropdown">Blog List Layouts</a>
                    <ul class="dropdown-menu">
                      <li><a class="dropdown-item" href="blog-list-sidebar.html">List with Sidebar</a></li>
                      <li><a class="dropdown-item" href="blog-list.html">List no Sidebar</a></li>
                    </ul>
                  </li>
                  <li class="dropdown"><a class="dropdown-item dropdown-toggle" href="##" data-toggle="dropdown">Blog Grid Layouts</a>
                    <ul class="dropdown-menu">
                      <li><a class="dropdown-item" href="blog-grid-sidebar.html">Grid with Sidebar</a></li>
                      <li><a class="dropdown-item" href="blog-grid.html">Grid no Sidebar</a></li>
                    </ul>
                  </li>
                  <li><a class="dropdown-item" href="blog-single.html">Single Post</a></li>
                </ul>
              </li>
              <li class="nav-item dropdown"><a class="nav-link dropdown-toggle" href="##" data-toggle="dropdown">Docs / Components</a>
                <ul class="dropdown-menu">
                  <li><a class="dropdown-item" href="docs/dev-setup.html">
                      <div class="d-flex">
                        <div class="lead text-muted pt-1"><i class="czi-book"></i></div>
                        <div class="ml-2"><span class="d-block text-heading">Documentation</span><small class="d-block text-muted">Kick-start customization</small></div>
                      </div></a></li>
                  <li class="dropdown-divider"></li>
                  <li><a class="dropdown-item" href="components/typography.html">
                      <div class="d-flex">
                        <div class="lead text-muted pt-1"><i class="czi-server"></i></div>
                        <div class="ml-2"><span class="d-block text-heading">Components<span class="badge badge-info ml-2">40+</span></span><small class="d-block text-muted">Faster page building</small></div>
                      </div></a></li>
                  <li class="dropdown-divider"></li>
                  <li><a class="dropdown-item" href="docs/changelog.html">
                      <div class="d-flex">
                        <div class="lead text-muted pt-1"><i class="czi-edit"></i></div>
                        <div class="ml-2"><span class="d-block text-heading">Changelog<span class="badge badge-success ml-2">v1.3</span></span><small class="d-block text-muted">Regular updates</small></div>
                      </div></a></li>
                  <li class="dropdown-divider"></li>
                  <li><a class="dropdown-item" href="mailto:contact@createx.studio">
                      <div class="d-flex">
                        <div class="lead text-muted pt-1"><i class="czi-help"></i></div>
                        <div class="ml-2"><span class="d-block text-heading">Support</span><small class="d-block text-muted">contact@createx.studio</small></div>
                      </div></a></li>
                </ul>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </header>
  
 </cfoutput>