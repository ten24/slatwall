<div ng-show="!slatwall.account.userIsLoggedIn() && slatwall.showCreateAccount">
	<span ng-init="slatwall.forgotPassword = false "></span>
	<form ng-model="Account_Create" ng-submit="swfForm.submitForm()" swf-form data-s-redirect-url="/my-account" data-method="createAccount,login">
		
			<div ng-show="swfForm.errorToDisplay.length" ng-bind="swfForm.errorToDisplay"></div>
		
		<div class="row">
			<div class="col-md-6">
				<div class="form-group">
					<label for="firstName">First Name</label>
					<input name="firstName" class="form-control" ng-model="Account_Create.firstName" swvalidationrequired="true" />
					<sw-error-display data-property-identifier="firstName" class="text-danger small"></sw-error-display>
				</div>
			</div>
			
			<div class="col-md-6">
				<div class="form-group">
					<label for="lastName">Last Name</label>
					<input name="lastName" class="form-control" ng-model="Account_Create.lastName" swvalidationrequired="true" />
					<sw-error-display data-property-identifier="lastName" class="text-danger small"></sw-error-display>
				</div>
			</div>
			
			<div class="col-md-6">
				<div class="form-group">
					<label for="emailAddress">Email Address</label>
					<input name="emailAddress" class="form-control" ng-model="Account_Create.emailAddress" swvalidationdatatype="email" swvalidationrequired="true" />
					<sw-error-display data-property-identifier="emailAddress" class="text-danger small"></sw-error-display>
				</div>
			</div>
			
			<div class="col-md-6">
				<div class="form-group">
					<label for="emailConfirm">Email Address Confirm</label>
					<input name="emailAddressConfirm" class="form-control" ng-model="Account_Create.emailAddressConfirm" swvalidationeqproperty="Account_Create.emailAddress" swvalidationdatatype="email" swvalidationrequired="true" />
					<sw-error-display data-property-identifier="emailAddressConfirm" class="text-danger small"></sw-error-display>
				</div>
			</div>
			
			<div class="col-md-6">
				<div class="form-group">
					<label for="password">Password</label>
					<input name="password" class="form-control" type="password" ng-model="Account_Create.password" swvalidationminlength="6" swvalidationrequired="true" />
					<sw-error-display data-property-identifier="password" class="text-danger small"></sw-error-display>
				</div>
			</div>
			
			<div class="col-md-6">
				<div class="form-group">
					<label for="passwordConfirm">Password Confirm</label>
					<input name="passwordConfirm" class="form-control" type="password" ng-model="Account_Create.passwordConfirm" swvalidationeqproperty="Account_Create.password" swvalidationrequired="true" />
					<sw-error-display data-property-identifier="passwordConfirm" class="text-danger small"></sw-error-display>
				</div>
			</div>
			
			<div class="col-md-6">
				<div class="form-group">
					<label for="phoneNumber">Phone Number</label>
	        		<input id="phoneNumber" type="text" name="phoneNumber" class="form-control" ng-model="Account_CreateAccount.phoneNumber">
	        		<sw:SwfErrorDisplay propertyIdentifier="phoneNumber" class="text-danger small"/>
	    		</div>
	    	</div>
    		
    		<div class="col-md-6">
	            <div class="form-group">
	            	<label for="company" class="control-labell">Organization</label>
	        		<input id="company" type="text" name="company" class="form-control" ng-model="Account_CreateAccount.company">
	        		<sw:SwfErrorDisplay propertyIdentifier="company" class="text-danger small"/>
	    		</div>   
	    	</div>
	    </div>
		<button class="btn btn-primary btn-block" type="submit">{{(swfForm.loading ? 'Loading...' : 'Sign Up')}}</button>
	</form>
</div>