<cfscript>
    local.stackedContent = $.getStackedContent({
      'header/main-navigation' : 'customBody',
      'footer/contact-us' : 'customBody',
      'footer/get-in-touch' : 'customBody',
      'footer/site-links' : 'customBody',
      'footer/stay-informed' : 'customBody'
    })
    local.stackedContent['header/productCategories'] = #StructKeyExists(local, "productCategories")? local.productCategories : {}#
    local.stackedContent['footer/copywriteDate'] = #year(now())#
    local.site["siteID"] = $.slatwall.getCurrentRequestSite().getSiteID()
    local.site["siteCode"] = $.slatwall.getCurrentRequestSite().getSiteCode()
    local.site["siteName"] = $.slatwall.getCurrentRequestSite().getSiteName()
    local.site["hibachiInstanceApplicationScopeKey"] = $.slatwall.getCurrentRequestSite().getHibachiInstanceApplicationScopeKey()
</cfscript>
<cfoutput>
<script>
        window.__SDK_URL__ = 'https://stoneandberg-admin.ten24dev.com/index.cfm/';
        window.__PRELOADED_STATE__ = JSON.stringify({
          preload: {
            site: #serializeJson( local.site)#,
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
