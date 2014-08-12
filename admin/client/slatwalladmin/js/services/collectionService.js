//collection service is used to maintain the state of the ui

angular.module('slatwalladmin.services')
.factory('collectionService',[
function(){
	
	
	return collectionService = {
		//properties
		filterGroups:[],
		filterGroupItemBreadCrumbs:[],
		
		//public functions
		addFilterGroupItemBreadCrumb: function(filterGroupItem){
			console.log('addFilterGroupItemBreadCrumb');
			filterGroupItem.focus = true;
			filterGroupItem.isClosed = false;
			//check if the new selected item is a child or sibling of the last item in the array 
			//if(filterGroupItem)
			for(i in filterGroupItem.siblingItems){
				var lastItem = collectionService.filterGroupItemBreadCrumbs[collectionService.filterGroupItemBreadCrumbs.length - 1];
				if(typeof(lastItem) !== 'undefined' && filterGroupItem.siblingItems[i].filterGroup === lastItem){
					console.log('sibling');
					console.log(lastItem);
					lastItem.focus = false;
					lastItem.disabled = true;
					collectionService.filterGroupItemBreadCrumbs.pop();
					
				}
			}
			
			
			collectionService.filterGroupItemBreadCrumbs.push(filterGroupItem);
			collectionService.disableFilterGroupItems(filterGroupItem.siblingItems);
			console.log(collectionService.filterGroupItemBreadCrumbs);
		},
		
		disableFilterGroupItems: function(filterGroupItems){
			for(i in filterGroupItems){
				filterGroupItems[i].disabled = true;
			}
		},
		
		enableFilterGroupItems: function(filterGroupItems){
			console.log(filterGroupItems);
			for(i in filterGroupItems){
				filterGroupItems[i].disabled = false;
			}
		},
		
		removeFilterGroupItemBreadCrumbs: function(filterGroupItem){
		    var i;
		    for(i = collectionService.filterGroupItemBreadCrumbs.length-1; i >= 0; i--){
		    	if (collectionService.filterGroupItemBreadCrumbs[i] !== filterGroupItem) {
		    		console.log(collectionService.filterGroupItemBreadCrumbs[i]);
		            collectionService.filterGroupItemBreadCrumbs[i].focus = false;
		            collectionService.filterGroupItemBreadCrumbs[i].isClosed = true;
		            collectionService.enableFilterGroupItems(collectionService.filterGroupItemBreadCrumbs[i].siblingItems);
		            collectionService.filterGroupItemBreadCrumbs.pop();
		        }else{
		        	break;
		        }
		    }
		},
		
		hasFilterGroupItemBreadCrumb: function(filterGroupItem) {
		    var i;
		    for (i = 0; i < collectionService.filterGroupItemBreadCrumbs.length; i++) {
		        if (collectionService.filterGroupItemBreadCrumbs[i] === filterGroupItem) {
		            return true;
		        }
		    }
		
		    return false;
		},
		
		/*applyDisabled: function(){
			//loops through breadcrumbs and applies disabled based on depth of bread crumb array
			for(var i = 0; i < collectionService.filterGroupItemBreadCrumbs.length;i++){
				console.log('breadCrumbs');
				console.log(collectionService.filterGroupItemBreadCrumbs[i]);
			}
		},*/
		
		setFilterGroups: function(filterGroups){
			collectionService.filterGroups = filterGroups;
		},
		
		//private functions
		
	};
}]);
