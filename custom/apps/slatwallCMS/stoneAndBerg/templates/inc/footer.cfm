<cfscript>
    local.isContact = $.slatwall.getContent().getUrlTitlePath() NEQ "contact";
    local.contactUs = EncodeForHTMLAttribute($.renderContent($.getContentByUrlTitlePath('footer/contact-us').getContentID(), 'customBody'));
    local.getInTouch = EncodeForHTMLAttribute($.renderContent($.getContentByUrlTitlePath('footer/get-in-touch').getContentID(), 'customBody'));
    local.siteLinks = EncodeForHTMLAttribute($.renderContent($.getContentByUrlTitlePath('footer/site-links').getContentID(), 'customBody'));
    local.stayInformed = EncodeForHTMLAttribute($.renderContent($.getContentByUrlTitlePath('footer/stay-informed').getContentID(), 'customBody'));
    local.copywriteDate =  #year(now())#;

</cfscript>
<cfoutput>
<!--- Footer--->
<div id="reactFooter"
 data-isContact=#local.isContact#
 data-contactUs=#local.contactUs#
 data-getInTouch=#local.getInTouch#
 data-siteLinks=#local.siteLinks#
 data-stayInformed=#local.stayInformed#
 data-copywriteDate=#local.copywriteDate# 
 ></div>
  
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
