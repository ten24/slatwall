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
          <h3>#local.contentColumn['title']#</h3>
          #local.contentColumn['customBody']#
        </div>
      </cfloop>

    </div>
  </div>
  
  <!--- Brand Slider --->
  <div class="container py-lg-4 mb-4">
    <h2 class="h3 text-center pb-4">Shop by brand</h2>
    <div class="row">
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/01.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/02.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/03.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/04.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/05.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/06.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/07.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/08.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/09.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/10.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/11.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/12.png" style="width: 150px;" alt="Brand"></a></div>
    </div>
  </div>

</cfoutput>

<cfinclude template="inc/footer.cfm" />
