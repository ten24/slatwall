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
  <script src="#$.getThemePath()#/custom/client/assets/js/jquery.min.js"></script>
  <script src="#$.getThemePath()#/custom/client/assets/js/bootstrap.min.js"></script>
  <script src="#$.getThemePath()#/custom/client/assets/js/slick.min.js"></script>
  <script src="#$.getThemePath()#/custom/client/assets/js/theme.js"></script>
  <script src="#$.getThemePath()#/custom/client/assets/js/simplebar.min.js"></script>
  <script src="#$.getThemePath()#/custom/swreact/build/js/bundle.js" ></script>
  <script src="#$.getThemePath()#/custom/swreact/build/js/0.chunk.js" ></script>
  <script src="#$.getThemePath()#/custom/swreact/build/js/main.chunk.js" ></script>
<!---   <script src="#$.getThemePath()#/custom/swreact/build/static/js/runtime-main.034396e0.js" ></script> --->
<!---   <script src="#$.getThemePath()#/custom/swreact/build/static/js/2.5b433cb9.chunk.js" ></script> --->
<!---   <script src="#$.getThemePath()#/custom/swreact/build/static/js/main.a8ab5d08.chunk.js" ></script> --->

  </footer>
</body>
</html>

</cfoutput>
