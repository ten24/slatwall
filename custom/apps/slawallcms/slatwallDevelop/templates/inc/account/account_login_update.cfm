<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
		
	<h4>Change Primary Email Login</h4>
	<p>Primary Email login: <strong>#$.slatwall.getAccount().getPrimaryEmailAddress().getEmailAddress()#</strong></p>
	
	<div class="row">
		<form class="col-md-5" ng-model="Account_UpdatePrimaryEmailAddress" ng-submit="swfForm.submitForm()" swf-form data-s-redirect-url="/my-account/login-information" data-method="updatePrimaryEmailAddress">
			
			<div ng-show="swfForm.errorToDisplay.length" ng-bind="swfForm.errorToDisplay" class="alert alert-danger">
				<a class="close" data-dismiss="alert"><i class="fa fa-times"></i></a>
			</div>
			
			<div class="form-group">
				<label for="emailAddress">Email Address</label>
				<input 
					name="emailAddress" 
					class="form-control" 
					ng-init="Account_UpdatePrimaryEmailAddress.emailAddress='#$.slatwall.getAccount().getPrimaryEmailAddress().getEmailAddress()#';" 
					ng-model="Account_UpdatePrimaryEmailAddress.emailAddress" 
					swvalidationrequired="true" 
					swvalidationdatatype="email"
				/>
				<sw-error-display data-property-identifier="emailAddress" class="text-danger small"></sw-error-display>
			</div>
			
			<div class="form-group">
				<label for="emailAddressConfirm">Confirm Email Address</label>
				<input 
					name="emailAddressConfirm" 
					class="form-control" 
					ng-init="Account_UpdatePrimaryEmailAddress.emailAddressConfirm='#$.slatwall.getAccount().getPrimaryEmailAddress().getEmailAddress()#'" 
					ng-model="Account_UpdatePrimaryEmailAddress.emailAddressConfirm" 
					swvalidationrequired="true" 
					swvalidationdatatype="email" 
					swvalidationeqproperty="Account_UpdatePrimaryEmailAddress.emailAddress"
				/>
				<sw-error-display data-property-identifier="emailAddressConfirm" class="text-danger small"></sw-error-display>
			</div>
	
		    <div class="form-group">
		    	<button class="btn btn-primary" type="submit">Update Email Login</button>
		    </div>
		</form>
	</div>
	
	<h4>Change Password</h4>
	
	<div class="row">
		<!--- Change Password --->
		<div class="col-md-5">
			<form action="?s=1" method="post">
				<!--- Get the change password process object --->
				<cfset changePasswordObj = $.slatwall.getAccount().getProcessObject('changePassword') />
				
				<input type="hidden" name="slatAction" value="public:account.changePassword" />
					
				<!--- New Password --->
				<div class="form-group">
					<label for="password">New Password</label>
					<sw:FormField type="password" valueObject="#changePasswordObj#" valueObjectProperty="password" class="form-control" fieldAttributes="required" />
					<sw:ErrorDisplay object="#changePasswordObj#" errorName="password" class="text-danger" />
			  	</div>
				
				<!--- Confirm New Password --->
				<div class="form-group">
					<label for="passwordConfirm">Confirm New Password</label>
					<sw:FormField type="password" valueObject="#changePasswordObj#" valueObjectProperty="passwordConfirm" class="form-control" fieldAttributes="required" />
					<sw:ErrorDisplay object="#changePasswordObj#" errorName="passwordConfirm" class="text-danger" />
			  	</div>
			  	
				<div class="form-group">
			  		<button type="submit" class="btn btn-primary">Change Password</button>
			  	</div>
			</form>
		</div>
	</div>
</cfoutput>