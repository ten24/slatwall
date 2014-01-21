<div class="container">
	<div class="row">
		<div id="content" class="col-lg-12">
			<br />
			<br />
			<table class="table table-striped table-bordered table-responsive sw-collection-display" sw-collection-display>
				<thead>
					<tr class="controls">
						<td colspan="{{collectionConfig.columns.length}}">
							<div class="form-inline pull-left" ng-show="collectionConfig.columns.length">
								<div class="form-group">
									<input type="text" class="form-control input-sm" />
								</div>
								<button type="submit" class="btn btn-sm"><i class="fa fa-search"></i></button>
							</div>
							<div class="btn-group pull-right">
								<a class="btn btn-sm" ng-click="showConfig = !showConfig" ng-disabled="!collectionConfig.columns.length"><i class="fa fa-cogs"></i></a>
							</div>
						</td>
					</tr>
					<tr class="configure" ng-show="showConfig">
						<td colspan="{{collectionConfig.columns.length}}">
							<div class="row">
								<div class="form-group col-sm-4">
									<label>Collection Object</label>
									<select class="form-control col-sm-4" ng-change="updateSwCollectionDisplay( 'collectionObjectChange' )" ng-model="collectionObject">
										<option value="{{option.value}}" ng-repeat="option in collectionObjectOptions" ng-selected="option.value == collectionObject">{{option.name}}</option>
									</select>
								</div>
								<div class="form-group col-sm-4" ng-show="collectionObject != ''">
									<label>Collection</label>
									<select class="form-control col-sm-4" ng-change="updateSwCollectionDisplay( 'collectionChange' )" ng-model="collectionID">
										<option value="{{option.value}}" ng-repeat="option in collectionIDOptions" ng-selected="option.value == collectionID">{{option.name}}</option>
									</select>
								</div>
								<div class="form-group col-sm-4" ng-show="collectionObject != ''" ng-model="collectionName">
									<label>Collection Name</label>
									<input type="text" class="form-control">
								</div>
							</div>
							<div class="row" ng-show="collectionObject != ''">
								<div class="col-lg-12">
									<a class="btn btn-primary">Add Filter</a>
								</div>
							</div>
						</td>
					</tr>
					<tr class="headers" ng-show="collectionConfig.columns.length">
						<th ng-repeat="column in collectionConfig.columns">{{column.title}}</th>
					</tr>
				</thead>
				<tbody ng-show="collectionConfig.columns.length">
					<tr ng-repeat="record in pageRecords">
						<td ng-repeat="column in collectionConfig.columns">{{record[column.propertyIdentifier]}}</td>
					</tr>
				</tbody>
				<tfoot ng-show="collectionConfig.columns.length">
					<tr class="footer">
						<td colspan="{{collectionConfig.columns.length}}">
							<ul class="pagination">
								<li class="disabled"><a tabindex="0" class="paginate_button first" id="datatable1_first">First</a></li>
								<li class="disabled"><a tabindex="0" class="paginate_button previous" id="datatable1_previous">Previous</a></li>
								<li class="active"><a tabindex="0">1</a></li>
								<li><a tabindex="0">2</a></li>
								<li><a tabindex="0">3</a></li>
								<li><a tabindex="0">4</a></li>
								<li><a tabindex="0">5</a></li>
								<li><a tabindex="0" class="paginate_button next" id="datatable1_next">Next</a></li>
								<li><a tabindex="0" class="paginate_button last" id="datatable1_last">Last</a></li>
							</ul>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>
</div>