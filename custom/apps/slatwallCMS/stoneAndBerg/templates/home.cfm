<cfinclude template="inc/header/header.cfm" />
<cfscript>

           local.homeMainBanner = $.slatwall.getService('contentService').getContentCollectionList()
           local.homeMainBanner.setDisplayProperties('site.siteCode,contentID,urlTitle,title,sortOrder,customBody,linkUrl,linkLabel')
           local.homeMainBanner.addFilter("site.siteCode",$.slatwall.getSite().getSiteCode())
           local.homeMainBanner.addFilter("activeFlag", true)
           local.homeMainBanner.addFilter("urlTitlePath","%main-banner-slider/%","LIKE")
           local.homeMainBanner.addOrderBy("sortOrder|ASC")
           local.homeBanner = getHibachiScope().hibachiHTMLEditFormat(serializeJson(local.homeMainBanner.getPageRecords()))

      local.homeContentColumns = $.slatwall.getService('contentService').getContentCollectionList()
       local.homeContentColumns.setDisplayProperties('site.siteCode,contentID,urlTitle,title,sortOrder,customBody,associatedImage')
       local.homeContentColumns.addFilter("site.siteCode",$.slatwall.getSite().getSiteCode())
       local.homeContentColumns.addFilter("activeFlag", true)
       local.homeContentColumns.addFilter("urlTitlePath","%content-columns/%","LIKE")
       local.homeContentColumns.addOrderBy("sortOrder|ASC")
    local.homeContent = getHibachiScope().hibachiHTMLEditFormat(serializeJson(local.homeContentColumns.getPageRecords()))


       local.homeBrands = $.slatwall.getService('contentService').getContentCollectionList()
       local.homeBrands.setDisplayProperties('site.siteCode,contentID,urlTitle,title,sortOrder,linkUrl,associatedImage')
       local.homeBrands.addFilter("site.siteCode",$.slatwall.getSite().getSiteCode())
       local.homeBrands.addFilter("activeFlag", true)
       local.homeBrands.addFilter("urlTitlePath","%shop-by/%","LIKE")
       local.homeBrands.addOrderBy("sortOrder|ASC")
       local.homeBrand = getHibachiScope().hibachiHTMLEditFormat(serializeJson(local.homeBrands.getPageRecords()))

       local.shopBy = EncodeForHTMLAttribute($.renderContent($.getContentByUrlTitlePath('home/shop-by').getContentID(), 'linkUrl'));
</cfscript>


<cfoutput>

<div id="reactHome" 
data-featuredSlider='[{"brand": "Brand A", "productTile": "Title 1", "price": "$209.24", "displayPrice": "$156.99", "linkUrl": "/hop-single-v1.html" },{"brand": "Brand A", "productTile": "Title 1", "price": "$209.24", "displayPrice": "$156.99", "linkUrl": "/shop-single-v1.html" },{"brand": "Brand A", "productTile": "Title 1", "price": "$209.24", "displayPrice": "$156.99", "linkUrl": "/shop-single-v1.html" },{"brand": "Brand A", "productTile": "Title 1", "price": "$209.24", "displayPrice": "$156.99", "linkUrl": "/shop-single-v1.html" },{"brand": "Brand A", "productTile": "Title 1", "price": "$209.24", "displayPrice": "$156.99", "linkUrl": "/shop-single-v1.html" },{"brand": "Brand A", "productTile": "Title 1", "price": "$209.24", "displayPrice": "$156.99", "linkUrl": "/shop-single-v1.html" }]'
data-homeMainBanner="#local.homeBanner#"
data-homeContent="#local.homeContent#"
data-homeBrand="#local.homeBrand#"
data-shopBy="#local.shopBy#"
></div>

<cfinclude template="inc/footer.cfm" />
 
</cfoutput>