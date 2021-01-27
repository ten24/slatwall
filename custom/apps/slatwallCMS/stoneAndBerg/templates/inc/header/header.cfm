<cfscript>
    local.productsMainNav = $.slatwall.getService('contentService').getContentCollectionList();
    local.productsMainNav.setDisplayProperties('site.siteCode,contentID,urlTitle,title,sortOrder,customBody,parentContent.contentID,parentContent.urlTitle,parentContent.title,parentContent.linkUrl');
    local.productsMainNav.addFilter("site.siteCode",$.slatwall.getSite().getSiteCode());
    local.productsMainNav.addFilter("activeFlag", true);
    local.productsMainNav.addFilter("urlTitlePath","%productCategories/%","LIKE");
    local.productsMainNav.addFilter("parentContent.urlTitle","productCategories","!=");
    local.productsMainNav.addOrderBy("parentContent.sortOrder|ASC");
    local.productsMainNav.addOrderBy("sortOrder|ASC");
    local.productsMainNav.setPageRecordsShow(100) ;
    local.productCategories = local.productsMainNav.getPageRecords();


</cfscript>


<cfoutput>
<!DOCTYPE html>
<html lang="en-us">
<head>
	<cfinclude template="head.cfm" />
</head>
  
  <!-- Body-->
  <body>
    <!-- Navbar 3 Level (Light)-->

  
 </cfoutput>