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
			<hb:HibachiPropertyDisplay object="#rc.account#" property="company" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="birthDate" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="genderFullWord" edit="false">   
			<hb:HibachiPropertyDisplay object="#rc.account#" property="complianceStatus" edit="false">
			<hb:HibachiPropertyDisplay object="#rc.account#" property="username" edit="false">
			     
			
			
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
