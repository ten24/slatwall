import * as angular from "angular";


class EntityRBKey {
    //@ngInject
    public static Factory(rbkeyService) {
        return (text: string) => {
            if (angular.isDefined(text) && angular.isString(text)) {
                text = text.replace('_', '').toLowerCase();
                text = rbkeyService.getRBKey('entity.' + text);

            }
            return text;
        }
    }

}
export {
    EntityRBKey
};