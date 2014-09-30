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
		
	    <!---</span>--->
	    <div class="row s-header-bar">
	      <div class="col-md-5 s-header-nav">
	        <ul class="nav nav-tabs" role="tablist">
	          <li class="active"><a href="##j-properties" role="tab" data-toggle="tab">PROPERTIES</a></li>
	          <li><a href="##j-filters" role="tab" data-toggle="tab">FILTERS <span>(<span ng-bind="filterCount()"></span>)</span></a></li>
	          <li><a href="##j-display-options" role="tab" data-toggle="tab">DISPLAY OPTIONS</a></li>
	        </ul>
	      </div>
	    </div>
	    <!--- //Header nav with title end --->
	
	    <!--- Tab panes for menu options start--->
	    
	    <div class="row s-options">
	      <div class="tab-content" id="j-property-box">
	
	        <div class="tab-pane active" id="j-properties">
	          <span class="s-edit-btn-group">
	          	  <button class="btn btn-xs s-btn-ten24" id="j-save-btn" ng-click="saveCollection()" ng-show="collectionDetails.isOpen">
	          		<i class="fa fa-floppy-o"></i> 
	          		Save
		          </button> 
		          <button class="btn btn-xs s-btn-lgrey" id="j-edit-btn" ng-click="collectionDetails.openCollectionDetails()" ng-show="!collectionDetails.isOpen">
		          	<i class="fa fa-pencil"></i> 
		          	Edit
		          </button>
	         </span>
	          <form  class="form-horizontal s-properties" role="form" name="collectionForm" ng-init="setCollectionFormScope(collectionForm)" >
	            <input  style="display:none" name="entityID" ng-model="collection.collectionID" type="hidden" value="">
	            	
	           <!-- <span 	sw-property-display
	            		object="collection"
	            		property="collectionName",
						is-editable="true"
	            ></span>-->
	            <div class="form-group">
	              <label class="col-sm-2 control-label">Title:<span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection title"> <i class="fa fa-question-circle"></i></span></label>
	              <div class="col-sm-10">
	                <input ng-show="collectionDetails.isOpen"  ng-model="collection.collectionName" name="collectionName" type="text" class="form-control" id="inputPassword" value="" required>
	               	<span style="color:red"
				      ng-show="collectionForm.collectionName.$invalid && collectionForm.collectionName.$dirty">
				      {{errorMessage.collectionName}}
				    </span>
	                <p ng-show="!collectionDetails.isOpen" class="form-control-static" ng-bind="collection.collectionName"><!---collection Name ---></p>
	              </div>
	            </div>
	            <div class="form-group">
	              <label for="inputPassword" class="col-sm-2 control-label">Code: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection code"> <i class="fa fa-question-circle"></i></span></label>
	              <div class="col-sm-10">
	                <input ng-show="collectionDetails.isOpen" ng-model="collection.collectionCode"  name="collectionCode" type="text" class="form-control" id="inputPassword" value="" required>
	                <p ng-show="!collectionDetails.isOpen" class="form-control-static" ng-bind="collection.collectionCode"><!---collection Code ---></p>
	              	<span  style="color:red"
				      ng-show="collectionForm.collectionCode.$invalid && collectionForm.collectionCode.$dirty">
				      {{errorMessage.collectionCode}}
				    </span>
	              </div>
	            </div>
	            <div class="form-group">
	              <label for="inputPassword" class="col-sm-2 control-label">Description: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection description"> <i class="fa fa-question-circle"></i></span></label>
	              <div class="col-sm-10">
	                <input ng-show="collectionDetails.isOpen"  ng-model="collection.description" name="description" type="text" class="form-control" id="inputPassword" value="" >
	                <p ng-show="!collectionDetails.isOpen" ng-bind="collection.description" class="form-control-static"><!---collection description ---></p>
	              	<span  style="color:red"
				      ng-show="collectionForm.description.$invalid && collectionForm.description.$dirty">
				      {{errorMessage.description}}
				    </span>
	              </div>
	            </div>
	            <div class="form-group">
	              <label for="inputPassword" class="col-sm-2 control-label">Collection Type: <span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="The collection type"> <i class="fa fa-question-circle"></i></span></label>
	              <div class="col-sm-10">
	                <input ng-show="collectionDetails.isOpen" disabled="disabled"  ng-model="collectionConfig.baseEntityAlias" type="text" class="form-control" value="" >
	                <p ng-show="!collectionDetails.isOpen" ng-bind="collectionConfig.baseEntityAlias" class="form-control-static"><!---collection base entity alias ---></p>
	              	
	              </div>
	            </div>
	          </form>
	        </div>
	        <div class="tab-pane" id="j-filters">
	          <div class="s-setting-options">
	            <div class="row s-setting-options-body">
	
	              <!--- Start Filter Group --->
	              <div class="col-xs-12 s-filters-selected">
	                <div class="row">
	                	<!---filterGroups gets taken apart here --->
	                	<ul class="col-xs-12 list-unstyled" 
	                		sw-filter-groups 
	                		data-filter-group="collectionConfig.filterGroups[0]"
	                		data-filter-group-item="collectionConfig.filterGroups[0].filterGroup"
	                		data-filter-properties-list="filterPropertiesList"
	                		data-save-collection="saveCollection()"
	                		>
	                	</ul>
	                </div>
	                <!--- //New Filter Panel --->
	              </div>
	              <!--- //End Filter Group --->
	            </div>
	          </div>
	        </div><!--- //Tab Pane --->
	        <div class="tab-pane s-display-options" id="j-display-options">
				<span  sw-display-options
					data-columns="collectionConfig.columns"
					data-properties-list="filterPropertiesList"
					data-save-collection="saveCollection()"
					data-callbacks="callbacks"
					data-base-entity-alias="collectionConfig.baseEntityAlias"
				>
					<li class="list-group-item" 
							ng-repeat="column in collectionConfig.columns" 
							sw-column-item
							data-column="column"
							data-column-index="$index"
							data-save-collection="saveCollection()"
							data-properties-list="filterPropertiesList"
							data-callbacks="callbacks"
							
					></li>
				</span >
			</div><!--- //Tab Pane --->
	      </div>
	
	    </div><!--- //Row --->
	    <!--- //Tab panes for menu options end--->
	    <div class="row s-table-header-nav">
	      <div class="col-xs-6">
	      	<!---TODO: implement keyword searching and bulk actions --->
		      <ul class="list-inline list-unstyled">
			      <!--<li>
		            <form role="search">
		
		                <label for="name" class="control-label"><i class="fa fa-level-down"></i></label>
		                <select size="1" name="" aria-controls="" class="form-control accordion-dropdown">
		                  <option value="15" selected="selected" disabled="disabled">Bulk Action</option>
		                  <option value="j-export-link" data-toggle="collapse">Export</option>
		                  <option value="j-delete-link" data-toggle="collapse">Delete</option>
		                </select>
		
		            </form>
		          </li>-->
			      <li style="width:200px;">
			        <form   class="s-table-header-search">
			          <div class="input-group">
			            <input  type="text" 
			            		class="form-control input-sm" 
			            		placeholder="Search" 
			            		name="srch-term" 
			            		ng-model="keywords"
			            />
			            <div class="input-group-btn">
			              <button   class="btn btn-default btn-sm" 
			              			type="submit"
			              			ng-click="searchCollection()"
			              >
			              	<i class="fa fa-search"></i>
			              </button>
			            </div>
			          </div>
			        </form>
			      </li>
			    </ul>
		  	</div>
	        <span   sw-pagination-bar
		      		data-collection="collection"
		      		data-current-page="currentPage"
		      		data-page-show="pageShow"
		      		data-page-start="pageStart"
		      		data-page-end="pageEnd"
		      		data-records-count="recordsCount"
	        >
	        </span>
	        
	 	</div>
	 	
	 	<span 	sw-export-action
	 			
	 	>
	 	</span>
	
	    <!--delete batch action-->
	    <div id="j-delete-link" class="row collapse s-batch-options">
	      <div class="col-md-12 s-add-filter">
	
	        <!--- Edit Filter Box --->
	
	          <h4> Delete:<i class="fa fa-times" data-toggle="collapse" data-target="#j-delete-link"></i></h4>
	          <div class="col-xs-12">
	
	            <div class="row">
	              <div class="col-xs-2">
	                <div class="form-group form-group-sm">
	                  <label class="col-sm-12 control-label s-no-padding" for="formGroupInputSmall">Items To Delete:</label>
	                  <div class="col-sm-12 s-no-paddings">
	
	                    <div class="radio">
	                      <input type="radio" name="radio1" id="radio7" value="option2" checked="checked">
	                      <label for="radio7">
	                          All
	                      </label>
	                    </div>
	                    <div class="radio">
	                      <input type="radio" name="radio1" id="radio7" value="option2">
	                      <label for="radio7">
	                          Visable
	                      </label>
	                    </div>
	                    <div class="radio">
	                      <input type="radio" name="radio1" id="radio7" value="option2">
	                      <label for="radio7">
	                          Selected
	                      </label>
	                    </div>
	                  </div>
	                  <div class="clearfix"></div>
	                </div>
	              </div>
	              <div class="col-xs-7 s-criteria">
	
	                <div class="alert alert-danger" role="alert">
	                  <div class="input-group">
	                    <label>Confirm action by typing "DELETE" below.</label>
	                    <input type="text" class="form-control j-delete-text" placeholder="">
	
	                  </div>
	                </div>
	
	              </div>
	              <div class="col-xs-2">
	                <div class="s-button-select-group">
	                  <button type="button" class="btn btn-sm s-btn-ten24 j-delete-btn" disabled="disabled" style="width:100%;">Delete</button>
	                </div>
	              </div>
	            </div>
	          </div>
	
	        <!--- //Edit Filter Box --->
	      </div>
	    </div>
	    <!--//delete batch action-->
	     
		<!---TODO: make this list view section a directive that we pass a collection into --->
	    <!---list view begin --->
	     <div class="table-responsive s-filter-table-box">
		    <table class="table table-bordered table-striped" > 
		        <thead>
		            <tr>
		                <th>Row</span></th>
		                <th ng-repeat="(key,column) in collectionConfig.columns" class="s-sortable" ng-bind="column.title" ng-show="column.isVisible"></th>
		                <th></th>
		            </tr>
		        </thead>
		        <tbody sw-scroll-trigger 
	    		infinite-scroll="appendToCollection()"		
	    		infinite-scroll-disabled="autoScrollDisabled"
	    		infinite-scroll-distance="1">
					<tr ng-repeat="pageRecord in collection.pageRecords">
			            <td> <div class="s-checkbox"><input type="checkbox" id="j-checkbox"><label for="j-checkbox"></label></div></td>
			            <td ng-repeat="(key,column) in collectionConfig.columns" ng-bind="pageRecord[column.propertyIdentifier.split('.').pop()]" ng-show="column.isVisible"></td>
			            <td class="s-edit-elements">
			              <ul>
			                <li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="View"><a href="##"><i class="fa fa-eye"></i></a></span></li>
			                <li><span class="j-tool-tip-item" data-toggle="tooltip" data-placement="top" title="Edit"><a href="##"><i class="fa fa-pencil"></i></a></span></li>
			              </ul>
			            </td>
		          	</tr>
		        </tbody>
		    </table>
		 </div>
		<!---list view end --->
	    <div class="row">
	      <div class="col-md-12" span ng-show="pageShow !== 'Auto'">
	        <div class="dataTables_info" id="example3_info" >Showing <b><span ng-bind="pageStart()"><!--- record start ---></span> to <span ng-bind="pageEnd()"><!---records end ---><span></b> of <span ng-bind="recordsCount()"><!--- records Count ---></span> entries</div>
	      </div>
	    </div>
	</div>
</div>


