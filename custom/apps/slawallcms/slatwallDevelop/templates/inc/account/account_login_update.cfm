<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>

<sw:MessageDisplay />

<!--- Login Update Success Message --->
<cfif $.slatwall.hasSuccessfulAction('public:account.changePassword')>
	<div class="alert alert-success">Your password has been updated.</div>
</cfif>

<h4>Change Primary Email Login</h4>

<p>Primary Email login: <strong>#$.slatwall.getAccount().getPrimaryEmailAddress().getEmailAddress()#</strong></p>

<div class="row">
	<!--- Change Email login --->
	<div class="col-md-5">
		<form action="?s=1" method="post">
			<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
			<input type="hidden" name="slatAction" value="public:account.update" />
			
			<!--- Primary Email Address --->
	  		<div class="form-group">
		  		<label for="emailAddress">Email</label>
				<sw:FormField 
					type="text" 
					valueObject="#$.slatwall.getAccount().getPrimaryEmailAddress()#" 
					valueObjectProperty="emailAddress" 
					class="form-control" 
					fieldAttributes="required dataType='email'" />
				<small class="form-text text-muted">Enter new account email. This will change your account email used to login.</small>
				<sw:ErrorDisplay object="#$.slatwall.getAccount().getPrimaryEmailAddress()#" errorName="emailAddress" />
			</div>
			
			<!--- Confirm Email Address --->
	  		<div class="form-group">
		  		<label for="emailAddress">Confirm Email Address</label>
				<sw:FormField 
					type="text" 
					valueObject="#$.slatwall.getAccount().getPrimaryEmailAddress()#" 
					valueObjectProperty="emailAddress" 
					class="form-control" 
					fieldAttributes="required" />
				<sw:ErrorDisplay object="#$.slatwall.getAccount().getPrimaryEmailAddress()#" errorName="emailAddress" />
			</div>
			
			<div class="form-group">
  				<button type="submit" class="btn btn-primary">Update Email Login</button>
			</div>
		</form>
	</div>
</div>

<hr/>

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