<cfimport prefix="swc" taglib="../tags" />
<cfinclude template="inc/header/header.cfm" />

<cfoutput>
<div class="page-title-overlap bg-dark pt-4">
  <div class="container d-lg-flex justify-content-between py-2 py-lg-3">
    <div class="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb breadcrumb-light flex-lg-nowrap justify-content-center justify-content-lg-start">
          <li class="breadcrumb-item"><a class="text-nowrap" href="index.html"><i class="fa fa-home"></i>Home</a></li>
          <li class="breadcrumb-item text-nowrap"><a href="##">Shop</a>
          </li>
          <li class="breadcrumb-item text-nowrap active" aria-current="page">Door Closers & Operators</li>
        </ol>
      </nav>
    </div>
    <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
      <h1 class="h3 text-light mb-0">Door Closers & Operators</h1>
    </div>
  </div>
</div>
<div class="container pb-5 mb-2 mb-md-4">
  <div class="row">
    <aside class="col-lg-4">
        <cfinclude template="inc/sidebar.cfm" />
    </aside>
    <div class="col-lg-8">
      <!---- Toolbar ---->
      <div class="d-flex justify-content-center justify-content-sm-between align-items-center pt-2 pb-4 pb-sm-5">
        <div class="d-flex flex-wrap">
          <div class="form-inline flex-nowrap mr-3 mr-sm-4 pb-3">
            Applied Filters: <span>X American Lock </span><span>X Bright Brass</span>
          </div>
        </div>
        <div class="d-flex pb-3"><a class="nav-link-style nav-link-light mr-3" href="##"><i class="fa fa-arrow-left"></i></a><span class="font-size-md text-light">1 / 5</span><a class="nav-link-style nav-link-light ml-3" href="##"><i class="fa fa-arrow-right"></i></a></div>
        <div class="d-none d-sm-flex pb-3">
          <label class="text-light opacity-75 text-nowrap mr-2 mt-2 d-none d-sm-block" for="sorting">Sort by:</label>
          <select class="form-control custom-select" id="sorting">
                  <option>Popularity</option>
                  <option>Low - Hight Price</option>
                  <option>High - Low Price</option>
                  <option>Average Rating</option>
                  <option>A - Z Order</option>
                  <option>Z - A Order</option>
                </select>
        </div>
      </div>
      
      <!---- end Toolbar----->
      
      <!---- Products Grid---->
  <div class="row mx-n2">
   
   <!---- all this is demo loop data, can be replaced by actual loop logic---->
   <cfset local.countVar = 0>
   <cfset local.imgCount = 0>
    <cfloop condition = "CountVar LESS THAN 20"> 
    <cfset local.countVar = local.countVar + 1> 
    <cfif local.imgCount == 4>
      <cfset local.imgCount = 0>  
    </cfif>
    <cfset local.imgCount = local.imgCount +1>
  <!----- end demo loop data----->  
    
    <!---- product start ---->
        <div class="col-md-4 col-sm-6 px-2 mb-4">
          <div class="card product-card">
            <button 
                class="btn-wishlist btn-sm" 
                type="button" 
                data-toggle="tooltip" 
                data-placement="left" 
                title="" 
                data-original-title="Add to wishlist">
                    <i class="fa fa-heart"></i>
            </button>
            <a class="card-img-top d-block overflow-hidden" href="/product-detail"><img src="#$.getThemePath()#/custom/client/assets/images/product-img-#local.imgCount#.png" alt="Product"></a>
          <div class="card-body py-2">
            <a class="product-meta d-block font-size-xs pb-1" href="##">CompX - C8051</a>
            <h3 class="product-title font-size-sm">
              <a href="/product-detail">Cam Locks - 5 Disc Tumbler</a>
            </h3>
            <div class="d-flex justify-content-between">
              <div class="product-price">
                <span class="text-accent">$154.<small>00</small></span> <small>LIST</small>
              </div>
            </div>
          </div>
          <div class="card-body card-body-hidden">
            <button 
              class="btn btn-primary btn-sm btn-block mb-2" 
              type="button" 
              data-toggle="toast" 
              data-target="##cart-toast">
                  <i class="fa fa-shopping-cart font-size-sm mr-1"></i>
                  Add to Cart
            </button>
          </div>
          <hr class="d-sm-none">
        </div>
        </div>
      <!---- product end ---->
  </cfloop>
   

      </div>
      
      
      <!---- end Products Grid ---->
    </div>
  </div>
</div>
</cfoutput>
<cfinclude template="inc/footer.cfm" />
