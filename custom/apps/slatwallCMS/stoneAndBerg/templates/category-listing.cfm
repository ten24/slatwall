<cfinclude template="inc/header/header.cfm" />

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../tags" />

<cfoutput>
<div class="bg-secondary py-4">
  <div class="container d-lg-flex justify-content-between py-2 py-lg-3">
    <div class="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb flex-lg-nowrap justify-content-center justify-content-lg-start">
          <li class="breadcrumb-item"><a class="text-nowrap" href="index.html"><i class="far fa-home"></i>Home</a></li>
          <li class="breadcrumb-item text-nowrap"><a href="##">Products</a>
          </li>
          <li class="breadcrumb-item text-nowrap active" aria-current="page">Door Hardware</li>
        </ol>
      </nav>
    </div>
    <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
      <h1 class="h3 mb-0">Shop Door Hardware</h1>
    </div>
  </div>
</div>

<div class="container pb-4 pb-sm-5">
  <!--- Categories grid --->
  <div class="row pt-5">
    <!--- Catogory --->
    <div class="col-md-4 col-sm-6 mb-3">
      <div class="card border-0"><a class="d-block overflow-hidden rounded-lg" href="shop-grid-ls.html"><img class="d-block w-100" src="#$.getThemePath()#/custom/client/assets/images/category-img-1.png" alt=""></a>
        <div class="card-body">
          <h2 class="h5">Door Closers & Operators</h2>
          <ul class="list-unstyled font-size-sm mb-0">
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>Automatic Operators</a></li>
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>Heavy Duty</a></li>
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>Medium Duty</a></li>
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>Light Duty</a></li>
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>Door Closer Parts</a></li>
          </ul>
        </div>
      </div>
    </div>
    <!--- end of Category --->
    
    <!--- Catogory --->
    <div class="col-md-4 col-sm-6 mb-3">
      <div class="card border-0"><a class="d-block overflow-hidden rounded-lg" href="shop-grid-ls.html"><img class="d-block w-100" src="#$.getThemePath()#/custom/client/assets/images/category-img-2.png" alt=""></a>
        <div class="card-body">
          <h2 class="h5">Storefront Hardware</h2>
          <ul class="list-unstyled font-size-sm mb-0">
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>Deadlatches</a></li>
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>Deadbolts</a></li>
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>Hookbolts</a></li>
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>Paddles/Levers</a></li>
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>Parts & Accessories</a></li>
          </ul>
        </div>
      </div>
    </div>
    <!--- end of Category --->
    
    <!--- Catogory --->
    <div class="col-md-4 col-sm-6 mb-3">
      <div class="card border-0"><a class="d-block overflow-hidden rounded-lg" href="shop-grid-ls.html"><img class="d-block w-100" src="#$.getThemePath()#/custom/client/assets/images/category-img-3.png" alt=""></a>
        <div class="card-body">
          <h2 class="h5">Electric Strikes</h2>
          <ul class="list-unstyled font-size-sm mb-0">
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>Surface Mount Style</a></li>
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>In-Frame Style</a></li>
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>For Rim Exits</a></li>
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>For Cylindrical Locksets</a></li>
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>For Mortise Locks</a></li>
            <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="far fa-chevron-circle-right pr-2"></i>Fire Rated</a></li>
          </ul>
        </div>
      </div>
    </div>
    <!--- end of Category --->

  </div>
</div>
</cfoutput>
<cfinclude template="inc/footer.cfm" />
