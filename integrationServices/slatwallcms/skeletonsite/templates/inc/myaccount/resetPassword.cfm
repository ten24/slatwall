<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<div class="row">
		<div class="span12">
			<h2>My Account</h2>
		</div>
	</div>
	<div class="row">
		<!--- Reset Password --->
		<div class="span6">
			<h5>Reset Password</h5>
			
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
			
			<form action="?s=1&swprid=#url.swprid#" method="post">
				<input type="hidden" name="slatAction" value="public:account.resetPassword,public:account.login" />
				<input type="hidden" name="accountID" value="#left(url.swprid, 32)#" />
				
				<!--- New Password --->
				<div class="control-group">
					<label class="control-label" for="rating">New Password</label>
					<div class="controls">
						
						<sw:FormField type="password" valueObject="#resetPasswordObj#" valueObjectProperty="password" class="span6" />
						<sw:ErrorDisplay object="#resetPasswordObj#" errorName="password" />
						
					</div>
	  			</div>
				
				<!--- Confirm Password --->
				<div class="control-group">
					<label class="control-label" for="rating">Confirm Password</label>
					<div class="controls">
						
						<sw:FormField type="password" valueObject="#resetPasswordObj#" valueObjectProperty="passwordConfirm" class="span6" />
						<sw:ErrorDisplay object="#resetPasswordObj#" errorName="passwordConfirm" />
						
					</div>
	  			</div>
				
				<!--- Reset Button --->
				<div class="control-group">
					<div class="controls">
	  					<button type="submit" class="btn btn-primary">Reset Password</button>
					</div>
	  			</div>
				
			</form>
		</div>
	</div>
</cfoutput>