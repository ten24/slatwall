<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
	
<!--- Success/Fail Messages --->
<cfif $.slatwall.hasSuccessfulAction( "public:account.update" )>
	<div class="alert alert-success alert-dismissible fade show">
		Email address updated
		<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	</div>
<!--- If this item was just tried to be added, but failed then show the failure message --->
<cfelseif $.slatwall.hasFailureAction( "public:account.update" )>
	<div class="alert alert-danger alert-dismissible fade show">
		Error adding email
		<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	</div>
</cfif>	
	
<!--- Existing Email Addresses --->
<cfset accountEmailAddressIndex = 0 />

<table class="table table-condensed table-bordered table-striped table-responsive-sm">
	<!--- Loop over all of the existing email addresses --->
	<tbody>
		
		<cfloop array="#$.slatwall.getAccount().getAccountEmailAddressesSmartList().getRecords()#" index="accountEmailAddress">
			<cfset accountEmailAddressIndex++ />
		<!--- Display Email Address --->
			<tr>
				<td>#accountEmailAddress.getEmailAddress()#</td>
				<td>
					<cfif accountEmailAddress.getAccountEmailAddressID() eq $.slatwall.getAccount().getPrimaryEmailAddress().getAccountEmailAddressID()>
						<spqn class="badge badge-primary">
							<i class="fa fa-check-circle" title="#accountEmailAddress.getEmailAddress()# is the primary email address for this account"></i> Primary
						</spqn>
					<cfelse>
						<a href="?slatAction=public:account.update&primaryEmailAddress.accountEmailAddressID=#accountEmailAddress.getAccountEmailAddressID()#" title="Set #accountEmailAddress.getEmailAddress()# as your primary email address">Set Primary</a>&nbsp;
					</cfif>
				</td>
				<td>
					<cfif accountEmailAddress.getAccountEmailAddressID() neq $.slatwall.getAccount().getPrimaryEmailAddress().getAccountEmailAddressID()>
						<a href="?slatAction=public:account.deleteAccountEmailAddress&accountEmailAddressID=#accountEmailAddress.getAccountEmailAddressID()#" title="Delete Email Address - #accountEmailAddress.getEmailAddress()#">Delete</a>
					</cfif>
				</td>
			</tr>
		</cfloop>
	</tbody>
</table>

<hr>

<h5 class="my-4">Add New Email Address</h5>

<!--- Start: Add Email Address Form --->
<form action="?s=1" method="post" class="form-inline">
	<!--- Email Address --->
	<cfset newAccountEmailAddress = $.slatwall.getAccount().getNewPropertyEntity( 'accountEmailAddresses' ) />
	
	<!--- Hidden slatAction to update the account --->
	<input type="hidden" name="slatAction" value="public:account.update" />
	
	<!--- Because we want to have a new accountEmailAddress, we set the ID as blank for the account update ---> 
	<input type="hidden" name="accountEmailAddresses[1].accountEmailAddressID" value="" />
		
	<div class="form-group mr-sm-3">
		<sw:FormField type="text" name="accountEmailAddresses[1].emailAddress" valueObject="#newAccountEmailAddress#" valueObjectProperty="emailAddress" fieldAttributes='required' class="form-control" />
	</div>
	
	<!--- Email error message display --->
	<sw:ErrorDisplay object="#newAccountEmailAddress#" errorName="emailAddress" />
	
	<button type="submit" class="btn btn-primary">Submit</button>
</form>
</cfoutput>