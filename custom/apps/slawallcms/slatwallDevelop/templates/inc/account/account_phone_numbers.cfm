<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags" />
<cfinclude template="account_phone_numbers_collection.cfm" />

<cfoutput>
<!--- Success/Fail Messages --->
<cfif $.slatwall.hasSuccessfulAction( "public:account.update" )>
	<div class="alert alert-success alert-dismissible fade show">
		Phone number updated
		<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	</div>
<!--- If this item was just tried to be added, but failed then show the failure message --->
<cfelseif $.slatwall.hasFailureAction( "public:account.update" )>
	<div class="alert alert-danger alert-dismissible fade show">
		Error updating phone number
		<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	</div>
</cfif>	

<!--- START: PHONE NUMBERS --->
<cfset accountPhoneNumberIndex=0 />

<table class="table table-condensed table-bordered table-striped table-responsive-sm">
	<tbody>
		<!--- Loop over the phone numbers to display them --->
		<cfloop  array="#local.phoneNumbers#" index="phoneNumber">
			<cfset accountPhoneNumberIndex++ />
		
			<tr>
				<td>#phoneNumber['phoneNumber']#</td>
				<td>
					<a href="##" onClick="$('.apn#accountPhoneNumberIndex#').toggle()" title="Edit Phone Number">Edit</a>
				</td>
				<td>
					<cfif phoneNumber['accountPhoneNumberID'] eq $.slatwall.getAccount().getPrimaryPhoneNumber().getAccountPhoneNumberID()>
						<spqn class="badge badge-primary">
							<i class="fa fa-check-circle" title="#phoneNumber['phoneNumber']# is the primary phone number for this account"></i>
						</span>
					<cfelse>
						<a href="?slatAction=public:account.update&primaryPhoneNumber.accountPhoneNumberID=#phoneNumber['accountPhoneNumberID']#" title="Set #phoneNumber['phoneNumber']# as your primary phone number">Set Primary</a>	
					</cfif>
				</td>
				<td>
					<a href="?slatAction=public:account.deleteAccountPhoneNumber&accountPhoneNumberID=#phoneNumber['accountPhoneNumberID']#" title="Delete Phone Number - #phoneNumber['phoneNumber']#">Delete</a>
				</td>
			</tr>
			<!--- Edit Number--->
			<!---<div class="apn#accountPhoneNumberIndex#<cfif not accountPhoneNumber.hasErrors()> hide</cfif>">
				<!--- Start: Edit Phone Number --->
				<form action="?s=1" method="post">
					<input type="hidden" name="slatAction" value="public:account.update" />
					<input type="hidden" name="accountPhoneNumbers[1].accountPhoneNumberID" value="#accountPhoneNumber.getAccountPhoneNumberID()#" />
					<!--- Phone Number --->
					<sw:FormField type="text" name="accountPhoneNumbers[1].phoneNumber" valueObject="#accountPhoneNumber#" valueObjectProperty="phoneNumber" fieldAttributes='required' class="form-control" />
					<button type="button" class="btn btn btn-secondary" onClick="$('.apn#accountPhoneNumberIndex#').toggle()">x</button>
					<button type="submit" class="btn btn-primary">Save</button>
					<sw:ErrorDisplay object="#accountPhoneNumber#" errorName="phoneNumber" />
				</form>
			</div>--->
		</cfloop>
	</tbody>
</table>

<hr>

<h5 class="my-4">Add New Phone Number</h5>

<!--- Start: Add Phone Number Form --->
<form action="?s=1" method="post" class="form-inline">
	<cfset newAccountPhoneNumber = $.slatwall.getAccount().getNewPropertyEntity( 'accountPhoneNumbers' ) />
	<input type="hidden" name="slatAction" value="public:account.update" />
	<input type="hidden" name="accountPhoneNumbers[1].accountPhoneNumberID" value="" />
	<div class="form-group mr-sm-3">
		<sw:FormField type="text" name="accountPhoneNumbers[1].phoneNumber" valueObject="#newAccountPhoneNumber#" valueObjectProperty="phoneNumber" fieldAttributes='required' class="form-control" />
		<sw:ErrorDisplay object="#newAccountPhoneNumber#" errorName="phoneNumber" />
  	</div>
  	<button type="submit" class="btn btn-primary">Submit</button>
</form>
</cfoutput>