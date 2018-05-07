<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<!--- CREATE ACCOUNT --->
	<div class="span6">
		<h5>Create New Account</h5>
		
		<!--- Sets up the create account processObject --->
		<cfset createAccountObj = $.slatwall.account().getProcessObject('create') />
		
		<!--- Create Account Form --->
		<form action="?s=1" method="post">
			<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
			<input type="hidden" name="slatAction" value="public:account.create,public:account.login" />
			
			<!--- This is passed so that we force the creation of a password and this isn't just a guest checkout --->
			<input type="hidden" name="createAuthenticationFlag" value="1" />
			
			<!--- Name --->
			<div class="row">
				
				<!--- First Name --->
				<div class="span3">
					<div class="control-group">
    					<label class="control-label" for="rating">First Name</label>
    					<div class="controls">
    						
							<sw:FormField type="text" valueObject="#createAccountObj#" valueObjectProperty="firstName" class="span3" />
							<sw:ErrorDisplay object="#createAccountObj#" errorName="firstName" />
							
    					</div>
  					</div>
				</div>
				
				<!--- Last Name --->
				<div class="span3">
					<div class="control-group">
    					<label class="control-label" for="rating">Last Name</label>
    					<div class="controls">
    						
							<sw:FormField type="text" valueObject="#createAccountObj#" valueObjectProperty="lastName" class="span3" />
							<sw:ErrorDisplay object="#createAccountObj#" errorName="lastName" />
							
    					</div>
  					</div>
				</div>
				
			</div>
			
			<!--- Phone Number --->
			<div class="control-group">
				<label class="control-label" for="rating">Phone Number</label>
				<div class="controls">
					
					<sw:FormField type="text" valueObject="#createAccountObj#" valueObjectProperty="phoneNumber" class="span6" />
					<sw:ErrorDisplay object="#createAccountObj#" errorName="phoneNumber" />
					
				</div>
  			</div>
			
			<!--- Email Address --->
			<div class="control-group">
				<label class="control-label" for="rating">Email Address</label>
				<div class="controls">
					
					<sw:FormField type="text" valueObject="#createAccountObj#" valueObjectProperty="emailAddress" class="span6" />
					<sw:ErrorDisplay object="#createAccountObj#" errorName="emailAddress" />
					
				</div>
  			</div>
			
			<!--- Email Address Confirm --->
			<div class="control-group">
				<label class="control-label" for="rating">Confirm Email Address</label>
				<div class="controls">
					
					<sw:FormField type="text" valueObject="#createAccountObj#" valueObjectProperty="emailAddressConfirm" class="span6" />
					<sw:ErrorDisplay object="#createAccountObj#" errorName="emailAddressConfirm" />
					
				</div>
  			</div>
			
			<!--- Password --->
			<div class="control-group">
				<label class="control-label" for="rating">Password</label>
				<div class="controls">
					
					<sw:FormField type="password" valueObject="#createAccountObj#" valueObjectProperty="password" class="span6" />
					<sw:ErrorDisplay object="#createAccountObj#" errorName="password" />
					
				</div>
  			</div>
			
			<!--- Password Confirm --->
			<div class="control-group">
				<label class="control-label" for="rating">Confirm Password</label>
				<div class="controls">
					
					<sw:FormField type="password" valueObject="#createAccountObj#" valueObjectProperty="passwordConfirm" class="span6" />
					<sw:ErrorDisplay object="#createAccountObj#" errorName="password" />
					
				</div>
  			</div>
			
			<!--- Create Button --->
			<div class="control-group pull-right">
				<div class="controls">
  					<button type="submit" class="btn btn-primary">Create Account & Continue</button>
				</div>
  			</div>
			
		</form>
		<!--- End: Create Account Form --->
		
		
	</div>
</cfoutput>