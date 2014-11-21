<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />
<div ng-controller="collections" style="margin-top:12px;">
	<div class="col-xs-12 s-filter-content">
	    <!--- Header nav with title start --->
	   <!--- <span ng-controller="collectionsTabController">--->
		<!---<span 	sw-header-with-tabs
				header-title="collection.collectionName"
				tab-array="[{tabTitle:'PROPERTIES',isActive:true,id:'properties'},
							{tabTitle:'FILTERS ('+filterCount+')',isActive:false,id:'filters'},
							{tabTitle:'DISPLAY OPTIONS',isActive:false,id:'display-options',directive:'sw-tab-display-options'}
				]"
		>
		</span>--->

	   
	    <!--- //Header nav with title end --->

	    <!--- Tab panes for menu options start--->

	    <div class="row s-options">
	      

	        
	          
	          <form  class="form-horizontal s-properties" role="form" name="collectionForm" ng-init="setCollectionFormScope(collectionForm)" >
	            <input  style="display:none" name="entityID" ng-model="collection.collectionID" type="hidden" value="">

	           <!-- <span 	sw-property-display
	            		object="collection"
	            		property="collectionName",
						is-editable="true"
	            ></span>-->
	            <div class="form-group">
	              <label class="col-sm-2 control-label" style="text-align:left;padding-left:40px;">Title:<span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection title"> <i class="fa fa-question-circle"></i></span></label>
	              <div class="col-sm-10">
	                <input ng-show="collectionDetails.isOpen"  ng-model="collection.collectionName" name="collectionName" type="text" class="form-control" id="inputPassword" value="" required>
	               	<span style="color:red"
				      ng-show="collectionForm.collectionName.$invalid && collectionForm.collectionName.$dirty" ng-bind="collection.collectionName">
				     
				    </span>
	                <p ng-show="!collectionDetails.isOpen" class="form-control-static" ng-bind="collection.collectionName"><!---collection Name ---></p>
	              </div>
	            </div>
	            <div class="form-group">
	              <label for="inputPassword" class="col-sm-2 control-label" style="text-align:left;padding-left:40px;">Code: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection code"> <i class="fa fa-question-circle"></i></span></label>
	              <div class="col-sm-10">
	                <input ng-show="collectionDetails.isOpen" ng-model="collection.collectionCode"  name="collectionCode" type="text" class="form-control" id="inputPassword" value="" >
	                <p ng-show="!collectionDetails.isOpen" class="form-control-static" ng-bind="collection.collectionCode"><!---collection Code ---></p>
	              	<span  style="color:red"
				      ng-show="collectionForm.collectionCode.$invalid && collectionForm.collectionCode.$dirty" ng-bind="collection.collectionCode">
				  
				    </span>
	              </div>
	            </div>
	            <div class="form-group">
	              <label for="inputPassword" class="col-sm-2 control-label" style="text-align:left;padding-left:40px;">Description: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection description"> <i class="fa fa-question-circle"></i></span></label>
	              <div class="col-sm-10">
	                <input ng-show="collectionDetails.isOpen"  ng-model="collection.description" name="description" type="text" class="form-control" id="inputPassword" value="" >
	                <p ng-show="!collectionDetails.isOpen" ng-bind="collection.description" class="form-control-static"><!---collection description ---></p>
	              	<span  style="color:red"
				      ng-show="collectionForm.description.$invalid && collectionForm.description.$dirty" ng-bind="collection.description" >
				      
				    </span>
	              </div>
	            </div>
	            <div class="form-group">
	              <label for="inputPassword" class="col-sm-2 control-label" style="text-align:left;padding-left:40px;">Collection Type: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection type"> <i class="fa fa-question-circle"></i></span></label>
	              <div class="col-sm-10">
	                <input ng-show="collectionDetails.isOpen" disabled="disabled"  ng-model="collectionConfig.baseEntityAlias" type="text" class="form-control" value="" >
	                <p ng-show="!collectionDetails.isOpen" ng-bind="collectionConfig.baseEntityAlias  | AliasDisplayName" class="form-control-static"><!---collection base entity alias ---></p>

	              </div>
	            </div>
	          </form>
	        </div>
	      

	    
	</div>
</div>
