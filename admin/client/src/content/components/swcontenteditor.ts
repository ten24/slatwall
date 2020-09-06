/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
declare var CKEDITOR:any;
class SWContentEditor{
    public static Factory(){
        var directive = (
            $log,
			$location,
			$http,
			$hibachi,
			formService,
			contentPartialsPath,
            slatwallPathBuilder
        )=> new SWContentEditor(
            $log,
			$location,
			$http,
			$hibachi,
			formService,
			contentPartialsPath,
            slatwallPathBuilder
        );
        directive.$inject = [
            '$log',
			'$location',
			'$http',
			'$hibachi',
			'formService',
			'contentPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
        $log,
		$location,
		$http,
		$hibachi,
		formService,
		contentPartialsPath,
            slatwallPathBuilder
    ){
        return {
			restrict: 'EA',
			scope:{
				content:"="
			},
			templateUrl:slatwallPathBuilder.buildPartialsPath(contentPartialsPath)+"contenteditor.html",
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

