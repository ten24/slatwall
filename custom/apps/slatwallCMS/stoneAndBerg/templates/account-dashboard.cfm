<cfinclude template="inc/header/header.cfm" />

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../tags" />

<cfoutput>
	
	<div class="page-title-overlap bg-lightgray pt-4">
      <div class="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div class="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb breadcrumb-dark flex-lg-nowrap justify-content-center justify-content-lg-start">
              <li class="breadcrumb-item"><a class="text-nowrap" href="/"><i class="far fa-home"></i>Home</a></li>
              <li class="breadcrumb-item text-nowrap active"><a href="##">Account</a></li>
            </ol>
          </nav>
        </div>
        <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 class="h3 mb-0">My Dashboard</h1>
        </div>
      </div>
    </div>
    
    <!-- Page Content-->
    <div class="container pb-5 mb-2 mb-md-3">
      <div class="row">
        <!-- Sidebar-->
        <aside class="col-lg-4 pt-4 pt-lg-0">
          <div class="cz-sidebar-static rounded-lg box-shadow-lg px-0 pb-0 mb-5 mb-lg-0">
            <div class="px-4 mb-4">
              <div class="media align-items-center">
                <div class="media-body">
                  <h3 class="font-size-base mb-0">Susan Gardner</h3>
                  <a href="##" class="text-accent font-size-sm">Logout</a>
                </div>
              </div>
            </div>
            <div class="bg-secondary px-4 py-3">
              <h3 class="font-size-sm mb-0 text-muted"><a href="/my-account" class="nav-link-style active">Overview</a></h3>
            </div>
            <ul class="list-unstyled mb-0">
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-shopping-bag pr-2"></i> Order History</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-user pr-2"></i> Profile Info</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-heart pr-2"></i> Favorties</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-map-marker-alt pr-2"></i> Addresses</a></li>
              <li class="mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-credit-card pr-2"></i> Payment Methods</a></li>
            </ul>
          </div>
        </aside>
        
        <!-- Content  -->
        <section class="col-lg-8">
          <!-- Toolbar-->
          <div class="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
            <div class="d-flex justify-content-between w-100">
              <h2 class="h3">Welcome to Stone and Berg</h2>
            </div>
          </div>
          
          #$.renderContent($.getContentByUrlTitlePath('my-account').getContentID(), 'customBody')#
          
          <h3 class="h4 mt-5 mb-3">Most Recent Order</h3>
          <div class="row bg-lightgray rounded align-items-center justify-content-between mb-4">
            <div class="col-xs-4 p-3">
              <h6>Order ##43810583021</h6>
              <span>10/12/2020</span>
            </div>
            <div class="col-xs-3 p-3">
              <h6>Status</h6>
              <span>New</span>
            </div>
            <div class="col-xs-3 p-3">
              <h6>Order Total</h6>
              <span>$1,293.95</span>
            </div>
            <div class="p-3">
              <a href="##" class="btn btn-outline-secondary">View</a>
            </div>
          </div>
          <a href="/my-account/orders" class="btn btn-primary">View All Orders</a>
        </section>
      </div>
    </div>
    
</cfoutput>
<cfinclude template="inc/footer.cfm" />