<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
<!--- Account Login --->
<div class="block pb-5" id="login" ng-show="slatwall.currentAccountPage == 'Login'">
	<form  ng-model="Account_Login" 
		ng-submit="swfForm.submitForm()" 
		swf-form 
		data-method="Login">
	    
	    <!--- Create Account toggle  --->
        <a href="##" class="btn btn-link float-right" ng-click="slatwall.currentAccountPage = 'CreateAccount'"><i class="fa fa-user-plus"></i> Create Account</a>
	    
		<h3>Account Login</h3>

        <!-- Invalid account error -->
		<div class="form-group">
			<label for="emailAddress_Login" class="form-label">Email Address</label>
			<input id="emailAddress_Login" name="emailAddress" placeholder="Email Address" class="form-control success" ng-model="Account_Login.emailAddress" swvalidationdatatype="email" swvalidationrequired="true">
			<sw:SwfErrorDisplay propertyIdentifier="emailAddress"/>
		</div>
		
        <div class="form-group">
			<label for="password_Login">Password</label>
			<input id="password_Login" type="password" name="password" placeholder="Password" class="form-control success" ng-model="Account_Login.password" swvalidationrequired="true">
			<sw:SwfErrorDisplay propertyIdentifier="password"/>
		</div>

        <div class="row">
            <div class="col-sm-6">
                <!--- Login Button --->
                <button ng-click="swfForm.submitForm()" ng-class="{disabled:slatwall.getRequestByAction('Login').loading}" class="btn btn-secondary">
                	{{(swfForm.loading ? '' : 'Login & Continue')}}
                	<span ng-show="swfForm.loading"><i class='fa fa-refresh fa-spin fa-fw'></i></span>
	        	</button>
            </div>
            <div class="col-sm-6">
                <!--- Reset Password toggle --->
                <a href="##" class="link" ng-click="slatwall.currentAccountPage = 'ForgotPassword'">Reset Password</a>
            </div>
        </div>
    </form>
</div>
<!--- //Account Login --->

<!--- Reset Password --->
<div id="forgotPassword" ng-show="slatwall.currentAccountPage == 'ForgotPassword'" class="block">
	<form ng-model="Account_ForgotPassword" ng-submit="swfForm.submitForm()" swf-form data-method="ForgotPassword">
	    
        <!-- Reset Password Success Message -->
        <div ng-show="swfForm.successfulActions.length" class="alert alert-info">An email with instructions to reset your password has been sent to your inbox.</div>
            
        <p>Enter your email to receive a password reset email or login.</p>
        
		<div class="form-group">
			<label for="emailAddress_ForgotPassword">Email Address</label>
			<input id="emailAddress_ForgotPassword" name="emailAddress" type="text" placeholder="Email Address" class="form-control"
				ng-model="Account_ForgotPassword.emailAddress" swvalidationdatatype="email" swvalidationrequired="true">
            <sw:SwfErrorDisplay propertyIdentifier="emailAddress"/>
		</div>
		
		<div class="row">
		    <div class="col-sm-6">
		        <button ng-click="swfForm.submitForm()" ng-class="{disabled:swfForm.loading}" class="btn btn-secondary">
                	{{(swfForm.loading ? '' : 'Reset Password')}}
                	<span ng-show="swfForm.loading"><i class='fa fa-refresh fa-spin fa-fw'></i></span>
            	</button>
		    </div>
		    <div class="col-sm-6">
		        <!--- Login toggle --->
                <a href="##" class="link" ng-click="slatwall.currentAccountPage = 'Login'"  role="button" aria-expanded="false" aria-controls="login">&lt;- Back to Login</a>
		    </div>
		</div>
    </form>
</div>
<!--- //Reset Password --->

