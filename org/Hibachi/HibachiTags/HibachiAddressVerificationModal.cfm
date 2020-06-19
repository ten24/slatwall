<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

	<cfset local.modalID = createUUID() />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<cfif structKeyExists(request.context,"addressVerificationStruct") AND NOT request.context.addressVerificationStruct.success >
			<div class="modal fade in" id="#local.modalID#">
			    <div class="modal-dialog">
			        <div class="modal-content">
			            <div class="modal-body">
			                <!--- TODO add padding to title --->
			                <h4>#request.context.addressVerificationStruct.message#</h4><br>
			                
							<cfif structKeyExists(request.context,"suggestedAddressName")>
								<hb:HibachiActionCaller 
									action="admin:entity.updateAddressWithSuggestedAddress" 
									queryString="redirectAction=detailOrderFulfillment&addressID=#request.context.addressVerificationStruct.suggestedAddress.addressID#&orderFulfillmentID=#request.context.orderFulfillmentID#" 
									text="Suggested Address: #request.context.suggestedAddressName#"
									class="list-group-item list-group-item-action">
			                </cfif>
			                <a
			                    class="list-group-item list-group-item-action" 
			                    href="##"
			                    data-dismiss="modal" 
			                    >Continue With Unverified Address
			                </a>
			            </div>
			        </div><!-- /.modal-content -->
			    </div><!-- /.modal-dialog -->
			</div>
			<script>$("###local.modalID#").modal("show");</script>
		</cfif>
	</cfoutput>	
</cfif>