<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.loyaltyAccruement" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<sw-collection-config-as-property
		data-base-entity-name="'Account'"
		data-property-name="'optionalTargetAccountConfig'"
		data-value='#rc.loyaltyAccruement.getOptionalTargetAccountConfig(true)#'
	></sw-collection-config-as-property>
</cfoutput>