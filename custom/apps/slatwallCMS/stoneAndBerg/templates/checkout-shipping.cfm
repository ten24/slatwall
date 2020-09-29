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
            <a class="step-item active current" href="##">
              <div class="step-progress"><span class="step-count">2</span></div>
              <div class="step-label"><i class="fal fa-shipping-fast"></i>Shipping</div>
            </a>
            <a class="step-item" href="##">
              <div class="step-progress"><span class="step-count">3</span></div>
              <div class="step-label"><i class="fal fa-credit-card"></i>Payment</div>
            </a>
            <a class="step-item" href="##">
              <div class="step-progress"><span class="step-count">4</span></div>
              <div class="step-label"><i class="fal fa-check-circle"></i>Review</div>
            </a>
          </div>
          
          <div class="row mb-3">
          	<div class="col-sm-12">
              <div class="form-group">
                <label class="w-100" for="checkout-recieve">How do you want to recieve your items?</label>
                <div class="form-check form-check-inline custom-control custom-radio d-inline-flex">
                  <input class="custom-control-input" type="radio" name="inlineRadioOptions" id="ship" value="option1" checked>
                  <label class="custom-control-label" for="ship">Ship my order</label>
                </div>
                <div class="form-check form-check-inline custom-control custom-radio d-inline-flex">
                  <input class="custom-control-input" type="radio" name="inlineRadioOptions" id="pickup" value="option2">
                  <label class="custom-control-label" for="pickup">Pick up my order</label>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Shipping address-->
          <h2 class="h6 pt-1 pb-3 mb-3 border-bottom">Shipping address</h2>
          
            <div class="row">
              <div class="col-sm-6">
                <div class="form-group">
                  <label for="checkout-country">Country</label>
                  <select class="form-control custom-select" id="checkout-country">
                    <option value="">Choose country</option>
                    <option value="CA">Canada</option>
                    <option value="US" selected>USA</option>
                  </select>
                </div>
              </div>
            <div class="col-sm-6">
              <div class="form-group">
                <label for="checkout-n">Name</label>
                <input class="form-control" type="text" id="checkout-n">
              </div>
            </div>
          </div>
          
          <div class="row">
            <div class="col-sm-6">
              <div class="form-group">
                <label for="checkout-address-1">Address 1</label>
                <input class="form-control" type="text" id="checkout-address-1">
              </div>
            </div>
            <div class="col-sm-6">
              <div class="form-group">
                <label for="checkout-address-2">Address 2</label>
                <input class="form-control" type="text" id="checkout-address-2">
              </div>
            </div>
          </div>
          
          <div class="row">
          	<div class="col-sm-6">
              <div class="form-group">
                <label for="checkout-address-1">City</label>
                <input class="form-control" type="text" id="checkout-city">
              </div>
            </div>
            <div class="col-sm-3">
              <div class="form-group">
                <label for="checkout-country">State</label>
                <select class="form-control custom-select" id="checkout-state">
                  <option value="AL">Alabama</option>
                  <option value="AK">Alaska</option>
                  <option value="AZ">Arizona</option>
                  <option value="AR">Arkansas</option>
                  <option value="CA">California</option>
                  <option value="CO">Colorado</option>
                  <option value="CT">Connecticut</option>
                  <option value="DE">Delaware</option>
                  <option value="DC">District Of Columbia</option>
                  <option value="FL">Florida</option>
                  <option value="GA">Georgia</option>
                  <option value="HI">Hawaii</option>
                  <option value="ID">Idaho</option>
                  <option value="IL">Illinois</option>
                  <option value="IN">Indiana</option>
                  <option value="IA">Iowa</option>
                  <option value="KS">Kansas</option>
                  <option value="KY">Kentucky</option>
                  <option value="LA">Louisiana</option>
                  <option value="ME">Maine</option>
                  <option value="MD">Maryland</option>
                  <option value="MA">Massachusetts</option>
                  <option value="MI">Michigan</option>
                  <option value="MN">Minnesota</option>
                  <option value="MS">Mississippi</option>
                  <option value="MO">Missouri</option>
                  <option value="MT">Montana</option>
                  <option value="NE">Nebraska</option>
                  <option value="NV">Nevada</option>
                  <option value="NH">New Hampshire</option>
                  <option value="NJ">New Jersey</option>
                  <option value="NM">New Mexico</option>
                  <option value="NY">New York</option>
                  <option value="NC">North Carolina</option>
                  <option value="ND">North Dakota</option>
                  <option value="OH">Ohio</option>
                  <option value="OK">Oklahoma</option>
                  <option value="OR">Oregon</option>
                  <option value="PA">Pennsylvania</option>
                  <option value="RI">Rhode Island</option>
                  <option value="SC">South Carolina</option>
                  <option value="SD">South Dakota</option>
                  <option value="TN">Tennessee</option>
                  <option value="TX">Texas</option>
                  <option value="UT">Utah</option>
                  <option value="VT">Vermont</option>
                  <option value="VA">Virginia</option>
                  <option value="WA">Washington</option>
                  <option value="WV">West Virginia</option>
                  <option value="WI">Wisconsin</option>
                  <option value="WY">Wyoming</option>
                </select>
              </div>
            </div>
            <div class="col-sm-3">
              <div class="form-group">
                <label for="checkout-zip">ZIP Code</label>
                <input class="form-control" type="text" id="checkout-zip">
              </div>
            </div>
          </div>
          
          <div class="custom-control custom-checkbox">
            <input class="custom-control-input" type="checkbox" checked="" id="save-address">
            <label class="custom-control-label" for="save-address">Save this address</label>
          </div>
          <div class="custom-control custom-checkbox">
            <input class="custom-control-input" type="checkbox" id="blind-ship">
            <label class="custom-control-label" for="blind-ship">Select for blind ship</label>
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