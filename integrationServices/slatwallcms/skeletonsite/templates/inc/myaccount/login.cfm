<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	
	<!--- Start: Login Form - SERVER SIDE --->
	<div class="card">
		<form class="card-body" action="?s=1" method="post">
			<h5 class="card-title">Server Side</h5>
			<!--- This hidden input is what tells slatwall to try and login the account --->
			<input type="hidden" name="slatAction" value="public:account.login" />
			
			<!--- Email Address --->
			<div class="control-group">
				<label class="control-label" for="rating">Email Address</label>
				<div class="controls">
					
					<sw:FormField type="text" valueObject="#accountLoginObj#" valueObjectProperty="emailAddress" class="span6" />
					<sw:ErrorDisplay object="#accountLoginObj#" errorName="emailAddress" />
					
				</div>
		  	</div>
			
			<!--- Password --->
			<div class="control-group">
				<label class="control-label" for="rating">Password</label>
				<div class="controls">
					
					<sw:FormField type="password" valueObject="#accountLoginObj#" valueObjectProperty="password" class="span6" />
					<sw:ErrorDisplay object="#accountLoginObj#" errorName="password" />
					
				</div>
		  	</div>
			
			<!--- Login Button --->
			<div class="control-group">
				<div class="controls">
		  			<button type="submit" class="btn btn-primary">Login & Continue</button>
				</div>
		  	</div>
			
		</form>	
	</div>
	<!--- End: Login Form SERVER SIDE --->
	
	<!--- Start: Login Form - CLIENT SIDE --->
	
	<div class="card" ng-show="!slatwall.account.userIsLoggedIn()">
		<sw-form
	    data-is-process-form="true"
	    data-object="'Account_Login'"
	    data-s-redirect-url="/my-account"
	    data-form-class="card-body"
	    data-error-class="error"
	    data-name="Account_Login"
		data-event-announcers="click,blur,change"
	    >
			
		<h5 class="card-title">Client Side</h5>
		
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
		        <swf-property-display
		            data-name="password"
		            data-type="password"
					on-change="myfunc"
					on-click="myclick"
		
		            data-property-identifier="password"
		            data-label-text="Password"
		            data-class="form-control"
		            >
		        </swf-property-display>
				<a href="##" ng-click="slatwall.forgotPassword = true;">Forgot your password?</a>
		    </div>
		    <div class="col-sm-12 form-group">
			    <sw-action-caller
			        data-action="login"
			        data-modal="false"
			        data-type="button"
			        data-class="btn-yellow"
			        data-error-class="error"
			        data-text="{{(slatwall.getRequestByAction('login').loading ? 'Loading...' : 'Sign In')}}">
			    </sw-action-caller>
			</div>
		</sw-form>
	</div>
</cfoutput>