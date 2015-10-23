/**
 * This directive will create a form logging in a user.
 * 
 */
angular.module('slatwall').directive('swfFormTest', [
        'ProcessObject',
        '$compile', 
        '$templateCache', 
        function(ProcessObject, $compile, $templateCache) {
             var getTemplate = function(scope, data) {
                    
                    var template = "";
                    template += "<form name='"+data['NAME']+"' novalidate class='form'>";
                    //should pass in accountID and or orderID for this user when using
                    for (var p in data["PROPERTIES"]){
                        
                        if (data["PROPERTIES"][p]['NAME'].indexOf("email") != -1){
                            template += "<swf:form-field name='"+data["PROPERTIES"][p]['NAME']+":' type='email' class='' value-object-property='"+data["PROPERTIES"][p]['NAME']+"' ng-model='slatwall.processObject."+data["NAME"]+"."+data["PROPERTIES"][p]['NAME']+" '></swf:form-field>";
                        }else if(data["PROPERTIES"][p]['NAME'].indexOf("password") != -1){
                            template += "<swf:form-field name='"+data["PROPERTIES"][p]['NAME']+":' type='password' class='' value-object-property='"+data["PROPERTIES"][p]['NAME']+"'></swf:form-field> ";
                        }else if(data["PROPERTIES"][p]['NAME'].indexOf("Flag") != -1){
                            template += "<swf:form-field name='"+data["PROPERTIES"][p]['NAME']+":' type='yesno' class='' value-object-property='"+data["PROPERTIES"][p]['NAME']+"'></swf:form-field> ";
                        }else if(data["PROPERTIES"][p]['NAME'] == "account" || data["PROPERTIES"][p]['NAME'] == "order"){
                           //do nothing with these. in future will make hidden with the id as the value. 
                        }else{
                           template += "<swf:form-field name='"+data["PROPERTIES"][p]['NAME']+"' type='text' class='' value-object-property='"+data["PROPERTIES"][p]['NAME']+"'></swf:form-field> "; 
                        }
                    }
                    //now add the submit for this processObject.
                    template += "<swf:form-field name='"+data["PROPERTIES"][p]['NAME']+":' type='submit' class='btn btn-default' value-object-property='"+data["PROPERTIES"][p]['NAME']+"' submit='"+data["NAME"]+"' ng-click='form.$save({ entityName: entityName, processObject: pObject, formData: getFormData()})'></swf:form-field> ";
                    template += "</form>";
                    
                    return template;
             };

            return {
                restrict: 'E',
                transclude: true,
                scope: {
                    entityName: "@?",
                    processObject: "@?",
                    hiddenFields: "=?",
                    actions: "=?"
                },
                templateUrl: '/admin/client/partials/frontend/swfErrorPartial.html',
                replace: false,
                link: 
                    function(scope, element, attrs) {
                        console.log("attrs", attrs);
                        scope.hiddenFields = attrs.hiddenFields || [];
                        scope.entityName = attrs.entityName || "Account";
                        scope.pObject    = attrs.processObject || "login";
                        console.log("Trying to retrieve process object: ", scope.entityName, scope.pObject);
                         
                        var form = ProcessObject.get({ entityName: scope.entityName, processObject: scope.pObject },
                        function() {
                            form.processObject["meta"] = [];
                            for (var p in form.processObject["PROPERTIES"]){
                                 
                                 angular.forEach(form.processObject["entityMeta"], function(n){
                                     if (n["NAME"] == form.processObject["PROPERTIES"][p]["NAME"]){
                                         form.processObject["meta"].push(n);
                                     }
                                 }, scope);
                            }
                            console.log("This process is: ", form.processObject);
                            var formName = form.processObject["NAME"].split(".");
                            formName = formName[formName.length-1];
                            console.log("FormName", formName);
                            form.processObject["NAME"] = formName;
                            
                            
                            
                            var template = getTemplate(scope, form.processObject);
                            element.html(template);
                            $compile(element.contents())(scope);
                            
                            return form.processObject;
                        });
                        scope.form = form;
                        scope.form.data = {};
                        scope.getFormData = function(){
                            return scope.form.data;
                        }
                        
                    }
            };
        }
    ]);