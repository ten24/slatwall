
interface IAlert {
    msg?: string;
    type?: string;
    fade?: boolean;
    dismissable?: boolean;
}

//model
class Alert implements IAlert {
    public msg: string;
    type: string;
    fade: boolean = false;
    dismissable: boolean = false;

    //@ngInject
    constructor(
        msg?: string,
        type?: string,
        fade?: boolean,
        dismissable?: boolean
    ) {
        this.msg = msg;
        this.type = type;
        this.fade = fade;
        this.dismissable = dismissable;
    }
}

export {
    Alert,
    IAlert
}





