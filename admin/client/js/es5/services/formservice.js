/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    var Form = (function () {
        function Form(name, object, editing) {
            this.$addControl = function (control) { };
            this.$removeControl = function (control) { };
            this.$setValidity = function (validationErrorKey, isValid, control) { };
            this.$setDirty = function () { };
            this.$setPristine = function () { };
            this.$commitViewValue = function () { };
            this.$rollbackViewValue = function () { };
            this.$setSubmitted = function () { };
            this.$setUntouched = function () { };
            this.name = name;
            this.object = object;
            this.editing = editing;
        }
        return Form;
    })();
    slatwalladmin.Form = Form;
    var FormService = (function () {
        function FormService($log) {
            var _this = this;
            this.$log = $log;
            this.setPristinePropertyValue = function (property, value) {
                _this._pristinePropertyValue[property] = value;
            };
            this.getPristinePropertyValue = function (property) {
                return _this._pristinePropertyValue[property];
            };
            this.clearForm = function (form) {
                _this.$log.debug('clear form');
                _this.$log.debug(form);
                for (var key in form) {
                    if (key.charAt(0) !== '$') {
                        _this.$log.debug(form[key]);
                    }
                }
            };
            this.setForm = function (form) {
                _this._forms[form.name] = form;
            };
            this.getForm = function (formName) {
                return _this._forms[formName];
            };
            this.getForms = function () {
                return _this._forms;
            };
            this.getFormsByObjectName = function (objectName) {
                var forms = [];
                for (var f in _this._forms) {
                    if (angular.isDefined(_this._forms[f].$$swFormInfo.object) && _this._forms[f].$$swFormInfo.object.metaData.className === objectName) {
                        forms.push(_this._forms[f]);
                    }
                }
                return forms;
            };
            this.createForm = function (name, object, editing) {
                var _form = new Form(name, object, editing);
                _this.setForm(_form);
                return _form;
            };
            this.resetForm = function (form) {
                for (var key in form) {
                    if (key.charAt(0) !== '$') {
                        if (angular.isDefined(_this.getPristinePropertyValue(key))) {
                            form[key].$setViewValue(_this.getPristinePropertyValue(key));
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
            this.$log = $log;
            this._forms = {};
            this._pristinePropertyValue = {};
        }
        FormService.$inject = ['$log'];
        return FormService;
    })();
    slatwalladmin.FormService = FormService;
    angular.module('slatwalladmin')
        .service('formService', FormService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/formservice.js.map