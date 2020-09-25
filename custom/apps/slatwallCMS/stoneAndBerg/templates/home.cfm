<cfimport prefix="swc" taglib="../tags" />
<cfinclude template="inc/header/header.cfm" />

<cfoutput>
  
  <!--- Hero slider --->
  <div class="hero" style="background-image: url(#$.getThemePath()#/custom/client/assets/images/main-bg-img.jpg);">
    <!--- Featured Products --->
    <div class="container">
      <div class="featured-products bg-white text-center pb-5 pt-5">
        <h3 class="h3">Featured Products</h3>
        <a href="##" class="text-link">Shop All Specials</a>
        <!--- Featured products slider to go here --->
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

</cfoutput>

<cfinclude template="inc/footer.cfm" />
