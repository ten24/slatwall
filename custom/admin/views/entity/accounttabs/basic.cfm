<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divclass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="firstName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="lastName" edit="#rc.edit#">
            <hb:HibachiPropertyDisplay object="#rc.account#" property="SpouseName" edit="#rc.edit#">			    
			<hb:HibachiPropertyDisplay object="#rc.account#" property="company" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="birthDate" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="genderFullWord" edit="false">   
			<hb:HibachiPropertyDisplay object="#rc.account#" property="complianceStatus" edit="false" attributeFlag="true">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="username" edit="false">
			<div class="form-group">
				<label class="control-label col-sm-4 title">#$.slatwall.rbKey('entity.account.accountNumber')#</label>
				<div class="col-sm-8">
					<p class="form-control-static value">
						#rc.account.getAccountNumber()# 
						<cfif not isNull(rc.account.getLastSyncedDateTime())>
							( <b class="text-success">Synced to Infotrax ICE</b> )
							<cfelse>
							( <b class="text-danger">NOT Synced to Infotrax ICE</b> )
						</cfif>
					</p>

				</div>
			</div>
			
			
		</hb:HibachiPropertyList>
      
		<!--- Overview --->
		<hb:HibachiPropertyList divclass="col-md-6">
		    
		    <cfif NOT IsNULL(rc.account.getAddress())> 
			<hb:HibachiPropertyDisplay object="#rc.account#" property="address" edit="false">
			</cfif>      
		    <hb:HibachiPropertyDisplay object="#rc.account#" property="languagePreference" value="#rc.account.getLanguagePreferenceLabel()#" edit="false">      
			<hb:HibachiPropertyDisplay object="#rc.account#" property="phoneNumber" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="emailAddress" edit="false">  
			<hb:HibachiPropertyDisplay object="#rc.account#" property="accountType" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="superUserFlag" edit="#rc.edit and $.slatwall.getAccount().getSuperUserFlag()#">
			<cfif NOT IsNULL( rc.account.getOwnerAccount() )>
				<hb:HibachiPropertyDisplay object="#rc.account.getOwnerAccount()#" property="fullName" edit="false" title = "Sponsor Name"> 
			</cfif>
			<cfif NOT IsNULL(rc.account.getGovernmentIdentificationLastFour())> 
			<hb:HibachiPropertyDisplay object="#rc.account#" property="GovernmentIdentificationLastFour" edit="false">
			</cfif>
		    	<cfif NOT IsNULL(rc.account.getEnrollmentDate())> 
			<hb:HibachiPropertyDisplay object="#rc.account#" property="enrollmentDate" edit="false">
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.account#" property="renewalDate" edit="false">	
			
		
			
			
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
