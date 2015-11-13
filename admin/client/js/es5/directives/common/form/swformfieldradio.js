/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    var swFormFieldRadioController = (function () {
        function swFormFieldRadioController($timeout, $log) {
            var _this = this;
            this.$timeout = $timeout;
            this.$log = $log;
            /** Creates a random ID - I think this should use UUID instead now that we have hibachi utilities */
            this.makeRandomID = function (count) {
                var text = "";
                var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
                for (var i = 0; i < count; i++)
                    text += possible.charAt(Math.floor(Math.random() * possible.length));
                return text;
            };
            /**  */
            if (this.propertyDisplay.fieldType === 'yesno') {
                //format value
                this.selectedRadioFormName = this.makeRandomID(26);
                this.propertyDisplay.object.data[this.propertyDisplay.property] = this.propertyDisplay.object.data[this.propertyDisplay.property] === 'YES ' || this.propertyDisplay.object.data[this.propertyDisplay.property] == 1 ? 1 : 0;
                /** on a formField changing, sets the form to dirty so that validation can kick in */
                this.formFieldChanged = function (option) {
                    _this.propertyDisplay.object.data[_this.propertyDisplay.property] = option.value;
                    _this.propertyDisplay.form[_this.propertyDisplay.property].$dirty = true;
                    _this.propertyDisplay.form['selected' + _this.propertyDisplay.object.metaData.className + _this.propertyDisplay.property + _this.selectedRadioFormName].$dirty = false;
                };
                /** sets the valid values for the radio */
                this.propertyDisplay.options = [
                    {
                        name: 'Yes',
                        value: 1
                    },
                    {
                        name: 'No',
                        value: 0
                    }
                ];
                if (angular.isDefined(this.propertyDisplay.object.data[this.propertyDisplay.property])) {
                    for (var i in this.propertyDisplay.options) {
                        if (this.propertyDisplay.options[i].value === this.propertyDisplay.object.data[this.propertyDisplay.property]) {
                            this.selected = this.propertyDisplay.options[i];
                            this.propertyDisplay.object.data[this.propertyDisplay.property] = this.propertyDisplay.options[i].value;
                        }
                    }
                }
                else {
                    this.selected = this.propertyDisplay.options[0];
                    this.propertyDisplay.object.data[this.propertyDisplay.property] = this.propertyDisplay.options[0].value;
                }
                /** doing this in a timeout creates a way to effect a digest without calling apply  */
                this.$timeout(function () {
                    _this.propertyDisplay.form[_this.propertyDisplay.property].$dirty = _this.propertyDisplay.isDirty;
                });
            }
        }
        swFormFieldRadioController.$inject = ['$timeout', '$log'];
        return swFormFieldRadioController;
    })();
    slatwalladmin.swFormFieldRadioController = swFormFieldRadioController;
    /**
     * This directive handles converting a property display into a form.
     * */
    var swFormFieldRadio = (function () {
        function swFormFieldRadio($log, $timeout, $slatwall, formService, partialsPath) {
            this.$log = $log;
            this.$timeout = $timeout;
            this.partialsPath = partialsPath;
            this.restrict = 'E';
            this.require = "^form";
            this.scope = {};
            this.transclude = true;
            this.bindToController = {
                propertyDisplay: "=?"
            };
            this.templateUrl = "";
            this.link = function (scope, element, attrs, formController) { };
            this.templateUrl = this.partialsPath + 'formfields/radio.html';
        }
        swFormFieldRadio.$inject = ['$log', '$timeout', '$slatwall', 'formService', 'partialsPath'];
        return swFormFieldRadio;
    })();
    slatwalladmin.swFormFieldRadio = swFormFieldRadio;
    angular.module('slatwalladmin').directive('swFormFieldRadioController', ['$log', '$timeout', '$slatwall', 'formService', 'partialsPath', function ($log, $timeout, $slatwall, formService, partialsPath) { return new slatwalladmin.swFormFieldNumber($log, $timeout, $slatwall, formService, partialsPath); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../../directives/common/form/swformfieldradio.js.map