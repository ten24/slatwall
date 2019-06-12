<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
<div ng-show="!slatwall.account.userIsLoggedIn() && !slatwall.showCreateAccount">
	<span ng-init="slatwall.forgotPassword = false "></span>
	<!--- Login form --->
	<form ng-model="Account_Login" ng-submit="swfForm.submitForm()" swf-form data-s-redirect-url="/my-account" data-method="Login" ng-show="!slatwall.forgotPassword">
		<div class="form-group">
			<label for="email">Email Address</label>
			<input name="emailAddress" class="form-control" ng-model="Account_Login.emailAddress" swvalidationdatatype="email" swvalidationrequired="true"/>
			<sw:SwfErrorDisplay propertyIdentifier="emailAddress" class="text-danger small"/>
		</div>
		<div class="form-group">
			<label for="password">Password</label>
			<input name="password" class="form-control" type="password" ng-model="Account_Login.password" swvalidationrequired="true"/>
			<sw:SwfErrorDisplay propertyIdentifier="password" class="text-danger small"/>
		</div>
		<button class="btn btn-primary btn-block">{{(slatwall.getRequestByAction('Login').loading ? 'Loading...' : 'Sign In')}}</button>
		
		<a href="##" class="btn btn-link btn-block text-center" ng-click="slatwall.forgotPassword = true;">Forgot your password?</a>
	</form>
	
	<!--- Forgot Password form --->
	<div ng-show="slatwall.forgotPassword" class="forgotPassword">
		<form ng-model="Account_ForgotPassword" ng-submit="swfForm.submitForm()" swf-form data-s-redirect-url="/my-account" data-method="forgotPassword">
			
			<div class="alert alert-success" ng-show="swfForm.successfulActions.length">
		        An email has been sent to the address you provided with a link to reset your password so you may <a href="##" ng-click="slatwall.forgotPassword = false">login</a>
		    </div>

			<p ng-if="slatwall.forgotPasswordNotSubmitted()">Enter your email to receive password reset instructions.</p>
			
			<div class="form-group">
				<label for="emailAddress">Email Address</label>
				<input name="emailAddress" class="form-control" ng-model="Account_ForgotPassword.emailAddress" swvalidationdatatype="email" swvalidationrequired="true" />
				<sw-error-display data-property-identifier="emailAddress" class="text-danger small"></sw-error-display>
			</div>
			<button class="btn btn-primary btn-block" type="submit">{{(swfForm.loading ? 'Loading...' : 'Send Reset Email')}}</button>
			<a href="##" class="btn btn-link btn-block" ng-click="slatwall.forgotPassword = false;">Back to Login</a>
		</form>
	</div>
</div>
</cfoutput>