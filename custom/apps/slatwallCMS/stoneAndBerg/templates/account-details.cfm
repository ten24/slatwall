<cfinclude template="inc/header/header.cfm" />

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../tags" />

<cfoutput>
<div class="page-title-overlap bg-dark pt-4">
      <div class="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div class="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb breadcrumb-light flex-lg-nowrap justify-content-center justify-content-lg-start">
              <li class="breadcrumb-item"><a class="text-nowrap" href="index.html"><i class="fa fa-home"></i>Home</a></li>
              <li class="breadcrumb-item text-nowrap"><a href="##">Account</a>
              </li>
              <li class="breadcrumb-item text-nowrap active" aria-current="page">Account Details</li>
            </ol>
          </nav>
        </div>
        <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 class="h3 text-light mb-0">My Account</h1>
        </div>
      </div>
    </div>
    
<!---- end top bar---->
<div class="container pb-5 mb-2 mb-md-3">
  <div class="row">
    <!---- sidebar ---->
    <aside class="col-lg-4 pt-4 pt-lg-0">
      <cfinclude template="inc/sidebar-2.cfm">
    </aside>
    <section class="col-lg-8">
          <!-- Toolbar-->
          <div class="d-none d-lg-flex justify-content-between align-items-center pt-lg-3 pb-4 pb-lg-5 mb-lg-4">
            <h6 class="font-size-base text-light mb-0">My Details</h6><a class="btn btn-primary btn-sm" href="account-signin.html"><i class="czi-sign-out mr-2"></i>Sign out</a>
          </div>
              
          <div class="card container" id="account-detail-card">
            <div class="row">
              <div class="col-md-6 form-group">
                <label for="firstName">First Name</label>
                <input type="text" id="firstName">
              </div>
              <div class="col-md-6 form-group">
                <label for="lastName">Last Name</label>
                <input type="text" id="lastName">
              </div>
              <div class="col-md-6 form-group">
                <laabel for="email">Email</laabel>
                <input type="text" id="email">
              </div>
              <div class="col-sm-6 col-md-4 form-group">
                <label for="phoneNumber">Phone Number</label>
                <input type="text" id="phoneNumber">
                </div>
                <div class="col-sm-6 col-md-2 form-group">
                 <label for="extension">Ext</label>
                 <input type="text" id="extension">
              </div>
              <div class="col-md-12 form-group">
                <label for="company">Company</label>
                <input type="text" id="company">
              </div>
              <div class="col-md-12 form-group d-sm-flex justify-content-around">
                <button class="btn btn-primary">Save Changes</button>
                <button class="btn btn-secondary mt-2">Change Password</button>
              </div>
            </div>
          </div>
        </section>
  </div>
</div>
</cfoutput>
<cfinclude template="inc/footer.cfm" />
