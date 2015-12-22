/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

interface IAlert{
    msg?:string;
    type?:string;
    fade?:boolean;
    dismissable?:boolean;
}

//model
export class Alert implements IAlert {
    msg:string;
    type:string;

    constructor(
        msg?: string,
        type?: string,
        fade:boolean=true,
        dismissable:boolean=true
    ) {
        this.msg = msg;
        this.type = type;
    }
}





