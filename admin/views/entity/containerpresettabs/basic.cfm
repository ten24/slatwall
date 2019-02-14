<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.containerPreset" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<div class="col-md-6">
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<input name="dimensionUnit.unitCode" type="hidden" value="in">
			    <hb:HibachiPropertyDisplay object="#rc.containerPreset#" property="containerName" edit="#rc.edit#">
            	<hb:HibachiPropertyDisplay object="#rc.containerPreset#" property="height" edit="#rc.edit#">
            	<hb:HibachiPropertyDisplay object="#rc.containerPreset#" property="width" edit="#rc.edit#">
            	<hb:HibachiPropertyDisplay object="#rc.containerPreset#" property="depth" edit="#rc.edit#">
            	<hb:HibachiPropertyDisplay object="#rc.containerPreset#" property="bottleSize" edit="#rc.edit#">
           		<hb:HibachiPropertyDisplay object="#rc.containerPreset#" property="maxQuantity" edit="#rc.edit#">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
	</div>
</cfoutput>


