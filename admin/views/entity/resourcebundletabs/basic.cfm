<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.resourceBundle" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="resourceBundleKey" edit="#rc.edit#" requiredFlag="true">
		
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="en" edit="#rc.edit#"> 
		
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="enUs" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="enGb" edit="#rc.edit#">	
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="es" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="fr" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="ga" edit="#rc.edit#" >
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="pl" edit="#rc.edit#">    
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="de" edit="#rc.edit#">   
		
			<hb:HibachiPropertyDisplay object="#rc.resourceBundle#" property="activeFlag" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput> 