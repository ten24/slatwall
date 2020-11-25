<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
<div class="row">
	<div class="col-md-6 offset-md-3">
		<div class="text-center my-3">
            <h1>Reset Password</h1>
            <p>Please reset your password below to access your account.</p>
        </div>
		<!--- If this item was just added show the success message --->
		<cfif $.slatwall.hasSuccessfulAction( "public:account.resetPassword" )>
			<div class="alert alert-success">
				Your account's password has been reset.
			</div>
		<!--- If this item was just tried to be added, but failed then show the failure message ---> 
		<cfelseif $.slatwall.hasFailureAction( "public:account.resetPassword" )>
			<div class="alert alert-danger">
				There was an error trying to reset your password.
			</div>
		</cfif>
		
		<cfset resetPasswordObj = $.slatwall.getAccount().getProcessObject('resetPassword') />
		
		<div class="card">
            <div class="card-body">
				<form action="?s=1&swprid=#url.swprid#" method="post">
					<input type="hidden" name="slatAction" value="public:account.resetPassword,public:account.login" />
					<input type="hidden" name="accountID" value="#left(url.swprid, 32)#" />
					<input type="hidden" name="sRedirectURL" value="/my-account/" />
					
					<!--- New Password --->
					<div class="form-group">
						<label for="password">New Password</label>
						<sw:FormField type="password" valueObject="#resetPasswordObj#" valueObjectProperty="password" class="form-control" fieldAttributes="required" />
						<sw:ErrorDisplay object="#resetPasswordObj#" errorName="password" />
			  		</div>
					
					<!--- Confirm Password --->
					<div class="form-group">
						<label for="passwordConfirm">Confirm Password</label>
						<sw:FormField type="password" valueObject="#resetPasswordObj#" valueObjectProperty="passwordConfirm" class="form-control" fieldAttributes="required" />
						<sw:ErrorDisplay object="#resetPasswordObj#" errorName="passwordConfirm" />
			  		</div>
					
					<!--- Reset Button --->
					<div class="form-group">
			  			<button type="submit" class="btn btn-primary">Reset Password</button>
			  		</div>
				</form>
			</div>
		</div>
	</div>
</div>
</cfoutput>