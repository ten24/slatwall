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
              <li class="breadcrumb-item text-nowrap active" aria-current="page">Favorites</li>
            </ol>
          </nav>
        </div>
        <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 class="h3 mb-0">My Favorites</h1>
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
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-shopping-bag pr-2"></i> Order History</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-user pr-2"></i> Profile Info</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3 active" href="##"><i class="far fa-heart pr-2"></i> Favorties</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-map-marker-alt pr-2"></i> Addresses</a></li>
              <li class="mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-credit-card pr-2"></i> Payment Methods</a></li>
            </ul>
          </div>
        </aside>
        
        <!-- Content  -->
        <section class="col-lg-8">
          
          <!-- Toolbar-->
          <div class="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
            <div class="d-flex justify-content-between w-100">
              &nbsp;
            </div>
          </div>
          
          <div class="row mx-n2">
            <!--- start of product tile --->
            <div class="col-md-4 col-sm-6 p-2">
              <div class="card product-card">
                <!--- only display heart when user is logged in --->
                <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Remove from favorites">
                  <i class="fas fa-heart"></i>
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
                    $209.24 list <!--- list price here --->
                  </div>
                </div>
              </div>
            </div>
            <!--- end of product tile --->
            
            <!--- start of product tile --->
            <div class="col-md-4 col-sm-6 p-2">
              <div class="card product-card">
                <!--- only display heart when user is logged in --->
                <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Remove from favorites">
                  <i class="fas fa-heart"></i>
                </button>
                <a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html">
                  <img src="#$.getThemePath()#/custom/client/assets/images/product-img-2.png" alt="Product">
                </a>
                <div class="card-body py-2 text-left">
                  <a class="product-meta d-block font-size-xs pb-1" href="##">Brand Here</a>
                  <h3 class="product-title font-size-sm">
                    <a href="shop-single-v1.html">Product Title Here</a>
                  </h3>
                  <div class="product-price">
                    <span class="text-accent">$156.99</span>
                    $209.24 list <!--- list price here --->
                  </div>
                </div>
              </div>
            </div>
            <!--- end of product tile --->
            
            <!--- start of product tile --->
            <div class="col-md-4 col-sm-6 p-2">
              <div class="card product-card">
                <!--- only display heart when user is logged in --->
                <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Remove from favorites">
                  <i class="fas fa-heart"></i>
                </button>
                <a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html">
                  <img src="#$.getThemePath()#/custom/client/assets/images/product-img-3.png" alt="Product">
                </a>
                <div class="card-body py-2 text-left">
                  <a class="product-meta d-block font-size-xs pb-1" href="##">Brand Here</a>
                  <h3 class="product-title font-size-sm">
                    <a href="shop-single-v1.html">Product Title Here</a>
                  </h3>
                  <div class="product-price">
                    <span class="text-accent">$156.99</span>
                    $209.24 list <!--- list price here --->
                  </div>
                </div>
              </div>
            </div>
            <!--- end of product tile --->
            
            <!--- start of product tile --->
            <div class="col-md-4 col-sm-6 p-2">
              <div class="card product-card">
                <!--- only display heart when user is logged in --->
                <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Remove from favorites">
                  <i class="fas fa-heart"></i>
                </button>
                <a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html">
                  <img src="#$.getThemePath()#/custom/client/assets/images/product-img-4.png" alt="Product">
                </a>
                <div class="card-body py-2 text-left">
                  <a class="product-meta d-block font-size-xs pb-1" href="##">Brand Here</a>
                  <h3 class="product-title font-size-sm">
                    <a href="shop-single-v1.html">Product Title Here</a>
                  </h3>
                  <div class="product-price">
                    <span class="text-accent">$156.99</span>
                    $209.24 list <!--- list price here --->
                  </div>
                </div>
              </div>
            </div>
            <!--- end of product tile --->

            
          </div> <!--- end of .row --->
         
          <!--- rule line --->
          <hr class="mb-4 mt-4">
          
          <!--- Pagination --->
          <nav class="d-flex justify-content-between pt-2" aria-label="Page navigation">
            <ul class="pagination">
              <li class="page-item"><a class="page-link" href="##"><i class="far fa-chevron-left mr-2"></i> Prev</a></li>
            </ul>
            <ul class="pagination">
              <li class="page-item d-sm-none"><span class="page-link page-link-static">1 / 5</span></li>
              <li class="page-item active d-none d-sm-block" aria-current="page"><span class="page-link">1<span class="sr-only">(current)</span></span></li>
              <li class="page-item d-none d-sm-block"><a class="page-link" href="##">2</a></li>
              <li class="page-item d-none d-sm-block"><a class="page-link" href="##">3</a></li>
              <li class="page-item d-none d-sm-block"><a class="page-link" href="##">4</a></li>
              <li class="page-item d-none d-sm-block"><a class="page-link" href="##">5</a></li>
            </ul>
            <ul class="pagination">
              <li class="page-item"><a class="page-link" href="##" aria-label="Next">Next <i class="far fa-chevron-right ml-2"></i></a></li>
            </ul>
          </nav>
        </section> <!--- end of .col-lg-8 --->
      </div>
    </div>
    
</cfoutput>
<cfinclude template="inc/footer.cfm" />