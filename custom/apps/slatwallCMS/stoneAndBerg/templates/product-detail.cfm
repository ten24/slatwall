<cfimport prefix="swc" taglib="../tags" />
<cfinclude template="inc/header/header.cfm" />

<cfoutput>
<div class="container">
      <div class="container bg-light p-0">

<!---- start template copy ---->
     <!-- Page Title (Shop)-->
    <div class="page-title-overlap bg-lightgray pt-4">
      <div class="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div class="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb text-small bg-lightgray flex-lg-nowrap justify-content-center justify-content-lg-start">
              <li class="breadcrumb-item"><a class="text-nowrap" href="index.html"><i class="fa fa-home"></i>Home</a></li>
              <li class="breadcrumb-item text-nowrap"><a href="##">Shop</a>
              </li>
              <li class="breadcrumb-item text-nowrap active" aria-current="page">Product Page v.1</li>
            </ol>
          </nav>
        </div>
        <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 class="h3 text-dark mb-0 font-accent">Gardell 1812 Series</h1>
        </div>
      </div>
    </div>
    <!-- Page Content-->
      <!-- Gallery + details-->
      <div class="bg-light box-shadow-lg rounded-lg px-4 py-3 mb-5 mx-5">
        <div class="px-lg-3">
          <div class="row">
            <!-- Product gallery-->
            <div class="col-lg-7 pr-lg-0 pt-0">
              <div class="cz-product-gallery">
                <div class="cz-preview order-sm-2">
                  <div class="cz-preview-item active" id="first"><img class="cz-image-zoom w-100" src="#$.getThemePath()#/custom/client/assets/images/product-img-1.png" data-zoom="#$.getThemePath()#/custom/client/assets/images/product-img-1.png" alt="Product image">
                    <div class="cz-image-zoom-pane"></div>
                  </div>
                </div>
              </div>
            </div>
            <!-- Product details-->
            <div class="col-lg-5 pt-0">
              <div class="product-details ml-auto pb-3">
                <div class="d-flex justify-content-between align-items-center mb-2">
                   <span class="d-inline-block font-size-sm align-middle px-2 bg-primary text-light">On Special</span>
                  <button class="btn-wishlist mr-0 mr-lg-n3" type="button" data-toggle="tooltip" title="Add to wishlist"><i class="fa fa-heart fa-circle"></i></button>
                </div>
                <div class="mb-3"><span class="text-small text-muted">product: </span><span class="h4 font-weight-normal text-large text-accent mr-1">1812</span>
                </div>
                <div class="mb-3 font-weight-light font-size-small text-muted">
                  After finding the item they want and clicking the box to go to the product detail page, that page should be configured to the item that was clicked back on the product listing page. AKA, Click on Gardall 1812-G-E, should be brought to the 1812 series page with a grey safe w/ electronic lock already configured.
                </div>
                <form class="mb-grid-gutter" method="post">
                  <div class="form-group">
                    <div class="d-flex justify-content-between align-items-center pb-1">
                      <label class="font-weight-medium" for="product-size">Finish & Lock Type</label>
                    </div>
                    <select class="custom-select" required id="product-size">
                      <option value="">Select size</option>
                      <option value="xs">XS</option>
                      <option value="s">S</option>
                      <option value="m">M</option>
                      <option value="l">L</option>
                      <option value="xl">XL</option>
                    </select>
                  </div>
                  <div class="mb-3">
                    <span class="h4 text-accent font-weight-light">$48.00</span> <span class="font-size-sm ml-1">$59.95 list</span>
                  </div>
                  <div class="form-group d-flex align-items-center">
                    <select class="custom-select mr-3" style="width: 5rem;">
                      <option value="1">1</option>
                      <option value="2">2</option>
                      <option value="3">3</option>
                      <option value="4">4</option>
                      <option value="5">5</option>
                    </select>
                    <button class="btn btn-primary btn-shadow btn-block" type="submit"><i class="fa fa-shopping-cart font-size-lg mr-2"></i>Add to Cart</button>
                  </div>
                </form>
                <!-- Product panels-->
                <div class="accordion mb-4" id="productPanels">
                  <div class="card">
                    <div class="card-header">
                      <h3 class="accordion-heading"><a href="##productInfo" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="productInfo">
                        <i class="fa fa-key font-size-lg align-middle mt-n1 mr-2"></i>
                        Product info<span class="accordion-indicator"><i class="fa fa-chevron-up"></i></span></a></h3>
                    </div>
                    <div class="collapse show" id="productInfo" data-parent="##productPanels">
                      <div class="card-body">
                        <div class="font-size-sm row">
                          <div class="col-6">
                            <ul>
                              <li>Manufacturer:</li>
                              <li>Style:</li>
                              <li>Fire Rated:</li>
                              <li>Safety Rating:</li>
                            </ul>
                          </div>
                          <div class="col-6 text-muted">
                            <ul>
                              <li>Gardall</li>
                              <li>Burgalry/Fire</li>
                              <li>2 hour</li>
                              <li>Residential Security Container (RSC)</li>
                            </ul>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="card">
                    <div class="card-header">
                      <h3 class="accordion-heading"><a class="collapsed" href="##shippingOptions" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="shippingOptions"><i class="fa fa-key align-middle mt-n1 mr-2"></i>Shipping options<span class="accordion-indicator"><i class="fa fa-chevron-up"></i></span></a></h3>
                    </div>
                    <div class="collapse" id="shippingOptions" data-parent="##productPanels">
                      <div class="card-body font-size-sm">
                        <div class="d-flex justify-content-between border-bottom pb-2">
                          <div>
                            <div class="font-weight-semibold text-dark">Courier</div>
                            <div class="font-size-sm text-muted">2 - 4 days</div>
                          </div>
                          <div>$26.50</div>
                        </div>
                        <div class="d-flex justify-content-between border-bottom py-2">
                          <div>
                            <div class="font-weight-semibold text-dark">Local shipping</div>
                            <div class="font-size-sm text-muted">up to one week</div>
                          </div>
                          <div>$10.00</div>
                        </div>
                        <div class="d-flex justify-content-between border-bottom py-2">
                          <div>
                            <div class="font-weight-semibold text-dark">Flat rate</div>
                            <div class="font-size-sm text-muted">5 - 7 days</div>
                          </div>
                          <div>$33.85</div>
                        </div>
                        <div class="d-flex justify-content-between border-bottom py-2">
                          <div>
                            <div class="font-weight-semibold text-dark">UPS ground shipping</div>
                            <div class="font-size-sm text-muted">4 - 6 days</div>
                          </div>
                          <div>$18.00</div>
                        </div>
                        <div class="d-flex justify-content-between pt-2">
                          <div>
                            <div class="font-weight-semibold text-dark">Local pickup from store</div>
                            <div class="font-size-sm text-muted">&mdash;</div>
                          </div>
                          <div>$0.00</div>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="card">
                    <div class="card-header">
                      <h3 class="accordion-heading"><a class="collapsed" href="##localStore" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="localStore"><i class="fa fa-key font-size-lg align-middle mt-n1 mr-2"></i>Find in local store<span class="accordion-indicator"><i class="fa fa-chevron-up"></i></span></a></h3>
                    </div>
                    <div class="collapse" id="localStore" data-parent="##productPanels">
                      <div class="card-body">
                        <select class="custom-select">
                          <option value>Select your country</option>
                          <option value="Argentina">Argentina</option>
                          <option value="Belgium">Belgium</option>
                          <option value="France">France</option>
                          <option value="Germany">Germany</option>
                          <option value="Spain">Spain</option>
                          <option value="UK">United Kingdom</option>
                          <option value="USA">USA</option>
                        </select>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

