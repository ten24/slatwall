angular.module('slatwalladmin')
.directive('swContentEditor', [
'$log',
'$location',
'$http',
'$slatwall',
'formService',
'contentPartialsPath',
	function(
	$log,
	$location,
    $http,
	$slatwall,
	formService,
	contentPartialsPath
	){
		return {
			restrict: 'EA',
			scope:{
				content:"="
			},
			templateUrl:contentPartialsPath+"contenteditor.html",
			link: function(scope, element,attrs){
                scope.editorOptions = CKEDITOR.editorConfig;
                
                scope.onContentChange = function(){
                    console.log('content Change');
                    var form = formService.getForm('contentEditor');   
                    console.log(form);
                    form.contentBody.$setDirty(); 
                }
                
//                scope.saveContent = function(){
//                   var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.post';
//                   var params = {
//                        entityID:scope.content.contentID,
//                        templateHTML:scope.content.templateHTML,
//                        context:'saveTemplateHTML',
//                        entityName:'content'   
//                   }
//                   $http.post(urlString,
//                        {
//                            params:params
//                        }
//                    )
//                    .success(function(data){
//                    }).error(function(reason){
//                    });
//                }
			}
		};
	}
]);
	
