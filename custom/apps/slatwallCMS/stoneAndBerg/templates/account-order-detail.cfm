<cfinclude template="inc/header/header.cfm" />

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../tags" />

<cfoutput>
	
	<div class="page-title-overlap bg-lightgray pt-4">
      <div class="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div class="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb breadcrumb-dark flex-lg-nowrap justify-content-center justify-content-lg-start">
              <li class="breadcrumb-item"><a class="text-nowrap" href="/"><i class="far fa-home"></i>Home</a></li>
              <li class="breadcrumb-item text-nowrap"><a href="##">Account</a>
              </li>
              <li class="breadcrumb-item text-nowrap active" aria-current="page">Order History</li>
            </ol>
          </nav>
        </div>
        <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 class="h3 mb-0">Order ##4678567</h1>
          <a href="##" class="previous-btn"><i class="far fa-chevron-left"></i>Back to All Orders</a>
        </div>
      </div>
    </div>
    
    <!-- Page Content-->
    <div class="container pb-5 mb-2 mb-md-3">
      <div class="row">
        <!-- Sidebar-->
        <aside class="col-lg-4 pt-4 pt-lg-0">
          <div class="cz-sidebar-static rounded-lg box-shadow-lg px-0 pb-0 mb-5 mb-lg-0">
            <div class="px-4 mb-4">
              <div class="media align-items-center">
                <div class="media-body">
                  <h3 class="font-size-base mb-0">Susan Gardner</h3>
                  <a href="##" class="text-accent font-size-sm">Logout</a>
                </div>
              </div>
            </div>
            <div class="bg-secondary px-4 py-3">
              <h3 class="font-size-sm mb-0 text-muted">Overview</h3>
            </div>
            <ul class="list-unstyled mb-0">
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3 active" href="##"><i class="far fa-shopping-bag pr-2"></i> Order History</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-user pr-2"></i> Profile Info</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-heart pr-2"></i> Favorties</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-map-marker-alt pr-2"></i> Addresses</a></li>
              <li class="mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-credit-card pr-2"></i> Payment Methods</a></li>
            </ul>
          </div>
          
          <div class="px-0 pb-0 mr-5 mt-5 mb-lg-0 text-center mb-5">
            <h6>Have a question about this order?</h6>
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.</p>
            <a href="/contact">Contact Us</a>
          </div>
        </aside>
        
        <!-- Content  -->
        <section class="col-lg-8 order-detail">
          <!-- Toolbar-->
          <div class="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5">
            <div class="row justify-content-between w-100 align-items-center">
              <div class="col-sm-6">
                Status <span class="badge badge-success m-0 p-2 ml-2">Delivered</span>
              </div>
              <div class="col-sm-6">
                <div class="row justify-content-end">
                  <div class="mr-3">
                    <a href="##" class="btn btn-outline-secondary"><i class="far fa-box-full mr-2"></i> Request RMA</a>
                  </div>
                  <div>
                    <a href="##" class="btn btn-outline-secondary"><i class="far fa-print mr-2"></i> Print</a>
                  </div>
                </div>
              </div>
            </div>
          </div> <!--- end of toolbar --->
          
          <div class="d-flex justify-content-between mb-4 mr-3">
            <a href="##" class="previous-btn"><i class="far fa-chevron-left"></i>Previous Order</a>
            <a href="##" class="next-btn">Next Order<i class="far fa-chevron-right"></i></a>
          </div>
          
          <!--- Order Details --->
          <div class="row align-items-start mb-5 mr-3">
            <div class="col-md-7">
              <div class="row">
                <div class="col-6">
                  <h3 class="h6">Shipping Address</h3>
                  <p class="text-sm">Jane Doe<br />
                  Business Name<br />
                  1234 Main Street<br />
                  Pleasentville, NY 12345</p>
                  
                  <h3 class="h6">PO Number</h3>
                  <p class="text-sm">572957420</p>
                  
                  <h3 class="h6">Date Placed</h3>
                  <p class="text-sm">2/24/2020</p>
                </div>
                <div class="col-6">
                  <h3 class="h6">Billing Address</h3>
                  <p class="text-sm">Jane Doe<br />
                  Business Name<br />
                  1234 Main Street<br />
                  Pleasentville, NY 12345</p>
                  
                  <h3 class="h6">Payment Method</h3>
                  <p class="text-sm">Credit Card<br />
                  Visa ending in x4172</p>
                </div>
              </div>
            </div>
            <div class="col-md-5 order-summary border rounded p-3 text-center">
              <h3 class="h6">Order Summary</h3>
              <table class="w-100 text-sm">
                <tr>
                  <td class="text-left">Subtotal:</td>
                  <td class="text-right">$265.00</td>
                </tr>
                <tr>
                  <td class="text-left">Shipping:</td>
                  <td class="text-right">$9.95</td>
                </tr>
                <tr>
                  <td class="text-left">Taxes:</td>
                  <td class="text-right">$8.40</td>
                </tr>
                <tr>
                  <td class="text-left">Handling Fee:</td>
                  <td class="text-right">$4.95</td>
                </tr>
                <tr>
                  <td class="text-left">Discounts:</td>
                  <td class="text-right">- $20.00</td>
                </tr>
              </table>
              <hr class="mb-4 mt-4">
              <span class="order-total h3">$519.99</span>
            </div>
          </div>
          
          <!--- Order Items --->
          <div class="order-items mr-3">
            <div class="shippment mb-5">
              <div class="row order-tracking bg-lightgray p-2">
                <div class="col-sm-6">Shippment 1 of 2</div>
                <div class="col-sm-6 text-right">Tracking Number: <a href="##" target="_blank">583105783025803</a></div>
              </div>
              <!-- Item-->
              <div class="d-sm-flex justify-content-between align-items-center my-4 pb-3 border-bottom">
                <div class="media media-ie-fix d-block d-sm-flex align-items-center text-center text-sm-left"><a class="d-inline-block mx-auto mr-sm-4" href="shop-single-v1.html" style="width: 10rem;"><img src="#$.getThemePath()#/custom/client/assets/images/product-img-2.png" alt="Product"></a>
                  <div class="media-body pt-2">
                    <span class="product-meta d-block font-size-xs pb-1">Product Series</span> <!--- only show this span if part of a bundled product? --->
                    <h3 class="product-title font-size-base mb-2"><a href="shop-single-v1.html">Product Title</a></h3> <!--- product title --->
                    <div class="font-size-sm">Brand Name <span class="text-muted mr-2">sku code</span></div> <!--- brand / sku --->
                    <div class="font-size-sm">$43.99 each <span class="text-muted mr-2">($67.00 list)</span></div> <!--- each / list price --->
                    <div class="font-size-lg text-accent pt-2">$829.83</div> <!--- total --->
                  </div>
                </div>
                <div class="pt-2 pt-sm-0 pl-sm-3 mx-auto mx-sm-0 text-center text-sm-left" style="max-width: 9rem;">
                  <div class="form-group mb-0">
                    <label class="font-weight-medium" for="quantity1">Quantity</label>
                    <span>1</span>
                  </div>
                  <a href="##" class="btn btn-outline-secondary">Re-order</a>
                </div>
              </div>
              
              <!-- Item-->
              <div class="d-sm-flex justify-content-between align-items-center my-4 pb-3 border-bottom">
                <div class="media media-ie-fix d-block d-sm-flex align-items-center text-center text-sm-left"><a class="d-inline-block mx-auto mr-sm-4" href="shop-single-v1.html" style="width: 10rem;"><img src="#$.getThemePath()#/custom/client/assets/images/product-img-1.png" alt="Product"></a>
                  <div class="media-body pt-2">
                    <span class="product-meta d-block font-size-xs pb-1">Product Series</span> <!--- only show this span if part of a bundled product? --->
                    <h3 class="product-title font-size-base mb-2"><a href="shop-single-v1.html">Product Title</a></h3> <!--- product title --->
                    <div class="font-size-sm">Brand Name <span class="text-muted mr-2">sku code</span></div> <!--- brand / sku --->
                    <div class="font-size-sm">$43.99 each <span class="text-muted mr-2">($67.00 list)</span></div> <!--- each / list price --->
                    <div class="font-size-lg text-accent pt-2">$829.83</div> <!--- total --->
                  </div>
                </div>
                <div class="pt-2 pt-sm-0 pl-sm-3 mx-auto mx-sm-0 text-center text-sm-left" style="max-width: 9rem;">
                  <div class="form-group mb-0">
                    <label class="font-weight-medium" for="quantity1">Quantity</label>
                    <span>1</span>
                  </div>
                  <a href="##" class="btn btn-outline-secondary">Re-order</a>
                </div>
              </div>
            </div>
            
            <div class="shippment mb-5">
              <div class="row order-tracking bg-lightgray p-2">
                <div class="col-sm-6">Shippment 2 of 2</div>
                <div class="col-sm-6 text-right">Tracking Number: <a href="##" target="_blank">583105783025803</a></div>
              </div>
              <!-- Item-->
              <div class="d-sm-flex justify-content-between align-items-center my-4 pb-3 border-bottom">
                <div class="media media-ie-fix d-block d-sm-flex align-items-center text-center text-sm-left"><a class="d-inline-block mx-auto mr-sm-4" href="shop-single-v1.html" style="width: 10rem;"><img src="#$.getThemePath()#/custom/client/assets/images/product-img-3.png" alt="Product"></a>
                  <div class="media-body pt-2">
                    <span class="product-meta d-block font-size-xs pb-1">Product Series</span> <!--- only show this span if part of a bundled product? --->
                    <h3 class="product-title font-size-base mb-2"><a href="shop-single-v1.html">Product Title</a></h3> <!--- product title --->
                    <div class="font-size-sm">Brand Name <span class="text-muted mr-2">sku code</span></div> <!--- brand / sku --->
                    <div class="font-size-sm">$43.99 each <span class="text-muted mr-2">($67.00 list)</span></div> <!--- each / list price --->
                    <div class="font-size-lg text-accent pt-2">$829.83</div> <!--- total --->
                  </div>
                </div>
                <div class="pt-2 pt-sm-0 pl-sm-3 mx-auto mx-sm-0 text-center text-sm-left" style="max-width: 9rem;">
                  <div class="form-group mb-0">
                    <label class="font-weight-medium" for="quantity1">Quantity</label>
                    <span>1</span>
                  </div>
                  <a href="##" class="btn btn-outline-secondary">Re-order</a>
                </div>
              </div>
            </div>
            
          </div>
          
        </section>
      </div>
    </div>
    
</cfoutput>
<cfinclude template="inc/footer.cfm" />