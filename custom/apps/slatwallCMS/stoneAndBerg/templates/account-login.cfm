<cfimport prefix="swc" taglib="../tags" />
<cfinclude template="inc/header/header.cfm" />

<cfoutput>
  
  <div class="container py-4 py-lg-5 my-4">
      <div class="row d-flex justify-content-center">
        
        
        <!--- Login Form --->
        <div class="col-md-6">
          <div class="card box-shadow">
            <div class="card-body">
              <h2 class="h4 mb-1">Sign in</h2>
              <p class="font-size-sm text-muted mb-4">Don't have an account? <a href="##">Request account</a>.</p>
              <form class="needs-validation" novalidate="">
                <div class="form-group">
                  <label for="reg-email">E-mail Address</label>
                  <input class="form-control" type="email" required="" id="reg-email">
                  <div class="invalid-feedback">Please enter valid email address!</div>
                </div>
                <div class="form-group">
                  <label for="reg-password">Password</label>
                  <input class="form-control" type="password" required="" id="reg-password">
                  <div class="invalid-feedback">Please enter password!</div>
                </div>
                <div class="text-right">
                  <a class="nav-link-inline font-size-sm" href="account-password-recovery.html">Forgot password?</a>
                </div>
                <hr class="mt-4">
                <div class="text-right pt-4">
                  <button class="btn btn-primary" type="submit">Sign In</button>
                </div>
              </form>
            </div>
          </div>
        </div>
        
        
        <!--- Request Account Form --->
        <div class="col-md-8 pt-4 mt-3 mt-md-0 card box-shadow">
          <h2 class="h4 mb-3">Request Account</h2>
          <p class="font-size-sm text-muted mb-4">Already have an account. <a href="##">Sign in here</a>.</p>
          <form class="needs-validation" novalidate="">
            <div class="row mb-3">
              <div class="col-sm-6">
                <div class="form-group">
                  <label for="reg-fn">First Name</label>
                  <input class="form-control" type="text" required="" id="reg-fn">
                  <div class="invalid-feedback">Please enter your first name!</div>
                </div>
              </div>
              <div class="col-sm-6">
                <div class="form-group">
                  <label for="reg-ln">Last Name</label>
                  <input class="form-control" type="text" required="" id="reg-ln">
                  <div class="invalid-feedback">Please enter your last name!</div>
                </div>
              </div>
              <div class="col-sm-6">
                <div class="form-group">
                  <label for="reg-email">E-mail Address</label>
                  <input class="form-control" type="email" required="" id="reg-email">
                  <div class="invalid-feedback">Please enter valid email address!</div>
                </div>
              </div>
              <div class="col-sm-6">
                <div class="form-group">
                  <label for="company">Company</label>
                  <input class="form-control" type="text" required="" id="company">
                </div>
              </div>
              <div class="col-sm-6">
                <div class="form-group">
                  <label for="reg-password">Password</label>
                  <input class="form-control" type="password" required="" id="reg-password">
                  <div class="invalid-feedback">Please enter password!</div>
                </div>
              </div>
              <div class="col-sm-6">
                <div class="form-group">
                  <label for="reg-password-confirm">Confirm Password</label>
                  <input class="form-control" type="password" required="" id="reg-password-confirm">
                  <div class="invalid-feedback">Passwords do not match!</div>
                </div>
              </div>
              <div class="col-sm-4">
                <div class="form-group">
                  <label for="reg-phone">Phone Number</label>
                  <input class="form-control" type="text" required="" id="reg-phone">
                  <div class="invalid-feedback">Please enter your phone number!</div>
                </div>
              </div>
              <div class="col-sm-2">
                <div class="form-group">
                  <label for="ext-phone">Ext.</label>
                  <input class="form-control" type="text" required="" id="ext-phone">
                </div>
              </div>
            </div>
            <hr>
            <ol class="p-3 mt-3">
              <li>
                <p class="mb-2">Download the application form</p>
                <p class="font-size-sm text-muted mb-2">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar sic tempor. Sociis natoque penatibus et magnis dis parturient montes.</p>
                <p class="font-size-sm text-muted"><a href="##">Download Application Here</a>.</p>
              </li>
              <li>
                <p class="mb-2">Upload your filled out form</p>
                <input type="file" id="application" name="application" accept="image/png, image/jpeg">
              </li>
            </ol>
            <hr>
            <div class="text-right mb-4 mt-3">
              <button class="btn btn-primary" type="submit">Request Account</button>
            </div>
          </form>
        </div> 
        
        
      </div><!--- end of .row --->
    </div>

</cfoutput>

<cfinclude template="inc/footer.cfm" />
