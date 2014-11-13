<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.task" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		
		<!--- Left Side Top --->
		<cf_HibachiPropertyList divClass="col-md-6">
			<cf_HibachiPropertyDisplay object="#rc.task#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.task#" property="runningFlag" edit="false">
			<cf_HibachiPropertyDisplay object="#rc.task#" property="taskName" edit="#rc.edit#">
		</cf_HibachiPropertyList>
		
		<!--- Right Side Top --->
		<cf_HibachiPropertyList divClass="col-md-6">
			
			<cf_HibachiPropertyDisplay object="#rc.task#" property="taskMethod" edit="false">
			
			<!--- Show the config for this task's process method --->
			<cfif rc.task.hasProcessObject( rc.task.getTaskMethod() )>
				<cfset processObject = rc.task.getProcessObject( rc.task.getTaskMethod() ) />
				<cfloop array="#processObject.getProperties()#" index="property">
					<cfif structKeyExists(property, "sw_taskConfig") and property.sw_taskConfig>
						<cf_HibachiPropertyDisplay object="#processObject#" fieldName="taskConfig.#property.name#" property="#property.name#" edit="#rc.edit#">
					</cfif>
				</cfloop>
			</cfif>
			
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>