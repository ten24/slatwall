"use strict";
'use strict';
angular.module('slatwalladmin').directive('swValidate', ['$log', '$slatwall', function($log, $slatwall) {
  return {
    restrict: "A",
    require: '^ngModel',
    link: function(scope, elem, attr, ngModel) {
      var ContextsEnum = {
        SAVE: {
          name: "save",
          value: 0
        },
        DELETE: {
          name: "delete",
          value: 1
        },
        EDIT: {
          name: "edit",
          value: 2
        }
      };
      var ValidationPropertiesEnum = {
        REGEX: {
          name: "regex",
          value: 0
        },
        MIN_VALUE: {
          name: "minValue",
          value: 1
        },
        MAX_VALUE: {
          name: "maxValue",
          value: 2
        },
        EQ: {
          name: "eq",
          value: 3
        },
        NEQ: {
          name: "neq",
          value: 4
        },
        UNIQUE: {
          name: "unique",
          value: 5
        },
        LTE: {
          name: "lte",
          value: 6
        },
        GTE: {
          name: "gte",
          value: 7
        },
        MIN_LENGTH: {
          name: "minLength",
          value: 8
        },
        MAX_LENGTH: {
          name: "maxLength",
          value: 9
        },
        DATA_TYPE: {
          name: "dataType",
          value: 10
        },
        REQUIRED: {
          name: "required",
          value: 11
        }
      };
      scope.validationPropertiesEnum = ValidationPropertiesEnum;
      scope.contextsEnum = ContextsEnum;
      var myCurrentContext = scope.contextsEnum.SAVE;
      var contextNamesArray = getNamesFromObject(ContextsEnum);
      var validationPropertiesArray = getNamesFromObject(ValidationPropertiesEnum);
      var validationObject = scope.propertyDisplay.object.validations.properties;
      var errors = scope.propertyDisplay.errors;
      var errorMessages = [];
      var failFlag = 0;
      function validate(name, context, elementValue) {
        var validationResults = {};
        validationResults = {
          "name": "name",
          "context": "context",
          "required": "required",
          "error": "none",
          "errorkey": "none"
        };
        for (var key in validationObject) {
          if (key === name || key === name + "Flag") {
            for (var inner in validationObject[key]) {
              var required = validationObject[key][inner].required || "false";
              var context = validationObject[key][inner].contexts || "none";
              validationResults = {
                "name": key,
                "context": context,
                "required": required,
                "error": "none",
                "errorkey": "none"
              };
              var elementValidationArr = map(checkHasValidationType, validationPropertiesArray, validationObject[key][inner]);
              for (var i = 0; i < elementValidationArr.length; i++) {
                if (elementValidationArr[i] == true) {
                  if (validationPropertiesArray[i] === "regex" && elementValue !== "") {
                    var re = validationObject[key][inner].regex;
                    var result = validate_RegExp(elementValue, re);
                    if (result != true) {
                      errorMessages.push("Invalid input");
                      validationResults.error = errorMessages[errorMessages.length - 1];
                      validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["REGEX"].name;
                      validationResults.fail = true;
                    } else {
                      errorMessages.push("Valid input");
                      validationResults.error = errorMessages[errorMessages.length - 1];
                      validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["REGEX"].name;
                      validationResults.fail = false;
                    }
                    return validationResults;
                  }
                  if (validationPropertiesArray[i] === "minValue") {
                    var validationMinValue = validationObject[key][inner].minValue;
                    $log.debug(validationMinValue);
                    var result = validate_MinValue(elementValue, validationMinValue);
                    $log.debug("e>v" + result + " :" + elementValue, ":" + validationMinValue);
                    if (result != true) {
                      errorMessages.push("Minimum value is: " + validationMinValue);
                      validationResults.error = errorMessages[errorMessages.length - 1];
                      validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MIN_VALUE"].name;
                      validationResults.fail = true;
                    } else {
                      validationResults.error = errorMessages[errorMessages.length - 1];
                      validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MIN_VALUE"].name;
                      validationResults.fail = false;
                    }
                    return validationResults;
                  }
                  if (validationPropertiesArray[i] === "maxValue") {
                    var validationMaxValue = validationObject[key][inner].maxValue;
                    var result = validate_MaxValue(elementValue, validationMaxValue);
                    $log.debug("Max Value result is: " + result);
                    if (result != true) {
                      errorMessages.push("Maximum value is: " + validationMaxValue);
                      validationResults.error = errorMessages[errorMessages.length - 1];
                      validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MAX_VALUE"].name;
                      validationResults.fail = true;
                    }
                    return validationResults;
                  }
                  if (validationPropertiesArray[i] === "minLength") {
                    var validationMinLength = validationObject[key][inner].minLength;
                    var result = validate_MinLength(elementValue, validationMinLength);
                    $log.debug("Min Length result is: " + result);
                    if (result != true) {
                      errorMessages.push("Minimum length must be: " + validationMinLength);
                      validationResults.error = errorMessages[errorMessages.length - 1];
                      validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MIN_LENGTH"].name;
                      validationResults.fail = true;
                    }
                    return validationResults;
                  }
                  if (validationPropertiesArray[i] === "maxLength") {
                    var validationMaxLength = validationObject[key][inner].maxLength;
                    var result = validate_MaxLength(elementValue, validationMaxLength);
                    $log.debug("Max Length result is: " + result);
                    if (result != true) {
                      errorMessages.push("Maximum length is: " + validationMaxLength);
                      validationResults.error = errorMessages[errorMessages.length - 1];
                      validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MAX_LENGTH"].name;
                      validationResults.fail = true;
                    }
                    return validationResults;
                  }
                  if (validationPropertiesArray[i] === "eq") {
                    var validationEq = validationObject[key][inner].eq;
                    var result = validate_Eq(elementValue, validationEq);
                    if (result != true) {
                      errorMessages.push("Must equal " + validationEq);
                      validationResults.error = errorMessages[errorMessages.length - 1];
                      validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["EQ"].name;
                      validationResults.fail = true;
                    }
                    return validationResults;
                  }
                  if (validationPropertiesArray[i] === "neq") {
                    var validationNeq = validationObject[key][inner].neq;
                    var result = validate_Neq(elementValue, validationNeq);
                    if (result != true) {
                      errorMessages.push("Must not equal: " + validationNeq);
                      validationResults.error = errorMessages[errorMessages.length - 1];
                      validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["NEQ"].name;
                      validationResults.fail = true;
                    }
                    return validationResults;
                  }
                  if (validationPropertiesArray[i] === "lte") {
                    var validationLte = validationObject[key][inner].lte;
                    var result = validate_Lte(elementValue, validationLte);
                    if (result != true) {
                      errorMessages.push("Must be less than " + validationLte);
                      validationResults.error = errorMessages[errorMessages.length - 1];
                      validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["LTE"].name;
                      validationResults.fail = true;
                    }
                    return validationResults;
                  }
                  if (validationPropertiesArray[i] === "gte") {
                    var validationGte = validationObject[key][inner].gte;
                    var result = validate_Gte(elementValue, validationGte);
                    if (result != true) {
                      errorMessages.push("Must be greater than: " + validationGte);
                      validationResults.error = errorMessages[errorMessages.length - 1];
                      validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["GTE"].name;
                      validationResults.fail = true;
                    }
                    return validationResults;
                  }
                  if (validationPropertiesArray[i] === "required") {
                    var validationRequire = validationObject[key][inner].require;
                    var result = validate_Required(elementValue, validationRequire);
                    if (result != true) {
                      errorMessages.push("Required");
                      validationResults.error = errorMessages[errorMessages.length - 1];
                      validationResults.errorkey = ValidationPropertiesEnum["REQUIRED"].name;
                      validationResults.fail = true;
                    } else {
                      errorMessages.push("Required");
                      validationResults.error = errorMessages[errorMessages.length - 1];
                      validationResults.errorkey = ValidationPropertiesEnum["REQUIRED"].name;
                      validationResults.fail = false;
                    }
                    return validationResults;
                  }
                }
              }
            }
          }
        }
      }
      function checkHasValidationType(validationProp, validationType) {
        if (validationProp[validationType] != undefined) {
          return true;
        } else {
          return false;
        }
      }
      function map(func, array, obj) {
        var result = [];
        forEach(array, function(element) {
          result.push(func(obj, element));
        });
        return result;
      }
      function forEach(array, action) {
        for (var i = 0; i < array.length; i++)
          action(array[i]);
      }
      function getNamesFromObject(obj) {
        var result = [];
        for (var i in obj) {
          var name = obj[i].name || "stub";
          result.push(name);
        }
        return result;
      }
      function validate_RegExp(value, pattern) {
        var regex = new RegExp(pattern);
        if (regex.test(value)) {
          return true;
        }
        return false;
      }
      function validate_MinValue(userValue, minValue) {
        return (userValue >= minValue);
      }
      function validate_MaxValue(userValue, maxValue) {
        return (userValue <= maxValue) ? true : false;
      }
      function validate_MinLength(userValue, minLength) {
        return (userValue.length >= minLength) ? true : false;
      }
      function validate_MaxLength(userValue, maxLength) {
        return (userValue.length <= maxLength) ? true : false;
      }
      function validate_Eq(userValue, eqValue) {
        return (userValue == eqValue) ? true : false;
      }
      function validate_Neq(userValue, neqValue) {
        return (userValue != neqValue) ? true : false;
      }
      function validate_Lte(userValue, decisionValue) {
        return (userValue < decisionValue) ? true : false;
      }
      function validate_Gte(userValue, decisionValue) {
        return (userValue > decisionValue) ? true : false;
      }
      function validate_EqProperty(userValue, property) {
        return (userValue === property) ? true : false;
      }
      function validate_IsNumeric(value) {
        return !isNaN(value) ? true : false;
      }
      function validate_Required(property, userValue) {
        return (userValue == "" && property == true) ? true : false;
      }
      ngModel.$parsers.unshift(function(value) {
        var name = elem.context.name;
        var currentValue = elem.val();
        var val = validate(name, myCurrentContext, currentValue) || {};
        $log.debug(scope);
        $log.debug(val);
        ngModel.$setValidity(val.errorkey, !val.fail);
        return true;
      });
      elem.bind('blur', function(e) {});
    }
  };
}]);
