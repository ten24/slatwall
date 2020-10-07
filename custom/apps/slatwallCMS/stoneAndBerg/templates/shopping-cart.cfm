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
          <li class="breadcrumb-item text-nowrap"><a href="shop-grid-ls.html">Shop</a></li>
          <li class="breadcrumb-item text-nowrap active" aria-current="page">Cart</li>
        </ol>
      </nav>
    </div>
    <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
      <h1 class="h3 mb-0">Your cart</h1>
    </div>
  </div>
</div>

<div class="container pb-5 mb-2 mb-md-4">
  <div class="row">
    <!-- List of items-->
    <section class="col-lg-8">
      <div class="d-flex justify-content-between align-items-center pt-3 pb-2 pb-sm-5 mt-1">
        <h2 class="h6 mb-0">Products</h2><a class="btn btn-outline-primary btn-sm pl-2" href="shop-grid-ls.html"><i class="far fa-chevron-left"></i> Continue shopping</a>
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
            <input class="form-control" type="number" id="quantity1" value="1">
          </div>
          <button class="btn btn-link px-0 text-danger" type="button"><i class="fal fa-times-circle"></i><span class="font-size-sm"> Remove</span></button>
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
        <div class="pt-2 pt-sm-0 pl-sm-3 mx-auto mx-sm-0 text-center text-sm-left" style="max-width: 9rem;">
          <div class="form-group mb-0">
            <label class="font-weight-medium" for="quantity4">Quantity</label>
            <input class="form-control" type="number" id="quantity4" value="1">
          </div>
          <button class="btn btn-link px-0 text-danger" type="button"><i class="fal fa-times-circle"></i><span class="font-size-sm"> Remove</span></button>
        </div>
      </div>
      <button class="btn btn-outline-accent btn-block" type="button"><i class="far fa-sync-alt"></i> Update cart</button>
    </section>
    
    
    <!-- Sidebar-->
    <aside class="col-lg-4 pt-4 pt-lg-0">
      <div class="cz-sidebar-static rounded-lg box-shadow-lg ml-lg-auto">
        <div class="text-center mb-4 pb-3 border-bottom">
          <h2 class="h6 mb-3 pb-1">Subtotal</h2>
          <h3 class="font-weight-normal">$265.00</h3>
        </div>
        
        <div class="accordion" id="order-options">
          <div class="card">
            <div class="card-header">
              <h3 class="accordion-heading"><a href="##promo-code" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="promo-code">Apply promo code</a></h3>
            </div>
            <div class="collapse show" id="promo-code" data-parent="##order-options">
              <form class="card-body needs-validation" method="post" novalidate="">
                <div class="form-group">
                  <input class="form-control" type="text" placeholder="Promo code" required="">
                  <div class="invalid-feedback">Please provide promo code.</div>
                </div>
                <button class="btn btn-outline-primary btn-block" type="submit">Apply promo code</button>
              </form>
            </div>
          </div>
        </div>
        
        <div class="form-group mb-4 mt-3">
          <label class="mb-2" for="order-comments"><span class="font-weight-medium">Order Notes</span></label>
          <textarea class="form-control" rows="6" id="order-comments"></textarea>
        </div>
        
        <a class="btn btn-primary btn-block mt-4" href="checkout-details.html">Proceed to Checkout</a>
      </div>
    </aside>
  </div>
</div>
</cfoutput>
<cfinclude template="inc/footer.cfm" />