<!--- Create Account --->
<div ng-show="slatwall.currentAccountPage == 'CreateAccount'" class="block">
	<h3>Create Account</h3>

    <div ng-show="swfForm.errors.length" class="alert alert-danger">Error creating account. See errors below.</div>

    <form 
    	ng-model="Account_CreateAccount" 
		ng-submit="swfForm.submitForm()" 
		swf-form 
		data-method="CreateAccount,Login">
        
    	<div class="row">
    		<div class="col-md-6">
    		    <div class="form-group">
    			    <label for="firstname_CreateAccount">First Name</label>
    			    <input id="firstname_CreateAccount" type="text" name="firstName" placeholder="First Name" class="form-control"
    				    ng-model="Account_CreateAccount.firstName" swvalidationrequired="true"
    			    >
                    <sw:SwfErrorDisplay propertyIdentifier="firstName"/>
                </div>
            </div>
    		<div class="col-md-6">
    		    <div class="form-group">
    			    <label for="lastname_CreateAccount">Last Name</label>
    			    <input id="lastname_CreateAccount" type="text" name="lastName" placeholder="Last Name" class="form-control" 
    				    ng-model="Account_CreateAccount.lastName" swvalidationrequired="true"
    			    >
                    <sw:SwfErrorDisplay propertyIdentifier="lastName"/>
                </div>
            </div>
    		<div class="col-md-6">
    		    <div class="form-group">
    			    <label for="email_CreateAccount">Email Address</label>
        			<input id="email_CreateAccount" type="text" name="emailAddress" placeholder="Email Address" class="form-control"
        				ng-model="Account_CreateAccount.emailAddress" swvalidationdatatype="email" swvalidationrequired="true"
        			>
                    <sw:SwfErrorDisplay propertyIdentifier="emailAddress"/>
                </div>
            </div>
    		<div class="col-md-6">
    		    <div class="form-group">
        			<label for="emailAddressConfirm_CreateAccount">Confirm Email Address</label>
        			<input id="emailAddressConfirm_CreateAccount" type="text" name="emailAddressConfirm" placeholder="Confirm Email Address" class="form-control" 
        				ng-model="Account_CreateAccount.emailAddressConfirm" swvalidationrequired="true" swvalidationeqproperty="Account_CreateAccount.emailAddress"
        			>
                    <sw:SwfErrorDisplay propertyIdentifier="emailAddressConfirm"/>
                </div>
            </div>
    		<div class="col-md-6">
    		    <div class="form-group">
    			    <label for="password_CreateAccount">Password</label>
        			<input id="password_CreateAccount" type="password" name="password" placeholder="Password" class="form-control"
        				ng-model="Account_CreateAccount.password" swvalidationrequired="true"
        			>
                    <sw:SwfErrorDisplay propertyIdentifier="password"/>
                </div>
            </div>
    		<div class="col-md-6">
    		    <div class="form-group">
    			    <label for="confirmPassword_CreateAccount">Confirm Password</label>
        			<input id="confirmPassword_CreateAccount" type="password" name="passwordConfirm" placeholder="Confirm Password" class="form-control" 
        				ng-model="Account_CreateAccount.passwordConfirm" swvalidationrequired="true" swvalidationeqproperty="Account_CreateAccount.password"
        			>
                    <sw:SwfErrorDisplay propertyIdentifier="passwordConfirm"/>
                </div>
            </div>

            <div class="col-md-6">
                <div class="form-group">
        			<label for="phoneNumber_CreateAccount" class="form-label">Phone Number</label>
        			<input id="phoneNumber_CreateAccount" type="text" name="phoneNumber" placeholder="Phone Number" class="form-control"
        				ng-model="Account_CreateAccount.phoneNumber">
        			<sw:SwfErrorDisplay propertyIdentifier="phoneNumber"/>
        		</div>
    		</div>
    		
            <div class="col-md-6">
                <div class="input_box">
        			<label for="jobCategory_CreateAccount" class="form-label">Job Title</label>
        			<input id="jobCategory_CreateAccount" type="text" name="jobCategory" placeholder="Job Title" class="form-control"
        				ng-model="Account_CreateAccount.jobCategory">
        			<sw:SwfErrorDisplay propertyIdentifier="jobCategory"/>
        		</div>
    		</div>      
    		
            <div class="col-md-6">
                <div class="input_box">
        			<label for="company_CreateAccount" class="form-label">Organization</label>
        			<input id="company_CreateAccount" type="text" name="company" placeholder="Organization" class="form-control"
        				ng-model="Account_CreateAccount.company">
        			<sw:SwfErrorDisplay propertyIdentifier="company"/>
        		</div>
    		</div>    		
    		
            <div class="col-md-6">
                <div class="input_box">
        			<label for="department_CreateAccount" class="form-label">Department</label>
        			<input id="department_CreateAccount" type="text" name="department" placeholder="Department" class="form-control"
        				ng-model="Account_CreateAccount.department">
        			<sw:SwfErrorDisplay propertyIdentifier="department"/>
        		</div>
    		</div>      
    		
            <div class="col-md-4 col-md-offset-4">
                <div class="input_box">
        			<label for="sendCatalog_CreateAccount" class="form-label" style="display:inline-block;">Newsletter Signup</label>
        			<input id="sendCatalog_CreateAccount" value="Yes" style="display:inline-block;vertical-align: top;width: auto;position: relative;top: -10px;" type="checkbox" name="sendCatalog" placeholder="Newsletter Signup" class="form-control"
        				ng-model="Account_CreateAccount.sendCatalog">
        			<sw:SwfErrorDisplay propertyIdentifier="sendCatalog"/>
        		</div>
    		</div>      		
    	</div>
    	
    	<div class="row">
            <div class="col-sm-6">
                <button type="submit" class="btn btn-secondary" ng-class="{disabled:swfForm.loading}">{{swfForm.loading ? '' : 'Create Account & Continue'}}
                	<span ng-show="swfForm.loading"><i class='fa fa-refresh fa-spin fa-fw'></i></span>
                </button>
            </div>
            <div class="col-sm-6">
            	<!--- Login toggle  --->
        	    <a href="##" class="link" ng-click="slatwall.currentAccountPage = 'Login'"  role="button" aria-expanded="false" aria-controls="login">&lt;- Back to Login</a>
            </div>
        </div>
        
    </form>
</div>
<!--- //Create Account --->
</cfoutput>