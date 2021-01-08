<cfimport prefix="swc" taglib="../tags" />
<cfinclude template="inc/header/header.cfm" />

<cfoutput>
  <!--- Hero slider --->
  <div class="hero mt-2" style="background-image: url(#$.getThemePath()#/custom/client/assets/images/main-bg-img.jpg);">
    <!--- Featured Products --->
    <div class="container">
      <div class="featured-products bg-white text-center pb-5 pt-5">
        <h3 class="h3 mb-0">Featured Products</h3>
        <a href="##" class="text-link">Shop All Specials</a>
        
        <div class="featured-slider row mt-4">
          
          <!--- start of product tile --->
          <div class="col-md-4 col-sm-6 px-2">
            <div class="card product-card">
              <!--- only display heart when user is logged in --->
              <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
                <i class="far fa-heart"></i>
                <!--- For solid heart (when product has been added to wishlist)
                <i class="far fa-heart"></i> --->
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
                  $209.24 <!--- list price here --->
                </div>
              </div>
            </div>
          </div>
          <!--- end of product tile --->
          
          <!--- start of product tile --->
          <div class="col-md-4 col-sm-6 px-2">
            <div class="card product-card">
              <span class="badge badge-primary">On Special</span>
              <!--- only display heart when user is logged in --->
              <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
                <i class="far fa-heart"></i>
                <!--- For solid heart (when product has been added to wishlist)
                <i class="far fa-heart"></i> --->
              </button>
              <a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html">
                <img src="#$.getThemePath()#/custom/client/assets/images/product-img-2.png" alt="Product">
              </a>
              <div class="card-body py-2 text-left">
                <a class="product-meta d-block font-size-xs pb-1" href="##">Brand Here</a>
                <h3 class="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div class="d-flex justify-content-between">
                  <div class="product-price">
                    <span class="text-accent">$156.99</span>
                    $209.24 <!--- list price here --->
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!--- end of product tile --->
          
          <!--- start of product tile --->
          <div class="col-md-4 col-sm-6 px-2">
            <div class="card product-card">
              <!--- only display heart when user is logged in --->
              <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
                <i class="far fa-heart"></i>
                <!--- For solid heart (when product has been added to wishlist)
                <i class="far fa-heart"></i> --->
              </button>
              <a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html">
                <img src="#$.getThemePath()#/custom/client/assets/images/product-img-3.png" alt="Product">
              </a>
              <div class="card-body py-2 text-left">
                <a class="product-meta d-block font-size-xs pb-1" href="##">Brand Here</a>
                <h3 class="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div class="d-flex justify-content-between">
                  <div class="product-price">
                    <span class="text-accent">$156.99</span>
                    $209.24 <!--- list price here --->
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!--- end of product tile --->
          
          <!--- start of product tile --->
          <div class="col-md-4 col-sm-6 px-2">
            <div class="card product-card">
              <!--- only display heart when user is logged in --->
              <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
                <i class="far fa-heart"></i>
                <!--- For solid heart (when product has been added to wishlist)
                <i class="far fa-heart"></i> --->
              </button>
              
              <a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html">
                <img src="#$.getThemePath()#/custom/client/assets/images/product-img-4.png" alt="Product">
              </a>
              <div class="card-body py-2 text-left">
                <a class="product-meta d-block font-size-xs pb-1" href="##">Brand Here</a>
                <h3 class="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div class="d-flex justify-content-between">
                  <div class="product-price">
                    <span class="text-accent">$156.99</span>
                    $209.24 <!--- list price here --->
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!--- end of product tile --->
          
          <!--- start of product tile --->
          <div class="col-md-4 col-sm-6 px-2">
            <div class="card product-card">
              <!--- only display heart when user is logged in --->
              <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="" data-original-title="Add to wishlist">
                <i class="far fa-heart"></i>
                <!--- For solid heart (when product has been added to wishlist)
                <i class="far fa-heart"></i> --->
              </button>
              <a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html">
                <img src="#$.getThemePath()#/custom/client/assets/images/product-img-3.png" alt="Product">
              </a>
              <div class="card-body py-2 text-left">
                <a class="product-meta d-block font-size-xs pb-1" href="##">Brand Here</a>
                <h3 class="product-title font-size-sm">
                  <a href="shop-single-v1.html">Product Title Here</a>
                </h3>
                <div class="d-flex justify-content-between">
                  <div class="product-price">
                    <span class="text-accent">$156.99</span>
                    $209.24 <!--- list price here --->
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!--- end of product tile --->
          
        </div>
      </div>
    </div>
    
    <div class="container">
      <div class="main-banner text-white text-center mr-5 ml-5">
        <div class="main-slider slider-dark">
          <cfset local.homeMainBanner = $.slatwall.getService('contentService').getContentCollectionList()>
          <cfset local.homeMainBanner.setDisplayProperties('site.siteCode,contentID,urlTitle,title,sortOrder,customBody,linkUrl,linkLabel')>
          <cfset local.homeMainBanner.addFilter("site.siteCode",$.slatwall.getSite().getSiteCode())>
          <cfset local.homeMainBanner.addFilter("activeFlag", true)>
          <cfset local.homeMainBanner.addFilter("urlTitlePath","%main-banner-slider/%","LIKE")>
          <cfset local.homeMainBanner.addOrderBy("sortOrder|ASC")>
          <cfset local.homeBanner = local.homeMainBanner.getPageRecords()>
          
          <cfloop array="#local.homeBanner#" index="local.slide">
            <div class="repeater">
              <h2 class="h2">#local.slide['title']#</h2>
              #local.slide['customBody']#
              <cfif len(trim(local.slide['linkUrl']))>
                <a href="#local.slide['linkUrl']#" class="btn btn-light btn-long">#local.slide['linkLabel']#</a>
              </cfif>
            </div>
          </cfloop>
          
        </div>
      </div>
    </div>
    
  </div>
  
  <!--- Content Columns --->
  <div class="container">
    <div class="row text-center mt-5 mb-5">
      <cfset local.homeContentColumns = $.slatwall.getService('contentService').getContentCollectionList()>
      <cfset local.homeContentColumns.setDisplayProperties('site.siteCode,contentID,urlTitle,title,sortOrder,customBody,associatedImage')>
      <cfset local.homeContentColumns.addFilter("site.siteCode",$.slatwall.getSite().getSiteCode())>
      <cfset local.homeContentColumns.addFilter("activeFlag", true)>
      <cfset local.homeContentColumns.addFilter("urlTitlePath","%content-columns/%","LIKE")>
      <cfset local.homeContentColumns.addOrderBy("sortOrder|ASC")>
      <cfset local.homeContent = local.homeContentColumns.getPageRecords()>
      
      <cfloop array="#local.homeContent#" index="local.contentColumn">
        <div class="col-md">
          <cfset local.contentImage = "/custom/assets/files/associatedimage/#local.contentColumn['associatedImage']#">
          <img class="mb-3" src="#local.contentImage#" alt="" />
          <h3 class="h3">#local.contentColumn['title']#</h3>
          #local.contentColumn['customBody']#
        </div>
      </cfloop>

    </div>
  </div>
  
  <!--- Brand Slider --->
  <div class="home-brand container-slider container py-lg-4 mb-4 mt-4 text-center">
    <h3 class="h3">#$.renderContent($.getContentByUrlTitlePath('home/shop-by').getContentID(), 'title')#</h3>
    
    <div class="brand-slider">
      <cfset local.homeBrands = $.slatwall.getService('contentService').getContentCollectionList()>
      <cfset local.homeBrands.setDisplayProperties('site.siteCode,contentID,urlTitle,title,sortOrder,linkUrl,associatedImage')>
      <cfset local.homeBrands.addFilter("site.siteCode",$.slatwall.getSite().getSiteCode())>
      <cfset local.homeBrands.addFilter("activeFlag", true)>
      <cfset local.homeBrands.addFilter("urlTitlePath","%shop-by/%","LIKE")>
      <cfset local.homeBrands.addOrderBy("sortOrder|ASC")>
      <cfset local.homeBrand = local.homeBrands.getPageRecords()>
      
      <cfloop array="#local.homeBrand#" index="local.brand">
        <div class="repeater">
          <div class="brand-box bg-white box-shadow-sm rounded-lg m-3">
            <a class="d-block p-4" href="#local.brand['linkUrl']#">
              <cfset local.brandLogo = "/custom/assets/files/associatedimage/#local.brand['associatedImage']#">
              <img class="d-block mx-auto" src="#local.brandLogo#" alt="#local.brand['title']#">
            </a>
          </div>
        </div>
      </cfloop>
    </div>
    
    <a class="btn btn-primary mt-3 btn-long" href="#$.renderContent($.getContentByUrlTitlePath('home/shop-by').getContentID(), 'linkUrl')#">More Brands</a>
  </div>
  
  <script>
    window.__STATE = #$.getStackedContent({
      'header/main-navigation' : 'customBody',
      'home/shop-by' : ['linkUrl', 'title', 'customBody']
    })#
  </script>

</cfoutput>

<cfinclude template="inc/footer.cfm" />
