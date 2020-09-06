/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

interface IAlert{
    msg?:string;
    type?:string;
    fade?:boolean;
    dismissable?:boolean;
}

//model
class Alert implements IAlert {
    public msg:string;
    type:string;
    fade:boolean=false;
    dismissable:boolean=false;

    constructor(
        msg?: string,
        type?: string,
        fade?:boolean,
        dismissable?:boolean
    ) {
        this.msg = msg;
        this.type = type;
        this.fade = fade;
        this.dismissable=dismissable;
    }
}

export{
    Alert,
    IAlert
}





