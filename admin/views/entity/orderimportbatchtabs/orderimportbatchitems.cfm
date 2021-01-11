<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.orderImportBatch" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset rc.orderImportBatchItemCollectionList = rc.orderImportBatch.getOrderImportBatchItemsCollectionList() />

<cfset rc.orderImportBatchItemCollectionList.setDisplayProperties('orderImportBatchItemStatusType.typeName,accountNumber,skuCode,quantity,name,streetAddress,street2Address,city,stateCode,locality,postalCode,countryCode,phoneNumber,processingErrors',{isVisible=true,isSearchable=true}) />
<cfif NOT isNull(rc.orderImportBatch.getOrderType()) AND rc.orderImportBatch.getOrderType().getSystemCode() == "otReplacementOrder" >
	<cfset rc.orderImportBatchItemCollectionList.addDisplayProperty(displayProperty='originalOrderNumber', columnConfig={isVisible:true}, prepend=true)/>
</cfif>
<!--- ottSchedule, using ID to improve performance --->
<cfset rc.orderImportBatchItemCollectionList.setOrderBy('accountNumber|asc')/>


<cfoutput>
	</form>
	<hb:HibachiEntityProcessForm
		entity="#rc.orderImportBatch#"
		processContext="deleteOrderImportBatchItems"
		sRenderItem="detailorderimportbatch"
		fRenderItem="editorderimportbatch">
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiListingDisplay
					collectionList="#rc.orderImportBatchItemCollectionList#"
					usingPersonalCollection="false"
					multiselectPropertyIdentifier="orderImportBatchItemID"
					multiselectFieldName="orderImportBatchItemIDs"
				>
				</hb:HibachiListingDisplay>
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		<div class="row">
			<div class="col-xs-12">
				<a ng-if="#rc.edit#" ng-cloak class="btn btn-danger modalload" target="_self" data-toggle="modal" data-target="##modalConfirm">
					Delete Checked Items
				</a>
				<button ng-if="!#rc.edit#" disabled ng-cloak class="btn btn-danger modalload">
					Delete Checked Items
				</a>
			</div>
			<div class="modal" id="modalConfirm" tabindex="-1" role="dialog" aria-hidden="true">
				<div class="modal-dialog">
				   <div class="modal-content">
				      <div class="modal-header">
				         <a class="close" data-dismiss="modal">&times;</a>
				         <h3>Delete Checked Items</h3>
				      </div>
				      <div class="modal-body">
				         <p><span>#$.slatwall.rbKey('define.delete.message')#</span></p>
				      </div>
				      <div class="modal-footer">
				         <a class="btn btn-default s-remove" data-dismiss="modal"><span class="glyphicon glyphicon-remove icon-white"></span> Cancel</a>
				         <button class="btn btn-danger" 
				            title="Delete"
				            type="submit"
				         >
				        	<i class="glyphicon glyphicon-ok icon-white"></i> Delete
				         </button>
				      </div>
				   </div>
				</div>
			</div>
		</div>
	</hb:HibachiEntityProcessForm>
	<form>
</cfoutput>	