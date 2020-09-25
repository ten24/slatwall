<cfimport prefix="swc" taglib="../tags" />
<cfinclude template="inc/header/header.cfm" />

<cfoutput>
  
  <!--- Featured Products --->
  
  <!--- Hero slider --->
  
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
  <div class="home-brand container py-lg-4 mb-4 mt-4 text-center">
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
    
    <a class="btn btn-primary mt-3" href="#$.renderContent($.getContentByUrlTitlePath('home/shop-by').getContentID(), 'linkUrl')#">More Brands</a>
  </div>

</cfoutput>

<cfinclude template="inc/footer.cfm" />
