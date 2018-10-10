<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	<!--- START: EMAIL ADDRESSES --->
	<div class="span4">
		<h5>Email Addresses</h5>
		
		<!--- Existing Email Addresses --->
		<table class="table table-condensed">
			
			<cfset accountEmailAddressIndex = 0 />
			
			<!--- Loop over all of the existing email addresses --->
			<cfloop array="#$.slatwall.getAccount().getAccountEmailAddressesSmartList().getRecords()#" index="accountEmailAddress">
				
				<cfset accountEmailAddressIndex++ />
				
				<tr>
					<td>
						

						<!--- Display Email Address --->
						<div class="aea#accountEmailAddressIndex#<cfif accountEmailAddress.hasErrors()> hide</cfif>">
							
							<!--- Email Address --->
							<span>#accountEmailAddress.getEmailAddress()# ( <cfif accountEmailAddress.getVerifiedFlag()>verified<cfelse><a href="?slatAction=public:account.sendAccountEmailAddressVerificationEmail&accountEmailAddressID=#accountEmailAddress.getAccountEmailAddressID()#">Verify Now</a></cfif> )</span>
							<!---[DEVELOPER NOTES]
								We are displaying a 'verified' value next to the email address, however you do not need to have email addresses get verified
								for slatwall to function properly.  If you choose not to use verifications then you can just remove the links and let
								email addresses stay unverified.
							--->
							
							<!--- Admin buttons --->
							<span class="pull-right">
								<a href="##" onClick="$('.aea#accountEmailAddressIndex#').toggle()" title="Edit Email Address"><i class="icon-pencil"></i></a>
								<cfif accountEmailAddress.getAccountEmailAddressID() neq $.slatwall.getAccount().getPrimaryEmailAddress().getAccountEmailAddressID()>
									<a href="?slatAction=public:account.deleteAccountEmailAddress&accountEmailAddressID=#accountEmailAddress.getAccountEmailAddressID()#" title="Delete Email Address - #accountEmailAddress.getEmailAddress()#"><i class="icon-trash"></i></a>
								</cfif>
								<cfif accountEmailAddress.getAccountEmailAddressID() eq $.slatwall.getAccount().getPrimaryEmailAddress().getAccountEmailAddressID()>
									<i class="icon-asterisk" title="#accountEmailAddress.getEmailAddress()# is the primary email address for this account" style="margin-right:5px;"></i>
								<cfelse>
									<a href="?slatAction=public:account.update&primaryEmailAddress.accountEmailAddressID=#accountEmailAddress.getAccountEmailAddressID()#" title="Set #accountEmailAddress.getEmailAddress()# as your primary email address"><i class="icon-asterisk"></i></a>&nbsp;
								</cfif>
							</span>
							
						</div>
						
						<!--- Edit Email Address --->
						<div class="aea#accountEmailAddressIndex#<cfif not accountEmailAddress.hasErrors()> hide</cfif>">
							
							<!--- Start: Edit Email Address --->
							<form action="?s=1" method="post">
								
								<input type="hidden" name="slatAction" value="public:account.update" />
								<input type="hidden" name="accountEmailAddresses[1].accountEmailAddressID" value="#accountEmailAddress.getAccountEmailAddressID()#" />
								
								<!--- Email Address --->
								<div class="control-group">
			    					<div class="controls">
			    						
										<div class="input-append">
											<sw:FormField type="text" name="accountEmailAddresses[1].emailAddress" valueObject="#accountEmailAddress#" valueObjectProperty="emailAddress" class="span3" />
											<button type="button" class="btn" onClick="$('.aea#accountEmailAddressIndex#').toggle()">x</button>
											<button type="submit" class="btn btn-primary">Save</button>
										</div>
										
										<sw:ErrorDisplay object="#accountEmailAddress#" errorName="emailAddress" />
										
			    					</div>
			  					</div>
								
							</form>
							<!--- End: Edit Email Address --->
						</div>
						
					</td>
				</tr>
				
			</cfloop>
		</table>
		
		<!--- Start: Add Email Address Form --->
		<form action="?s=1" method="post">
			
			<!--- Hidden slatAction to update the account --->
			<input type="hidden" name="slatAction" value="public:account.update" />
			
			<!--- Because we want to have a new accountEmailAddress, we set the ID as blank for the account update ---> 
			<input type="hidden" name="accountEmailAddresses[1].accountEmailAddressID" value="" />
			
			<!--- Email Address --->
			<div class="control-group">
				<div class="controls">
					
					<cfset newAccountEmailAddress = $.slatwall.getAccount().getNewPropertyEntity( 'accountEmailAddresses' ) />
					
					<div class="input-append">
						<sw:FormField type="text" name="accountEmailAddresses[1].emailAddress" valueObject="#newAccountEmailAddress#" valueObjectProperty="emailAddress" fieldAttributes='placeholder="Add Email Address"' class="span3" />
						<button type="submit" class="btn btn-primary"><i class="icon-plus icon-white"></i></button>
					</div>
					
					<sw:ErrorDisplay object="#newAccountEmailAddress#" errorName="emailAddress" />
					
				</div>
  			</div>
			
		</form>
		<!--- End: Add Email Address Form --->
		
		<br />
														
	</div>
	<!--- END: EMAIL ADDRESSES --->
</cfoutput>