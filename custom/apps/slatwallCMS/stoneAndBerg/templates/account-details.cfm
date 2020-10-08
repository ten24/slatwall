<cfinclude template="inc/header/header.cfm" />


<cfoutput>
	
	<div class="page-title-overlap bg-lightgray pt-4">
      <div class="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div class="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb breadcrumb-dark flex-lg-nowrap justify-content-center justify-content-lg-start">
              <li class="breadcrumb-item"><a class="text-nowrap" href="/"><i class="far fa-home"></i>Home</a></li>
              <li class="breadcrumb-item text-nowrap"><a href="##">Account</a></li>
              <li class="breadcrumb-item text-nowrap active"><a href="##">My Profile</a></li>
            </ol>
          </nav>
        </div>
        <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 class="h3 mb-0">My Profile</h1>
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
              <h3 class="font-size-sm mb-0 text-muted"><a href="/my-account" class="nav-link-style">Overview</a></h3>
            </div>
            <ul class="list-unstyled mb-0">
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-shopping-bag pr-2"></i> Order History</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3 active" href="##"><i class="far fa-user pr-2"></i> Profile Info</a></li>
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
              <h6 class="h6">Update your profile details below:</h6>
            </div>
          </div>
          
          <div class="row">
              <div class="col-sm-6">
                <div class="form-group">
                  <label for="account-fn">First Name</label>
                  <input class="form-control" type="text" id="account-fn" value="Susan">
                </div>
              </div>
              <div class="col-sm-6">
                <div class="form-group">
                  <label for="account-ln">Last Name</label>
                  <input class="form-control" type="text" id="account-ln" value="Gardner">
                </div>
              </div>
              <div class="col-sm-6">
                <div class="form-group">
                  <label for="account-email">Email Address</label>
                  <input class="form-control" type="email" id="account-email" value="s.gardner@example.com" disabled="">
                </div>
              </div>
              <div class="col-sm-4">
                <div class="form-group">
                  <label for="account-phone">Phone Number</label>
                  <input class="form-control" type="text" id="account-phone" value="+7 (805) 348 95 72" required="">
                </div>
              </div>
              <div class="col-sm-2">
                <div class="form-group">
                  <label for="account-etx">Ext.</label>
                  <input class="form-control" type="text" id="account-etx" value="2" required="">
                </div>
              </div>
              <div class="col-sm-6">
                <div class="form-group">
                  <label for="account-comp">Company</label>
                  <input class="form-control" type="text" id="account-comp" value="">
                </div>
              </div>
              <div class="col-12">
                <hr class="mt-2 mb-3">
                <div class="d-flex flex-wrap justify-content-end">
                  <button class="btn btn-secondary mt-3 mt-sm-0 mr-3" type="button">Update password</button>
                  <button class="btn btn-primary mt-3 mt-sm-0" type="button">Update profile</button>
                </div>
              </div>
            </div>
        </section>
      </div>
    </div>
    
</cfoutput>
<cfinclude template="inc/footer.cfm" />
