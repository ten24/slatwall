<cfscript>
    local.myDateTime = now();
</cfscript>
<cfoutput>

<!--- Footer--->
  <footer class="pt-5">
    <div class="bg-primary p-5">
     <div class="container">
      <div class="row">
        <div class="col-0 col-md-2"></div>
        <div class="col-md-8 text-center">
         	#$.renderContent($.getContentByUrlTitlePath('footer/contact-us').getContentID(), 'customBody')#
        </div>
        <div class="col-0 col-md-2"></div>
      </div>
    </div>     
    </div>
    <div class="bg-light pt-4">
      <div class="container">
        <div class="row pt-2">
          <div class="col-md-2 col-sm-6">
            <div class="widget widget-links pb-2 mb-4">
         	#$.renderContent($.getContentByUrlTitlePath('footer/site-links').getContentID(), 'customBody')#
            </div>
          </div>
          <div class="col-md-4 col-sm-6">
            <div class="widget widget-links pb-2 mb-4">
          	#$.renderContent($.getContentByUrlTitlePath('footer/get-in-touch').getContentID(), 'customBody')#
            </div>
          </div>
          <div class="col-md-6">
            <div class="widget pb-2 mb-4">
         	  #$.renderContent($.getContentByUrlTitlePath('footer/stay-informed').getContentID(), 'customBody')#
              <form class="validate" action="##" method="get" name="mc-embedded-subscribe-form" id="mc-embedded-subscribe-form">
                <div class="input-group input-group-overlay flex-nowrap">
                  <div class="input-group-prepend-overlay"><span class="input-group-text text-muted font-size-base"></span></div>
                  <div class="row">
                  <div class="col-12 d-flex">
                      <input class="form-control prepended-form-control mr-2" type="text" name="FirstName" id="mce-FirstName" value="" placeholder="First Name" required>
                      <input class="form-control prepended-form-control mr-2" type="text" name="LastName" id="mce-LastName" value="" placeholder="Last Name" required>
                      <input class="form-control prepended-form-control" type="text" name="Company" id="mce-Comapny" value="" placeholder="Company" required>
                  </div>
                  <div class="col-12 d-flex pt-2">
                  <input class="form-control prepended-form-control" type="email" name="Email" id="mce-Email" value="" placeholder="Your email" required>
                  <div class="input-group-append">
                    <button class="btn btn-primary" type="submit" name="subscribe" id="mc-embedded-subscribe">Subscribe*</button>
                  </div>
                  </div>
                </div>
                </div>
                <!--- real people should not fill this in and expect good things - do not remove this or risk form bot signups--->
                <div style="position: absolute; left: -5000px;" aria-hidden="true">
                  <input type="text" name="b_c7103e2c981361a6639545bd5_29ca296126" tabindex="-1">
                </div><small class="form-text text-light opacity-50" id="mc-helper">*Subscribe to our newsletter to receive early discount offers, updates and new products info.</small>
                <div class="subscribe-status"></div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="bg-darker pt-4">
      <div class="container">
        <div class="row">
          <div class="col-md-6 text-center text-md-left mb-4 text-light">
               <img class="w-50" src="#$.getThemePath()#/custom/client/assets/images/sb-logo-white.png" alt="Stone and Berg logo">
          </div>
          <div class="col-md-6 font-size-xs text-light text-center text-md-right mb-4">
             @#Year(myDateTime & "")# All rights reserved. Stone and Berg Company Inc
          </div>
        </div>
      </div>
    </div>
    
  </footer>
  <!--- JavaScript libraries, plugins and custom scripts--->
  <script src="#$.getThemePath()#/custom/client/assets/js/jquery.min.js"></script>
  <script src="#$.getThemePath()#/custom/client/assets/js/bootstrap.min.js"></script>
  <script src="#$.getThemePath()#/custom/client/assets/js/slick.min.js"></script>
  <script src="#$.getThemePath()#/custom/client/assets/js/theme.js"></script>
</body>
</html>

</cfoutput>
