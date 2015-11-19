/// <reference path='../../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
declare var CKEDITOR:any;
class SWContentEditor{
    public static Factory(){
        var directive = (
            $log,
			$location,
			$http,
			$slatwall,
			formService,
			contentPartialsPath
        )=> new SWContentEditor(
            $log,
			$location,
			$http,
			$slatwall,
			formService,
			contentPartialsPath
        );
        directive.$inject = [
            '$log',
			'$location',
			'$http',
			'$slatwall',
			'formService',
			'contentPartialsPath'
        ];
        return directive;
    }
    constructor(
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
                    var form = formService.getForm('contentEditor');   
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
}
export{
    SWContentEditor
}

