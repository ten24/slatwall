<div>
	<table class="table table-striped table-bordered table-condensed">
		<tr>
			<th ng-repeat="column in collection.config.columns">{{column.propertyIdentifier}}</th>
		</tr>
		<tr ng-repeat="record in collection.pageRecords">
			<td ng-repeat="column in collection.config.columns">{{record[column.propertyIdentifier]}}</td>
		</tr>
	</table>
</div>