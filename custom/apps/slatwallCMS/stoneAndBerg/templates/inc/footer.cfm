<cfscript>

    local.site["siteID"] = $.slatwall.getCurrentRequestSite().getSiteID()
    local.site["siteCode"] = $.slatwall.getCurrentRequestSite().getSiteCode()
    local.site["siteName"] = $.slatwall.getCurrentRequestSite().getSiteName()
    local.site["hibachiInstanceApplicationScopeKey"] = $.slatwall.getCurrentRequestSite().getHibachiInstanceApplicationScopeKey()
    local.site["hibachiConfig"] = $.slatwall.getHibachiConfig()
    local.router["globalURLKeyProduct"] = {
      "URLKey": $.slatwall.setting('globalURLKeyProduct'),
      "URLKeyType": 'Product' }
    local.router["globalURLKeyProductType"] = {
      "URLKey": $.slatwall.setting('globalURLKeyProductType'),
      "URLKeyType": 'ProductType' }
    local.router["globalURLKeyCategory"] = {
      "URLKey": $.slatwall.setting('globalURLKeyCategory'),
      "URLKeyType": 'Category' }
    local.router["globalURLKeyBrand"] = {
      "URLKey": $.slatwall.setting('globalURLKeyBrand'),
      "URLKeyType": 'Brand' }
    local.router["globalURLKeyAccount"] = {
      "URLKey": $.slatwall.setting('globalURLKeyAccount'),
      "URLKeyType": 'Account' }
    local.router["globalURLKeyAddress"] = {
      "URLKey": $.slatwall.setting('globalURLKeyAddress'),
      "URLKeyType": 'Address' }
    local.router["globalURLKeyAttribute"] = {
      "URLKey": $.slatwall.setting('globalURLKeyAttribute'),
      "URLKeyType": 'Attribute' }
      
</cfscript>
<cfoutput>
<script>
        window.__SDK_URL__ = 'https://stoneandberg-admin.ten24dev.com/index.cfm/';
        window.__PRELOADED_STATE__ = JSON.stringify({
          preload: {
            site: #serializeJson( local.site)#,
            router: #serializeJson( local.router)#,
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
