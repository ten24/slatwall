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
				<a class="step-item active current" href="##">
					<div class="step-progress"><span class="step-count">3</span></div>
					<div class="step-label"><i class="fal fa-credit-card"></i>Payment</div>
				</a>
				<a class="step-item" href="##">
					<div class="step-progress"><span class="step-count">4</span></div>
					<div class="step-label"><i class="fal fa-check-circle"></i>Review</div>
				</a>
			</div>
          
          <!-- Payment Method -->
          <div class="row mb-3">
          	<div class="col-sm-12">
              <div class="form-group">
                <label class="w-100" for="checkout-recieve">Select Your Method of Payment</label>
                <div class="form-check form-check-inline custom-control custom-radio d-inline-flex">
                  <input class="custom-control-input" type="radio" name="inlineRadioOptions" id="card" value="option1" checked>
                  <label class="custom-control-label" for="card">Credit Card</label>
                </div>
                <div class="form-check form-check-inline custom-control custom-radio d-inline-flex">
                  <input class="custom-control-input" type="radio" name="inlineRadioOptions" id="cod" value="option2">
                  <label class="custom-control-label" for="cod">Cash on Delivery</label>
                </div>
                <div class="form-check form-check-inline custom-control custom-radio d-inline-flex">
                  <input class="custom-control-input" type="radio" name="inlineRadioOptions" id="po" value="option2">
                  <label class="custom-control-label" for="po">Purchase Order</label>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Credit Card -->
          <h2 class="h6 pt-1 pb-3 mb-3 border-bottom">Credit Card Information</h2>
          
          <div class="row">
          	<div class="col-sm-6">
              <div class="form-group">
                <label for="checkout-nc">Name on Card</label>
                <input class="form-control" type="text" id="checkout-nc">
              </div>
            </div>
            <div class="col-sm-6">
              <div class="form-group">
                <label for="checkout-cn">Card Number</label>
                <input class="form-control" type="text" id="checkout-cn">
              </div>
            </div>
          </div>
          
          <div class="row">
            <div class="col-sm-6">
              <div class="form-group">
                <label for="checkout-cvv">CVV</label>
                <input class="form-control" type="text" id="checkout-cvv">
              </div>
            </div>
            <div class="col-sm-3">
              <div class="form-group">
					<label for="checkout-expiration-m">Expiration Month</label>
					<select class="form-control custom-select" id="checkout-expiration-m">
						<option value="">Select Month</option>
						<option value="01">01 - JAN</option>
						<option value="02">02 - FEB</option>
						<option value="03">03 - MAR</option>
						<option value="04">04 - APR</option>
						<option value="05">05 - MAY</option>
						<option value="06">06 - JUN</option>
						<option value="07">07 - JUL</option>
						<option value="08">08 - AUG</option>
						<option value="09">09 - SEP</option>
						<option value="10">10 - OCT</option>
						<option value="11">11 - NOV</option>
						<option value="12">12 - DEC</option>
					</select>
				</div>
            </div>
            <div class="col-sm-3">
              <div class="form-group">
					<label for="checkout-expiration-y">Expiration Year</label>
					<select class="form-control custom-select" id="checkout-expiration-y">
						<option value="">Select Year</option>
						<option value="2020">2020</option>
						<option value="2021">2021</option>
						<option value="2022">2022</option>
						<option value="2023">2023</option>
						<option value="2024">2024</option>
						<option value="2025">2025</option>
						<option value="2026">2026</option>
						<option value="2027">2027</option>
						<option value="2028">2028</option>
						<option value="2029">2029</option>
						<option value="2030">2030</option>
					</select>
				</div>
            </div>
          </div>
          
          <!-- Billing Address -->
          <h2 class="h6 pt-1 pb-3 mb-3 border-bottom">Billing Address</h2>

          <div class="custom-control custom-checkbox">
            <input class="custom-control-input" type="checkbox" checked="" id="same-address">
            <label class="custom-control-label" for="same-address">Same as shipping address</label>
          </div>
         
          <!-- Navigation (desktop)-->
          <div class="d-lg-flex pt-4 mt-3">
            <div class="w-50 pr-3"><a class="btn btn-secondary btn-block" href="shop-cart.html"><i class="far fa-chevron-left"></i> <span class="d-none d-sm-inline">Back</span><span class="d-inline d-sm-none">Back</span></a></div>
            <div class="w-50 pl-2"><a class="btn btn-primary btn-block" href="checkout-shipping.html"><span class="d-none d-sm-inline">Save & Continue</span><span class="d-inline d-sm-none">Next</span> <i class="far fa-chevron-right"></i></a></div>
          </div>
        </section>
        <!-- Sidebar-->
        <aside class="col-lg-4 pt-4 pt-lg-0">
          <div class="cz-sidebar-static rounded-lg box-shadow-lg ml-lg-auto">
          	<div class="alert alert-success alert-wicon" role="alert">
          		<i class="fal fa-usd-circle"></i>
          		You're only $13.03 away from recieving <strong>free freight</strong> on your order!
          	</div>
            <div class="widget mb-3">
              <h2 class="widget-title text-center">Order summary</h2>
            </div>
            <ul class="list-unstyled font-size-sm pb-2 border-bottom">
              <li class="d-flex justify-content-between align-items-center"><span class="mr-2">Subtotal:</span><span class="text-right">$265.00</span></li>
              <li class="d-flex justify-content-between align-items-center"><span class="mr-2">Shipping:</span><span class="text-right">--</span></li>
              <li class="d-flex justify-content-between align-items-center"><span class="mr-2">Taxes:</span><span class="text-right">$9.00</span></li>
              <li class="d-flex justify-content-between align-items-center"><span class="mr-2">Discount:</span><span class="text-right">--</span></li>
            </ul>
            <h3 class="font-weight-normal text-center my-4">$274.<small>50</small></h3>
            <form class="needs-validation" method="post" novalidate="">
              <div class="form-group">
                <input class="form-control" type="text" placeholder="Promo code" required="">
                <div class="invalid-feedback">Please provide promo code.</div>
              </div>
              <button class="btn btn-outline-primary btn-block" type="submit">Apply promo code</button>
            </form>
          </div>
        </aside>
      </div>
      
    </div>
</cfoutput>
<cfinclude template="inc/footer.cfm" />