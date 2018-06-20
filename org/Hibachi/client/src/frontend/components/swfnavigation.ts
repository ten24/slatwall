/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFNavigationController{
    //@ngInject
    public slatwall;
    public tabs;
    public tabTargets;
    public currentTab;
    public accountTabDisabled=false;
    public fulfillmentTabDisabled=true;
    public paymentTabDisabled=true;
    public reviewTabDisabled=true;
    public accountTabCompleted=false;
    public fulfillmentTabCompleted=true;
    public paymentTabCompleted=true;
    public manualDisable;
    public actionType;
    
    private updateNavbar = (orderRequirementsList, oldList)=>{
        console.log('updateSlabbar', orderRequirementsList);
        if(orderRequirementsList != undefined){
            this.accountTabDisabled = orderRequirementsList.indexOf('account') === -1;
            this.accountTabCompleted = this.accountTabDisabled;
            
            this.fulfillmentTabDisabled = orderRequirementsList.indexOf('account') > -1;
            this.fulfillmentTabCompleted = orderRequirementsList.indexOf('fulfillment') === -1;
            
            this.paymentTabDisabled = this.fulfillmentTabDisabled || orderRequirementsList.indexOf('fulfillment') > -1;
            this.paymentTabCompleted = orderRequirementsList.indexOf('payment') === -1;
            
            this.reviewTabDisabled = this.paymentTabDisabled || orderRequirementsList.indexOf('payment') > -1;
        }
        
        if(!this.slatwall.account.accountID){
            this.showTab('account');
        }else if(!oldList && orderRequirementsList){
            this.selectTab(this.slatwall.account.accountID);
        }
        
        if(this.manualDisable){
            this.updateDisabledTabs();
        }
    }
    
    private selectTab = (accountID)=>{
        let orderRequirementsList = this.slatwall.cart.orderRequirementsList;
        console.log('selectSlab',orderRequirementsList);
        let activeTab = 'review';
        if(!accountID || orderRequirementsList == undefined){
            activeTab = 'account';
        }
        else{
            let sections = ['account','fulfillment','payment'];
            for(let index=sections.length-1; index>=0; index--){
                let section = sections[index];
                if(orderRequirementsList.includes(section)){
                    activeTab = section;
                }
            }
        }
        if(activeTab.length){
            this.showTab(activeTab);
        }
    }
    
    private showTab(tab){
        this[tab+'TabDisabled'] = false;
        if(this.manualDisable){
            this.updateDisabledTab(tab);
        }
        this.$timeout(()=>{
            let actionTarget;
            if(this.actionType == 'collapse'){
                actionTarget = $(this.tabTargets[tab]);
            }else{
                actionTarget = this.tabs[tab];
            }
            actionTarget[this.actionType]('show');
        });
    }
    
    private updateDisabledTabs = ()=>{
        if(this.tabs && !this.tabTargets){
            this.getTabTargets();
        }
        if(this.tabTargets){
            for(let key in this.tabs){
                this.updateDisabledTab(key);
            }
        }
    }
    
    private updateDisabledTab = (key)=>{
        if(!this.tabs || !this.tabs[key]){
            return;
        }
        
        if(!this.tabTargets || !this.tabTargets[key]){
            this.getTabTarget(key);
        }
        
        if(this[key+'TabDisabled'] && this.tabs[key].attr('href')){
            this.removeTarget(key);
        }else if(!this[key+'TabDisabled'] && !this.tabs[key].attr('href')){
            this.restoreTarget(key);
        }else{
        }
    }
    
    private getTabTargets = ()=>{
        this.tabTargets = {
            account: this.tabs.account.attr('href'),
            fulfillment: this.tabs.fulfillment.attr('href'),
            payment: this.tabs.payment.attr('href'),
            review: this.tabs.review.attr('href')
        };
    }
    
    private getTabTarget = (key) =>{
        this.tabTargets = this.tabTargets || {};
        this.tabTargets[key] = this.tabs[key].attr('href');
    }
    
    private removeTarget = (key)=>{
        this.tabs[key].attr('href',null);
    }
    
    private restoreTarget = (key)=>{
        this.tabs[key].attr('href',this.tabTargets[key]);
    }
    
    constructor(private $rootScope, private $scope, private $timeout){
        this.$rootScope = $rootScope;
        if(!this.actionType){
            this.actionType = 'tab';
        }
        this.slatwall = $rootScope.slatwall;
        // $scope.$watch('tabs', ()=>{
        //     this.updateNavbar(this.slatwall.cart.orderRequirementsList);
        //     this.selectTab();
        // })
        $scope.$watch('slatwall.cart.orderRequirementsList',this.updateNavbar);
        $scope.$watch('slatwall.account.accountID',this.selectTab);
    }
    
}
 
class SWFNavigation{
    public static Factory(){
        var directive = (
            $rootScope
        )=> new SWFNavigation(
            $rootScope
        );
        directive.$inject = ['$rootScope'];
        return directive;
    }
    
    //@ngInject
    constructor(
        $rootScope
    ){
        return {
            controller:SWFNavigationController,
            controllerAs:"swfNavigation",
            bindToController: {
                manualDisable:"=?",
                actionType:"@?"
            },
            restrict: "A",
            link: function(scope, element, attributes, controller) {
                let tabs = {
                    account: $('#account-tab'),
                    fulfillment: $('#fulfillment-tab'),
                    payment: $('#payment-tab'),
                    review: $('#review-tab')
                };
                controller.tabs = tabs;
            }
        };
    }
}
export{
    SWFNavigationController,
    SWFNavigation
}
