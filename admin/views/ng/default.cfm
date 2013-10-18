<!doctype html>
<html ng-app="slatwall">
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Admin NG</title>
		
		<script src="//ajax.googleapis.com/ajax/libs/angularjs/1.0.8/angular.min.js"></script>
		<script src="//cdnjs.cloudflare.com/ajax/libs/angularFire/0.2.0/angularfire.min.js"></script>
		<link href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet">
		
	</head>
	<body>
		<div class="col-xs-12 col-sm-12 col-md-12">
			<div class="row">
				<div class="col-xs-12 col-sm-12 col-md-12" sw-collection="Brand" data-collection-id="">
					
				</div>
				
			</div>
		</div>
	</body>
</html>
<script type="text/javascript">
	var slatwall = angular.module('slatwall', []);
	slatwall.directive('swCollection', ['$http', function($http){
		return {
			restrict: 'A',
			templateUrl: '?slatAction=admin:ng.collection',
			replace: true,
			link: function(scope, element, attrs) {
				
				$http({
					method: 'get',
					url: '/?slatAction=admin:ng.collection',
					params: {
						collectionID: attrs.collectionID,
						collectionObject: attrs.swCollection,
						collectionData: scope.collectionData
					},
					headers: {
						'X-Hibachi-AJAX': true
					}
				}).success(function(result){
					scope.collection = result.collection;
				});
				
				scope.columns = [
					{title:'Hello'},
					{title:'World'},
				]
			}
		};
	}]);
</script>
<!---
<div class="col-sm-6 col-md-4 col-lg-3">
	COL 1
</div>
<div class="col-sm-6 col-md-4 col-lg-3">
	COL 2
</div>
<div class="col-sm-6 col-md-4 col-lg-3">
	COL 3
</div>
<div class="col-sm-6 col-md-4 col-lg-3">
	COL 4
</div>
--->