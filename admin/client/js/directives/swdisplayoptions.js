angular.module('slatwalladmin')
.directive('swDisplayOptions',
['$http',
'$compile',
'$templateCache',
'collectionService',
'partialsPath',
'$log',
function($http,
$compile,
$templateCache,
collectionService,
partialsPath,
$log){
	return {
		restrict: 'A',
		transclude:true,
		scope:{
			columns:'=',
			propertiesList:"=",
			saveCollection:"&"
		},
		templateUrl:partialsPath+"displayoptions.html",
		controller: function($scope,$element,$attrs){
			this.removeColumn = function(columnIndex){
				$log.debug('parent remove column');
				$log.debug($scope.columns);
				if($scope.columns.length){
					$scope.columns.splice(columnIndex, 1);
				}
				
			};
			
			this.getPropertiesList = function(){
				return $scope.propertiesList;
			};
			
			$scope.addColumn = function(selectedProperty){
				$log.debug('add column');
				$log.debug(selectedProperty);
				$log.debug($scope.columns);
				if(angular.isDefined(selectedProperty)){
					var column = {};
					column.title = selectedProperty.displayPropertyIdentifier;
					column.propertyIdentifier = selectedProperty.propertyIdentifier;
					column.isVisible = true;
					$scope.columns.push(column);
					$scope.saveCollection();
				}
				
			};
			
			jQuery(function($) {
				
			      var panelList = angular.element($element).children('ul');
			      panelList.sortable({
			          // Only make the .panel-heading child elements support dragging.
			          // Omit this to make then entire <li>...</li> draggable.
			          handle: '.s-pannel-name',
			          update: function() {
			              $('.s-pannel-name', panelList).each(function(index, elem) {
			            	  console.log('test');
			                   var $listItem = $(elem),
			                       newIndex = $listItem.index();

			                   // Persist the new indices.
			              });
			          }
			      });
			  });
			
			/*$('.s-j-draggablePanelList .btn-group a').click(function(e){
			    e.preventDefault();
			    if($(this).hasClass('s-sort')){
			      var currentSort = $(this).children('i:visible');
			      if(currentSort.hasClass('s-not-active')){
			        $(currentSort).removeAttr('class').addClass('fa fa-sort-amount-asc');
			        $(currentSort).parent().siblings('.s-sort-num').show();
			      }else if(currentSort.hasClass('fa-sort-amount-asc')){
			        $(currentSort).removeAttr('class').addClass('fa fa-sort-amount-desc');
			      }else if(currentSort.hasClass('fa-sort-amount-desc')){
			        $(currentSort).addClass('s-not-active');
			        $(currentSort).parent().siblings('.s-sort-num').hide();
			      };
			    }else{
			      $(this).toggleClass('active');
			    };
			  });*/
		}
	};
}]);


	
	
