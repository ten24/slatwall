<cfinclude template="inc/header/header.cfm" />

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../tags" />

<cfoutput>
	
	<div class="page-title-overlap bg-lightgray pt-4">
      <div class="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div class="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb breadcrumb-dark flex-lg-nowrap justify-content-center justify-content-lg-start">
              <li class="breadcrumb-item"><a class="text-nowrap" href="index.html"><i class="far fa-home"></i>Home</a></li>
              <li class="breadcrumb-item text-nowrap"><a href="shop-grid-ls.html">Shop</a>
              </li>
              <li class="breadcrumb-item text-nowrap active" aria-current="page">Checkout</li>
            </ol>
          </nav>
        </div>
        <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 class="h3 mb-0">Checkout</h1>
        </div>
      </div>
    </div>
    
    <div class="container pb-5 mb-2 mb-md-4">
      <div class="row">
        <section class="col-lg-8">
          <!-- Steps-->
          <div class="steps steps-dark pt-2 pb-3 mb-5">
            <a class="step-item active" href="/shopping-cart">
              <div class="step-progress"><span class="step-count">1</span></div>
              <div class="step-label"><i class="fal fa-shopping-cart"></i>Cart</div>
            </a>
            <a class="step-item active" href="##">
              <div class="step-progress"><span class="step-count">2</span></div>
              <div class="step-label"><i class="fal fa-shipping-fast"></i>Shipping</div>
            </a>
            <a class="step-item active" href="##">
              <div class="step-progress"><span class="step-count">3</span></div>
              <div class="step-label"><i class="fal fa-credit-card"></i>Payment</div>
            </a>
            <a class="step-item active current" href="##">
              <div class="step-progress"><span class="step-count">4</span></div>
              <div class="step-label"><i class="fal fa-check-circle"></i>Review</div>
            </a>
          </div>
          
			<div class="row bg-lightgray pt-3 pr-3 pl-3 rounded mb-5">
				<div class="col-md-4">
					<h3 class="h6">Shipping Address:</h3>
					<p>
						<em>Address Nickname</em><br />
						Name <br />
						Street Address <br />
						City, State Zip
					</p>
				</div>
				<div class="col-md-4">
					<h3 class="h6">Billing Address:</h3>
					<p>
						<em>Address Nickname</em><br />
						Name <br />
						Street Address <br />
						City, State Zip
					</p>
				</div>
				<div class="col-md-4">
					<h3 class="h6">Payment Method:</h3>
					<p>
						<em>method of payment</em><br />
						Name <br />
						Vias ending in x1234
					</p>
				</div>
			</div>
          
          <!-- Order Items -->
          <h2 class="h6 pt-1 pb-3 mb-3 border-bottom">Review your order</h2>
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
	        <div class="pt-2 pt-sm-0 pl-sm-3 mx-auto mx-sm-0 text-center text-sm-right" style="max-width: 9rem;">
              <p class="mb-0"><span class="text-muted font-size-sm">Quantity:</span><span>&nbsp;1</span></p>
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
	        <div class="p-2 border rounded mx-auto mx-sm-0 text-center" style="max-width: 15rem;">
	          <i class="fal fa-exclamation-circle"></i>
	          <p class="text-sm mb-0">This item is on backorder. Lorem ipsum dolor sit amet elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco.</p>
	        </div>
	        <div class="pt-2 pt-sm-0 pl-sm-3 mx-auto mx-sm-0 text-center text-sm-right" style="max-width: 9rem;">
              <p class="mb-0"><span class="text-muted font-size-sm">Quantity:</span><span>&nbsp;1</span></p>
            </div>
	      </div>
            
          <!-- Navigation (desktop)-->
          <div class="d-lg-flex pt-4 mt-3">
            <div class="w-50 pr-3"><a class="btn btn-secondary btn-block" href="shop-cart.html"><i class="far fa-chevron-left"></i> <span class="d-none d-sm-inline">Back</span><span class="d-inline d-sm-none">Back</span></a></div>
            <div class="w-50 pl-2"><a class="btn btn-primary btn-block" href="checkout-shipping.html"><span class="d-none d-sm-inline">Complete Order</span><span class="d-inline d-sm-none">Finish</span> <i class="far fa-chevron-right"></i></a></div>
          </div>
        </section>
        <!-- Sidebar-->
        <aside class="col-lg-4 pt-4 pt-lg-0">
          <div class="cz-sidebar-static rounded-lg box-shadow-lg ml-lg-auto">
            <div class="widget mb-3">
              <h2 class="widget-title text-center">Order summary</h2>
            </div>
            <ul class="list-unstyled font-size-sm pb-2 border-bottom">
              <li class="d-flex justify-content-between align-items-center"><span class="mr-2">Subtotal:</span><span class="text-right">$265.00</span></li>
              <li class="d-flex justify-content-between align-items-center"><span class="mr-2">Shipping:</span><span class="text-right">$8.50</span></li>
              <li class="d-flex justify-content-between align-items-center"><span class="mr-2">Taxes:</span><span class="text-right">$9.00</span></li>
            </ul>
            <h3 class="font-weight-normal text-center my-4">$274.<small>50</small></h3>
            <a class="btn btn-primary btn-block" href="##">Complete Order</a>
          </div>
        </aside>
      </div>
      
    </div>
</cfoutput>
<cfinclude template="inc/footer.cfm" />