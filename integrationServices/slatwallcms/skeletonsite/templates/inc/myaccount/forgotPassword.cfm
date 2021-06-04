<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
<div class="card">
	<h5 class="card-title">Forgot Password - Server Side</h5>
	<!--- Sets up the account login processObject --->
	<cfset forgotPasswordObj = $.slatwall.getAccount().getProcessObject('forgotPassword') />
	
	<cfif $.slatwall.hasSuccessfulAction( "public:account.forgotPassword" )>
		<div class="alert alert-success">
			An email has been sent to the address you provided with a link to reset your password. 
		</div>
	</cfif>
	
	<!--- Start: Forgot Password Form --->
	<form class="card-body" action="?s=1" method="post">
		
		<!--- This hidden input is what tells slatwall to try and login the account --->
		<input type="hidden" name="slatAction" value="public:account.forgotPassword" />
		
		<!--- Email Address --->
		<div class="control-group">
			<label class="control-label" for="rating">Email Address</label>
			<div class="controls">
				
				<sw:FormField type="text" valueObject="#accountLoginObj#" valueObjectProperty="emailAddress" class="span6" />
				<sw:ErrorDisplay object="#forgotPasswordObj#" errorName="emailAddress" />
				
			</div>
	  	</div>
		
		<!--- Reset Email Button --->
		<div class="control-group">
			<div class="controls">
	  			<button type="submit" class="btn">Send Me Reset Email</button>
			</div>
	  	</div>
		
	</form>
	<!--- End: Forgot Password Form --->	
</div>

	<!--- Start: Forgot Password Form - CLIENT SIDE --->	
<div ng-if="slatwall.hasSuccessfulAction('forgotPassword')" class="alert alert-success">
	An email has been sent to the address you provided with a link to reset your password. 
</div>
<div class="card" ng-show="!slatwall.account.userIsLoggedIn()">
	<sw-form
	data-is-process-form="true"
	data-object="'Account_ForgotPassword'"
	data-form-class="card-body"
	data-error-class="error"
	data-name="Account_Forgot_Password"
	data-event-announcers="click,blur,change"
>
	
<h5 class="card-title">Forgot Password - Client Side</h5>

   <div class="col-sm-12 form-group">
        <swf-property-display
            data-name="emailAddress"
            data-type="email"
            data-property-identifier="emailAddress"
            data-label-text="Email Address"
            data-class="form-control"
            >
        </swf-property-display>
    </div>
    <div class="col-sm-12 form-group">
	    <sw-action-caller
	        data-action="forgotPassword"
	        data-modal="false"
	        data-type="button"
	        data-class="btn-yellow"
	        data-error-class="error"
	        data-text="{{(slatwall.getRequestByAction('forgotPassword').loading ? 'Loading...' : 'Submit')}}">
	    </sw-action-caller>
	</div>
</sw-form>
</div>
</cfoutput>