<cfscript>
    local.stackedContent = $.getStackedContent({
      'header/main-navigation' : 'customBody',
      'footer/contact-us' : 'customBody',
      'footer/get-in-touch' : 'customBody',
      'footer/site-links' : 'customBody',
      'footer/stay-informed' : 'customBody',
      'home/shop-by' : ['linkUrl', 'title', 'customBody']
    })
    local.stackedContent['header/productCategories'] = #StructKeyExists(local, "productCategories")? local.productCategories : {}#
    local.stackedContent['footer/copywriteDate'] = #year(now())#
</cfscript>
<cfoutput>
<script>
        window.__SDK_URL__ = 'https://stoneandberg-admin.ten24dev.com/index.cfm/';
        window.__PRELOADED_STATE__ = JSON.stringify({
          preload: {
            navigation: #serializeJson(StructKeyExists(local, "navigation")? local.navigation : {})#,
            footer: #serializeJson(StructKeyExists(local, "footer")? local.footer : {})#,
            about: #serializeJson(StructKeyExists(local, "about")? local.about : {})#,
            home: #serializeJson(StructKeyExists(local, "home")? local.home : {})#,
            contact: #serializeJson(StructKeyExists(local, "contact")? local.contact : {})#,
            categoryListing: #serializeJson(StructKeyExists(local, "categoryListing")? local["categoryListing"] : {})#,
            accountOverview: #serializeJson(StructKeyExists(local, "accountOverview")? local["accountOverview"] : {})#,
            accountProfile: #serializeJson(StructKeyExists(local, "accountProfile")? local["accountProfile"] : {})#,
            accountOrderHistory: #serializeJson(StructKeyExists(local, "accountOrderHistory")? local["accountOrderHistory"] : {})#,
            accountFavorites: #serializeJson(StructKeyExists(local, "accountFavorites")? local["accountFavorites"] : {})#,
            accountAddresses: #serializeJson(StructKeyExists(local, "accountAddresses")? local["accountAddresses"] : {})#,
            accountPaymentMethods: #serializeJson(StructKeyExists(local, "accountPaymentMethods")? local["accountPaymentMethods"] : {})#,
            stackedContent: #serializeJson(local.stackedContent)#
          },
          home: {} ,
        }).replace(/</g, '\\u003c')
      </script>
  <!--- JavaScript libraries, plugins and custom scripts--->
  <script
  src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"
  integrity="sha512-bLT0Qm9VnAYZDflyKcBaQ2gg0hSYNQrJ8RilYldYQ1FxQYoCLtUjuuRuZo+fjqhx/qtq/1itJ0C2ejDxltZVFg=="
  crossorigin="anonymous"
></script>
<script
  src="https://cdn.jsdelivr.net/npm/bs-custom-file-input/dist/bs-custom-file-input.min.js"
  crossorigin="anonymous"
></script>
<script src="https://cdn.jsdelivr.net/gh/cferdinandi/smooth-scroll@16.1.3/dist/smooth-scroll.polyfills.min.js"></script>

<cfinclude template="reactFooterAssets.cfm" />
  </footer>
</body>
</html>

</cfoutput>
