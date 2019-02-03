<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
		
	<h4>Change Primary Email Login</h4>
	<p>Primary Email login: <strong>#$.slatwall.getAccount().getPrimaryEmailAddress().getEmailAddress()#</strong></p>

	<form ng-model="Account_UpdatePrimaryEmailAddress" ng-submit="swfForm.submitForm()" swf-form data-s-redirect-url="/my-account/login-information" data-method="updatePrimaryEmailAddress">
		
		<div ng-show="swfForm.errorToDisplay.length" ng-bind="swfForm.errorToDisplay" class="alert alert-danger">
			<a class="close" data-dismiss="alert"><i class="fa fa-times"></i></a>
		</div>
		
		<div class="form-group">
			<label for="emailAddress">Email Address</label>
			<input name="emailAddress" class="form-control" ng-init="Account_UpdatePrimaryEmailAddress.emailAddress='#$.slatwall.getAccount().getPrimaryEmailAddress().getEmailAddress()#';" ng-model="Account_UpdatePrimaryEmailAddress.emailAddress" swvalidationrequired="true" swvalidationdatatype="email"/>
			<sw-error-display data-property-identifier="emailAddress" class="text-danger small"></sw-error-display>
		</div>
		
		<div class="form-group">
			<label for="emailAddressConfirm">Confirm Email Address</label>
			<input name="emailAddressConfirm" class="form-control" ng-init="Account_UpdatePrimaryEmailAddress.emailAddressConfirm='#$.slatwall.getAccount().getPrimaryEmailAddress().getEmailAddress()#'" ng-model="Account_UpdatePrimaryEmailAddress.emailAddressConfirm" swvalidationrequired="true" swvalidationdatatype="email" swvalidationeqproperty="Account_UpdatePrimaryEmailAddress.emailAddress"/>
			<sw-error-display data-property-identifier="emailAddressConfirm" class="text-danger small"></sw-error-display>
		</div>

	    <div class="form-group">
	    	<button class="btn btn-primary" type="submit">Update Email Login</button>
	    </div>
	</form>

	<hr/>

	<h4>Change Password</h4>

	<form ng-model="Account_UpdatePassword" ng-submit="swfForm.submitForm()" swf-form data-s-redirect-url="/my-account/login-information" data-method="updatePassword">
		
		<div ng-show="swfForm.errorToDisplay.length" ng-bind="swfForm.errorToDisplay" class="alert alert-danger">
			<a class="close" data-dismiss="alert"><i class="fa fa-times"></i></a>
		</div>
		<!---
		<input type="hidden" name="emailAddress" ng-model="Account_UpdatePassword.emailAddress" ng-value="#$.slatwall.getAccount().getPrimaryEmailAddress().getEmailAddress()#" />
		--->		
		
		<div class="form-group">
			<input 
				type="hidden" 
				name="emailAddress" 
				class="form-control" 
				ng-model="Account_UpdatePassword.emailAddress" 
				ng-init=
				"Account_UpdatePassword.emailAddress='#$.slatwall.getAccount().getPrimaryEmailAddress().getEmailAddress()#';"
				swvalidationrequired="true"
			/>
		</div>


		<div class="form-group">
			<label for="password">Current Password</label>
			<input name="existingPassword" class="form-control" type="password" ng-model="Account_UpdatePassword.existingPassword" swvalidationrequired="true" />
			<sw-error-display data-property-identifier="existingPassword" class="text-danger small"></sw-error-display>
		</div>
		
		<div class="form-group">
			<label for="password">Password</label>
			<input name="password" class="form-control" type="password" ng-model="Account_UpdatePassword.password" swvalidationrequired="true"/>
			<sw-error-display data-property-identifier="password" class="text-danger small"></sw-error-display>
		</div>
		
		<div class="form-group">
			<label for="passwordConfirm">Confirm Password</label>
			<input name="passwordConfirm" class="form-control" type="password" ng-model="Account_UpdatePassword.passwordConfirm" swvalidationrequired="true" swvalidationeqproperty="Account_UpdatePassword.password"/>
			<sw-error-display data-property-identifier="passwordConfirm" class="text-danger small"></sw-error-display>
		</div>

	    <div class="form-group">
	    	<button class="btn btn-primary" type="submit">Change Password</button>
	    </div>
	</form>

</cfoutput>

