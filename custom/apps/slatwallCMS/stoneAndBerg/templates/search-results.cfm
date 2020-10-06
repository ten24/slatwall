<cfimport prefix="swc" taglib="../tags" />
<cfinclude template="inc/header/header.cfm" />

<cfoutput>
<div class="page-title-overlap bg-lightgray pt-4">
  <div class="container d-lg-flex justify-content-between py-2 py-lg-3">
    <div class="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb breadcrumb-dark flex-lg-nowrap justify-content-center justify-content-lg-start">
          <li class="breadcrumb-item"><a class="text-nowrap" href="index.html"><i class="fa fa-home"></i>Home</a></li>
          </li>
          <li class="breadcrumb-item text-nowrap active" aria-current="page">Door Closers & Operators</li>
        </ol>
      </nav>
    </div>
    <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
      <h1 class="h3 text-dark mb-0">Door Closers & Operators</h1>
    </div>
  </div>
</div>
<div class="container pb-5 mb-2 mb-md-4">
  <div class="row">
    <div class="col-md-5">
      <!---- Toolbar ---->
      <div class="d-flex justify-content-center justify-content-sm-between align-items-center pt-2 pb-4 pb-sm-5">
        <div class="d-flex flex-wrap">
          <div class="form-inline flex-nowrap mr-3 mr-sm-4 pb-3 text-dark">
            <span>Your search for "1812" returned <strong>11 Results</strong></span>
          </div>
        </div>
        </div>
        </div>
        <div class="col-md-7">
          <div class="row">
            <div class="col-md-4 d-flex">
               <label class="text-dark opacity-75 text-nowrap mr-2 mt-2 d-none d-sm-block w-25" for="sorting">Sort by:</label>
          <select class="form-control custom-select" id="sorting">
                  <option>Default sort?</option>
                  <option>Popularity</option>
                  <option>Low - Hight Price</option>
                  <option>High - Low Price</option>
                  <option>Average Rating</option>
                  <option>A - Z Order</option>
                  <option>Z - A Order</option>
                </select>
            </div>
            <div class="col-md-8 d-flex">
               <label class="d-none d-sm-block d-md-none w-25" for="searchSearch">Search by:</label>
                <input type="text" class="input-group-overlay form-control text-dark ml-md-3" id="searchSearch" placeholder="Search by brand, product type, product code or title">
            </div>
          </div>
            </div>
        </div>
      <!---- end Toolbar----->

      <!---- Products Grid---->
  <div class="row">

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