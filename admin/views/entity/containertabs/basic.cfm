<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.container" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<div class="col-md-6">
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
			    <hb:HibachiPropertyDisplay object="#rc.container.getContainerPreset()#" property="containerName" edit="#rc.edit#">
            	<hb:HibachiPropertyDisplay object="#rc.container#" property="height" edit="#rc.edit#">
            	<hb:HibachiPropertyDisplay object="#rc.container#" property="width" edit="#rc.edit#">
            	<hb:HibachiPropertyDisplay object="#rc.container#" property="depth" edit="#rc.edit#">
            	<hb:HibachiPropertyDisplay object="#rc.container#" property="weight" edit="#rc.edit#">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
	</div>
</cfoutput>


