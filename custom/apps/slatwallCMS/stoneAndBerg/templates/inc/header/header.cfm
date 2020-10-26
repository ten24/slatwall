<cfoutput>
<!DOCTYPE html>
<html lang="en-us">
<head>
	<cfinclude template="head.cfm" />
</head>
  
  <!-- Body-->
  <body>
    <!-- Navbar 3 Level (Light)-->
    <header class="shadow-sm">

    <!-- Remove "navbar-sticky" class to make navigation bar scrollable with the page.-->
    <div class="navbar-sticky bg-light">
      <div class="navbar navbar-expand-lg navbar-light">
        <div class="container">
          <!-- Brand Logo -->
          <a class="navbar-brand d-none d-md-block mr-3 flex-shrink-0" href="/">
            <img src="#$.getThemePath()#/custom/client/assets/images/sb-logo.png" alt="Stone & Berg Logo"/>
          </a>
          <a class="navbar-brand d-md-none mr-2" href="/">
            <img src="#$.getThemePath()#/custom/client/assets/images/sb-logo-mobile.png" style="min-width: 90px;" alt="Stone & Berg Logo"/>
          </a>
          
          <div class="navbar-right">
            <div class="navbar-topright">
              <div class="input-group-overlay d-none d-lg-flex">
                <input class="form-control appended-form-control" type="text" placeholder="Search for products">
                <div class="input-group-append-overlay"><span class="input-group-text"><i class="far fa-search"></i></span></div>
              </div>
              <div class="navbar-toolbar d-flex flex-shrink-0 align-items-center">
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="##navbarCollapse"><span class="navbar-toggler-icon"></span></button><a class="navbar-tool navbar-stuck-toggler" href="##"><span class="navbar-tool-tooltip">Expand menu</span>
                  <div class="navbar-tool-icon-box"><i class="far fa-bars"></i></div></a><a class="navbar-tool ml-1 ml-lg-0 mr-n1 mr-lg-2" href="##" data-toggle="modal">
                  <div class="navbar-tool-icon-box"><i class="far fa-user"></i></div>
                  <div class="navbar-tool-text ml-n3"><small>Hello, Sign in</small>My Account</div></a>
                <div class="navbar-tool ml-3"><a class="navbar-tool-icon-box bg-secondary" href="##"><span class="navbar-tool-label">4</span><i class="far fa-shopping-cart"></i></a><a class="navbar-tool-text" href="shop-cart.html"><small>My Cart</small>$265.00</a>
                </div>
              </div>
            </div>
            
            <div class="navbar-main-links">
              #$.renderContent($.getContentByUrlTitlePath('header/main-navigation').getContentID(), 'customBody')#
            </div>
          </div>
        </div>
      </div>
      <div class="navbar navbar-expand-lg navbar-dark bg-dark navbar-stuck-menu mt-2 pt-0 pb-0">
        <div class="container p-0">
          <div class="collapse navbar-collapse" id="navbarCollapse">
            <!-- Search-->
            <div class="input-group-overlay d-lg-none my-3 ml-0">
              <div class="input-group-prepend-overlay"><span class="input-group-text"><i class="far fa-search"></i></span></div>
              <input class="form-control prepended-form-control" type="text" placeholder="Search for products">
            </div>
            
            <!-- Primary menu-->
            <ul class="navbar-nav nav-categories">
              <cfset local.productsMainNav = $.slatwall.getService('contentService').getContentCollectionList()>
              <cfset local.productsMainNav.setDisplayProperties('site.siteCode,contentID,urlTitle,title,sortOrder,customBody,parentContent.contentID,parentContent.urlTitle,parentContent.title,parentContent.linkUrl')>
              <cfset local.productsMainNav.addFilter("site.siteCode",$.slatwall.getSite().getSiteCode())>
              <cfset local.productsMainNav.addFilter("activeFlag", true)>
              <cfset local.productsMainNav.addFilter("urlTitlePath","%productCategories/%","LIKE")>
              <cfset local.productsMainNav.addFilter("parentContent.urlTitle","productCategories","!=")>
              <cfset local.productsMainNav.addOrderBy("parentContent.sortOrder|ASC")>
              <cfset local.productsMainNav.addOrderBy("sortOrder|ASC")>
              <cfset local.productsMainNav.setPageRecordsShow(100) />
              <cfset local.productCategories = local.productsMainNav.getPageRecords()>
              <cfparam name="local.categoryCounter" default="0">
              <cfparam name="local.categoryPrevious" default="">
              
              <cfloop array="#local.productCategories#" index="local.productCategory">
              
                <!---
                End dropdown and Start New One 
                --->
                <cfif local.categoryCounter NEQ "0" AND local.categoryPrevious NEQ local.productCategory['parentContent_title']>
                      </div>
                    </div>
                  </li>
                  
                  <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#local.productCategory['parentContent_linkUrl']#" data-toggle="dropdown">
                      #local.productCategory['parentContent_title']#<span></span>
                    </a>
                    <div class="dropdown-menu pt-0 pb-3">
                      <div class="nav-shop-all">
                        <a href="#local.productCategory['parentContent_linkUrl']#">
                          Shop All #local.productCategory['parentContent_title']#<i class="far fa-arrow-right ml-2"></i>
                        </a>
                      </div>
                      <div class="d-flex flex-wrap flex-lg-nowrap px-2">
                        <div class="mega-dropdown-column py-4 px-3">
                          <div class="widget widget-links mb-3">
                            #local.productCategory['customBody']#
                          </div>
                        </div>

                  <cfset local.categoryPrevious = local.productCategory['parentContent_title']>
                  <cfset local.categoryCounter ++ />
                
                <!--- 
                Start New dropdown - no ending 
                --->
                <cfelseif local.categoryCounter EQ "0">
                <li class="nav-item dropdown">
                  <a class="nav-link dropdown-toggle" href="#local.productCategory['parentContent_linkUrl']#" data-toggle="dropdown">
                    #local.productCategory['parentContent_title']#<span></span>
                  </a>
                  <div class="dropdown-menu pt-0 pb-3">
                    <div class="nav-shop-all">
                      <a href="#local.productCategory['parentContent_linkUrl']#">
                        Shop All #local.productCategory['parentContent_title']#<i class="far fa-arrow-right ml-2"></i>
                      </a>
                    </div>
                    <div class="d-flex flex-wrap flex-lg-nowrap px-2">
                      <div class="mega-dropdown-column py-4 px-3">
                        <div class="widget widget-links mb-3">
                          #local.productCategory['customBody']#
                        </div>
                      </div>
                      
                  <cfset local.categoryPrevious = local.productCategory['parentContent_title']>
                  <cfset local.categoryCounter ++ />
                
                <!--- 
                Continue with children 
                --->
                <cfelse>
                  <div class="mega-dropdown-column py-4 px-3">
                    <div class="widget widget-links mb-3">
                      #local.productCategory['customBody']#
                    </div>
                  </div>
                  <cfset local.categoryPrevious = local.productCategory['parentContent_title']>
                  <cfset local.categoryCounter ++ />
                </cfif>
                  
              </cfloop>
                  </div>
                </div>
              </li>
              
            </ul>
            
            <!-- Departments menu-->
            <ul class="navbar-nav mega-nav ml-lg-2">
              <li class="nav-item"><a class="nav-link" href="##"><i class="far fa-industry-alt mr-2"></i>Shop by Manufacturer</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </header>
  
 </cfoutput>