<!---- start slider ---->
      <div class="bg-light box-shadow-lg rounded-lg px-4 py-3 mb-5 mx-5">
        <div class="px-lg-3">
<div class="product-slider row mt-4">
          
          <!--- start of product tile --->
          <div class="col-md-4 col-sm-6 px-2">
            <div class="card product-card">
              <!--- only display heart when user is logged in --->
              <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
                <i class="far fa-heart"></i>
                <!--- For solid heart (when product has been added to wishlist)
                <i class="far fa-heart"></i> --->
              </button>
              <a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html">
                <img src="#$.getThemePath()#/custom/client/assets/images/product-img-1.png" alt="Product">
              </a>
              <div class="card-body py-2 text-left">
                <a class="product-meta d-block font-size-xs pb-1" href="##">Brand Here</a>
                <h3 class="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div class="product-price">
                  <span class="text-accent">$156.99</span>
                  $209.24 <!--- list price here --->
                </div>
              </div>
            </div>
          </div>
          <!--- end of product tile --->
          
          <!--- start of product tile --->
          <div class="col-md-4 col-sm-6 px-2">
            <div class="card product-card">
              <span class="badge badge-primary">On Special</span>
              <!--- only display heart when user is logged in --->
              <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
                <i class="far fa-heart"></i>
                <!--- For solid heart (when product has been added to wishlist)
                <i class="far fa-heart"></i> --->
              </button>
              <a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html">
                <img src="#$.getThemePath()#/custom/client/assets/images/product-img-2.png" alt="Product">
              </a>
              <div class="card-body py-2 text-left">
                <a class="product-meta d-block font-size-xs pb-1" href="##">Brand Here</a>
                <h3 class="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div class="d-flex justify-content-between">
                  <div class="product-price">
                    <span class="text-accent">$156.99</span>
                    $209.24 <!--- list price here --->
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!--- end of product tile --->
          
          <!--- start of product tile --->
          <div class="col-md-4 col-sm-6 px-2">
            <div class="card product-card">
              <!--- only display heart when user is logged in --->
              <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
                <i class="far fa-heart"></i>
                <!--- For solid heart (when product has been added to wishlist)
                <i class="far fa-heart"></i> --->
              </button>
              <a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html">
                <img src="#$.getThemePath()#/custom/client/assets/images/product-img-3.png" alt="Product">
              </a>
              <div class="card-body py-2 text-left">
                <a class="product-meta d-block font-size-xs pb-1" href="##">Brand Here</a>
                <h3 class="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div class="d-flex justify-content-between">
                  <div class="product-price">
                    <span class="text-accent">$156.99</span>
                    $209.24 <!--- list price here --->
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!--- end of product tile --->
          
          <!--- start of product tile --->
          <div class="col-md-4 col-sm-6 px-2">
            <div class="card product-card">
              <!--- only display heart when user is logged in --->
              <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
                <i class="far fa-heart"></i>
                <!--- For solid heart (when product has been added to wishlist)
                <i class="far fa-heart"></i> --->
              </button>
              
              <a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html">
                <img src="#$.getThemePath()#/custom/client/assets/images/product-img-4.png" alt="Product">
              </a>
              <div class="card-body py-2 text-left">
                <a class="product-meta d-block font-size-xs pb-1" href="##">Brand Here</a>
                <h3 class="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div class="d-flex justify-content-between">
                  <div class="product-price">
                    <span class="text-accent">$156.99</span>
                    $209.24 <!--- list price here --->
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!--- end of product tile --->
          
          <!--- start of product tile --->
          <div class="col-md-4 col-sm-6 px-2">
            <div class="card product-card">
              <!--- only display heart when user is logged in --->
              <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
                <i class="far fa-heart"></i>
                <!--- For solid heart (when product has been added to wishlist)
                <i class="far fa-heart"></i> --->
              </button>
              <a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html">
                <img src="#$.getThemePath()#/custom/client/assets/images/product-img-3.png" alt="Product">
              </a>
              <div class="card-body py-2 text-left">
                <a class="product-meta d-block font-size-xs pb-1" href="##">Brand Here</a>
                <h3 class="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div class="d-flex justify-content-between">
                  <div class="product-price">
                    <span class="text-accent">$156.99</span>
                    $209.24 <!--- list price here --->
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!--- end of product tile --->
          
        </div>
<!---- end slider ---->

</div>
</div>
</div>

<cfinclude template="_slatwall-footer.cfm" />
</cfoutput>

