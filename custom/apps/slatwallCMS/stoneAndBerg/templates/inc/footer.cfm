<cfscript>
    local.isContact = $.slatwall.getContent().getUrlTitlePath() NEQ "contact";
    local.contactUs = $.renderContent($.getContentByUrlTitlePath('footer/contact-us').getContentID(), 'customBody');
    local.getInTouch = $.renderContent($.getContentByUrlTitlePath('footer/get-in-touch').getContentID(), 'customBody');
    local.siteLinks = $.renderContent($.getContentByUrlTitlePath('footer/site-links').getContentID(), 'customBody');
    local.stayInformed = $.renderContent($.getContentByUrlTitlePath('footer/stay-informed').getContentID(), 'customBody');
    local.copywriteDate =  #year(now())#;
    
    local.footer = {
      "actionBanner": {
        "display": true,
        "markup": '#reReplace(local.contactUs,"#chr(13)#|#chr(9)#|\n|\r","","ALL")#',
      },
        "getInTouch": '#reReplace(local.getInTouch,"#chr(13)#|#chr(9)#|\n|\r","","ALL")#',
        "siteLinks": '#reReplace(local.siteLinks,"#chr(13)#|#chr(9)#|\n|\r","","ALL")#',
        "stayInformed": '#reReplace(local.stayInformed,"#chr(13)#|#chr(9)#|\n|\r","","ALL")#',
        "copywriteDate": #local.copywriteDate#,
    }
    
    local.userReducer = $.slatwall.getAccount();
    local.userReducer["firstName"] = StructKeyExists(local.userReducer, "firstName") ? local.userReducer : "";
    local.userReducer["lastName"] = StructKeyExists(local.userReducer, "lastName") ? local.userReducer : "";

</cfscript>
<cfoutput>
<script>
 
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
            test: "sdfdf",
          },
          userReducer: #serializeJson(local.userReducer)# ,
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
<!--- 
  <script src="#$.getThemePath()#/custom/swreact/build/js/bundle.js" ></script>
  <script src="#$.getThemePath()#/custom/swreact/build/js/0.chunk.js" ></script>
  <script src="#$.getThemePath()#/custom/swreact/build/js/main.chunk.js" ></script>
  --->
<cfinclude template="reactFooterAssets.cfm" />
  </footer>
</body>
</html>

</cfoutput>
