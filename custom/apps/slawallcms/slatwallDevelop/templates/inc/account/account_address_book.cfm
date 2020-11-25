<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../../../tags">
<cfoutput>
<cfset accountAddressIndex = 0 />

<!--- Address Create/Edit/Delete Success/Fail Messages --->
<cfif $.slatwall.hasSuccessfulAction( "public:account.update" )>
	<div class="alert alert-success alert-dismissible fade show">
		Address has been updated.
		<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	</div>
<cfelseif $.slatwall.hasSuccessfulAction( "public:account.deleteAccountAddress" )>
	<div class="alert alert-info alert-dismissible fade show">
		Address has been deleted.
		<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	</div>
<!--- If this item was just tried to be added, but failed then show the failure message --->
<cfelseif $.slatwall.hasFailureAction( "public:account.update" )>
	<div class="alert alert-danger alert-dismissible fade show">
		Address was not upated. See below for errors.
		<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	</div>
</cfif>

<!--- Create Address --->
<div class="text-right mb-2">
	<button class="btn btn-secondary" type="button" data-toggle="collapse" data-target="##createAddress" onClick="$('.addresses').toggle()" aria-expanded="false" aria-controls="createAddress">
		<i class="fa fa-plus-circle"></i> Create Address
	</button>
</div>	

<!--- get the newPropertyEntity for accountAddress --->
<cfset newAccountAddress = $.slatwall.getAccount().getNewPropertyEntity( 'accountAddresses' ) />

<!--- This is the accordian details when expanded --->
<div id="createAddress" class="collapse<cfif newAccountAddress.hasErrors()> show</cfif>">
	<!--- Start: New Address Form --->
	<form action="?s=1" method="post">
		
		<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
		<input type="hidden" name="slatAction" value="public:account.update" />
		
		<!--- Set the accountAddressID to blank so tha it creates a new one --->
		<input type="hidden" name="accountAddresses[1].accountAddressID" value="" />
		
		<!--- Nickname --->
		<div class="form-group">
			<label for="nickName">Nickname</label>
			<sw:FormField type="text" name="accountAddresses[1].accountAddressName" valueObject="#newAccountAddress#" valueObjectProperty="accountAddressName" class="form-control" />
			<sw:ErrorDisplay object="#newAccountAddress#" errorName="accountAddressName" />
		</div>

		<!--- New Address --->
		<div class="form-group">
			<sw:AddressForm id="newAccountAddress" address="#newAccountAddress.getAddress()#" fieldNamePrefix="accountAddresses[1].address." fieldClass="form-control" />
		</div>
  		
  		<button type="submit" class="btn btn-primary">Add Address</button>
  		<button type="button" class="btn btn-secondary" data-toggle="collapse" data-target="##createAddress" onClick="$('.addresses').toggle()" aria-expanded="false" aria-controls="createAddress">Close</button>
	</form>
</div>

<!--- Address Listing/Edit --->
<div class="addresses row <cfif newAccountAddress.hasErrors()>d-none</cfif>">
<cfloop array="#$.slatwall.getAccount().getAccountAddressesSmartList().getRecords()#" index="accountAddress">
	<div class="col-md-6">
		<cfset accountAddressIndex++ />
		<!--- Display Address --->
		<div class="card mb-3 aa#accountAddressIndex#<cfif accountAddress.hasErrors()> collapse</cfif> <cfif accountAddress.getAccountAddressID() eq $.slatwall.getAccount().getPrimaryAddress().getAccountAddressID()>border-secondary</cfif>">
			<!--- Set Primary Address option --->
			<div class="card-header text-center">
				<cfif accountAddress.getAccountAddressID() neq $.slatwall.getAccount().getPrimaryAddress().getAccountAddressID()>
					<small><a href="?slatAction=public:account.update&primaryAddress.accountAddressID=#accountAddress.getAccountAddressID()#" title="Set this as your primary phone address">Set as Primary Address</a></small>
				<cfelse>
					<small><i class="fa fa-check-circle"></i> Primary Address</small>
				</cfif>
			</div>
			
			<div class="card-body">
				<!--- Address Nickname if it exists --->
				<cfif not isNull(accountAddress.getAccountAddressName())>
					<h5 class="card-title">#encodeForHTML( accountAddress.getAccountAddressName() )#</h5>
				</cfif>
				
				<!--- Address Details --->
				<div class="form-group">
					<sw:AddressDisplay address="#accountAddress.getAddress()#" />
				</div>
				<cfif accountAddress.getAccountAddressID() neq $.slatwall.getAccount().getPrimaryAddress().getAccountAddressID()>
					<small><a href="?slatAction=public:account.deleteAccountAddress&accountAddressID=#accountAddress.getAccountAddressID()#" title="Delete Address" class="card-link pull-left text-danger">Delete</a></small>
				</cfif>
				<small><a href="##" onClick="$('.aa#accountAddressIndex#').toggle()" title="Edit Address" class="card-link pull-right">Edit</a></small>
			</div>
		</div>
	</div>
		
	<!--- Edit Address --->
	<div class="col-12 aa#accountAddressIndex#<cfif not accountAddress.hasErrors()> collapse</cfif>">
		
		<!--- Start: Edit Address Form --->
		<form action="?s=1" method="post" class="mb-4">
			
			<!--- This hidden input is what tells slatwall to 'create' an account, it is then chained by the 'login' method so that happens directly after --->
			<input type="hidden" name="slatAction" value="public:account.update" />
			
			<input type="hidden" name="accountAddresses[1].accountAddressID" value="#accountAddress.getAccountAddressID()#" />
			
			<!--- Nickname --->
			<label for="nickName">Nickname</label>
			<sw:FormField type="text" name="accountAddresses[1].accountAddressName" valueObject="#accountAddress#" valueObjectProperty="accountAddressName" class="form-control" />
			<sw:ErrorDisplay object="#accountAddress#" errorName="accountAddressName" />

			<!--- Address --->
			<div class="form-group">
				<sw:AddressForm address="#accountAddress.getAddress()#" fieldNamePrefix="accountAddresses[1].address." fieldClass="form-control" />
			</div>
			<!--- Update Button --->
  			<button type="submit" class="btn btn-primary">Save</button>
  			<a href="##" onClick="$('.aa#accountAddressIndex#').toggle()" title="Edit Address" class="btn btn-secondary">Close</a>

		</form>

	</div>
	
</cfloop>
</div>
</cfoutput>