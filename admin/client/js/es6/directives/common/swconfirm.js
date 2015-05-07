/**
 * <------------------------------------------------------------------------------------------------------------------------------------>
 *   This directive can be used to prompt the user with a confirmation dialog.
 *
 *   Example Usage 1:
 *   <a swconfirm
 *   						use-rb-key=true
 * 							yes-text="define.yes"
 * 							no-text="define.no"
 * 							confirm-text="define.confirm"
 * 							message-text="define.delete.message"
 * 							callback="someFunction()">
 *   </a>
 *   Alternate Version (No Rbkeys):
 *   <a swconfirm
 *   						use-rb-key=false
 * 							yes-text="Sure"
 * 							no-text="Not Sure!"
 * 							confirm-text="Sure"
 * 							message-text="Are you sure?"
 * 							callback="sure()">
 *   </a>
 *
 *   Note: Because the template is dynamic, the following keywords can not be used anywhere in the text for this modal.
 *
 *   [yes] [no] [confirm] [message] [callback]
 *
 *   The above words in upper-case can be used - just not those words inside square brackets.
 *   Note: Your callback function on-confirm should return true;
 *<------------------------------------------------------------------------------------------------------------------------------------->
 */
angular.module('slatwalladmin').directive('swConfirm', ['$slatwall', '$log', '$compile', '$modal', 'partialsPath', function ($slatwall, $log, $compile, $modal, partialsPath) {
    var buildConfirmationModal = function (simple, useRbKey, confirmText, messageText, noText, yesText, callback) {
        /* Keys */
        var confirmKey = "[confirm]";
        var messageKey = "[message]";
        var noKey = "[no]";
        var yesKey = "[yes]";
        var callbackKey = "[callback]";
        var swRbKey = "sw-rbkey=";
        /* Values */
        var confirmVal = "<confirm>";
        var messageVal = "<message>";
        var noVal = "<no>";
        var yesVal = "<yes>";
        var callbackVal = "<callback>";
        /* Parse Tags */
        var startTag = "\"'";
        var endTag = "'\"";
        var startParen = "'";
        var endParen = "'";
        var empty = "";
        /* Modal String */
        var parsedKeyString = "";
        var finishedString = "";
        //Figure out which version of this tag we are using
        var templateString = "<div>" + "<div class='modal-header'><a class='close' data-dismiss='modal' ng-click='cancel()'>×</a><h3 [confirm]><confirm></h3></div>" + "<div class='modal-body' [message]>" + "<message>" + "</div>" + "<div class='modal-footer'>" + "<button class='btn btn-sm btn-default btn-inverse' ng-click='cancel()' [no]><no></button>" + "<button class='btn btn-sm btn-default btn-primary' ng-click='[callback]' [yes]><yes></button></div></div></div>";
        /* Use RbKeys or Not? */
        if (useRbKey === "true") {
            $log.debug("Using RbKey? " + useRbKey);
            /* Then decorate the template with the keys. */
            confirmText = swRbKey + startTag + confirmText + endTag;
            messageText = swRbKey + startTag + messageText + endTag;
            yesText = swRbKey + startTag + yesText + endTag;
            noText = swRbKey + startTag + noText + endTag;
            parsedKeyString = templateString.replace(confirmKey, confirmText).replace(messageText, messageText).replace(noKey, noText).replace(yesKey, yesText).replace(callback, callback);
            $log.debug(finishedString);
            finishedString = parsedKeyString.replace(confirm, empty).replace(messageVal, empty).replace(noVal, empty).replace(yesVal, empty);
            $log.debug(finishedString);
            return finishedString;
        }
        else {
            /* Then decorate the template without the keys. */
            $log.debug("Using RbKey? " + useRbKey);
            parsedKeyString = templateString.replace(confirmVal, confirmText).replace(messageVal, messageText).replace(noVal, noText).replace(yesVal, yesText);
            finishedString = parsedKeyString.replace(confirmKey, empty).replace(messageKey, empty).replace(noKey, empty).replace(yesKey, empty).replace(callbackKey, callback);
            $log.debug(finishedString);
            return finishedString;
        }
    };
    return {
        restrict: 'EA',
        scope: {
            callback: "&",
            entity: "="
        },
        link: function (scope, element, attr) {
            /* Grab the template and build the modal on click */
            $log.debug("Modal is: ");
            $log.debug($modal);
            element.bind('click', function () {
                /* Default Values */
                var useRbKey = attr.useRbKey || "false";
                var simple = attr.simple || false;
                var yesText = attr.yesText || "define.yes";
                var noText = attr.noText || "define.no";
                var confirmText = attr.confirmText || "define.delete";
                var messageText = attr.messageText || "define.delete_message";
                var callback = attr.callback || "onSuccess()";
                var templateString = buildConfirmationModal(simple, useRbKey, confirmText, messageText, noText, yesText, callback);
                var modalInstance = $modal.open({
                    template: templateString,
                    controller: 'confirmationController'
                });
                /**
                 * Handles the result - callback or dismissed
                 */
                modalInstance.result.then(function (result) {
                    $log.debug("Result:" + result);
                    scope.callback();
                    return true;
                }, function () {
                    //There was an error
                });
            }); //<--end bind 	
        }
    };
}]);

//# sourceMappingURL=../../directives/common/swconfirm.js.map