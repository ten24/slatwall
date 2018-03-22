<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.src" type="any" default="" />
	<cfparam name="attributes.type" type="any" default="" />
	<cfoutput>
		<script src="#attributes.src#?instantiationKey=#attributes.hibachiScope.getApplicationValue('instantiationKey')#" type="#attributes.type#"></script>
	</cfoutput>
</cfif>
