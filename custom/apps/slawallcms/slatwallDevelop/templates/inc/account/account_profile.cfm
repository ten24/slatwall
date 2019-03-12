<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<!--- Profile Update Success Message --->
	<cfif $.slatwall.hasSuccessfulAction('public:account.update')>
		<div class="alert alert-success">Your account has been updated.</div>
	</cfif>
	
	<cfif $.slatwall.hasFailureAction('public:account.update')>
		<div class="alert alert-success">Your account could not be updated. See errors below.</div>
	</cfif>
	
	<!--- Profile Update Form --->
	<form action="?s=1" method="post">
		<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
		<input type="hidden" name="slatAction" value="public:account.update" />
		
		<div class="row">
			<div class="col-md-6">
				<!--- First Name --->
				<div class="form-group">
					<label for="firstName">First Name</label>
					<sw:FormField type="text" valueObject="#$.slatwall.getAccount()#" valueObjectProperty="firstName" class="form-control" fieldAttributes="required" />
					<sw:ErrorDisplay object="#$.slatwall.getAccount()#" errorName="firstName" />
		  		</div>
		  	</div>
			
			<div class="col-md-6">	
				<!--- Last Name --->
				<div class="form-group">
					<label for="lastName">Last Name</label>
					<sw:FormField type="text" valueObject="#$.slatwall.getAccount()#" valueObjectProperty="lastName" class="form-control" fieldAttributes="required" />
					<sw:ErrorDisplay object="#$.slatwall.getAccount()#" errorName="lastName" />
		  		</div>
		  	</div>
		  	
		  	<div class="col-md-6">
		  		<!--- Company / Organization --->
		  		<div class="form-group">
			  		<label for="organization">Organization</label>
					<sw:FormField type="text" valueObject="#$.slatwall.getAccount()#" valueObjectProperty="company" class="form-control" />
					<sw:ErrorDisplay object="#$.slatwall.getAccount()#" errorName="company" />
				</div>
			</div>
			
			<div class="col-md-6">
		  		<!--- Primary Phone Number --->
		  		<div class="form-group">
			  		<label for="organization">Phone Number</label>
					<sw:FormField type="text" valueObject="#$.slatwall.getAccount().getPrimaryPhoneNumber()#" valueObjectProperty="phoneNumber" class="form-control" fieldAttributes="required" />
					<sw:ErrorDisplay object="#$.slatwall.getAccount().getprimaryPhoneNumber()#" errorName="phoneNumber" />
				</div>
			</div>
			
			<div class="col-md-6">
		  		<!--- Primary Email Address --->
		  		<div class="form-group">
			  		<label for="organization">Email</label>
					<sw:Formfield type="text" valueObject="#$.slatwall.getAccount().getPrimaryEmailAddress()#" valueObjectProperty="emailAddress" class="form-control" fieldAttributes="disabled" />
					<small class="form-text text-muted"><a href="/my-account/login-information/">Update my account email login</a>
					<sw:ErrorDisplay object="#$.slatwall.getAccount().getPrimaryEmailAddress()#" errorName="emailAddress" />
				</div>
			</div>
		</div>
		<!--- Update Button --->
  		<button type="submit" class="btn btn-primary">Update Account</button>
	</form>
</cfoutput>