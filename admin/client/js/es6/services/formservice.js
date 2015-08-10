/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    class Form {
        constructor(name, object, editing) {
            this.name = name;
            this.object = object;
            this.editing = editing;
            this.name = name;
            this.object = object;
            this.editing = editing;
        }
    }
    slatwalladmin.Form = Form;
    class FormService {
        constructor($log) {
            this.$log = $log;
            this.setPristinePropertyValue = (property, value) => {
                this._pristinePropertyValue[property] = value;
            };
            this.getPristinePropertyValue = (property) => {
                return this._pristinePropertyValue[property];
            };
            this.clearForm = (form) => {
                $log.debug('clear form');
                $log.debug(form);
                for (var key in form) {
                    if (key.charAt(0) !== '$') {
                        $log.debug(form[key]);
                    }
                }
            };
            this.setForm = (form) => {
                this._forms[form.name] = form;
            };
            this.getForm = (formName) => {
                return this._forms[formName];
            };
            this.getForms = () => {
                return this._forms;
            };
            this.getFormsByObjectName = (objectName) => {
                var forms = [];
                for (var f in this._forms) {
                    if (angular.isDefined(this._forms[f].$$swFormInfo.object) && this._forms[f].$$swFormInfo.object.metaData.className === objectName) {
                        forms.push(this._forms[f]);
                    }
                }
                return forms;
            };
            this.createForm = (name, object, editing) => {
                var _form = new Form(name, object, editing);
                this.setForm(_form);
                return _form;
            };
            this.resetForm = (form) => {
                for (var key in form) {
                    if (key.charAt(0) !== '$') {
                        if (angular.isDefined(this.getPristinePropertyValue(key))) {
                            form[key].$setViewValue(this.getPristinePropertyValue(key));
                        }
                        else {
                            form[key].$setViewValue('');
                        }
                        form[key].$render();
                    }
                }
                form.$submitted = false;
                form.$setPristine();
            };
            this._forms = {};
            this._pristinePropertyValue = {};
        }
    }
    FormService.$inject = ['$log'];
    slatwalladmin.FormService = FormService;
    angular.module('slatwalladmin')
        .service('formService', FormService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/formservice.js.map