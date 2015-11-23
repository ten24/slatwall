/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    class Form {
        constructor(name, object, editing) {
            this.$addControl = (control) => { };
            this.$removeControl = (control) => { };
            this.$setValidity = (validationErrorKey, isValid, control) => { };
            this.$setDirty = () => { };
            this.$setPristine = () => { };
            this.$commitViewValue = () => { };
            this.$rollbackViewValue = () => { };
            this.$setSubmitted = () => { };
            this.$setUntouched = () => { };
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
                this.$log.debug('resetting form');
                this.$log.debug(form);
                for (var key in form) {
                    if (angular.isDefined(form[key])
                        && typeof form[key].$setViewValue == 'function'
                        && angular.isDefined(form[key].$viewValue)) {
                        this.$log.debug(form[key]);
                        if (angular.isDefined(this.getPristinePropertyValue(key))) {
                            form[key].$setViewValue(this.getPristinePropertyValue(key));
                        }
                        else {
                            form[key].$setViewValue('');
                        }
                        form[key].$setUntouched(true);
                        form[key].$render();
                        this.$log.debug(form[key]);
                    }
                }
                form.$submitted = false;
                form.$setPristine();
                form.$setUntouched();
            };
            this.$log = $log;
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