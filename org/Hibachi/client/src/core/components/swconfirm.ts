/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import { Directive, ElementRef, Input ,HostListener} from "@angular/core";
import { Inject } from "@angular/core";
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
 *   Note: Because the template is dynamic, the following keywords can not be used anywhere in the text for this modal as we interpolate 
 *   those.
 *
 *   [yes] [no] [confirm] [message] [callback]
 *
 *   The above words in upper-case can be used - just not those words inside square brackets.
 *   Note: Your callback function on-confirm should return true;
 *<------------------------------------------------------------------------------------------------------------------------------------->
 */

@Directive({
    selector: "[sw-confirm]"
})


export class SWConfirm{
    private $log: any;
    private $modal: any;

    @Input() callback;
    @Input() workflowtrigger;
    @Input() userbkey;
    @Input() simple;
    @Input() yestext;
    @Input() notext;
    @Input() confirmtext;
    @Input() messagetext;


    //@ngInject
    constructor(
        @Inject('$log') $log: any,
        @Inject('$modal') $modal: any,
        private el: ElementRef
    ) {
        this.$log = $log;
        this.$modal = $modal;
    }

    @HostListener('click',['$event'])
    onClick(){
        /* Grab the template and build the modal on click */
        this.$log.debug("Modal is: ");
        this.$log.debug(this.$modal);

            console.log("elementref", this.el);
            /* Default Values */    
            var useRbKey = this.userbkey;
            var simple = this.simple;
            var yesText = this.yestext;
            var noText = this.notext;
            var confirmText = this.confirmtext;
            var messageText = this.messagetext;
            var templateString = this.buildConfirmationModal(simple, useRbKey, confirmText, messageText, noText, yesText);
            var ref =this;
            var modalInstance = this.$modal.open({
                template: templateString,
                controller: 'confirmationController',
                resolve: {
                    callback: function () {
                        return ref.callback;
                    },
                    workflowtrigger: function () {
                        return ref.workflowtrigger;
                    }
                }
            });

            /**
            * Handles the result - callback or dismissed
            */
            modalInstance.result.then((result)=> {
                this.$log.debug("Result:" + result);
                return true;
            }, function () {
                //There was an error
            });
    }

    buildConfirmationModal = function (simple, useRbKey, confirmText, messageText, noText, yesText) {

        /* Keys */
        var confirmKey = "[confirm]";
        var messageKey = "[message]";
        var noKey = "[no]";
        var yesKey = "[yes]";
        var swRbKey = "sw-rbkey=";

        /* Values */
        var confirmVal = "<confirm>";
        var messageVal = "<message>";
        var noVal = "<no>";
        var yesVal = "<yes>";

        /* Parse Tags */
        var startTag: string = "\"'";
        var endTag: string = "'\"";
        var startParen: string = "'";
        var endParen: string = "'";
        var empty: string = "";

        /* Modal String */
        var parsedKeyString: string = "";
        var finishedString: string = "";

       // console.log(callback);

        //Figure out which version of this tag we are using

        var templateString =
            "<div>" +
            "<div class='modal-header'><a class='close' data-dismiss='modal'  ng-click ='cancel()'>×</a><h3 [confirm]><confirm></h3></div>" +
            "<div class='modal-body' [message]>" + "<message>" + "</div>" +
            "<div class='modal-footer'>" +
            "<button class='btn btn-sm btn-default btn-inverse'  ng-click ='cancel()' [no]><no></button>" +
                "<button class='btn btn-sm btn-default btn-primary'  ng-click ='fireCallback()' [yes]><yes></button></div></div></div>";



        /* Use RbKeys or Not? */
        if (useRbKey === "true") {
            this.$log.debug("Using RbKey? " + useRbKey);
            /* Then decorate the template with the keys. */
            confirmText = swRbKey + startTag + confirmText + endTag;
            messageText = swRbKey + startTag + messageText + endTag;
            yesText = swRbKey + startTag + yesText + endTag;
            noText = swRbKey + startTag + noText + endTag;

            parsedKeyString = templateString.replace(confirmKey, confirmText)
                .replace(messageText, messageText)
                .replace(noKey, noText)
                .replace(yesKey, yesText);

            this.$log.debug(finishedString);
            finishedString = parsedKeyString.replace(confirmKey, empty)
                .replace(messageVal, empty)
                .replace(noVal, empty)
                .replace(yesVal, empty);
            this.$log.debug(finishedString);
            return finishedString;
        } else {
            /* Then decorate the template without the keys. */
            this.$log.debug("Using RbKey? " + useRbKey);
            parsedKeyString = templateString.replace(confirmVal, confirmText)
                .replace(messageVal, messageText)
                .replace(noVal, noText)
                .replace(yesVal, yesText)
            finishedString = parsedKeyString.replace(confirmKey, empty)
                .replace(messageKey, empty)
                .replace(noKey, empty)
                .replace(yesKey, empty);
            this.$log.debug(finishedString);
            return finishedString;
        }
    };

}
