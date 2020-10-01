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
          <li class="breadcrumb-item text-nowrap active" aria-current="page">Categories</li>
        </ol>
      </nav>
    </div>
    <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
      <h1 class="h3 mb-0">Shop Door Hardware</h1>
    </div>
  </div>
</div>

<div class="container pb-5 mb-2 mb-md-4">
  <div class="row">
   <div class="col-12">
     <div class="container pb-4 pb-sm-5">
       <div class="col-md-4 col-sm-6 mb-3">
          <div class="card border-0"><a class="d-block overflow-hidden rounded-lg" href="shop-grid-ls.html"><img class="d-block w-100" src="#$.getThemePath()#/custom/client/assets/images/category-img-1.png" alt="Clothing"></a>
            <div class="card-body">
              <h2 class="h5">Category Title</h2>
              <ul class="list-unstyled font-size-sm mb-0">
                <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="czi-arrow-right-circle mr-2"></i>Blazers &amp; Suits</a><span class="font-size-ms text-muted">235</span></li>
                <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="czi-arrow-right-circle mr-2"></i>Blouse</a><span class="font-size-ms text-muted">410</span></li>
                <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="czi-arrow-right-circle mr-2"></i>Cardigans &amp; Jumpers</a><span class="font-size-ms text-muted">107</span></li>
                <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="czi-arrow-right-circle mr-2"></i>Dresses</a><span class="font-size-ms text-muted">93</span></li>
                <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="czi-arrow-right-circle mr-2"></i>Hoodie &amp; Sweatshirts</a><span class="font-size-ms text-muted">93</span></li>
                <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="czi-arrow-right-circle mr-2"></i>Sportswear</a><span class="font-size-ms text-muted">65</span></li>
                <li>...</li>
                <li>
                  <hr>
                </li>
                <li class="d-flex align-items-center justify-content-between"><a class="nav-link-style" href="##"><i class="czi-arrow-right-circle mr-2"></i>View all</a><span class="font-size-ms text-muted">2,548</span></li>
              </ul>
            </div>
          </div>
        </div>
     </div>
   </div>
  </div>
</div>
</cfoutput>
<cfinclude template="inc/footer.cfm" />
