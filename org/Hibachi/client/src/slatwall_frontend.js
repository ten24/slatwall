/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	/*jshint browser:true */
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var basebootstrap_1 = __webpack_require__(1);
	var frontend_module_1 = __webpack_require__(61);
	//custom bootstrapper
	var bootstrapper = (function (_super) {
	    __extends(bootstrapper, _super);
	    function bootstrapper() {
	        this.myApplication = frontend_module_1.frontendmodule.name;
	        var angular = _super.call(this);
	        angular.bootstrap();
	    }
	    return bootstrapper;
	})(basebootstrap_1.BaseBootStrapper);
	module.exports = new bootstrapper();


/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path='../typings/hibachiTypescript.d.ts' />
	/// <reference path='../typings/tsd.d.ts' />
	__webpack_require__(2)();
	var core_module_1 = __webpack_require__(11);
	//generic bootstrapper
	var BaseBootStrapper = (function () {
	    function BaseBootStrapper() {
	        var _this = this;
	        this._resourceBundle = {};
	        this.getData = function () {
	            return _this.$http.get('/index.cfm/?' + hibachiConfig.action + '=api:main.getConfig')
	                .then(function (resp) {
	                core_module_1.coremodule.constant('appConfig', resp.data.data);
	                localStorage.setItem('appConfig', JSON.stringify(resp.data.data));
	                _this.appConfig = resp.data.data;
	                return _this.getResourceBundles();
	            });
	        };
	        this.getResourceBundle = function (locale) {
	            var deferred = _this.$q.defer();
	            var locale = locale || _this.appConfig.rbLocale;
	            if (_this._resourceBundle[locale]) {
	                return _this._resourceBundle[locale];
	            }
	            var urlString = _this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.getResourceBundle&instantiationKey=' + _this.appConfig.instantiationKey + '&locale=' + locale;
	            _this.$http({
	                url: urlString,
	                method: "GET"
	            }).success(function (response, status, headersGetter) {
	                _this._resourceBundle[locale] = response.data;
	                console.log(_this._resourceBundle);
	                deferred.resolve(response);
	            }).error(function (response) {
	                _this._resourceBundle[locale] = {};
	                deferred.reject(response);
	            });
	            return deferred.promise;
	        };
	        this.getResourceBundles = function () {
	            ////$log.debug('hasResourceBundle');
	            ////$log.debug(this._loadedResourceBundle);
	            //$log.debug(this.getConfigValue('rbLocale').split('_'));
	            var rbLocale = _this.appConfig.rbLocale.split('_');
	            var localeListArray = rbLocale;
	            var rbPromise;
	            var rbPromises = [];
	            rbPromise = _this.getResourceBundle(_this.appConfig.rbLocale);
	            rbPromises.push(rbPromise);
	            if (localeListArray.length === 2) {
	                //$log.debug('has two');
	                rbPromise = _this.getResourceBundle(localeListArray[0]);
	                rbPromises.push(rbPromise);
	            }
	            if (localeListArray[0] !== 'en') {
	                //$log.debug('get english');
	                _this.getResourceBundle('en_us');
	                _this.getResourceBundle('en');
	            }
	            var resourceBundlePromises = _this.$q.all(rbPromises).then(function (data) {
	                core_module_1.coremodule.constant('resourceBundles', _this._resourceBundle);
	                localStorage.setItem('resourceBundles', JSON.stringify(_this._resourceBundle));
	            }, function (error) {
	            });
	            return resourceBundlePromises;
	        };
	        return angular.lazy(this.myApplication)
	            .resolve(['$http', '$q', '$timeout', function ($http, $q, $timeout) {
	                _this.$http = $http;
	                _this.$q = $q;
	                if (localStorage.getItem('appConfig')
	                    && localStorage.getItem('appConfig') !== 'undefined'
	                    && localStorage.getItem('resourceBundles')
	                    && localStorage.getItem('resourceBundles') !== 'undefined') {
	                    return $http.get('/index.cfm/?' + hibachiConfig.action + '=api:main.getInstantiationKey')
	                        .then(function (resp) {
	                        var appConfig = JSON.parse(localStorage.getItem('appConfig'));
	                        if (resp.data.data === appConfig.instantiationKey) {
	                            core_module_1.coremodule.constant('appConfig', appConfig)
	                                .constant('resourceBundles', JSON.parse(localStorage.getItem('resourceBundles')));
	                        }
	                        else {
	                            return _this.getData();
	                        }
	                    });
	                }
	                else {
	                    return _this.getData();
	                }
	            }])
	            .loading(function () {
	            //angular.element('#loading').show();
	        })
	            .error(function () {
	            //angular.element('#error').show();
	        })
	            .done(function () {
	            //angular.element('#loading').hide();
	        });
	    }
	    return BaseBootStrapper;
	})();
	exports.BaseBootStrapper = BaseBootStrapper;


/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path='../typings/hibachiTypescript.d.ts' />
	/// <reference path='../typings/tsd.d.ts' />
	module.exports = function () {
	    /* JS */
	    __webpack_require__(3);
	    __webpack_require__(4);
	    __webpack_require__(5);
	    __webpack_require__(6);
	    __webpack_require__(7);
	    __webpack_require__(8);
	    __webpack_require__(9);
	    __webpack_require__(10);
	};


/***/ },
/* 3 */
/***/ function(module, exports) {

	Date.CultureInfo={name:"en-US",englishName:"English (United States)",nativeName:"English (United States)",dayNames:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],abbreviatedDayNames:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],shortestDayNames:["Su","Mo","Tu","We","Th","Fr","Sa"],firstLetterDayNames:["S","M","T","W","T","F","S"],monthNames:["January","February","March","April","May","June","July","August","September","October","November","December"],abbreviatedMonthNames:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],amDesignator:"AM",pmDesignator:"PM",firstDayOfWeek:0,twoDigitYearMax:2029,dateElementOrder:"mdy",formatPatterns:{shortDate:"M/d/yyyy",longDate:"dddd, MMMM dd, yyyy",shortTime:"h:mm tt",longTime:"h:mm:ss tt",fullDateTime:"dddd, MMMM dd, yyyy h:mm:ss tt",sortableDateTime:"yyyy-MM-ddTHH:mm:ss",universalSortableDateTime:"yyyy-MM-dd HH:mm:ssZ",rfc1123:"ddd, dd MMM yyyy HH:mm:ss GMT",monthDay:"MMMM dd",yearMonth:"MMMM, yyyy"},regexPatterns:{jan:/^jan(uary)?/i,feb:/^feb(ruary)?/i,mar:/^mar(ch)?/i,apr:/^apr(il)?/i,may:/^may/i,jun:/^jun(e)?/i,jul:/^jul(y)?/i,aug:/^aug(ust)?/i,sep:/^sep(t(ember)?)?/i,oct:/^oct(ober)?/i,nov:/^nov(ember)?/i,dec:/^dec(ember)?/i,sun:/^su(n(day)?)?/i,mon:/^mo(n(day)?)?/i,tue:/^tu(e(s(day)?)?)?/i,wed:/^we(d(nesday)?)?/i,thu:/^th(u(r(s(day)?)?)?)?/i,fri:/^fr(i(day)?)?/i,sat:/^sa(t(urday)?)?/i,future:/^next/i,past:/^last|past|prev(ious)?/i,add:/^(\+|after|from)/i,subtract:/^(\-|before|ago)/i,yesterday:/^yesterday/i,today:/^t(oday)?/i,tomorrow:/^tomorrow/i,now:/^n(ow)?/i,millisecond:/^ms|milli(second)?s?/i,second:/^sec(ond)?s?/i,minute:/^min(ute)?s?/i,hour:/^h(ou)?rs?/i,week:/^w(ee)?k/i,month:/^m(o(nth)?s?)?/i,day:/^d(ays?)?/i,year:/^y((ea)?rs?)?/i,shortMeridian:/^(a|p)/i,longMeridian:/^(a\.?m?\.?|p\.?m?\.?)/i,timezone:/^((e(s|d)t|c(s|d)t|m(s|d)t|p(s|d)t)|((gmt)?\s*(\+|\-)\s*\d\d\d\d?)|gmt)/i,ordinalSuffix:/^\s*(st|nd|rd|th)/i,timeContext:/^\s*(\:|a|p)/i},abbreviatedTimeZoneStandard:{GMT:"-000",EST:"-0400",CST:"-0500",MST:"-0600",PST:"-0700"},abbreviatedTimeZoneDST:{GMT:"-000",EDT:"-0500",CDT:"-0600",MDT:"-0700",PDT:"-0800"}},Date.getMonthNumberFromName=function(t){for(var e=Date.CultureInfo.monthNames,n=Date.CultureInfo.abbreviatedMonthNames,r=t.toLowerCase(),a=0;a<e.length;a++)if(e[a].toLowerCase()==r||n[a].toLowerCase()==r)return a;return-1},Date.getDayNumberFromName=function(t){for(var e=Date.CultureInfo.dayNames,n=Date.CultureInfo.abbreviatedDayNames,r=(Date.CultureInfo.shortestDayNames,t.toLowerCase()),a=0;a<e.length;a++)if(e[a].toLowerCase()==r||n[a].toLowerCase()==r)return a;return-1},Date.isLeapYear=function(t){return t%4===0&&t%100!==0||t%400===0},Date.getDaysInMonth=function(t,e){return[31,Date.isLeapYear(t)?29:28,31,30,31,30,31,31,30,31,30,31][e]},Date.getTimezoneOffset=function(t,e){return e?Date.CultureInfo.abbreviatedTimeZoneDST[t.toUpperCase()]:Date.CultureInfo.abbreviatedTimeZoneStandard[t.toUpperCase()]},Date.getTimezoneAbbreviation=function(t,e){var n,r=e?Date.CultureInfo.abbreviatedTimeZoneDST:Date.CultureInfo.abbreviatedTimeZoneStandard;for(n in r)if(r[n]===t)return n;return null},Date.prototype.clone=function(){return new Date(this.getTime())},Date.prototype.compareTo=function(t){if(isNaN(this))throw new Error(this);if(t instanceof Date&&!isNaN(t))return this>t?1:t>this?-1:0;throw new TypeError(t)},Date.prototype.equals=function(t){return 0===this.compareTo(t)},Date.prototype.between=function(t,e){var n=this.getTime();return n>=t.getTime()&&n<=e.getTime()},Date.prototype.addMilliseconds=function(t){return this.setMilliseconds(this.getMilliseconds()+t),this},Date.prototype.addSeconds=function(t){return this.addMilliseconds(1e3*t)},Date.prototype.addMinutes=function(t){return this.addMilliseconds(6e4*t)},Date.prototype.addHours=function(t){return this.addMilliseconds(36e5*t)},Date.prototype.addDays=function(t){return this.addMilliseconds(864e5*t)},Date.prototype.addWeeks=function(t){return this.addMilliseconds(6048e5*t)},Date.prototype.addMonths=function(t){var e=this.getDate();return this.setDate(1),this.setMonth(this.getMonth()+t),this.setDate(Math.min(e,this.getDaysInMonth())),this},Date.prototype.addYears=function(t){return this.addMonths(12*t)},Date.prototype.add=function(t){if("number"==typeof t)return this._orient=t,this;var e=t;return(e.millisecond||e.milliseconds)&&this.addMilliseconds(e.millisecond||e.milliseconds),(e.second||e.seconds)&&this.addSeconds(e.second||e.seconds),(e.minute||e.minutes)&&this.addMinutes(e.minute||e.minutes),(e.hour||e.hours)&&this.addHours(e.hour||e.hours),(e.month||e.months)&&this.addMonths(e.month||e.months),(e.year||e.years)&&this.addYears(e.year||e.years),(e.day||e.days)&&this.addDays(e.day||e.days),this},Date._validate=function(t,e,n,r){if("number"!=typeof t)throw new TypeError(t+" is not a Number.");if(e>t||t>n)throw new RangeError(t+" is not a valid value for "+r+".");return!0},Date.validateMillisecond=function(t){return Date._validate(t,0,999,"milliseconds")},Date.validateSecond=function(t){return Date._validate(t,0,59,"seconds")},Date.validateMinute=function(t){return Date._validate(t,0,59,"minutes")},Date.validateHour=function(t){return Date._validate(t,0,23,"hours")},Date.validateDay=function(t,e,n){return Date._validate(t,1,Date.getDaysInMonth(e,n),"days")},Date.validateMonth=function(t){return Date._validate(t,0,11,"months")},Date.validateYear=function(t){return Date._validate(t,1,9999,"seconds")},Date.prototype.set=function(t){var e=t;return e.millisecond||0===e.millisecond||(e.millisecond=-1),e.second||0===e.second||(e.second=-1),e.minute||0===e.minute||(e.minute=-1),e.hour||0===e.hour||(e.hour=-1),e.day||0===e.day||(e.day=-1),e.month||0===e.month||(e.month=-1),e.year||0===e.year||(e.year=-1),-1!=e.millisecond&&Date.validateMillisecond(e.millisecond)&&this.addMilliseconds(e.millisecond-this.getMilliseconds()),-1!=e.second&&Date.validateSecond(e.second)&&this.addSeconds(e.second-this.getSeconds()),-1!=e.minute&&Date.validateMinute(e.minute)&&this.addMinutes(e.minute-this.getMinutes()),-1!=e.hour&&Date.validateHour(e.hour)&&this.addHours(e.hour-this.getHours()),-1!==e.month&&Date.validateMonth(e.month)&&this.addMonths(e.month-this.getMonth()),-1!=e.year&&Date.validateYear(e.year)&&this.addYears(e.year-this.getFullYear()),-1!=e.day&&Date.validateDay(e.day,this.getFullYear(),this.getMonth())&&this.addDays(e.day-this.getDate()),e.timezone&&this.setTimezone(e.timezone),e.timezoneOffset&&this.setTimezoneOffset(e.timezoneOffset),this},Date.prototype.clearTime=function(){return this.setHours(0),this.setMinutes(0),this.setSeconds(0),this.setMilliseconds(0),this},Date.prototype.isLeapYear=function(){var t=this.getFullYear();return t%4===0&&t%100!==0||t%400===0},Date.prototype.isWeekday=function(){return!(this.is().sat()||this.is().sun())},Date.prototype.getDaysInMonth=function(){return Date.getDaysInMonth(this.getFullYear(),this.getMonth())},Date.prototype.moveToFirstDayOfMonth=function(){return this.set({day:1})},Date.prototype.moveToLastDayOfMonth=function(){return this.set({day:this.getDaysInMonth()})},Date.prototype.moveToDayOfWeek=function(t,e){var n=(t-this.getDay()+7*(e||1))%7;return this.addDays(0===n?n+=7*(e||1):n)},Date.prototype.moveToMonth=function(t,e){var n=(t-this.getMonth()+12*(e||1))%12;return this.addMonths(0===n?n+=12*(e||1):n)},Date.prototype.getDayOfYear=function(){return Math.floor((this-new Date(this.getFullYear(),0,1))/864e5)},Date.prototype.getWeekOfYear=function(t){var e=this.getFullYear(),n=this.getMonth(),r=this.getDate(),a=t||Date.CultureInfo.firstDayOfWeek,o=8-new Date(e,0,1).getDay();8==o&&(o=1);var i=(Date.UTC(e,n,r,0,0,0)-Date.UTC(e,0,1,0,0,0))/864e5+1,s=Math.floor((i-o+7)/7);if(s===a){e--;var u=8-new Date(e,0,1).getDay();s=2==u||8==u?53:52}return s},Date.prototype.isDST=function(){return console.log("isDST"),"D"==this.toString().match(/(E|C|M|P)(S|D)T/)[2]},Date.prototype.getTimezone=function(){return Date.getTimezoneAbbreviation(this.getUTCOffset,this.isDST())},Date.prototype.setTimezoneOffset=function(t){var e=this.getTimezoneOffset(),n=-6*Number(t)/10;return this.addMinutes(n-e),this},Date.prototype.setTimezone=function(t){return this.setTimezoneOffset(Date.getTimezoneOffset(t))},Date.prototype.getUTCOffset=function(){var t,e=-10*this.getTimezoneOffset()/6;return 0>e?(t=(e-1e4).toString(),t[0]+t.substr(2)):(t=(e+1e4).toString(),"+"+t.substr(1))},Date.prototype.getDayName=function(t){return t?Date.CultureInfo.abbreviatedDayNames[this.getDay()]:Date.CultureInfo.dayNames[this.getDay()]},Date.prototype.getMonthName=function(t){return t?Date.CultureInfo.abbreviatedMonthNames[this.getMonth()]:Date.CultureInfo.monthNames[this.getMonth()]},Date.prototype._toString=Date.prototype.toString,Date.prototype.toString=function(t){var e=this,n=function(t){return 1==t.toString().length?"0"+t:t};return t?t.replace(/dd?d?d?|MM?M?M?|yy?y?y?|hh?|HH?|mm?|ss?|tt?|zz?z?/g,function(t){switch(t){case"hh":return n(e.getHours()<13?e.getHours():e.getHours()-12);case"h":return e.getHours()<13?e.getHours():e.getHours()-12;case"HH":return n(e.getHours());case"H":return e.getHours();case"mm":return n(e.getMinutes());case"m":return e.getMinutes();case"ss":return n(e.getSeconds());case"s":return e.getSeconds();case"yyyy":return e.getFullYear();case"yy":return e.getFullYear().toString().substring(2,4);case"dddd":return e.getDayName();case"ddd":return e.getDayName(!0);case"dd":return n(e.getDate());case"d":return e.getDate().toString();case"MMMM":return e.getMonthName();case"MMM":return e.getMonthName(!0);case"MM":return n(e.getMonth()+1);case"M":return e.getMonth()+1;case"t":return e.getHours()<12?Date.CultureInfo.amDesignator.substring(0,1):Date.CultureInfo.pmDesignator.substring(0,1);case"tt":return e.getHours()<12?Date.CultureInfo.amDesignator:Date.CultureInfo.pmDesignator;case"zzz":case"zz":case"z":return""}}):this._toString()},Date.now=function(){return new Date},Date.today=function(){return Date.now().clearTime()},Date.prototype._orient=1,Date.prototype.next=function(){return this._orient=1,this},Date.prototype.last=Date.prototype.prev=Date.prototype.previous=function(){return this._orient=-1,this},Date.prototype._is=!1,Date.prototype.is=function(){return this._is=!0,this},Number.prototype._dateElement="day",Number.prototype.fromNow=function(){var t={};return t[this._dateElement]=this,Date.now().add(t)},Number.prototype.ago=function(){var t={};return t[this._dateElement]=-1*this,Date.now().add(t)},function(){for(var t,e=Date.prototype,n=Number.prototype,r="sunday monday tuesday wednesday thursday friday saturday".split(/\s/),a="january february march april may june july august september october november december".split(/\s/),o="Millisecond Second Minute Hour Day Week Month Year".split(/\s/),i=function(t){return function(){return this._is?(this._is=!1,this.getDay()==t):this.moveToDayOfWeek(t,this._orient)}},s=0;s<r.length;s++)e[r[s]]=e[r[s].substring(0,3)]=i(s);for(var u=function(t){return function(){return this._is?(this._is=!1,this.getMonth()===t):this.moveToMonth(t,this._orient)}},h=0;h<a.length;h++)e[a[h]]=e[a[h].substring(0,3)]=u(h);for(var c=function(t){return function(){return"s"!=t.substring(t.length-1)&&(t+="s"),this["add"+t](this._orient)}},d=function(t){return function(){return this._dateElement=t,this}},l=0;l<o.length;l++)t=o[l].toLowerCase(),e[t]=e[t+"s"]=c(o[l]),n[t]=n[t+"s"]=d(t)}(),Date.prototype.toJSONString=function(){return this.toString("yyyy-MM-ddThh:mm:ssZ")},Date.prototype.toShortDateString=function(){return this.toString(Date.CultureInfo.formatPatterns.shortDatePattern)},Date.prototype.toLongDateString=function(){return this.toString(Date.CultureInfo.formatPatterns.longDatePattern)},Date.prototype.toShortTimeString=function(){return this.toString(Date.CultureInfo.formatPatterns.shortTimePattern)},Date.prototype.toLongTimeString=function(){return this.toString(Date.CultureInfo.formatPatterns.longTimePattern)},Date.prototype.getOrdinal=function(){switch(this.getDate()){case 1:case 21:case 31:return"st";case 2:case 22:return"nd";case 3:case 23:return"rd";default:return"th"}},function(){Date.Parsing={Exception:function(t){this.message="Parse error at '"+t.substring(0,10)+" ...'"}};for(var t=Date.Parsing,e=t.Operators={rtoken:function(e){return function(n){var r=n.match(e);if(r)return[r[0],n.substring(r[0].length)];throw new t.Exception(n)}},token:function(){return function(t){return e.rtoken(new RegExp("^s*"+t+"s*"))(t)}},stoken:function(t){return e.rtoken(new RegExp("^"+t))},until:function(t){return function(e){for(var n=[],r=null;e.length;){try{r=t.call(this,e)}catch(a){n.push(r[0]),e=r[1];continue}break}return[n,e]}},many:function(t){return function(e){for(var n=[],r=null;e.length;){try{r=t.call(this,e)}catch(a){return[n,e]}n.push(r[0]),e=r[1]}return[n,e]}},optional:function(t){return function(e){var n=null;try{n=t.call(this,e)}catch(r){return[null,e]}return[n[0],n[1]]}},not:function(e){return function(n){try{e.call(this,n)}catch(r){return[null,n]}throw new t.Exception(n)}},ignore:function(t){return t?function(e){var n=null;return n=t.call(this,e),[null,n[1]]}:null},product:function(){for(var t=arguments[0],n=Array.prototype.slice.call(arguments,1),r=[],a=0;a<t.length;a++)r.push(e.each(t[a],n));return r},cache:function(e){var n={},r=null;return function(a){try{r=n[a]=n[a]||e.call(this,a)}catch(o){r=n[a]=o}if(r instanceof t.Exception)throw r;return r}},any:function(){var e=arguments;return function(n){for(var r=null,a=0;a<e.length;a++)if(null!=e[a]){try{r=e[a].call(this,n)}catch(o){r=null}if(r)return r}throw new t.Exception(n)}},each:function(){var e=arguments;return function(n){for(var r=[],a=null,o=0;o<e.length;o++)if(null!=e[o]){try{a=e[o].call(this,n)}catch(i){throw new t.Exception(n)}r.push(a[0]),n=a[1]}return[r,n]}},all:function(){var t=arguments,e=e;return e.each(e.optional(t))},sequence:function(n,r,a){return r=r||e.rtoken(/^\s*/),a=a||null,1==n.length?n[0]:function(e){for(var o=null,i=null,s=[],u=0;u<n.length;u++){try{o=n[u].call(this,e)}catch(h){break}s.push(o[0]);try{i=r.call(this,o[1])}catch(c){i=null;break}e=i[1]}if(!o)throw new t.Exception(e);if(i)throw new t.Exception(i[1]);if(a)try{o=a.call(this,o[1])}catch(d){throw new t.Exception(o[1])}return[s,o?o[1]:e]}},between:function(t,n,a){a=a||t;var o=e.each(e.ignore(t),n,e.ignore(a));return function(t){var e=o.call(this,t);return[[e[0][0],r[0][2]],e[1]]}},list:function(t,n,r){return n=n||e.rtoken(/^\s*/),r=r||null,t instanceof Array?e.each(e.product(t.slice(0,-1),e.ignore(n)),t.slice(-1),e.ignore(r)):e.each(e.many(e.each(t,e.ignore(n))),px,e.ignore(r))},set:function(n,r,a){return r=r||e.rtoken(/^\s*/),a=a||null,function(o){for(var i=null,s=null,u=null,h=null,c=[[],o],d=!1,l=0;l<n.length;l++){u=null,s=null,i=null,d=1==n.length;try{i=n[l].call(this,o)}catch(y){continue}if(h=[[i[0]],i[1]],i[1].length>0&&!d)try{u=r.call(this,i[1])}catch(f){d=!0}else d=!0;if(d||0!==u[1].length||(d=!0),!d){for(var m=[],p=0;p<n.length;p++)l!=p&&m.push(n[p]);s=e.set(m,r).call(this,u[1]),s[0].length>0&&(h[0]=h[0].concat(s[0]),h[1]=s[1])}if(h[1].length<c[1].length&&(c=h),0===c[1].length)break}if(0===c[0].length)return c;if(a){try{u=a.call(this,c[1])}catch(g){throw new t.Exception(c[1])}c[1]=u[1]}return c}},forward:function(t,e){return function(n){return t[e].call(this,n)}},replace:function(t,e){return function(n){var r=t.call(this,n);return[e,r[1]]}},process:function(t,e){return function(n){var r=t.call(this,n);return[e.call(this,r[0]),r[1]]}},min:function(e,n){return function(r){var a=n.call(this,r);if(a[0].length<e)throw new t.Exception(r);return a}}},n=function(t){return function(){var e=null,n=[];if(arguments.length>1?e=Array.prototype.slice.call(arguments):arguments[0]instanceof Array&&(e=arguments[0]),!e)return t.apply(null,arguments);for(var r=0,a=e.shift();r<a.length;r++)return e.unshift(a[r]),n.push(t.apply(null,e)),e.shift(),n}},a="optional not ignore cache".split(/\s/),o=0;o<a.length;o++)e[a[o]]=n(e[a[o]]);for(var i=function(t){return function(){return arguments[0]instanceof Array?t.apply(null,arguments[0]):t.apply(null,arguments)}},s="each any all".split(/\s/),u=0;u<s.length;u++)e[s[u]]=i(e[s[u]])}(),function(){var t=function(e){for(var n=[],r=0;r<e.length;r++)e[r]instanceof Array?n=n.concat(t(e[r])):e[r]&&n.push(e[r]);return n};Date.Grammar={},Date.Translator={hour:function(t){return function(){this.hour=Number(t)}},minute:function(t){return function(){this.minute=Number(t)}},second:function(t){return function(){this.second=Number(t)}},meridian:function(t){return function(){this.meridian=t.slice(0,1).toLowerCase()}},timezone:function(t){return function(){var e=t.replace(/[^\d\+\-]/g,"");e.length?this.timezoneOffset=Number(e):this.timezone=t.toLowerCase()}},day:function(t){var e=t[0];return function(){this.day=Number(e.match(/\d+/)[0])}},month:function(t){return function(){this.month=3==t.length?Date.getMonthNumberFromName(t):Number(t)-1}},year:function(t){return function(){var e=Number(t);this.year=t.length>2?e:e+(e+2e3<Date.CultureInfo.twoDigitYearMax?2e3:1900)}},rday:function(t){return function(){switch(t){case"yesterday":this.days=-1;break;case"tomorrow":this.days=1;break;case"today":this.days=0;break;case"now":this.days=0,this.now=!0}}},finishExact:function(t){t=t instanceof Array?t:[t];var e=new Date;this.year=e.getFullYear(),this.month=e.getMonth(),this.day=1,this.hour=0,this.minute=0,this.second=0;for(var n=0;n<t.length;n++)t[n]&&t[n].call(this);if(this.hour="p"==this.meridian&&this.hour<13?this.hour+12:this.hour,this.day>Date.getDaysInMonth(this.year,this.month))throw new RangeError(this.day+" is not a valid value for days.");var r=new Date(this.year,this.month,this.day,this.hour,this.minute,this.second);return this.timezone?r.set({timezone:this.timezone}):this.timezoneOffset&&r.set({timezoneOffset:this.timezoneOffset}),r},finish:function(e){if(e=e instanceof Array?t(e):[e],0===e.length)return null;for(var n=0;n<e.length;n++)"function"==typeof e[n]&&e[n].call(this);if(this.now)return new Date;var r=Date.today(),a=!(null==this.days&&!this.orient&&!this.operator);if(a){var o,i,s;return s="past"==this.orient||"subtract"==this.operator?-1:1,this.weekday&&(this.unit="day",o=Date.getDayNumberFromName(this.weekday)-r.getDay(),i=7,this.days=o?(o+s*i)%i:s*i),this.month&&(this.unit="month",o=this.month-r.getMonth(),i=12,this.months=o?(o+s*i)%i:s*i,this.month=null),this.unit||(this.unit="day"),(null==this[this.unit+"s"]||null!=this.operator)&&(this.value||(this.value=1),"week"==this.unit&&(this.unit="day",this.value=7*this.value),this[this.unit+"s"]=this.value*s),r.add(this)}return this.meridian&&this.hour&&(this.hour=this.hour<13&&"p"==this.meridian?this.hour+12:this.hour),this.weekday&&!this.day&&(this.day=r.addDays(Date.getDayNumberFromName(this.weekday)-r.getDay()).getDate()),this.month&&!this.day&&(this.day=1),r.set(this)}};var e,n=Date.Parsing.Operators,r=Date.Grammar,a=Date.Translator;r.datePartDelimiter=n.rtoken(/^([\s\-\.\,\/\x27]+)/),r.timePartDelimiter=n.stoken(":"),r.whiteSpace=n.rtoken(/^\s*/),r.generalDelimiter=n.rtoken(/^(([\s\,]|at|on)+)/);var o={};r.ctoken=function(t){var e=o[t];if(!e){for(var r=Date.CultureInfo.regexPatterns,a=t.split(/\s+/),i=[],s=0;s<a.length;s++)i.push(n.replace(n.rtoken(r[a[s]]),a[s]));e=o[t]=n.any.apply(null,i)}return e},r.ctoken2=function(t){return n.rtoken(Date.CultureInfo.regexPatterns[t])},r.h=n.cache(n.process(n.rtoken(/^(0[0-9]|1[0-2]|[1-9])/),a.hour)),r.hh=n.cache(n.process(n.rtoken(/^(0[0-9]|1[0-2])/),a.hour)),r.H=n.cache(n.process(n.rtoken(/^([0-1][0-9]|2[0-3]|[0-9])/),a.hour)),r.HH=n.cache(n.process(n.rtoken(/^([0-1][0-9]|2[0-3])/),a.hour)),r.m=n.cache(n.process(n.rtoken(/^([0-5][0-9]|[0-9])/),a.minute)),r.mm=n.cache(n.process(n.rtoken(/^[0-5][0-9]/),a.minute)),r.s=n.cache(n.process(n.rtoken(/^([0-5][0-9]|[0-9])/),a.second)),r.ss=n.cache(n.process(n.rtoken(/^[0-5][0-9]/),a.second)),r.hms=n.cache(n.sequence([r.H,r.mm,r.ss],r.timePartDelimiter)),r.t=n.cache(n.process(r.ctoken2("shortMeridian"),a.meridian)),r.tt=n.cache(n.process(r.ctoken2("longMeridian"),a.meridian)),r.z=n.cache(n.process(n.rtoken(/^(\+|\-)?\s*\d\d\d\d?/),a.timezone)),r.zz=n.cache(n.process(n.rtoken(/^(\+|\-)\s*\d\d\d\d/),a.timezone)),r.zzz=n.cache(n.process(r.ctoken2("timezone"),a.timezone)),r.timeSuffix=n.each(n.ignore(r.whiteSpace),n.set([r.tt,r.zzz])),r.time=n.each(n.optional(n.ignore(n.stoken("T"))),r.hms,r.timeSuffix),r.d=n.cache(n.process(n.each(n.rtoken(/^([0-2]\d|3[0-1]|\d)/),n.optional(r.ctoken2("ordinalSuffix"))),a.day)),r.dd=n.cache(n.process(n.each(n.rtoken(/^([0-2]\d|3[0-1])/),n.optional(r.ctoken2("ordinalSuffix"))),a.day)),r.ddd=r.dddd=n.cache(n.process(r.ctoken("sun mon tue wed thu fri sat"),function(t){return function(){this.weekday=t}})),r.M=n.cache(n.process(n.rtoken(/^(1[0-2]|0\d|\d)/),a.month)),r.MM=n.cache(n.process(n.rtoken(/^(1[0-2]|0\d)/),a.month)),r.MMM=r.MMMM=n.cache(n.process(r.ctoken("jan feb mar apr may jun jul aug sep oct nov dec"),a.month)),r.y=n.cache(n.process(n.rtoken(/^(\d\d?)/),a.year)),r.yy=n.cache(n.process(n.rtoken(/^(\d\d)/),a.year)),r.yyy=n.cache(n.process(n.rtoken(/^(\d\d?\d?\d?)/),a.year)),r.yyyy=n.cache(n.process(n.rtoken(/^(\d\d\d\d)/),a.year)),e=function(){return n.each(n.any.apply(null,arguments),n.not(r.ctoken2("timeContext")))},r.day=e(r.d,r.dd),r.month=e(r.M,r.MMM),r.year=e(r.yyyy,r.yy),r.orientation=n.process(r.ctoken("past future"),function(t){return function(){this.orient=t}}),r.operator=n.process(r.ctoken("add subtract"),function(t){return function(){this.operator=t}}),r.rday=n.process(r.ctoken("yesterday tomorrow today now"),a.rday),r.unit=n.process(r.ctoken("minute hour day week month year"),function(t){return function(){this.unit=t}}),r.value=n.process(n.rtoken(/^\d\d?(st|nd|rd|th)?/),function(t){return function(){this.value=t.replace(/\D/g,"")}}),r.expression=n.set([r.rday,r.operator,r.value,r.unit,r.orientation,r.ddd,r.MMM]),e=function(){return n.set(arguments,r.datePartDelimiter)},r.mdy=e(r.ddd,r.month,r.day,r.year),r.ymd=e(r.ddd,r.year,r.month,r.day),r.dmy=e(r.ddd,r.day,r.month,r.year),r.date=function(t){return(r[Date.CultureInfo.dateElementOrder]||r.mdy).call(this,t)},r.format=n.process(n.many(n.any(n.process(n.rtoken(/^(dd?d?d?|MM?M?M?|yy?y?y?|hh?|HH?|mm?|ss?|tt?|zz?z?)/),function(t){if(r[t])return r[t];throw Date.Parsing.Exception(t)}),n.process(n.rtoken(/^[^dMyhHmstz]+/),function(t){return n.ignore(n.stoken(t))}))),function(t){return n.process(n.each.apply(null,t),a.finishExact)});var i={},s=function(t){return i[t]=i[t]||r.format(t)[0]};r.formats=function(t){if(t instanceof Array){for(var e=[],r=0;r<t.length;r++)e.push(s(t[r]));return n.any.apply(null,e)}return s(t)},r._formats=r.formats(["yyyy-MM-ddTHH:mm:ss","ddd, MMM dd, yyyy H:mm:ss tt","ddd MMM d yyyy HH:mm:ss zzz","d"]),r._start=n.process(n.set([r.date,r.time,r.expression],r.generalDelimiter,r.whiteSpace),a.finish),r.start=function(t){try{var e=r._formats.call({},t);if(0===e[1].length)return e}catch(n){}return r._start.call({},t)}}(),Date._parse=Date.parse,Date.parse=function(t){var e=null;if(!t)return null;try{e=Date.Grammar.start.call({},t)}catch(n){return null}return 0===e[1].length?e[0]:null},Date.getParseFunction=function(t){var e=Date.Grammar.formats(t);return function(t){var n=null;try{n=e.call({},t)}catch(r){return null}return 0===n[1].length?n[0]:null}},Date.parseExact=function(t,e){return Date.getParseFunction(e)(t)};

/***/ },
/* 4 */
/***/ function(module, exports) {

	/*
	 AngularJS v1.4.9
	 (c) 2010-2015 Google, Inc. http://angularjs.org
	 License: MIT
	*/
	(function(S,W,w){'use strict';function M(a){return function(){var b=arguments[0],d;d="["+(a?a+":":"")+b+"] http://errors.angularjs.org/1.4.9/"+(a?a+"/":"")+b;for(b=1;b<arguments.length;b++){d=d+(1==b?"?":"&")+"p"+(b-1)+"=";var c=encodeURIComponent,e;e=arguments[b];e="function"==typeof e?e.toString().replace(/ \{[\s\S]*$/,""):"undefined"==typeof e?"undefined":"string"!=typeof e?JSON.stringify(e):e;d+=c(e)}return Error(d)}}function Aa(a){if(null==a||Xa(a))return!1;if(E(a)||F(a)||A&&a instanceof A)return!0;
	var b="length"in Object(a)&&a.length;return Q(b)&&(0<=b&&(b-1 in a||a instanceof Array)||"function"==typeof a.item)}function n(a,b,d){var c,e;if(a)if(B(a))for(c in a)"prototype"==c||"length"==c||"name"==c||a.hasOwnProperty&&!a.hasOwnProperty(c)||b.call(d,a[c],c,a);else if(E(a)||Aa(a)){var f="object"!==typeof a;c=0;for(e=a.length;c<e;c++)(f||c in a)&&b.call(d,a[c],c,a)}else if(a.forEach&&a.forEach!==n)a.forEach(b,d,a);else if(oc(a))for(c in a)b.call(d,a[c],c,a);else if("function"===typeof a.hasOwnProperty)for(c in a)a.hasOwnProperty(c)&&
	b.call(d,a[c],c,a);else for(c in a)ra.call(a,c)&&b.call(d,a[c],c,a);return a}function pc(a,b,d){for(var c=Object.keys(a).sort(),e=0;e<c.length;e++)b.call(d,a[c[e]],c[e]);return c}function qc(a){return function(b,d){a(d,b)}}function Xd(){return++ob}function Ob(a,b,d){for(var c=a.$$hashKey,e=0,f=b.length;e<f;++e){var g=b[e];if(G(g)||B(g))for(var h=Object.keys(g),k=0,l=h.length;k<l;k++){var m=h[k],r=g[m];d&&G(r)?da(r)?a[m]=new Date(r.valueOf()):La(r)?a[m]=new RegExp(r):r.nodeName?a[m]=r.cloneNode(!0):
	Pb(r)?a[m]=r.clone():(G(a[m])||(a[m]=E(r)?[]:{}),Ob(a[m],[r],!0)):a[m]=r}}c?a.$$hashKey=c:delete a.$$hashKey;return a}function N(a){return Ob(a,sa.call(arguments,1),!1)}function Yd(a){return Ob(a,sa.call(arguments,1),!0)}function Z(a){return parseInt(a,10)}function Qb(a,b){return N(Object.create(a),b)}function z(){}function Ya(a){return a}function na(a){return function(){return a}}function rc(a){return B(a.toString)&&a.toString!==ta}function q(a){return"undefined"===typeof a}function u(a){return"undefined"!==
	typeof a}function G(a){return null!==a&&"object"===typeof a}function oc(a){return null!==a&&"object"===typeof a&&!sc(a)}function F(a){return"string"===typeof a}function Q(a){return"number"===typeof a}function da(a){return"[object Date]"===ta.call(a)}function B(a){return"function"===typeof a}function La(a){return"[object RegExp]"===ta.call(a)}function Xa(a){return a&&a.window===a}function Za(a){return a&&a.$evalAsync&&a.$watch}function $a(a){return"boolean"===typeof a}function tc(a){return a&&Q(a.length)&&
	Zd.test(ta.call(a))}function Pb(a){return!(!a||!(a.nodeName||a.prop&&a.attr&&a.find))}function $d(a){var b={};a=a.split(",");var d;for(d=0;d<a.length;d++)b[a[d]]=!0;return b}function oa(a){return K(a.nodeName||a[0]&&a[0].nodeName)}function ab(a,b){var d=a.indexOf(b);0<=d&&a.splice(d,1);return d}function Ma(a,b){function d(a,b){var d=b.$$hashKey,e;if(E(a)){e=0;for(var f=a.length;e<f;e++)b.push(c(a[e]))}else if(oc(a))for(e in a)b[e]=c(a[e]);else if(a&&"function"===typeof a.hasOwnProperty)for(e in a)a.hasOwnProperty(e)&&
	(b[e]=c(a[e]));else for(e in a)ra.call(a,e)&&(b[e]=c(a[e]));d?b.$$hashKey=d:delete b.$$hashKey;return b}function c(a){if(!G(a))return a;var b=e.indexOf(a);if(-1!==b)return f[b];if(Xa(a)||Za(a))throw Ba("cpws");var b=!1,c;E(a)?(c=[],b=!0):tc(a)?c=new a.constructor(a):da(a)?c=new Date(a.getTime()):La(a)?(c=new RegExp(a.source,a.toString().match(/[^\/]*$/)[0]),c.lastIndex=a.lastIndex):B(a.cloneNode)?c=a.cloneNode(!0):(c=Object.create(sc(a)),b=!0);e.push(a);f.push(c);return b?d(a,c):c}var e=[],f=[];if(b){if(tc(b))throw Ba("cpta");
	if(a===b)throw Ba("cpi");E(b)?b.length=0:n(b,function(a,c){"$$hashKey"!==c&&delete b[c]});e.push(a);f.push(b);return d(a,b)}return c(a)}function ha(a,b){if(E(a)){b=b||[];for(var d=0,c=a.length;d<c;d++)b[d]=a[d]}else if(G(a))for(d in b=b||{},a)if("$"!==d.charAt(0)||"$"!==d.charAt(1))b[d]=a[d];return b||a}function ka(a,b){if(a===b)return!0;if(null===a||null===b)return!1;if(a!==a&&b!==b)return!0;var d=typeof a,c;if(d==typeof b&&"object"==d)if(E(a)){if(!E(b))return!1;if((d=a.length)==b.length){for(c=
	0;c<d;c++)if(!ka(a[c],b[c]))return!1;return!0}}else{if(da(a))return da(b)?ka(a.getTime(),b.getTime()):!1;if(La(a))return La(b)?a.toString()==b.toString():!1;if(Za(a)||Za(b)||Xa(a)||Xa(b)||E(b)||da(b)||La(b))return!1;d=ea();for(c in a)if("$"!==c.charAt(0)&&!B(a[c])){if(!ka(a[c],b[c]))return!1;d[c]=!0}for(c in b)if(!(c in d)&&"$"!==c.charAt(0)&&u(b[c])&&!B(b[c]))return!1;return!0}return!1}function bb(a,b,d){return a.concat(sa.call(b,d))}function uc(a,b){var d=2<arguments.length?sa.call(arguments,2):
	[];return!B(b)||b instanceof RegExp?b:d.length?function(){return arguments.length?b.apply(a,bb(d,arguments,0)):b.apply(a,d)}:function(){return arguments.length?b.apply(a,arguments):b.call(a)}}function ae(a,b){var d=b;"string"===typeof a&&"$"===a.charAt(0)&&"$"===a.charAt(1)?d=w:Xa(b)?d="$WINDOW":b&&W===b?d="$DOCUMENT":Za(b)&&(d="$SCOPE");return d}function cb(a,b){if("undefined"===typeof a)return w;Q(b)||(b=b?2:null);return JSON.stringify(a,ae,b)}function vc(a){return F(a)?JSON.parse(a):a}function wc(a,
	b){var d=Date.parse("Jan 01, 1970 00:00:00 "+a)/6E4;return isNaN(d)?b:d}function Rb(a,b,d){d=d?-1:1;var c=wc(b,a.getTimezoneOffset());b=a;a=d*(c-a.getTimezoneOffset());b=new Date(b.getTime());b.setMinutes(b.getMinutes()+a);return b}function ua(a){a=A(a).clone();try{a.empty()}catch(b){}var d=A("<div>").append(a).html();try{return a[0].nodeType===Na?K(d):d.match(/^(<[^>]+>)/)[1].replace(/^<([\w\-]+)/,function(a,b){return"<"+K(b)})}catch(c){return K(d)}}function xc(a){try{return decodeURIComponent(a)}catch(b){}}
	function yc(a){var b={};n((a||"").split("&"),function(a){var c,e,f;a&&(e=a=a.replace(/\+/g,"%20"),c=a.indexOf("="),-1!==c&&(e=a.substring(0,c),f=a.substring(c+1)),e=xc(e),u(e)&&(f=u(f)?xc(f):!0,ra.call(b,e)?E(b[e])?b[e].push(f):b[e]=[b[e],f]:b[e]=f))});return b}function Sb(a){var b=[];n(a,function(a,c){E(a)?n(a,function(a){b.push(ia(c,!0)+(!0===a?"":"="+ia(a,!0)))}):b.push(ia(c,!0)+(!0===a?"":"="+ia(a,!0)))});return b.length?b.join("&"):""}function pb(a){return ia(a,!0).replace(/%26/gi,"&").replace(/%3D/gi,
	"=").replace(/%2B/gi,"+")}function ia(a,b){return encodeURIComponent(a).replace(/%40/gi,"@").replace(/%3A/gi,":").replace(/%24/g,"$").replace(/%2C/gi,",").replace(/%3B/gi,";").replace(/%20/g,b?"%20":"+")}function be(a,b){var d,c,e=Oa.length;for(c=0;c<e;++c)if(d=Oa[c]+b,F(d=a.getAttribute(d)))return d;return null}function ce(a,b){var d,c,e={};n(Oa,function(b){b+="app";!d&&a.hasAttribute&&a.hasAttribute(b)&&(d=a,c=a.getAttribute(b))});n(Oa,function(b){b+="app";var e;!d&&(e=a.querySelector("["+b.replace(":",
	"\\:")+"]"))&&(d=e,c=e.getAttribute(b))});d&&(e.strictDi=null!==be(d,"strict-di"),b(d,c?[c]:[],e))}function zc(a,b,d){G(d)||(d={});d=N({strictDi:!1},d);var c=function(){a=A(a);if(a.injector()){var c=a[0]===W?"document":ua(a);throw Ba("btstrpd",c.replace(/</,"&lt;").replace(/>/,"&gt;"));}b=b||[];b.unshift(["$provide",function(b){b.value("$rootElement",a)}]);d.debugInfoEnabled&&b.push(["$compileProvider",function(a){a.debugInfoEnabled(!0)}]);b.unshift("ng");c=db(b,d.strictDi);c.invoke(["$rootScope",
	"$rootElement","$compile","$injector",function(a,b,c,d){a.$apply(function(){b.data("$injector",d);c(b)(a)})}]);return c},e=/^NG_ENABLE_DEBUG_INFO!/,f=/^NG_DEFER_BOOTSTRAP!/;S&&e.test(S.name)&&(d.debugInfoEnabled=!0,S.name=S.name.replace(e,""));if(S&&!f.test(S.name))return c();S.name=S.name.replace(f,"");$.resumeBootstrap=function(a){n(a,function(a){b.push(a)});return c()};B($.resumeDeferredBootstrap)&&$.resumeDeferredBootstrap()}function de(){S.name="NG_ENABLE_DEBUG_INFO!"+S.name;S.location.reload()}
	function ee(a){a=$.element(a).injector();if(!a)throw Ba("test");return a.get("$$testability")}function Ac(a,b){b=b||"_";return a.replace(fe,function(a,c){return(c?b:"")+a.toLowerCase()})}function ge(){var a;if(!Bc){var b=qb();(pa=q(b)?S.jQuery:b?S[b]:w)&&pa.fn.on?(A=pa,N(pa.fn,{scope:Pa.scope,isolateScope:Pa.isolateScope,controller:Pa.controller,injector:Pa.injector,inheritedData:Pa.inheritedData}),a=pa.cleanData,pa.cleanData=function(b){var c;if(Tb)Tb=!1;else for(var e=0,f;null!=(f=b[e]);e++)(c=
	pa._data(f,"events"))&&c.$destroy&&pa(f).triggerHandler("$destroy");a(b)}):A=P;$.element=A;Bc=!0}}function rb(a,b,d){if(!a)throw Ba("areq",b||"?",d||"required");return a}function Qa(a,b,d){d&&E(a)&&(a=a[a.length-1]);rb(B(a),b,"not a function, got "+(a&&"object"===typeof a?a.constructor.name||"Object":typeof a));return a}function Ra(a,b){if("hasOwnProperty"===a)throw Ba("badname",b);}function Cc(a,b,d){if(!b)return a;b=b.split(".");for(var c,e=a,f=b.length,g=0;g<f;g++)c=b[g],a&&(a=(e=a)[c]);return!d&&
	B(a)?uc(e,a):a}function sb(a){for(var b=a[0],d=a[a.length-1],c,e=1;b!==d&&(b=b.nextSibling);e++)if(c||a[e]!==b)c||(c=A(sa.call(a,0,e))),c.push(b);return c||a}function ea(){return Object.create(null)}function he(a){function b(a,b,c){return a[b]||(a[b]=c())}var d=M("$injector"),c=M("ng");a=b(a,"angular",Object);a.$$minErr=a.$$minErr||M;return b(a,"module",function(){var a={};return function(f,g,h){if("hasOwnProperty"===f)throw c("badname","module");g&&a.hasOwnProperty(f)&&(a[f]=null);return b(a,f,function(){function a(b,
	d,e,f){f||(f=c);return function(){f[e||"push"]([b,d,arguments]);return y}}function b(a,d){return function(b,e){e&&B(e)&&(e.$$moduleName=f);c.push([a,d,arguments]);return y}}if(!g)throw d("nomod",f);var c=[],e=[],t=[],C=a("$injector","invoke","push",e),y={_invokeQueue:c,_configBlocks:e,_runBlocks:t,requires:g,name:f,provider:b("$provide","provider"),factory:b("$provide","factory"),service:b("$provide","service"),value:a("$provide","value"),constant:a("$provide","constant","unshift"),decorator:b("$provide",
	"decorator"),animation:b("$animateProvider","register"),filter:b("$filterProvider","register"),controller:b("$controllerProvider","register"),directive:b("$compileProvider","directive"),config:C,run:function(a){t.push(a);return this}};h&&C(h);return y})}})}function ie(a){N(a,{bootstrap:zc,copy:Ma,extend:N,merge:Yd,equals:ka,element:A,forEach:n,injector:db,noop:z,bind:uc,toJson:cb,fromJson:vc,identity:Ya,isUndefined:q,isDefined:u,isString:F,isFunction:B,isObject:G,isNumber:Q,isElement:Pb,isArray:E,
	version:je,isDate:da,lowercase:K,uppercase:tb,callbacks:{counter:0},getTestability:ee,$$minErr:M,$$csp:Ca,reloadWithDebugInfo:de});Ub=he(S);Ub("ng",["ngLocale"],["$provide",function(a){a.provider({$$sanitizeUri:ke});a.provider("$compile",Dc).directive({a:le,input:Ec,textarea:Ec,form:me,script:ne,select:oe,style:pe,option:qe,ngBind:re,ngBindHtml:se,ngBindTemplate:te,ngClass:ue,ngClassEven:ve,ngClassOdd:we,ngCloak:xe,ngController:ye,ngForm:ze,ngHide:Ae,ngIf:Be,ngInclude:Ce,ngInit:De,ngNonBindable:Ee,
	ngPluralize:Fe,ngRepeat:Ge,ngShow:He,ngStyle:Ie,ngSwitch:Je,ngSwitchWhen:Ke,ngSwitchDefault:Le,ngOptions:Me,ngTransclude:Ne,ngModel:Oe,ngList:Pe,ngChange:Qe,pattern:Fc,ngPattern:Fc,required:Gc,ngRequired:Gc,minlength:Hc,ngMinlength:Hc,maxlength:Ic,ngMaxlength:Ic,ngValue:Re,ngModelOptions:Se}).directive({ngInclude:Te}).directive(ub).directive(Jc);a.provider({$anchorScroll:Ue,$animate:Ve,$animateCss:We,$$animateJs:Xe,$$animateQueue:Ye,$$AnimateRunner:Ze,$$animateAsyncRun:$e,$browser:af,$cacheFactory:bf,
	$controller:cf,$document:df,$exceptionHandler:ef,$filter:Kc,$$forceReflow:ff,$interpolate:gf,$interval:hf,$http:jf,$httpParamSerializer:kf,$httpParamSerializerJQLike:lf,$httpBackend:mf,$xhrFactory:nf,$location:of,$log:pf,$parse:qf,$rootScope:rf,$q:sf,$$q:tf,$sce:uf,$sceDelegate:vf,$sniffer:wf,$templateCache:xf,$templateRequest:yf,$$testability:zf,$timeout:Af,$window:Bf,$$rAF:Cf,$$jqLite:Df,$$HashMap:Ef,$$cookieReader:Ff})}])}function eb(a){return a.replace(Gf,function(a,d,c,e){return e?c.toUpperCase():
	c}).replace(Hf,"Moz$1")}function Lc(a){a=a.nodeType;return 1===a||!a||9===a}function Mc(a,b){var d,c,e=b.createDocumentFragment(),f=[];if(Vb.test(a)){d=d||e.appendChild(b.createElement("div"));c=(If.exec(a)||["",""])[1].toLowerCase();c=ja[c]||ja._default;d.innerHTML=c[1]+a.replace(Jf,"<$1></$2>")+c[2];for(c=c[0];c--;)d=d.lastChild;f=bb(f,d.childNodes);d=e.firstChild;d.textContent=""}else f.push(b.createTextNode(a));e.textContent="";e.innerHTML="";n(f,function(a){e.appendChild(a)});return e}function P(a){if(a instanceof
	P)return a;var b;F(a)&&(a=T(a),b=!0);if(!(this instanceof P)){if(b&&"<"!=a.charAt(0))throw Wb("nosel");return new P(a)}if(b){b=W;var d;a=(d=Kf.exec(a))?[b.createElement(d[1])]:(d=Mc(a,b))?d.childNodes:[]}Nc(this,a)}function Xb(a){return a.cloneNode(!0)}function vb(a,b){b||wb(a);if(a.querySelectorAll)for(var d=a.querySelectorAll("*"),c=0,e=d.length;c<e;c++)wb(d[c])}function Oc(a,b,d,c){if(u(c))throw Wb("offargs");var e=(c=xb(a))&&c.events,f=c&&c.handle;if(f)if(b){var g=function(b){var c=e[b];u(d)&&
	ab(c||[],d);u(d)&&c&&0<c.length||(a.removeEventListener(b,f,!1),delete e[b])};n(b.split(" "),function(a){g(a);yb[a]&&g(yb[a])})}else for(b in e)"$destroy"!==b&&a.removeEventListener(b,f,!1),delete e[b]}function wb(a,b){var d=a.ng339,c=d&&fb[d];c&&(b?delete c.data[b]:(c.handle&&(c.events.$destroy&&c.handle({},"$destroy"),Oc(a)),delete fb[d],a.ng339=w))}function xb(a,b){var d=a.ng339,d=d&&fb[d];b&&!d&&(a.ng339=d=++Lf,d=fb[d]={events:{},data:{},handle:w});return d}function Yb(a,b,d){if(Lc(a)){var c=
	u(d),e=!c&&b&&!G(b),f=!b;a=(a=xb(a,!e))&&a.data;if(c)a[b]=d;else{if(f)return a;if(e)return a&&a[b];N(a,b)}}}function zb(a,b){return a.getAttribute?-1<(" "+(a.getAttribute("class")||"")+" ").replace(/[\n\t]/g," ").indexOf(" "+b+" "):!1}function Ab(a,b){b&&a.setAttribute&&n(b.split(" "),function(b){a.setAttribute("class",T((" "+(a.getAttribute("class")||"")+" ").replace(/[\n\t]/g," ").replace(" "+T(b)+" "," ")))})}function Bb(a,b){if(b&&a.setAttribute){var d=(" "+(a.getAttribute("class")||"")+" ").replace(/[\n\t]/g,
	" ");n(b.split(" "),function(a){a=T(a);-1===d.indexOf(" "+a+" ")&&(d+=a+" ")});a.setAttribute("class",T(d))}}function Nc(a,b){if(b)if(b.nodeType)a[a.length++]=b;else{var d=b.length;if("number"===typeof d&&b.window!==b){if(d)for(var c=0;c<d;c++)a[a.length++]=b[c]}else a[a.length++]=b}}function Pc(a,b){return Cb(a,"$"+(b||"ngController")+"Controller")}function Cb(a,b,d){9==a.nodeType&&(a=a.documentElement);for(b=E(b)?b:[b];a;){for(var c=0,e=b.length;c<e;c++)if(u(d=A.data(a,b[c])))return d;a=a.parentNode||
	11===a.nodeType&&a.host}}function Qc(a){for(vb(a,!0);a.firstChild;)a.removeChild(a.firstChild)}function Zb(a,b){b||vb(a);var d=a.parentNode;d&&d.removeChild(a)}function Mf(a,b){b=b||S;if("complete"===b.document.readyState)b.setTimeout(a);else A(b).on("load",a)}function Rc(a,b){var d=Db[b.toLowerCase()];return d&&Sc[oa(a)]&&d}function Nf(a,b){var d=function(c,d){c.isDefaultPrevented=function(){return c.defaultPrevented};var f=b[d||c.type],g=f?f.length:0;if(g){if(q(c.immediatePropagationStopped)){var h=
	c.stopImmediatePropagation;c.stopImmediatePropagation=function(){c.immediatePropagationStopped=!0;c.stopPropagation&&c.stopPropagation();h&&h.call(c)}}c.isImmediatePropagationStopped=function(){return!0===c.immediatePropagationStopped};var k=f.specialHandlerWrapper||Of;1<g&&(f=ha(f));for(var l=0;l<g;l++)c.isImmediatePropagationStopped()||k(a,c,f[l])}};d.elem=a;return d}function Of(a,b,d){d.call(a,b)}function Pf(a,b,d){var c=b.relatedTarget;c&&(c===a||Qf.call(a,c))||d.call(a,b)}function Df(){this.$get=
	function(){return N(P,{hasClass:function(a,b){a.attr&&(a=a[0]);return zb(a,b)},addClass:function(a,b){a.attr&&(a=a[0]);return Bb(a,b)},removeClass:function(a,b){a.attr&&(a=a[0]);return Ab(a,b)}})}}function Da(a,b){var d=a&&a.$$hashKey;if(d)return"function"===typeof d&&(d=a.$$hashKey()),d;d=typeof a;return d="function"==d||"object"==d&&null!==a?a.$$hashKey=d+":"+(b||Xd)():d+":"+a}function Sa(a,b){if(b){var d=0;this.nextUid=function(){return++d}}n(a,this.put,this)}function Rf(a){return(a=a.toString().replace(Tc,
	"").match(Uc))?"function("+(a[1]||"").replace(/[\s\r\n]+/," ")+")":"fn"}function db(a,b){function d(a){return function(b,c){if(G(b))n(b,qc(a));else return a(b,c)}}function c(a,b){Ra(a,"service");if(B(b)||E(b))b=t.instantiate(b);if(!b.$get)throw Ea("pget",a);return r[a+"Provider"]=b}function e(a,b){return function(){var c=y.invoke(b,this);if(q(c))throw Ea("undef",a);return c}}function f(a,b,d){return c(a,{$get:!1!==d?e(a,b):b})}function g(a){rb(q(a)||E(a),"modulesToLoad","not an array");var b=[],c;
	n(a,function(a){function d(a){var b,c;b=0;for(c=a.length;b<c;b++){var e=a[b],f=t.get(e[0]);f[e[1]].apply(f,e[2])}}if(!m.get(a)){m.put(a,!0);try{F(a)?(c=Ub(a),b=b.concat(g(c.requires)).concat(c._runBlocks),d(c._invokeQueue),d(c._configBlocks)):B(a)?b.push(t.invoke(a)):E(a)?b.push(t.invoke(a)):Qa(a,"module")}catch(e){throw E(a)&&(a=a[a.length-1]),e.message&&e.stack&&-1==e.stack.indexOf(e.message)&&(e=e.message+"\n"+e.stack),Ea("modulerr",a,e.stack||e.message||e);}}});return b}function h(a,c){function d(b,
	e){if(a.hasOwnProperty(b)){if(a[b]===k)throw Ea("cdep",b+" <- "+l.join(" <- "));return a[b]}try{return l.unshift(b),a[b]=k,a[b]=c(b,e)}catch(f){throw a[b]===k&&delete a[b],f;}finally{l.shift()}}function e(a,c,f,g){"string"===typeof f&&(g=f,f=null);var k=[],h=db.$$annotate(a,b,g),l,m,t;m=0;for(l=h.length;m<l;m++){t=h[m];if("string"!==typeof t)throw Ea("itkn",t);k.push(f&&f.hasOwnProperty(t)?f[t]:d(t,g))}E(a)&&(a=a[l]);return a.apply(c,k)}return{invoke:e,instantiate:function(a,b,c){var d=Object.create((E(a)?
	a[a.length-1]:a).prototype||null);a=e(a,d,b,c);return G(a)||B(a)?a:d},get:d,annotate:db.$$annotate,has:function(b){return r.hasOwnProperty(b+"Provider")||a.hasOwnProperty(b)}}}b=!0===b;var k={},l=[],m=new Sa([],!0),r={$provide:{provider:d(c),factory:d(f),service:d(function(a,b){return f(a,["$injector",function(a){return a.instantiate(b)}])}),value:d(function(a,b){return f(a,na(b),!1)}),constant:d(function(a,b){Ra(a,"constant");r[a]=b;C[a]=b}),decorator:function(a,b){var c=t.get(a+"Provider"),d=c.$get;
	c.$get=function(){var a=y.invoke(d,c);return y.invoke(b,null,{$delegate:a})}}}},t=r.$injector=h(r,function(a,b){$.isString(b)&&l.push(b);throw Ea("unpr",l.join(" <- "));}),C={},y=C.$injector=h(C,function(a,b){var c=t.get(a+"Provider",b);return y.invoke(c.$get,c,w,a)});n(g(a),function(a){a&&y.invoke(a)});return y}function Ue(){var a=!0;this.disableAutoScrolling=function(){a=!1};this.$get=["$window","$location","$rootScope",function(b,d,c){function e(a){var b=null;Array.prototype.some.call(a,function(a){if("a"===
	oa(a))return b=a,!0});return b}function f(a){if(a){a.scrollIntoView();var c;c=g.yOffset;B(c)?c=c():Pb(c)?(c=c[0],c="fixed"!==b.getComputedStyle(c).position?0:c.getBoundingClientRect().bottom):Q(c)||(c=0);c&&(a=a.getBoundingClientRect().top,b.scrollBy(0,a-c))}else b.scrollTo(0,0)}function g(a){a=F(a)?a:d.hash();var b;a?(b=h.getElementById(a))?f(b):(b=e(h.getElementsByName(a)))?f(b):"top"===a&&f(null):f(null)}var h=b.document;a&&c.$watch(function(){return d.hash()},function(a,b){a===b&&""===a||Mf(function(){c.$evalAsync(g)})});
	return g}]}function gb(a,b){if(!a&&!b)return"";if(!a)return b;if(!b)return a;E(a)&&(a=a.join(" "));E(b)&&(b=b.join(" "));return a+" "+b}function Sf(a){F(a)&&(a=a.split(" "));var b=ea();n(a,function(a){a.length&&(b[a]=!0)});return b}function Fa(a){return G(a)?a:{}}function Tf(a,b,d,c){function e(a){try{a.apply(null,sa.call(arguments,1))}finally{if(y--,0===y)for(;R.length;)try{R.pop()()}catch(b){d.error(b)}}}function f(){H=null;g();h()}function g(){a:{try{p=m.state;break a}catch(a){}p=void 0}p=q(p)?
	null:p;ka(p,D)&&(p=D);D=p}function h(){if(v!==k.url()||x!==p)v=k.url(),x=p,n(la,function(a){a(k.url(),p)})}var k=this,l=a.location,m=a.history,r=a.setTimeout,t=a.clearTimeout,C={};k.isMock=!1;var y=0,R=[];k.$$completeOutstandingRequest=e;k.$$incOutstandingRequestCount=function(){y++};k.notifyWhenNoOutstandingRequests=function(a){0===y?a():R.push(a)};var p,x,v=l.href,Y=b.find("base"),H=null;g();x=p;k.url=function(b,d,e){q(e)&&(e=null);l!==a.location&&(l=a.location);m!==a.history&&(m=a.history);if(b){var f=
	x===e;if(v===b&&(!c.history||f))return k;var h=v&&Ga(v)===Ga(b);v=b;x=e;if(!c.history||h&&f){if(!h||H)H=b;d?l.replace(b):h?(d=l,e=b.indexOf("#"),e=-1===e?"":b.substr(e),d.hash=e):l.href=b;l.href!==b&&(H=b)}else m[d?"replaceState":"pushState"](e,"",b),g(),x=p;return k}return H||l.href.replace(/%27/g,"'")};k.state=function(){return p};var la=[],I=!1,D=null;k.onUrlChange=function(b){if(!I){if(c.history)A(a).on("popstate",f);A(a).on("hashchange",f);I=!0}la.push(b);return b};k.$$applicationDestroyed=function(){A(a).off("hashchange popstate",
	f)};k.$$checkUrlChange=h;k.baseHref=function(){var a=Y.attr("href");return a?a.replace(/^(https?\:)?\/\/[^\/]*/,""):""};k.defer=function(a,b){var c;y++;c=r(function(){delete C[c];e(a)},b||0);C[c]=!0;return c};k.defer.cancel=function(a){return C[a]?(delete C[a],t(a),e(z),!0):!1}}function af(){this.$get=["$window","$log","$sniffer","$document",function(a,b,d,c){return new Tf(a,c,b,d)}]}function bf(){this.$get=function(){function a(a,c){function e(a){a!=r&&(t?t==a&&(t=a.n):t=a,f(a.n,a.p),f(a,r),r=a,
	r.n=null)}function f(a,b){a!=b&&(a&&(a.p=b),b&&(b.n=a))}if(a in b)throw M("$cacheFactory")("iid",a);var g=0,h=N({},c,{id:a}),k=ea(),l=c&&c.capacity||Number.MAX_VALUE,m=ea(),r=null,t=null;return b[a]={put:function(a,b){if(!q(b)){if(l<Number.MAX_VALUE){var c=m[a]||(m[a]={key:a});e(c)}a in k||g++;k[a]=b;g>l&&this.remove(t.key);return b}},get:function(a){if(l<Number.MAX_VALUE){var b=m[a];if(!b)return;e(b)}return k[a]},remove:function(a){if(l<Number.MAX_VALUE){var b=m[a];if(!b)return;b==r&&(r=b.p);b==
	t&&(t=b.n);f(b.n,b.p);delete m[a]}a in k&&(delete k[a],g--)},removeAll:function(){k=ea();g=0;m=ea();r=t=null},destroy:function(){m=h=k=null;delete b[a]},info:function(){return N({},h,{size:g})}}}var b={};a.info=function(){var a={};n(b,function(b,e){a[e]=b.info()});return a};a.get=function(a){return b[a]};return a}}function xf(){this.$get=["$cacheFactory",function(a){return a("templates")}]}function Dc(a,b){function d(a,b,c){var d=/^\s*([@&]|=(\*?))(\??)\s*(\w*)\s*$/,e={};n(a,function(a,f){var g=a.match(d);
	if(!g)throw ga("iscp",b,f,a,c?"controller bindings definition":"isolate scope definition");e[f]={mode:g[1][0],collection:"*"===g[2],optional:"?"===g[3],attrName:g[4]||f}});return e}function c(a){var b=a.charAt(0);if(!b||b!==K(b))throw ga("baddir",a);if(a!==a.trim())throw ga("baddir",a);}var e={},f=/^\s*directive\:\s*([\w\-]+)\s+(.*)$/,g=/(([\w\-]+)(?:\:([^;]+))?;?)/,h=$d("ngSrc,ngSrcset,src,srcset"),k=/^(?:(\^\^?)?(\?)?(\^\^?)?)?/,l=/^(on[a-z]+|formaction)$/;this.directive=function t(b,f){Ra(b,"directive");
	F(b)?(c(b),rb(f,"directiveFactory"),e.hasOwnProperty(b)||(e[b]=[],a.factory(b+"Directive",["$injector","$exceptionHandler",function(a,c){var f=[];n(e[b],function(e,g){try{var h=a.invoke(e);B(h)?h={compile:na(h)}:!h.compile&&h.link&&(h.compile=na(h.link));h.priority=h.priority||0;h.index=g;h.name=h.name||b;h.require=h.require||h.controller&&h.name;h.restrict=h.restrict||"EA";var k=h,l=h,m=h.name,t={isolateScope:null,bindToController:null};G(l.scope)&&(!0===l.bindToController?(t.bindToController=d(l.scope,
	m,!0),t.isolateScope={}):t.isolateScope=d(l.scope,m,!1));G(l.bindToController)&&(t.bindToController=d(l.bindToController,m,!0));if(G(t.bindToController)){var y=l.controller,X=l.controllerAs;if(!y)throw ga("noctrl",m);var U;a:if(X&&F(X))U=X;else{if(F(y)){var n=Vc.exec(y);if(n){U=n[3];break a}}U=void 0}if(!U)throw ga("noident",m);}var s=k.$$bindings=t;G(s.isolateScope)&&(h.$$isolateBindings=s.isolateScope);h.$$moduleName=e.$$moduleName;f.push(h)}catch(w){c(w)}});return f}])),e[b].push(f)):n(b,qc(t));
	return this};this.aHrefSanitizationWhitelist=function(a){return u(a)?(b.aHrefSanitizationWhitelist(a),this):b.aHrefSanitizationWhitelist()};this.imgSrcSanitizationWhitelist=function(a){return u(a)?(b.imgSrcSanitizationWhitelist(a),this):b.imgSrcSanitizationWhitelist()};var m=!0;this.debugInfoEnabled=function(a){return u(a)?(m=a,this):m};this.$get=["$injector","$interpolate","$exceptionHandler","$templateRequest","$parse","$controller","$rootScope","$sce","$animate","$$sanitizeUri",function(a,b,c,
	d,p,x,v,Y,H,la){function I(a,b){try{a.addClass(b)}catch(c){}}function D(a,b,c,d,e){a instanceof A||(a=A(a));n(a,function(b,c){b.nodeType==Na&&b.nodeValue.match(/\S+/)&&(a[c]=A(b).wrap("<span></span>").parent()[0])});var f=L(a,b,a,c,d,e);D.$$addScopeClass(a);var g=null;return function(b,c,d){rb(b,"scope");e&&e.needsNewScope&&(b=b.$parent.$new());d=d||{};var h=d.parentBoundTranscludeFn,k=d.transcludeControllers;d=d.futureParentElement;h&&h.$$boundTransclude&&(h=h.$$boundTransclude);g||(g=(d=d&&d[0])?
	"foreignobject"!==oa(d)&&d.toString().match(/SVG/)?"svg":"html":"html");d="html"!==g?A(Q(g,A("<div>").append(a).html())):c?Pa.clone.call(a):a;if(k)for(var l in k)d.data("$"+l+"Controller",k[l].instance);D.$$addScopeInfo(d,b);c&&c(d,b);f&&f(b,d,d,h);return d}}function L(a,b,c,d,e,f){function g(a,c,d,e){var f,k,l,m,t,v,I;if(p)for(I=Array(c.length),m=0;m<h.length;m+=3)f=h[m],I[f]=c[f];else I=c;m=0;for(t=h.length;m<t;)k=I[h[m++]],c=h[m++],f=h[m++],c?(c.scope?(l=a.$new(),D.$$addScopeInfo(A(k),l)):l=a,
	v=c.transcludeOnThisElement?O(a,c.transclude,e):!c.templateOnThisElement&&e?e:!e&&b?O(a,b):null,c(f,l,k,d,v)):f&&f(a,k.childNodes,w,e)}for(var h=[],k,l,m,t,p,v=0;v<a.length;v++){k=new aa;l=X(a[v],[],k,0===v?d:w,e);(f=l.length?s(l,a[v],k,b,c,null,[],[],f):null)&&f.scope&&D.$$addScopeClass(k.$$element);k=f&&f.terminal||!(m=a[v].childNodes)||!m.length?null:L(m,f?(f.transcludeOnThisElement||!f.templateOnThisElement)&&f.transclude:b);if(f||k)h.push(v,f,k),t=!0,p=p||f;f=null}return t?g:null}function O(a,
	b,c){return function(d,e,f,g,h){d||(d=a.$new(!1,h),d.$$transcluded=!0);return b(d,e,{parentBoundTranscludeFn:c,transcludeControllers:f,futureParentElement:g})}}function X(a,b,c,d,e){var h=c.$attr,k;switch(a.nodeType){case 1:u(b,va(oa(a)),"E",d,e);for(var l,m,t,p=a.attributes,v=0,I=p&&p.length;v<I;v++){var L=!1,C=!1;l=p[v];k=l.name;m=T(l.value);l=va(k);if(t=ia.test(l))k=k.replace(Yc,"").substr(8).replace(/_(.)/g,function(a,b){return b.toUpperCase()});(l=l.match(ja))&&fa(l[1])&&(L=k,C=k.substr(0,k.length-
	5)+"end",k=k.substr(0,k.length-6));l=va(k.toLowerCase());h[l]=k;if(t||!c.hasOwnProperty(l))c[l]=m,Rc(a,l)&&(c[l]=!0);P(a,b,m,l,t);u(b,l,"A",d,e,L,C)}a=a.className;G(a)&&(a=a.animVal);if(F(a)&&""!==a)for(;k=g.exec(a);)l=va(k[2]),u(b,l,"C",d,e)&&(c[l]=T(k[3])),a=a.substr(k.index+k[0].length);break;case Na:if(11===Ha)for(;a.parentNode&&a.nextSibling&&a.nextSibling.nodeType===Na;)a.nodeValue+=a.nextSibling.nodeValue,a.parentNode.removeChild(a.nextSibling);J(b,a.nodeValue);break;case 8:try{if(k=f.exec(a.nodeValue))l=
	va(k[1]),u(b,l,"M",d,e)&&(c[l]=T(k[2]))}catch(X){}}b.sort(wa);return b}function U(a,b,c){var d=[],e=0;if(b&&a.hasAttribute&&a.hasAttribute(b)){do{if(!a)throw ga("uterdir",b,c);1==a.nodeType&&(a.hasAttribute(b)&&e++,a.hasAttribute(c)&&e--);d.push(a);a=a.nextSibling}while(0<e)}else d.push(a);return A(d)}function Ta(a,b,c){return function(d,e,f,g,h){e=U(e[0],b,c);return a(d,e,f,g,h)}}function s(a,b,d,e,f,g,h,l,m){function t(a,b,c,d){if(a){c&&(a=Ta(a,c,d));a.require=q.require;a.directiveName=z;if(O===
	q||q.$$isolateScope)a=ba(a,{isolateScope:!0});h.push(a)}if(b){c&&(b=Ta(b,c,d));b.require=q.require;b.directiveName=z;if(O===q||q.$$isolateScope)b=ba(b,{isolateScope:!0});l.push(b)}}function p(a,b,c,d){var e;if(F(b)){var f=b.match(k);b=b.substring(f[0].length);var g=f[1]||f[3],f="?"===f[2];"^^"===g?c=c.parent():e=(e=d&&d[b])&&e.instance;e||(d="$"+b+"Controller",e=g?c.inheritedData(d):c.data(d));if(!e&&!f)throw ga("ctreq",b,a);}else if(E(b))for(e=[],g=0,f=b.length;g<f;g++)e[g]=p(a,b[g],c,d);return e||
	null}function v(a,b,c,d,e,f){var g=ea(),h;for(h in d){var k=d[h],l={$scope:k===O||k.$$isolateScope?e:f,$element:a,$attrs:b,$transclude:c},m=k.controller;"@"==m&&(m=b[k.name]);l=x(m,l,!0,k.controllerAs);g[k.name]=l;hb||a.data("$"+k.name+"Controller",l.instance)}return g}function I(a,c,e,f,g){function k(a,b,c){var d;Za(a)||(c=b,b=a,a=w);hb&&(d=X);c||(c=hb?x.parent():x);return g(a,b,d,c,Ta)}var m,t,L,X,y,x,U;b===e?(f=d,x=d.$$element):(x=A(e),f=new aa(x,d));L=c;O?t=c.$new(!0):C&&(L=c.$parent);g&&(y=k,
	y.$$boundTransclude=g);R&&(X=v(x,f,y,R,t,c));O&&(D.$$addScopeInfo(x,t,!0,!(n&&(n===O||n===O.$$originalDirective))),D.$$addScopeClass(x,!0),t.$$isolateBindings=O.$$isolateBindings,(U=Z(c,f,t,t.$$isolateBindings,O))&&t.$on("$destroy",U));for(var Xc in X){U=R[Xc];var Y=X[Xc],H=U.$$bindings.bindToController;Y.identifier&&H&&(m=Z(L,f,Y.instance,H,U));var q=Y();q!==Y.instance&&(Y.instance=q,x.data("$"+U.name+"Controller",q),m&&m(),m=Z(L,f,Y.instance,H,U))}fa=0;for(K=h.length;fa<K;fa++)m=h[fa],ca(m,m.isolateScope?
	t:c,x,f,m.require&&p(m.directiveName,m.require,x,X),y);var Ta=c;O&&(O.template||null===O.templateUrl)&&(Ta=t);a&&a(Ta,e.childNodes,w,g);for(fa=l.length-1;0<=fa;fa--)m=l[fa],ca(m,m.isolateScope?t:c,x,f,m.require&&p(m.directiveName,m.require,x,X),y)}m=m||{};for(var L=-Number.MAX_VALUE,C=m.newScopeDirective,R=m.controllerDirectives,O=m.newIsolateScopeDirective,n=m.templateDirective,Y=m.nonTlbTranscludeDirective,H=!1,la=!1,hb=m.hasElementTranscludeDirective,u=d.$$element=A(b),q,z,J,ib=e,wa,fa=0,K=a.length;fa<
	K;fa++){q=a[fa];var N=q.$$start,P=q.$$end;N&&(u=U(b,N,P));J=w;if(L>q.priority)break;if(J=q.scope)q.templateUrl||(G(J)?(Ua("new/isolated scope",O||C,q,u),O=q):Ua("new/isolated scope",O,q,u)),C=C||q;z=q.name;!q.templateUrl&&q.controller&&(J=q.controller,R=R||ea(),Ua("'"+z+"' controller",R[z],q,u),R[z]=q);if(J=q.transclude)H=!0,q.$$tlb||(Ua("transclusion",Y,q,u),Y=q),"element"==J?(hb=!0,L=q.priority,J=u,u=d.$$element=A(W.createComment(" "+z+": "+d[z]+" ")),b=u[0],V(f,sa.call(J,0),b),ib=D(J,e,L,g&&g.name,
	{nonTlbTranscludeDirective:Y})):(J=A(Xb(b)).contents(),u.empty(),ib=D(J,e,w,w,{needsNewScope:q.$$isolateScope||q.$$newScope}));if(q.template)if(la=!0,Ua("template",n,q,u),n=q,J=B(q.template)?q.template(u,d):q.template,J=ha(J),q.replace){g=q;J=Vb.test(J)?Zc(Q(q.templateNamespace,T(J))):[];b=J[0];if(1!=J.length||1!==b.nodeType)throw ga("tplrt",z,"");V(f,u,b);J={$attr:{}};var Eb=X(b,[],J),$=a.splice(fa+1,a.length-(fa+1));(O||C)&&Wc(Eb,O,C);a=a.concat(Eb).concat($);M(d,J);K=a.length}else u.html(J);if(q.templateUrl)la=
	!0,Ua("template",n,q,u),n=q,q.replace&&(g=q),I=S(a.splice(fa,a.length-fa),u,d,f,H&&ib,h,l,{controllerDirectives:R,newScopeDirective:C!==q&&C,newIsolateScopeDirective:O,templateDirective:n,nonTlbTranscludeDirective:Y}),K=a.length;else if(q.compile)try{wa=q.compile(u,d,ib),B(wa)?t(null,wa,N,P):wa&&t(wa.pre,wa.post,N,P)}catch(da){c(da,ua(u))}q.terminal&&(I.terminal=!0,L=Math.max(L,q.priority))}I.scope=C&&!0===C.scope;I.transcludeOnThisElement=H;I.templateOnThisElement=la;I.transclude=ib;m.hasElementTranscludeDirective=
	hb;return I}function Wc(a,b,c){for(var d=0,e=a.length;d<e;d++)a[d]=Qb(a[d],{$$isolateScope:b,$$newScope:c})}function u(b,d,f,g,h,k,l){if(d===h)return null;h=null;if(e.hasOwnProperty(d)){var m;d=a.get(d+"Directive");for(var p=0,v=d.length;p<v;p++)try{m=d[p],(q(g)||g>m.priority)&&-1!=m.restrict.indexOf(f)&&(k&&(m=Qb(m,{$$start:k,$$end:l})),b.push(m),h=m)}catch(I){c(I)}}return h}function fa(b){if(e.hasOwnProperty(b))for(var c=a.get(b+"Directive"),d=0,f=c.length;d<f;d++)if(b=c[d],b.multiElement)return!0;
	return!1}function M(a,b){var c=b.$attr,d=a.$attr,e=a.$$element;n(a,function(d,e){"$"!=e.charAt(0)&&(b[e]&&b[e]!==d&&(d+=("style"===e?";":" ")+b[e]),a.$set(e,d,!0,c[e]))});n(b,function(b,f){"class"==f?(I(e,b),a["class"]=(a["class"]?a["class"]+" ":"")+b):"style"==f?(e.attr("style",e.attr("style")+";"+b),a.style=(a.style?a.style+";":"")+b):"$"==f.charAt(0)||a.hasOwnProperty(f)||(a[f]=b,d[f]=c[f])})}function S(a,b,c,e,f,g,h,k){var l=[],m,t,p=b[0],v=a.shift(),C=Qb(v,{templateUrl:null,transclude:null,replace:null,
	$$originalDirective:v}),x=B(v.templateUrl)?v.templateUrl(b,c):v.templateUrl,y=v.templateNamespace;b.empty();d(x).then(function(d){var R,D;d=ha(d);if(v.replace){d=Vb.test(d)?Zc(Q(y,T(d))):[];R=d[0];if(1!=d.length||1!==R.nodeType)throw ga("tplrt",v.name,x);d={$attr:{}};V(e,b,R);var U=X(R,[],d);G(v.scope)&&Wc(U,!0);a=U.concat(a);M(c,d)}else R=p,b.html(d);a.unshift(C);m=s(a,R,c,f,b,v,g,h,k);n(e,function(a,c){a==R&&(e[c]=b[0])});for(t=L(b[0].childNodes,f);l.length;){d=l.shift();D=l.shift();var Y=l.shift(),
	H=l.shift(),U=b[0];if(!d.$$destroyed){if(D!==p){var q=D.className;k.hasElementTranscludeDirective&&v.replace||(U=Xb(R));V(Y,A(D),U);I(A(U),q)}D=m.transcludeOnThisElement?O(d,m.transclude,H):H;m(t,d,U,e,D)}}l=null});return function(a,b,c,d,e){a=e;b.$$destroyed||(l?l.push(b,c,d,a):(m.transcludeOnThisElement&&(a=O(b,m.transclude,e)),m(t,b,c,d,a)))}}function wa(a,b){var c=b.priority-a.priority;return 0!==c?c:a.name!==b.name?a.name<b.name?-1:1:a.index-b.index}function Ua(a,b,c,d){function e(a){return a?
	" (module: "+a+")":""}if(b)throw ga("multidir",b.name,e(b.$$moduleName),c.name,e(c.$$moduleName),a,ua(d));}function J(a,c){var d=b(c,!0);d&&a.push({priority:0,compile:function(a){a=a.parent();var b=!!a.length;b&&D.$$addBindingClass(a);return function(a,c){var e=c.parent();b||D.$$addBindingClass(e);D.$$addBindingInfo(e,d.expressions);a.$watch(d,function(a){c[0].nodeValue=a})}}})}function Q(a,b){a=K(a||"html");switch(a){case "svg":case "math":var c=W.createElement("div");c.innerHTML="<"+a+">"+b+"</"+
	a+">";return c.childNodes[0].childNodes;default:return b}}function Eb(a,b){if("srcdoc"==b)return Y.HTML;var c=oa(a);if("xlinkHref"==b||"form"==c&&"action"==b||"img"!=c&&("src"==b||"ngSrc"==b))return Y.RESOURCE_URL}function P(a,c,d,e,f){var g=Eb(a,e);f=h[e]||f;var k=b(d,!0,g,f);if(k){if("multiple"===e&&"select"===oa(a))throw ga("selmulti",ua(a));c.push({priority:100,compile:function(){return{pre:function(a,c,h){c=h.$$observers||(h.$$observers=ea());if(l.test(e))throw ga("nodomevents");var m=h[e];m!==
	d&&(k=m&&b(m,!0,g,f),d=m);k&&(h[e]=k(a),(c[e]||(c[e]=[])).$$inter=!0,(h.$$observers&&h.$$observers[e].$$scope||a).$watch(k,function(a,b){"class"===e&&a!=b?h.$updateClass(a,b):h.$set(e,a)}))}}}})}}function V(a,b,c){var d=b[0],e=b.length,f=d.parentNode,g,h;if(a)for(g=0,h=a.length;g<h;g++)if(a[g]==d){a[g++]=c;h=g+e-1;for(var k=a.length;g<k;g++,h++)h<k?a[g]=a[h]:delete a[g];a.length-=e-1;a.context===d&&(a.context=c);break}f&&f.replaceChild(c,d);a=W.createDocumentFragment();a.appendChild(d);A.hasData(d)&&
	(A.data(c,A.data(d)),pa?(Tb=!0,pa.cleanData([d])):delete A.cache[d[A.expando]]);d=1;for(e=b.length;d<e;d++)f=b[d],A(f).remove(),a.appendChild(f),delete b[d];b[0]=c;b.length=1}function ba(a,b){return N(function(){return a.apply(null,arguments)},a,b)}function ca(a,b,d,e,f,g){try{a(b,d,e,f,g)}catch(h){c(h,ua(d))}}function Z(a,c,d,e,f){var g=[];n(e,function(e,h){var k=e.attrName,l=e.optional,m,t,v,I;switch(e.mode){case "@":l||ra.call(c,k)||(d[h]=c[k]=void 0);c.$observe(k,function(a){F(a)&&(d[h]=a)});
	c.$$observers[k].$$scope=a;F(c[k])&&(d[h]=b(c[k])(a));break;case "=":if(!ra.call(c,k)){if(l)break;c[k]=void 0}if(l&&!c[k])break;t=p(c[k]);I=t.literal?ka:function(a,b){return a===b||a!==a&&b!==b};v=t.assign||function(){m=d[h]=t(a);throw ga("nonassign",c[k],f.name);};m=d[h]=t(a);l=function(b){I(b,d[h])||(I(b,m)?v(a,b=d[h]):d[h]=b);return m=b};l.$stateful=!0;l=e.collection?a.$watchCollection(c[k],l):a.$watch(p(c[k],l),null,t.literal);g.push(l);break;case "&":t=c.hasOwnProperty(k)?p(c[k]):z;if(t===z&&
	l)break;d[h]=function(b){return t(a,b)}}});return g.length&&function(){for(var a=0,b=g.length;a<b;++a)g[a]()}}var aa=function(a,b){if(b){var c=Object.keys(b),d,e,f;d=0;for(e=c.length;d<e;d++)f=c[d],this[f]=b[f]}else this.$attr={};this.$$element=a};aa.prototype={$normalize:va,$addClass:function(a){a&&0<a.length&&H.addClass(this.$$element,a)},$removeClass:function(a){a&&0<a.length&&H.removeClass(this.$$element,a)},$updateClass:function(a,b){var c=$c(a,b);c&&c.length&&H.addClass(this.$$element,c);(c=
	$c(b,a))&&c.length&&H.removeClass(this.$$element,c)},$set:function(a,b,d,e){var f=Rc(this.$$element[0],a),g=ad[a],h=a;f?(this.$$element.prop(a,b),e=f):g&&(this[g]=b,h=g);this[a]=b;e?this.$attr[a]=e:(e=this.$attr[a])||(this.$attr[a]=e=Ac(a,"-"));f=oa(this.$$element);if("a"===f&&"href"===a||"img"===f&&"src"===a)this[a]=b=la(b,"src"===a);else if("img"===f&&"srcset"===a){for(var f="",g=T(b),k=/(\s+\d+x\s*,|\s+\d+w\s*,|\s+,|,\s+)/,k=/\s/.test(g)?k:/(,)/,g=g.split(k),k=Math.floor(g.length/2),l=0;l<k;l++)var m=
	2*l,f=f+la(T(g[m]),!0),f=f+(" "+T(g[m+1]));g=T(g[2*l]).split(/\s/);f+=la(T(g[0]),!0);2===g.length&&(f+=" "+T(g[1]));this[a]=b=f}!1!==d&&(null===b||q(b)?this.$$element.removeAttr(e):this.$$element.attr(e,b));(a=this.$$observers)&&n(a[h],function(a){try{a(b)}catch(d){c(d)}})},$observe:function(a,b){var c=this,d=c.$$observers||(c.$$observers=ea()),e=d[a]||(d[a]=[]);e.push(b);v.$evalAsync(function(){e.$$inter||!c.hasOwnProperty(a)||q(c[a])||b(c[a])});return function(){ab(e,b)}}};var $=b.startSymbol(),
	da=b.endSymbol(),ha="{{"==$||"}}"==da?Ya:function(a){return a.replace(/\{\{/g,$).replace(/}}/g,da)},ia=/^ngAttr[A-Z]/,ja=/^(.+)Start$/;D.$$addBindingInfo=m?function(a,b){var c=a.data("$binding")||[];E(b)?c=c.concat(b):c.push(b);a.data("$binding",c)}:z;D.$$addBindingClass=m?function(a){I(a,"ng-binding")}:z;D.$$addScopeInfo=m?function(a,b,c,d){a.data(c?d?"$isolateScopeNoTemplate":"$isolateScope":"$scope",b)}:z;D.$$addScopeClass=m?function(a,b){I(a,b?"ng-isolate-scope":"ng-scope")}:z;return D}]}function va(a){return eb(a.replace(Yc,
	""))}function $c(a,b){var d="",c=a.split(/\s+/),e=b.split(/\s+/),f=0;a:for(;f<c.length;f++){for(var g=c[f],h=0;h<e.length;h++)if(g==e[h])continue a;d+=(0<d.length?" ":"")+g}return d}function Zc(a){a=A(a);var b=a.length;if(1>=b)return a;for(;b--;)8===a[b].nodeType&&Uf.call(a,b,1);return a}function cf(){var a={},b=!1;this.register=function(b,c){Ra(b,"controller");G(b)?N(a,b):a[b]=c};this.allowGlobals=function(){b=!0};this.$get=["$injector","$window",function(d,c){function e(a,b,c,d){if(!a||!G(a.$scope))throw M("$controller")("noscp",
	d,b);a.$scope[b]=c}return function(f,g,h,k){var l,m,r;h=!0===h;k&&F(k)&&(r=k);if(F(f)){k=f.match(Vc);if(!k)throw Vf("ctrlfmt",f);m=k[1];r=r||k[3];f=a.hasOwnProperty(m)?a[m]:Cc(g.$scope,m,!0)||(b?Cc(c,m,!0):w);Qa(f,m,!0)}if(h)return h=(E(f)?f[f.length-1]:f).prototype,l=Object.create(h||null),r&&e(g,r,l,m||f.name),N(function(){var a=d.invoke(f,l,g,m);a!==l&&(G(a)||B(a))&&(l=a,r&&e(g,r,l,m||f.name));return l},{instance:l,identifier:r});l=d.instantiate(f,g,m);r&&e(g,r,l,m||f.name);return l}}]}function df(){this.$get=
	["$window",function(a){return A(a.document)}]}function ef(){this.$get=["$log",function(a){return function(b,d){a.error.apply(a,arguments)}}]}function $b(a){return G(a)?da(a)?a.toISOString():cb(a):a}function kf(){this.$get=function(){return function(a){if(!a)return"";var b=[];pc(a,function(a,c){null===a||q(a)||(E(a)?n(a,function(a,d){b.push(ia(c)+"="+ia($b(a)))}):b.push(ia(c)+"="+ia($b(a))))});return b.join("&")}}}function lf(){this.$get=function(){return function(a){function b(a,e,f){null===a||q(a)||
	(E(a)?n(a,function(a,c){b(a,e+"["+(G(a)?c:"")+"]")}):G(a)&&!da(a)?pc(a,function(a,c){b(a,e+(f?"":"[")+c+(f?"":"]"))}):d.push(ia(e)+"="+ia($b(a))))}if(!a)return"";var d=[];b(a,"",!0);return d.join("&")}}}function ac(a,b){if(F(a)){var d=a.replace(Wf,"").trim();if(d){var c=b("Content-Type");(c=c&&0===c.indexOf(bd))||(c=(c=d.match(Xf))&&Yf[c[0]].test(d));c&&(a=vc(d))}}return a}function cd(a){var b=ea(),d;F(a)?n(a.split("\n"),function(a){d=a.indexOf(":");var e=K(T(a.substr(0,d)));a=T(a.substr(d+1));e&&
	(b[e]=b[e]?b[e]+", "+a:a)}):G(a)&&n(a,function(a,d){var f=K(d),g=T(a);f&&(b[f]=b[f]?b[f]+", "+g:g)});return b}function dd(a){var b;return function(d){b||(b=cd(a));return d?(d=b[K(d)],void 0===d&&(d=null),d):b}}function ed(a,b,d,c){if(B(c))return c(a,b,d);n(c,function(c){a=c(a,b,d)});return a}function jf(){var a=this.defaults={transformResponse:[ac],transformRequest:[function(a){return G(a)&&"[object File]"!==ta.call(a)&&"[object Blob]"!==ta.call(a)&&"[object FormData]"!==ta.call(a)?cb(a):a}],headers:{common:{Accept:"application/json, text/plain, */*"},
	post:ha(bc),put:ha(bc),patch:ha(bc)},xsrfCookieName:"XSRF-TOKEN",xsrfHeaderName:"X-XSRF-TOKEN",paramSerializer:"$httpParamSerializer"},b=!1;this.useApplyAsync=function(a){return u(a)?(b=!!a,this):b};var d=!0;this.useLegacyPromiseExtensions=function(a){return u(a)?(d=!!a,this):d};var c=this.interceptors=[];this.$get=["$httpBackend","$$cookieReader","$cacheFactory","$rootScope","$q","$injector",function(e,f,g,h,k,l){function m(b){function c(a){var b=N({},a);b.data=ed(a.data,a.headers,a.status,f.transformResponse);
	a=a.status;return 200<=a&&300>a?b:k.reject(b)}function e(a,b){var c,d={};n(a,function(a,e){B(a)?(c=a(b),null!=c&&(d[e]=c)):d[e]=a});return d}if(!$.isObject(b))throw M("$http")("badreq",b);if(!F(b.url))throw M("$http")("badreq",b.url);var f=N({method:"get",transformRequest:a.transformRequest,transformResponse:a.transformResponse,paramSerializer:a.paramSerializer},b);f.headers=function(b){var c=a.headers,d=N({},b.headers),f,g,h,c=N({},c.common,c[K(b.method)]);a:for(f in c){g=K(f);for(h in d)if(K(h)===
	g)continue a;d[f]=c[f]}return e(d,ha(b))}(b);f.method=tb(f.method);f.paramSerializer=F(f.paramSerializer)?l.get(f.paramSerializer):f.paramSerializer;var g=[function(b){var d=b.headers,e=ed(b.data,dd(d),w,b.transformRequest);q(e)&&n(d,function(a,b){"content-type"===K(b)&&delete d[b]});q(b.withCredentials)&&!q(a.withCredentials)&&(b.withCredentials=a.withCredentials);return r(b,e).then(c,c)},w],h=k.when(f);for(n(y,function(a){(a.request||a.requestError)&&g.unshift(a.request,a.requestError);(a.response||
	a.responseError)&&g.push(a.response,a.responseError)});g.length;){b=g.shift();var m=g.shift(),h=h.then(b,m)}d?(h.success=function(a){Qa(a,"fn");h.then(function(b){a(b.data,b.status,b.headers,f)});return h},h.error=function(a){Qa(a,"fn");h.then(null,function(b){a(b.data,b.status,b.headers,f)});return h}):(h.success=fd("success"),h.error=fd("error"));return h}function r(c,d){function g(a,c,d,e){function f(){l(c,a,d,e)}D&&(200<=a&&300>a?D.put(X,[a,c,cd(d),e]):D.remove(X));b?h.$applyAsync(f):(f(),h.$$phase||
	h.$apply())}function l(a,b,d,e){b=-1<=b?b:0;(200<=b&&300>b?n.resolve:n.reject)({data:a,status:b,headers:dd(d),config:c,statusText:e})}function r(a){l(a.data,a.status,ha(a.headers()),a.statusText)}function y(){var a=m.pendingRequests.indexOf(c);-1!==a&&m.pendingRequests.splice(a,1)}var n=k.defer(),I=n.promise,D,L,O=c.headers,X=t(c.url,c.paramSerializer(c.params));m.pendingRequests.push(c);I.then(y,y);!c.cache&&!a.cache||!1===c.cache||"GET"!==c.method&&"JSONP"!==c.method||(D=G(c.cache)?c.cache:G(a.cache)?
	a.cache:C);D&&(L=D.get(X),u(L)?L&&B(L.then)?L.then(r,r):E(L)?l(L[1],L[0],ha(L[2]),L[3]):l(L,200,{},"OK"):D.put(X,I));q(L)&&((L=gd(c.url)?f()[c.xsrfCookieName||a.xsrfCookieName]:w)&&(O[c.xsrfHeaderName||a.xsrfHeaderName]=L),e(c.method,X,d,g,O,c.timeout,c.withCredentials,c.responseType));return I}function t(a,b){0<b.length&&(a+=(-1==a.indexOf("?")?"?":"&")+b);return a}var C=g("$http");a.paramSerializer=F(a.paramSerializer)?l.get(a.paramSerializer):a.paramSerializer;var y=[];n(c,function(a){y.unshift(F(a)?
	l.get(a):l.invoke(a))});m.pendingRequests=[];(function(a){n(arguments,function(a){m[a]=function(b,c){return m(N({},c||{},{method:a,url:b}))}})})("get","delete","head","jsonp");(function(a){n(arguments,function(a){m[a]=function(b,c,d){return m(N({},d||{},{method:a,url:b,data:c}))}})})("post","put","patch");m.defaults=a;return m}]}function nf(){this.$get=function(){return function(){return new S.XMLHttpRequest}}}function mf(){this.$get=["$browser","$window","$document","$xhrFactory",function(a,b,d,
	c){return Zf(a,c,a.defer,b.angular.callbacks,d[0])}]}function Zf(a,b,d,c,e){function f(a,b,d){var f=e.createElement("script"),m=null;f.type="text/javascript";f.src=a;f.async=!0;m=function(a){f.removeEventListener("load",m,!1);f.removeEventListener("error",m,!1);e.body.removeChild(f);f=null;var g=-1,C="unknown";a&&("load"!==a.type||c[b].called||(a={type:"error"}),C=a.type,g="error"===a.type?404:200);d&&d(g,C)};f.addEventListener("load",m,!1);f.addEventListener("error",m,!1);e.body.appendChild(f);return m}
	return function(e,h,k,l,m,r,t,C){function y(){x&&x();v&&v.abort()}function R(b,c,e,f,g){u(H)&&d.cancel(H);x=v=null;b(c,e,f,g);a.$$completeOutstandingRequest(z)}a.$$incOutstandingRequestCount();h=h||a.url();if("jsonp"==K(e)){var p="_"+(c.counter++).toString(36);c[p]=function(a){c[p].data=a;c[p].called=!0};var x=f(h.replace("JSON_CALLBACK","angular.callbacks."+p),p,function(a,b){R(l,a,c[p].data,"",b);c[p]=z})}else{var v=b(e,h);v.open(e,h,!0);n(m,function(a,b){u(a)&&v.setRequestHeader(b,a)});v.onload=
	function(){var a=v.statusText||"",b="response"in v?v.response:v.responseText,c=1223===v.status?204:v.status;0===c&&(c=b?200:"file"==xa(h).protocol?404:0);R(l,c,b,v.getAllResponseHeaders(),a)};e=function(){R(l,-1,null,null,"")};v.onerror=e;v.onabort=e;t&&(v.withCredentials=!0);if(C)try{v.responseType=C}catch(Y){if("json"!==C)throw Y;}v.send(q(k)?null:k)}if(0<r)var H=d(y,r);else r&&B(r.then)&&r.then(y)}}function gf(){var a="{{",b="}}";this.startSymbol=function(b){return b?(a=b,this):a};this.endSymbol=
	function(a){return a?(b=a,this):b};this.$get=["$parse","$exceptionHandler","$sce",function(d,c,e){function f(a){return"\\\\\\"+a}function g(c){return c.replace(m,a).replace(r,b)}function h(f,h,m,r){function p(a){try{var b=a;a=m?e.getTrusted(m,b):e.valueOf(b);var d;if(r&&!u(a))d=a;else if(null==a)d="";else{switch(typeof a){case "string":break;case "number":a=""+a;break;default:a=cb(a)}d=a}return d}catch(g){c(Ia.interr(f,g))}}r=!!r;for(var x,v,n=0,H=[],s=[],I=f.length,D=[],L=[];n<I;)if(-1!=(x=f.indexOf(a,
	n))&&-1!=(v=f.indexOf(b,x+k)))n!==x&&D.push(g(f.substring(n,x))),n=f.substring(x+k,v),H.push(n),s.push(d(n,p)),n=v+l,L.push(D.length),D.push("");else{n!==I&&D.push(g(f.substring(n)));break}m&&1<D.length&&Ia.throwNoconcat(f);if(!h||H.length){var O=function(a){for(var b=0,c=H.length;b<c;b++){if(r&&q(a[b]))return;D[L[b]]=a[b]}return D.join("")};return N(function(a){var b=0,d=H.length,e=Array(d);try{for(;b<d;b++)e[b]=s[b](a);return O(e)}catch(g){c(Ia.interr(f,g))}},{exp:f,expressions:H,$$watchDelegate:function(a,
	b){var c;return a.$watchGroup(s,function(d,e){var f=O(d);B(b)&&b.call(this,f,d!==e?c:f,a);c=f})}})}}var k=a.length,l=b.length,m=new RegExp(a.replace(/./g,f),"g"),r=new RegExp(b.replace(/./g,f),"g");h.startSymbol=function(){return a};h.endSymbol=function(){return b};return h}]}function hf(){this.$get=["$rootScope","$window","$q","$$q",function(a,b,d,c){function e(e,h,k,l){var m=4<arguments.length,r=m?sa.call(arguments,4):[],t=b.setInterval,C=b.clearInterval,y=0,n=u(l)&&!l,p=(n?c:d).defer(),x=p.promise;
	k=u(k)?k:0;x.then(null,null,m?function(){e.apply(null,r)}:e);x.$$intervalId=t(function(){p.notify(y++);0<k&&y>=k&&(p.resolve(y),C(x.$$intervalId),delete f[x.$$intervalId]);n||a.$apply()},h);f[x.$$intervalId]=p;return x}var f={};e.cancel=function(a){return a&&a.$$intervalId in f?(f[a.$$intervalId].reject("canceled"),b.clearInterval(a.$$intervalId),delete f[a.$$intervalId],!0):!1};return e}]}function cc(a){a=a.split("/");for(var b=a.length;b--;)a[b]=pb(a[b]);return a.join("/")}function hd(a,b){var d=
	xa(a);b.$$protocol=d.protocol;b.$$host=d.hostname;b.$$port=Z(d.port)||$f[d.protocol]||null}function id(a,b){var d="/"!==a.charAt(0);d&&(a="/"+a);var c=xa(a);b.$$path=decodeURIComponent(d&&"/"===c.pathname.charAt(0)?c.pathname.substring(1):c.pathname);b.$$search=yc(c.search);b.$$hash=decodeURIComponent(c.hash);b.$$path&&"/"!=b.$$path.charAt(0)&&(b.$$path="/"+b.$$path)}function qa(a,b){if(0===b.indexOf(a))return b.substr(a.length)}function Ga(a){var b=a.indexOf("#");return-1==b?a:a.substr(0,b)}function jb(a){return a.replace(/(#.+)|#$/,
	"$1")}function dc(a,b,d){this.$$html5=!0;d=d||"";hd(a,this);this.$$parse=function(a){var d=qa(b,a);if(!F(d))throw Fb("ipthprfx",a,b);id(d,this);this.$$path||(this.$$path="/");this.$$compose()};this.$$compose=function(){var a=Sb(this.$$search),d=this.$$hash?"#"+pb(this.$$hash):"";this.$$url=cc(this.$$path)+(a?"?"+a:"")+d;this.$$absUrl=b+this.$$url.substr(1)};this.$$parseLinkUrl=function(c,e){if(e&&"#"===e[0])return this.hash(e.slice(1)),!0;var f,g;u(f=qa(a,c))?(g=f,g=u(f=qa(d,f))?b+(qa("/",f)||f):
	a+g):u(f=qa(b,c))?g=b+f:b==c+"/"&&(g=b);g&&this.$$parse(g);return!!g}}function ec(a,b,d){hd(a,this);this.$$parse=function(c){var e=qa(a,c)||qa(b,c),f;q(e)||"#"!==e.charAt(0)?this.$$html5?f=e:(f="",q(e)&&(a=c,this.replace())):(f=qa(d,e),q(f)&&(f=e));id(f,this);c=this.$$path;var e=a,g=/^\/[A-Z]:(\/.*)/;0===f.indexOf(e)&&(f=f.replace(e,""));g.exec(f)||(c=(f=g.exec(c))?f[1]:c);this.$$path=c;this.$$compose()};this.$$compose=function(){var b=Sb(this.$$search),e=this.$$hash?"#"+pb(this.$$hash):"";this.$$url=
	cc(this.$$path)+(b?"?"+b:"")+e;this.$$absUrl=a+(this.$$url?d+this.$$url:"")};this.$$parseLinkUrl=function(b,d){return Ga(a)==Ga(b)?(this.$$parse(b),!0):!1}}function jd(a,b,d){this.$$html5=!0;ec.apply(this,arguments);this.$$parseLinkUrl=function(c,e){if(e&&"#"===e[0])return this.hash(e.slice(1)),!0;var f,g;a==Ga(c)?f=c:(g=qa(b,c))?f=a+d+g:b===c+"/"&&(f=b);f&&this.$$parse(f);return!!f};this.$$compose=function(){var b=Sb(this.$$search),e=this.$$hash?"#"+pb(this.$$hash):"";this.$$url=cc(this.$$path)+
	(b?"?"+b:"")+e;this.$$absUrl=a+d+this.$$url}}function Gb(a){return function(){return this[a]}}function kd(a,b){return function(d){if(q(d))return this[a];this[a]=b(d);this.$$compose();return this}}function of(){var a="",b={enabled:!1,requireBase:!0,rewriteLinks:!0};this.hashPrefix=function(b){return u(b)?(a=b,this):a};this.html5Mode=function(a){return $a(a)?(b.enabled=a,this):G(a)?($a(a.enabled)&&(b.enabled=a.enabled),$a(a.requireBase)&&(b.requireBase=a.requireBase),$a(a.rewriteLinks)&&(b.rewriteLinks=
	a.rewriteLinks),this):b};this.$get=["$rootScope","$browser","$sniffer","$rootElement","$window",function(d,c,e,f,g){function h(a,b,d){var e=l.url(),f=l.$$state;try{c.url(a,b,d),l.$$state=c.state()}catch(g){throw l.url(e),l.$$state=f,g;}}function k(a,b){d.$broadcast("$locationChangeSuccess",l.absUrl(),a,l.$$state,b)}var l,m;m=c.baseHref();var r=c.url(),t;if(b.enabled){if(!m&&b.requireBase)throw Fb("nobase");t=r.substring(0,r.indexOf("/",r.indexOf("//")+2))+(m||"/");m=e.history?dc:jd}else t=Ga(r),m=
	ec;var C=t.substr(0,Ga(t).lastIndexOf("/")+1);l=new m(t,C,"#"+a);l.$$parseLinkUrl(r,r);l.$$state=c.state();var y=/^\s*(javascript|mailto):/i;f.on("click",function(a){if(b.rewriteLinks&&!a.ctrlKey&&!a.metaKey&&!a.shiftKey&&2!=a.which&&2!=a.button){for(var e=A(a.target);"a"!==oa(e[0]);)if(e[0]===f[0]||!(e=e.parent())[0])return;var h=e.prop("href"),k=e.attr("href")||e.attr("xlink:href");G(h)&&"[object SVGAnimatedString]"===h.toString()&&(h=xa(h.animVal).href);y.test(h)||!h||e.attr("target")||a.isDefaultPrevented()||
	!l.$$parseLinkUrl(h,k)||(a.preventDefault(),l.absUrl()!=c.url()&&(d.$apply(),g.angular["ff-684208-preventDefault"]=!0))}});jb(l.absUrl())!=jb(r)&&c.url(l.absUrl(),!0);var n=!0;c.onUrlChange(function(a,b){q(qa(C,a))?g.location.href=a:(d.$evalAsync(function(){var c=l.absUrl(),e=l.$$state,f;a=jb(a);l.$$parse(a);l.$$state=b;f=d.$broadcast("$locationChangeStart",a,c,b,e).defaultPrevented;l.absUrl()===a&&(f?(l.$$parse(c),l.$$state=e,h(c,!1,e)):(n=!1,k(c,e)))}),d.$$phase||d.$digest())});d.$watch(function(){var a=
	jb(c.url()),b=jb(l.absUrl()),f=c.state(),g=l.$$replace,m=a!==b||l.$$html5&&e.history&&f!==l.$$state;if(n||m)n=!1,d.$evalAsync(function(){var b=l.absUrl(),c=d.$broadcast("$locationChangeStart",b,a,l.$$state,f).defaultPrevented;l.absUrl()===b&&(c?(l.$$parse(a),l.$$state=f):(m&&h(b,g,f===l.$$state?null:l.$$state),k(a,f)))});l.$$replace=!1});return l}]}function pf(){var a=!0,b=this;this.debugEnabled=function(b){return u(b)?(a=b,this):a};this.$get=["$window",function(d){function c(a){a instanceof Error&&
	(a.stack?a=a.message&&-1===a.stack.indexOf(a.message)?"Error: "+a.message+"\n"+a.stack:a.stack:a.sourceURL&&(a=a.message+"\n"+a.sourceURL+":"+a.line));return a}function e(a){var b=d.console||{},e=b[a]||b.log||z;a=!1;try{a=!!e.apply}catch(k){}return a?function(){var a=[];n(arguments,function(b){a.push(c(b))});return e.apply(b,a)}:function(a,b){e(a,null==b?"":b)}}return{log:e("log"),info:e("info"),warn:e("warn"),error:e("error"),debug:function(){var c=e("debug");return function(){a&&c.apply(b,arguments)}}()}}]}
	function Va(a,b){if("__defineGetter__"===a||"__defineSetter__"===a||"__lookupGetter__"===a||"__lookupSetter__"===a||"__proto__"===a)throw aa("isecfld",b);return a}function ld(a,b){a+="";if(!F(a))throw aa("iseccst",b);return a}function ya(a,b){if(a){if(a.constructor===a)throw aa("isecfn",b);if(a.window===a)throw aa("isecwindow",b);if(a.children&&(a.nodeName||a.prop&&a.attr&&a.find))throw aa("isecdom",b);if(a===Object)throw aa("isecobj",b);}return a}function md(a,b){if(a){if(a.constructor===a)throw aa("isecfn",
	b);if(a===ag||a===bg||a===cg)throw aa("isecff",b);}}function nd(a,b){if(a&&(a===(0).constructor||a===(!1).constructor||a==="".constructor||a==={}.constructor||a===[].constructor||a===Function.constructor))throw aa("isecaf",b);}function dg(a,b){return"undefined"!==typeof a?a:b}function od(a,b){return"undefined"===typeof a?b:"undefined"===typeof b?a:a+b}function V(a,b){var d,c;switch(a.type){case s.Program:d=!0;n(a.body,function(a){V(a.expression,b);d=d&&a.expression.constant});a.constant=d;break;case s.Literal:a.constant=
	!0;a.toWatch=[];break;case s.UnaryExpression:V(a.argument,b);a.constant=a.argument.constant;a.toWatch=a.argument.toWatch;break;case s.BinaryExpression:V(a.left,b);V(a.right,b);a.constant=a.left.constant&&a.right.constant;a.toWatch=a.left.toWatch.concat(a.right.toWatch);break;case s.LogicalExpression:V(a.left,b);V(a.right,b);a.constant=a.left.constant&&a.right.constant;a.toWatch=a.constant?[]:[a];break;case s.ConditionalExpression:V(a.test,b);V(a.alternate,b);V(a.consequent,b);a.constant=a.test.constant&&
	a.alternate.constant&&a.consequent.constant;a.toWatch=a.constant?[]:[a];break;case s.Identifier:a.constant=!1;a.toWatch=[a];break;case s.MemberExpression:V(a.object,b);a.computed&&V(a.property,b);a.constant=a.object.constant&&(!a.computed||a.property.constant);a.toWatch=[a];break;case s.CallExpression:d=a.filter?!b(a.callee.name).$stateful:!1;c=[];n(a.arguments,function(a){V(a,b);d=d&&a.constant;a.constant||c.push.apply(c,a.toWatch)});a.constant=d;a.toWatch=a.filter&&!b(a.callee.name).$stateful?c:
	[a];break;case s.AssignmentExpression:V(a.left,b);V(a.right,b);a.constant=a.left.constant&&a.right.constant;a.toWatch=[a];break;case s.ArrayExpression:d=!0;c=[];n(a.elements,function(a){V(a,b);d=d&&a.constant;a.constant||c.push.apply(c,a.toWatch)});a.constant=d;a.toWatch=c;break;case s.ObjectExpression:d=!0;c=[];n(a.properties,function(a){V(a.value,b);d=d&&a.value.constant;a.value.constant||c.push.apply(c,a.value.toWatch)});a.constant=d;a.toWatch=c;break;case s.ThisExpression:a.constant=!1,a.toWatch=
	[]}}function pd(a){if(1==a.length){a=a[0].expression;var b=a.toWatch;return 1!==b.length?b:b[0]!==a?b:w}}function qd(a){return a.type===s.Identifier||a.type===s.MemberExpression}function rd(a){if(1===a.body.length&&qd(a.body[0].expression))return{type:s.AssignmentExpression,left:a.body[0].expression,right:{type:s.NGValueParameter},operator:"="}}function sd(a){return 0===a.body.length||1===a.body.length&&(a.body[0].expression.type===s.Literal||a.body[0].expression.type===s.ArrayExpression||a.body[0].expression.type===
	s.ObjectExpression)}function td(a,b){this.astBuilder=a;this.$filter=b}function ud(a,b){this.astBuilder=a;this.$filter=b}function Hb(a){return"constructor"==a}function fc(a){return B(a.valueOf)?a.valueOf():eg.call(a)}function qf(){var a=ea(),b=ea();this.$get=["$filter",function(d){function c(a,b){return null==a||null==b?a===b:"object"===typeof a&&(a=fc(a),"object"===typeof a)?!1:a===b||a!==a&&b!==b}function e(a,b,d,e,f){var g=e.inputs,h;if(1===g.length){var k=c,g=g[0];return a.$watch(function(a){var b=
	g(a);c(b,k)||(h=e(a,w,w,[b]),k=b&&fc(b));return h},b,d,f)}for(var l=[],m=[],r=0,n=g.length;r<n;r++)l[r]=c,m[r]=null;return a.$watch(function(a){for(var b=!1,d=0,f=g.length;d<f;d++){var k=g[d](a);if(b||(b=!c(k,l[d])))m[d]=k,l[d]=k&&fc(k)}b&&(h=e(a,w,w,m));return h},b,d,f)}function f(a,b,c,d){var e,f;return e=a.$watch(function(a){return d(a)},function(a,c,d){f=a;B(b)&&b.apply(this,arguments);u(a)&&d.$$postDigest(function(){u(f)&&e()})},c)}function g(a,b,c,d){function e(a){var b=!0;n(a,function(a){u(a)||
	(b=!1)});return b}var f,g;return f=a.$watch(function(a){return d(a)},function(a,c,d){g=a;B(b)&&b.call(this,a,c,d);e(a)&&d.$$postDigest(function(){e(g)&&f()})},c)}function h(a,b,c,d){var e;return e=a.$watch(function(a){return d(a)},function(a,c,d){B(b)&&b.apply(this,arguments);e()},c)}function k(a,b){if(!b)return a;var c=a.$$watchDelegate,d=!1,c=c!==g&&c!==f?function(c,e,f,g){f=d&&g?g[0]:a(c,e,f,g);return b(f,c,e)}:function(c,d,e,f){e=a(c,d,e,f);c=b(e,c,d);return u(e)?c:e};a.$$watchDelegate&&a.$$watchDelegate!==
	e?c.$$watchDelegate=a.$$watchDelegate:b.$stateful||(c.$$watchDelegate=e,d=!a.inputs,c.inputs=a.inputs?a.inputs:[a]);return c}var l=Ca().noUnsafeEval,m={csp:l,expensiveChecks:!1},r={csp:l,expensiveChecks:!0};return function(c,l,y){var n,p,x;switch(typeof c){case "string":x=c=c.trim();var v=y?b:a;n=v[x];n||(":"===c.charAt(0)&&":"===c.charAt(1)&&(p=!0,c=c.substring(2)),y=y?r:m,n=new gc(y),n=(new hc(n,d,y)).parse(c),n.constant?n.$$watchDelegate=h:p?n.$$watchDelegate=n.literal?g:f:n.inputs&&(n.$$watchDelegate=
	e),v[x]=n);return k(n,l);case "function":return k(c,l);default:return k(z,l)}}}]}function sf(){this.$get=["$rootScope","$exceptionHandler",function(a,b){return vd(function(b){a.$evalAsync(b)},b)}]}function tf(){this.$get=["$browser","$exceptionHandler",function(a,b){return vd(function(b){a.defer(b)},b)}]}function vd(a,b){function d(a,b,c){function d(b){return function(c){e||(e=!0,b.call(a,c))}}var e=!1;return[d(b),d(c)]}function c(){this.$$state={status:0}}function e(a,b){return function(c){b.call(a,
	c)}}function f(c){!c.processScheduled&&c.pending&&(c.processScheduled=!0,a(function(){var a,d,e;e=c.pending;c.processScheduled=!1;c.pending=w;for(var f=0,g=e.length;f<g;++f){d=e[f][0];a=e[f][c.status];try{B(a)?d.resolve(a(c.value)):1===c.status?d.resolve(c.value):d.reject(c.value)}catch(h){d.reject(h),b(h)}}}))}function g(){this.promise=new c;this.resolve=e(this,this.resolve);this.reject=e(this,this.reject);this.notify=e(this,this.notify)}var h=M("$q",TypeError);N(c.prototype,{then:function(a,b,c){if(q(a)&&
	q(b)&&q(c))return this;var d=new g;this.$$state.pending=this.$$state.pending||[];this.$$state.pending.push([d,a,b,c]);0<this.$$state.status&&f(this.$$state);return d.promise},"catch":function(a){return this.then(null,a)},"finally":function(a,b){return this.then(function(b){return l(b,!0,a)},function(b){return l(b,!1,a)},b)}});N(g.prototype,{resolve:function(a){this.promise.$$state.status||(a===this.promise?this.$$reject(h("qcycle",a)):this.$$resolve(a))},$$resolve:function(a){var c,e;e=d(this,this.$$resolve,
	this.$$reject);try{if(G(a)||B(a))c=a&&a.then;B(c)?(this.promise.$$state.status=-1,c.call(a,e[0],e[1],this.notify)):(this.promise.$$state.value=a,this.promise.$$state.status=1,f(this.promise.$$state))}catch(g){e[1](g),b(g)}},reject:function(a){this.promise.$$state.status||this.$$reject(a)},$$reject:function(a){this.promise.$$state.value=a;this.promise.$$state.status=2;f(this.promise.$$state)},notify:function(c){var d=this.promise.$$state.pending;0>=this.promise.$$state.status&&d&&d.length&&a(function(){for(var a,
	e,f=0,g=d.length;f<g;f++){e=d[f][0];a=d[f][3];try{e.notify(B(a)?a(c):c)}catch(h){b(h)}}})}});var k=function(a,b){var c=new g;b?c.resolve(a):c.reject(a);return c.promise},l=function(a,b,c){var d=null;try{B(c)&&(d=c())}catch(e){return k(e,!1)}return d&&B(d.then)?d.then(function(){return k(a,b)},function(a){return k(a,!1)}):k(a,b)},m=function(a,b,c,d){var e=new g;e.resolve(a);return e.promise.then(b,c,d)},r=function C(a){if(!B(a))throw h("norslvr",a);if(!(this instanceof C))return new C(a);var b=new g;
	a(function(a){b.resolve(a)},function(a){b.reject(a)});return b.promise};r.defer=function(){return new g};r.reject=function(a){var b=new g;b.reject(a);return b.promise};r.when=m;r.resolve=m;r.all=function(a){var b=new g,c=0,d=E(a)?[]:{};n(a,function(a,e){c++;m(a).then(function(a){d.hasOwnProperty(e)||(d[e]=a,--c||b.resolve(d))},function(a){d.hasOwnProperty(e)||b.reject(a)})});0===c&&b.resolve(d);return b.promise};return r}function Cf(){this.$get=["$window","$timeout",function(a,b){var d=a.requestAnimationFrame||
	a.webkitRequestAnimationFrame,c=a.cancelAnimationFrame||a.webkitCancelAnimationFrame||a.webkitCancelRequestAnimationFrame,e=!!d,f=e?function(a){var b=d(a);return function(){c(b)}}:function(a){var c=b(a,16.66,!1);return function(){b.cancel(c)}};f.supported=e;return f}]}function rf(){function a(a){function b(){this.$$watchers=this.$$nextSibling=this.$$childHead=this.$$childTail=null;this.$$listeners={};this.$$listenerCount={};this.$$watchersCount=0;this.$id=++ob;this.$$ChildScope=null}b.prototype=a;
	return b}var b=10,d=M("$rootScope"),c=null,e=null;this.digestTtl=function(a){arguments.length&&(b=a);return b};this.$get=["$injector","$exceptionHandler","$parse","$browser",function(f,g,h,k){function l(a){a.currentScope.$$destroyed=!0}function m(a){9===Ha&&(a.$$childHead&&m(a.$$childHead),a.$$nextSibling&&m(a.$$nextSibling));a.$parent=a.$$nextSibling=a.$$prevSibling=a.$$childHead=a.$$childTail=a.$root=a.$$watchers=null}function r(){this.$id=++ob;this.$$phase=this.$parent=this.$$watchers=this.$$nextSibling=
	this.$$prevSibling=this.$$childHead=this.$$childTail=null;this.$root=this;this.$$destroyed=!1;this.$$listeners={};this.$$listenerCount={};this.$$watchersCount=0;this.$$isolateBindings=null}function t(a){if(v.$$phase)throw d("inprog",v.$$phase);v.$$phase=a}function C(a,b){do a.$$watchersCount+=b;while(a=a.$parent)}function y(a,b,c){do a.$$listenerCount[c]-=b,0===a.$$listenerCount[c]&&delete a.$$listenerCount[c];while(a=a.$parent)}function s(){}function p(){for(;w.length;)try{w.shift()()}catch(a){g(a)}e=
	null}function x(){null===e&&(e=k.defer(function(){v.$apply(p)}))}r.prototype={constructor:r,$new:function(b,c){var d;c=c||this;b?(d=new r,d.$root=this.$root):(this.$$ChildScope||(this.$$ChildScope=a(this)),d=new this.$$ChildScope);d.$parent=c;d.$$prevSibling=c.$$childTail;c.$$childHead?(c.$$childTail.$$nextSibling=d,c.$$childTail=d):c.$$childHead=c.$$childTail=d;(b||c!=this)&&d.$on("$destroy",l);return d},$watch:function(a,b,d,e){var f=h(a);if(f.$$watchDelegate)return f.$$watchDelegate(this,b,d,f,
	a);var g=this,k=g.$$watchers,l={fn:b,last:s,get:f,exp:e||a,eq:!!d};c=null;B(b)||(l.fn=z);k||(k=g.$$watchers=[]);k.unshift(l);C(this,1);return function(){0<=ab(k,l)&&C(g,-1);c=null}},$watchGroup:function(a,b){function c(){h=!1;k?(k=!1,b(e,e,g)):b(e,d,g)}var d=Array(a.length),e=Array(a.length),f=[],g=this,h=!1,k=!0;if(!a.length){var l=!0;g.$evalAsync(function(){l&&b(e,e,g)});return function(){l=!1}}if(1===a.length)return this.$watch(a[0],function(a,c,f){e[0]=a;d[0]=c;b(e,a===c?e:d,f)});n(a,function(a,
	b){var k=g.$watch(a,function(a,f){e[b]=a;d[b]=f;h||(h=!0,g.$evalAsync(c))});f.push(k)});return function(){for(;f.length;)f.shift()()}},$watchCollection:function(a,b){function c(a){e=a;var b,d,g,h;if(!q(e)){if(G(e))if(Aa(e))for(f!==r&&(f=r,p=f.length=0,l++),a=e.length,p!==a&&(l++,f.length=p=a),b=0;b<a;b++)h=f[b],g=e[b],d=h!==h&&g!==g,d||h===g||(l++,f[b]=g);else{f!==t&&(f=t={},p=0,l++);a=0;for(b in e)ra.call(e,b)&&(a++,g=e[b],h=f[b],b in f?(d=h!==h&&g!==g,d||h===g||(l++,f[b]=g)):(p++,f[b]=g,l++));if(p>
	a)for(b in l++,f)ra.call(e,b)||(p--,delete f[b])}else f!==e&&(f=e,l++);return l}}c.$stateful=!0;var d=this,e,f,g,k=1<b.length,l=0,m=h(a,c),r=[],t={},n=!0,p=0;return this.$watch(m,function(){n?(n=!1,b(e,e,d)):b(e,g,d);if(k)if(G(e))if(Aa(e)){g=Array(e.length);for(var a=0;a<e.length;a++)g[a]=e[a]}else for(a in g={},e)ra.call(e,a)&&(g[a]=e[a]);else g=e})},$digest:function(){var a,f,h,l,m,r,n=b,C,x=[],q,y;t("$digest");k.$$checkUrlChange();this===v&&null!==e&&(k.defer.cancel(e),p());c=null;do{r=!1;for(C=
	this;u.length;){try{y=u.shift(),y.scope.$eval(y.expression,y.locals)}catch(w){g(w)}c=null}a:do{if(l=C.$$watchers)for(m=l.length;m--;)try{if(a=l[m])if((f=a.get(C))!==(h=a.last)&&!(a.eq?ka(f,h):"number"===typeof f&&"number"===typeof h&&isNaN(f)&&isNaN(h)))r=!0,c=a,a.last=a.eq?Ma(f,null):f,a.fn(f,h===s?f:h,C),5>n&&(q=4-n,x[q]||(x[q]=[]),x[q].push({msg:B(a.exp)?"fn: "+(a.exp.name||a.exp.toString()):a.exp,newVal:f,oldVal:h}));else if(a===c){r=!1;break a}}catch(la){g(la)}if(!(l=C.$$watchersCount&&C.$$childHead||
	C!==this&&C.$$nextSibling))for(;C!==this&&!(l=C.$$nextSibling);)C=C.$parent}while(C=l);if((r||u.length)&&!n--)throw v.$$phase=null,d("infdig",b,x);}while(r||u.length);for(v.$$phase=null;H.length;)try{H.shift()()}catch(A){g(A)}},$destroy:function(){if(!this.$$destroyed){var a=this.$parent;this.$broadcast("$destroy");this.$$destroyed=!0;this===v&&k.$$applicationDestroyed();C(this,-this.$$watchersCount);for(var b in this.$$listenerCount)y(this,this.$$listenerCount[b],b);a&&a.$$childHead==this&&(a.$$childHead=
	this.$$nextSibling);a&&a.$$childTail==this&&(a.$$childTail=this.$$prevSibling);this.$$prevSibling&&(this.$$prevSibling.$$nextSibling=this.$$nextSibling);this.$$nextSibling&&(this.$$nextSibling.$$prevSibling=this.$$prevSibling);this.$destroy=this.$digest=this.$apply=this.$evalAsync=this.$applyAsync=z;this.$on=this.$watch=this.$watchGroup=function(){return z};this.$$listeners={};this.$$nextSibling=null;m(this)}},$eval:function(a,b){return h(a)(this,b)},$evalAsync:function(a,b){v.$$phase||u.length||
	k.defer(function(){u.length&&v.$digest()});u.push({scope:this,expression:a,locals:b})},$$postDigest:function(a){H.push(a)},$apply:function(a){try{t("$apply");try{return this.$eval(a)}finally{v.$$phase=null}}catch(b){g(b)}finally{try{v.$digest()}catch(c){throw g(c),c;}}},$applyAsync:function(a){function b(){c.$eval(a)}var c=this;a&&w.push(b);x()},$on:function(a,b){var c=this.$$listeners[a];c||(this.$$listeners[a]=c=[]);c.push(b);var d=this;do d.$$listenerCount[a]||(d.$$listenerCount[a]=0),d.$$listenerCount[a]++;
	while(d=d.$parent);var e=this;return function(){var d=c.indexOf(b);-1!==d&&(c[d]=null,y(e,1,a))}},$emit:function(a,b){var c=[],d,e=this,f=!1,h={name:a,targetScope:e,stopPropagation:function(){f=!0},preventDefault:function(){h.defaultPrevented=!0},defaultPrevented:!1},k=bb([h],arguments,1),l,m;do{d=e.$$listeners[a]||c;h.currentScope=e;l=0;for(m=d.length;l<m;l++)if(d[l])try{d[l].apply(null,k)}catch(r){g(r)}else d.splice(l,1),l--,m--;if(f)return h.currentScope=null,h;e=e.$parent}while(e);h.currentScope=
	null;return h},$broadcast:function(a,b){var c=this,d=this,e={name:a,targetScope:this,preventDefault:function(){e.defaultPrevented=!0},defaultPrevented:!1};if(!this.$$listenerCount[a])return e;for(var f=bb([e],arguments,1),h,k;c=d;){e.currentScope=c;d=c.$$listeners[a]||[];h=0;for(k=d.length;h<k;h++)if(d[h])try{d[h].apply(null,f)}catch(l){g(l)}else d.splice(h,1),h--,k--;if(!(d=c.$$listenerCount[a]&&c.$$childHead||c!==this&&c.$$nextSibling))for(;c!==this&&!(d=c.$$nextSibling);)c=c.$parent}e.currentScope=
	null;return e}};var v=new r,u=v.$$asyncQueue=[],H=v.$$postDigestQueue=[],w=v.$$applyAsyncQueue=[];return v}]}function ke(){var a=/^\s*(https?|ftp|mailto|tel|file):/,b=/^\s*((https?|ftp|file|blob):|data:image\/)/;this.aHrefSanitizationWhitelist=function(b){return u(b)?(a=b,this):a};this.imgSrcSanitizationWhitelist=function(a){return u(a)?(b=a,this):b};this.$get=function(){return function(d,c){var e=c?b:a,f;f=xa(d).href;return""===f||f.match(e)?d:"unsafe:"+f}}}function fg(a){if("self"===a)return a;
	if(F(a)){if(-1<a.indexOf("***"))throw za("iwcard",a);a=wd(a).replace("\\*\\*",".*").replace("\\*","[^:/.?&;]*");return new RegExp("^"+a+"$")}if(La(a))return new RegExp("^"+a.source+"$");throw za("imatcher");}function xd(a){var b=[];u(a)&&n(a,function(a){b.push(fg(a))});return b}function vf(){this.SCE_CONTEXTS=ma;var a=["self"],b=[];this.resourceUrlWhitelist=function(b){arguments.length&&(a=xd(b));return a};this.resourceUrlBlacklist=function(a){arguments.length&&(b=xd(a));return b};this.$get=["$injector",
	function(d){function c(a,b){return"self"===a?gd(b):!!a.exec(b.href)}function e(a){var b=function(a){this.$$unwrapTrustedValue=function(){return a}};a&&(b.prototype=new a);b.prototype.valueOf=function(){return this.$$unwrapTrustedValue()};b.prototype.toString=function(){return this.$$unwrapTrustedValue().toString()};return b}var f=function(a){throw za("unsafe");};d.has("$sanitize")&&(f=d.get("$sanitize"));var g=e(),h={};h[ma.HTML]=e(g);h[ma.CSS]=e(g);h[ma.URL]=e(g);h[ma.JS]=e(g);h[ma.RESOURCE_URL]=
	e(h[ma.URL]);return{trustAs:function(a,b){var c=h.hasOwnProperty(a)?h[a]:null;if(!c)throw za("icontext",a,b);if(null===b||q(b)||""===b)return b;if("string"!==typeof b)throw za("itype",a);return new c(b)},getTrusted:function(d,e){if(null===e||q(e)||""===e)return e;var g=h.hasOwnProperty(d)?h[d]:null;if(g&&e instanceof g)return e.$$unwrapTrustedValue();if(d===ma.RESOURCE_URL){var g=xa(e.toString()),r,t,n=!1;r=0;for(t=a.length;r<t;r++)if(c(a[r],g)){n=!0;break}if(n)for(r=0,t=b.length;r<t;r++)if(c(b[r],
	g)){n=!1;break}if(n)return e;throw za("insecurl",e.toString());}if(d===ma.HTML)return f(e);throw za("unsafe");},valueOf:function(a){return a instanceof g?a.$$unwrapTrustedValue():a}}}]}function uf(){var a=!0;this.enabled=function(b){arguments.length&&(a=!!b);return a};this.$get=["$parse","$sceDelegate",function(b,d){if(a&&8>Ha)throw za("iequirks");var c=ha(ma);c.isEnabled=function(){return a};c.trustAs=d.trustAs;c.getTrusted=d.getTrusted;c.valueOf=d.valueOf;a||(c.trustAs=c.getTrusted=function(a,b){return b},
	c.valueOf=Ya);c.parseAs=function(a,d){var e=b(d);return e.literal&&e.constant?e:b(d,function(b){return c.getTrusted(a,b)})};var e=c.parseAs,f=c.getTrusted,g=c.trustAs;n(ma,function(a,b){var d=K(b);c[eb("parse_as_"+d)]=function(b){return e(a,b)};c[eb("get_trusted_"+d)]=function(b){return f(a,b)};c[eb("trust_as_"+d)]=function(b){return g(a,b)}});return c}]}function wf(){this.$get=["$window","$document",function(a,b){var d={},c=Z((/android (\d+)/.exec(K((a.navigator||{}).userAgent))||[])[1]),e=/Boxee/i.test((a.navigator||
	{}).userAgent),f=b[0]||{},g,h=/^(Moz|webkit|ms)(?=[A-Z])/,k=f.body&&f.body.style,l=!1,m=!1;if(k){for(var r in k)if(l=h.exec(r)){g=l[0];g=g.substr(0,1).toUpperCase()+g.substr(1);break}g||(g="WebkitOpacity"in k&&"webkit");l=!!("transition"in k||g+"Transition"in k);m=!!("animation"in k||g+"Animation"in k);!c||l&&m||(l=F(k.webkitTransition),m=F(k.webkitAnimation))}return{history:!(!a.history||!a.history.pushState||4>c||e),hasEvent:function(a){if("input"===a&&11>=Ha)return!1;if(q(d[a])){var b=f.createElement("div");
	d[a]="on"+a in b}return d[a]},csp:Ca(),vendorPrefix:g,transitions:l,animations:m,android:c}}]}function yf(){this.$get=["$templateCache","$http","$q","$sce",function(a,b,d,c){function e(f,g){e.totalPendingRequests++;F(f)&&a.get(f)||(f=c.getTrustedResourceUrl(f));var h=b.defaults&&b.defaults.transformResponse;E(h)?h=h.filter(function(a){return a!==ac}):h===ac&&(h=null);return b.get(f,{cache:a,transformResponse:h})["finally"](function(){e.totalPendingRequests--}).then(function(b){a.put(f,b.data);return b.data},
	function(a){if(!g)throw ga("tpload",f,a.status,a.statusText);return d.reject(a)})}e.totalPendingRequests=0;return e}]}function zf(){this.$get=["$rootScope","$browser","$location",function(a,b,d){return{findBindings:function(a,b,d){a=a.getElementsByClassName("ng-binding");var g=[];n(a,function(a){var c=$.element(a).data("$binding");c&&n(c,function(c){d?(new RegExp("(^|\\s)"+wd(b)+"(\\s|\\||$)")).test(c)&&g.push(a):-1!=c.indexOf(b)&&g.push(a)})});return g},findModels:function(a,b,d){for(var g=["ng-",
	"data-ng-","ng\\:"],h=0;h<g.length;++h){var k=a.querySelectorAll("["+g[h]+"model"+(d?"=":"*=")+'"'+b+'"]');if(k.length)return k}},getLocation:function(){return d.url()},setLocation:function(b){b!==d.url()&&(d.url(b),a.$digest())},whenStable:function(a){b.notifyWhenNoOutstandingRequests(a)}}}]}function Af(){this.$get=["$rootScope","$browser","$q","$$q","$exceptionHandler",function(a,b,d,c,e){function f(f,k,l){B(f)||(l=k,k=f,f=z);var m=sa.call(arguments,3),r=u(l)&&!l,t=(r?c:d).defer(),n=t.promise,q;
	q=b.defer(function(){try{t.resolve(f.apply(null,m))}catch(b){t.reject(b),e(b)}finally{delete g[n.$$timeoutId]}r||a.$apply()},k);n.$$timeoutId=q;g[q]=t;return n}var g={};f.cancel=function(a){return a&&a.$$timeoutId in g?(g[a.$$timeoutId].reject("canceled"),delete g[a.$$timeoutId],b.defer.cancel(a.$$timeoutId)):!1};return f}]}function xa(a){Ha&&(ba.setAttribute("href",a),a=ba.href);ba.setAttribute("href",a);return{href:ba.href,protocol:ba.protocol?ba.protocol.replace(/:$/,""):"",host:ba.host,search:ba.search?
	ba.search.replace(/^\?/,""):"",hash:ba.hash?ba.hash.replace(/^#/,""):"",hostname:ba.hostname,port:ba.port,pathname:"/"===ba.pathname.charAt(0)?ba.pathname:"/"+ba.pathname}}function gd(a){a=F(a)?xa(a):a;return a.protocol===yd.protocol&&a.host===yd.host}function Bf(){this.$get=na(S)}function zd(a){function b(a){try{return decodeURIComponent(a)}catch(b){return a}}var d=a[0]||{},c={},e="";return function(){var a,g,h,k,l;a=d.cookie||"";if(a!==e)for(e=a,a=e.split("; "),c={},h=0;h<a.length;h++)g=a[h],k=
	g.indexOf("="),0<k&&(l=b(g.substring(0,k)),q(c[l])&&(c[l]=b(g.substring(k+1))));return c}}function Ff(){this.$get=zd}function Kc(a){function b(d,c){if(G(d)){var e={};n(d,function(a,c){e[c]=b(c,a)});return e}return a.factory(d+"Filter",c)}this.register=b;this.$get=["$injector",function(a){return function(b){return a.get(b+"Filter")}}];b("currency",Ad);b("date",Bd);b("filter",gg);b("json",hg);b("limitTo",ig);b("lowercase",jg);b("number",Cd);b("orderBy",Dd);b("uppercase",kg)}function gg(){return function(a,
	b,d){if(!Aa(a)){if(null==a)return a;throw M("filter")("notarray",a);}var c;switch(ic(b)){case "function":break;case "boolean":case "null":case "number":case "string":c=!0;case "object":b=lg(b,d,c);break;default:return a}return Array.prototype.filter.call(a,b)}}function lg(a,b,d){var c=G(a)&&"$"in a;!0===b?b=ka:B(b)||(b=function(a,b){if(q(a))return!1;if(null===a||null===b)return a===b;if(G(b)||G(a)&&!rc(a))return!1;a=K(""+a);b=K(""+b);return-1!==a.indexOf(b)});return function(e){return c&&!G(e)?Ja(e,
	a.$,b,!1):Ja(e,a,b,d)}}function Ja(a,b,d,c,e){var f=ic(a),g=ic(b);if("string"===g&&"!"===b.charAt(0))return!Ja(a,b.substring(1),d,c);if(E(a))return a.some(function(a){return Ja(a,b,d,c)});switch(f){case "object":var h;if(c){for(h in a)if("$"!==h.charAt(0)&&Ja(a[h],b,d,!0))return!0;return e?!1:Ja(a,b,d,!1)}if("object"===g){for(h in b)if(e=b[h],!B(e)&&!q(e)&&(f="$"===h,!Ja(f?a:a[h],e,d,f,f)))return!1;return!0}return d(a,b);case "function":return!1;default:return d(a,b)}}function ic(a){return null===
	a?"null":typeof a}function Ad(a){var b=a.NUMBER_FORMATS;return function(a,c,e){q(c)&&(c=b.CURRENCY_SYM);q(e)&&(e=b.PATTERNS[1].maxFrac);return null==a?a:Ed(a,b.PATTERNS[1],b.GROUP_SEP,b.DECIMAL_SEP,e).replace(/\u00A4/g,c)}}function Cd(a){var b=a.NUMBER_FORMATS;return function(a,c){return null==a?a:Ed(a,b.PATTERNS[0],b.GROUP_SEP,b.DECIMAL_SEP,c)}}function mg(a){var b=0,d,c,e,f,g;-1<(c=a.indexOf(Fd))&&(a=a.replace(Fd,""));0<(e=a.search(/e/i))?(0>c&&(c=e),c+=+a.slice(e+1),a=a.substring(0,e)):0>c&&(c=
	a.length);for(e=0;a.charAt(e)==jc;e++);if(e==(g=a.length))d=[0],c=1;else{for(g--;a.charAt(g)==jc;)g--;c-=e;d=[];for(f=0;e<=g;e++,f++)d[f]=+a.charAt(e)}c>Gd&&(d=d.splice(0,Gd-1),b=c-1,c=1);return{d:d,e:b,i:c}}function ng(a,b,d,c){var e=a.d,f=e.length-a.i;b=q(b)?Math.min(Math.max(d,f),c):+b;d=b+a.i;c=e[d];if(0<d)e.splice(d);else{a.i=1;e.length=d=b+1;for(var g=0;g<d;g++)e[g]=0}for(5<=c&&e[d-1]++;f<b;f++)e.push(0);if(b=e.reduceRight(function(a,b,c,d){b+=a;d[c]=b%10;return Math.floor(b/10)},0))e.unshift(b),
	a.i++}function Ed(a,b,d,c,e){if(!F(a)&&!Q(a)||isNaN(a))return"";var f=!isFinite(a),g=!1,h=Math.abs(a)+"",k="";if(f)k="\u221e";else{g=mg(h);ng(g,e,b.minFrac,b.maxFrac);k=g.d;h=g.i;e=g.e;f=[];for(g=k.reduce(function(a,b){return a&&!b},!0);0>h;)k.unshift(0),h++;0<h?f=k.splice(h):(f=k,k=[0]);h=[];for(k.length>b.lgSize&&h.unshift(k.splice(-b.lgSize).join(""));k.length>b.gSize;)h.unshift(k.splice(-b.gSize).join(""));k.length&&h.unshift(k.join(""));k=h.join(d);f.length&&(k+=c+f.join(""));e&&(k+="e+"+e)}return 0>
	a&&!g?b.negPre+k+b.negSuf:b.posPre+k+b.posSuf}function Ib(a,b,d){var c="";0>a&&(c="-",a=-a);for(a=""+a;a.length<b;)a=jc+a;d&&(a=a.substr(a.length-b));return c+a}function ca(a,b,d,c){d=d||0;return function(e){e=e["get"+a]();if(0<d||e>-d)e+=d;0===e&&-12==d&&(e=12);return Ib(e,b,c)}}function Jb(a,b){return function(d,c){var e=d["get"+a](),f=tb(b?"SHORT"+a:a);return c[f][e]}}function Hd(a){var b=(new Date(a,0,1)).getDay();return new Date(a,0,(4>=b?5:12)-b)}function Id(a){return function(b){var d=Hd(b.getFullYear());
	b=+new Date(b.getFullYear(),b.getMonth(),b.getDate()+(4-b.getDay()))-+d;b=1+Math.round(b/6048E5);return Ib(b,a)}}function kc(a,b){return 0>=a.getFullYear()?b.ERAS[0]:b.ERAS[1]}function Bd(a){function b(a){var b;if(b=a.match(d)){a=new Date(0);var f=0,g=0,h=b[8]?a.setUTCFullYear:a.setFullYear,k=b[8]?a.setUTCHours:a.setHours;b[9]&&(f=Z(b[9]+b[10]),g=Z(b[9]+b[11]));h.call(a,Z(b[1]),Z(b[2])-1,Z(b[3]));f=Z(b[4]||0)-f;g=Z(b[5]||0)-g;h=Z(b[6]||0);b=Math.round(1E3*parseFloat("0."+(b[7]||0)));k.call(a,f,g,
	h,b)}return a}var d=/^(\d{4})-?(\d\d)-?(\d\d)(?:T(\d\d)(?::?(\d\d)(?::?(\d\d)(?:\.(\d+))?)?)?(Z|([+-])(\d\d):?(\d\d))?)?$/;return function(c,d,f){var g="",h=[],k,l;d=d||"mediumDate";d=a.DATETIME_FORMATS[d]||d;F(c)&&(c=og.test(c)?Z(c):b(c));Q(c)&&(c=new Date(c));if(!da(c)||!isFinite(c.getTime()))return c;for(;d;)(l=pg.exec(d))?(h=bb(h,l,1),d=h.pop()):(h.push(d),d=null);var m=c.getTimezoneOffset();f&&(m=wc(f,c.getTimezoneOffset()),c=Rb(c,f,!0));n(h,function(b){k=qg[b];g+=k?k(c,a.DATETIME_FORMATS,m):
	b.replace(/(^'|'$)/g,"").replace(/''/g,"'")});return g}}function hg(){return function(a,b){q(b)&&(b=2);return cb(a,b)}}function ig(){return function(a,b,d){b=Infinity===Math.abs(Number(b))?Number(b):Z(b);if(isNaN(b))return a;Q(a)&&(a=a.toString());if(!E(a)&&!F(a))return a;d=!d||isNaN(d)?0:Z(d);d=0>d?Math.max(0,a.length+d):d;return 0<=b?a.slice(d,d+b):0===d?a.slice(b,a.length):a.slice(Math.max(0,d+b),d)}}function Dd(a){function b(b,d){d=d?-1:1;return b.map(function(b){var c=1,h=Ya;if(B(b))h=b;else if(F(b)){if("+"==
	b.charAt(0)||"-"==b.charAt(0))c="-"==b.charAt(0)?-1:1,b=b.substring(1);if(""!==b&&(h=a(b),h.constant))var k=h(),h=function(a){return a[k]}}return{get:h,descending:c*d}})}function d(a){switch(typeof a){case "number":case "boolean":case "string":return!0;default:return!1}}return function(a,e,f){if(!Aa(a))return a;E(e)||(e=[e]);0===e.length&&(e=["+"]);var g=b(e,f);g.push({get:function(){return{}},descending:f?-1:1});a=Array.prototype.map.call(a,function(a,b){return{value:a,predicateValues:g.map(function(c){var e=
	c.get(a);c=typeof e;if(null===e)c="string",e="null";else if("string"===c)e=e.toLowerCase();else if("object"===c)a:{if("function"===typeof e.valueOf&&(e=e.valueOf(),d(e)))break a;if(rc(e)&&(e=e.toString(),d(e)))break a;e=b}return{value:e,type:c}})}});a.sort(function(a,b){for(var c=0,d=0,e=g.length;d<e;++d){var c=a.predicateValues[d],f=b.predicateValues[d],n=0;c.type===f.type?c.value!==f.value&&(n=c.value<f.value?-1:1):n=c.type<f.type?-1:1;if(c=n*g[d].descending)break}return c});return a=a.map(function(a){return a.value})}}
	function Ka(a){B(a)&&(a={link:a});a.restrict=a.restrict||"AC";return na(a)}function Jd(a,b,d,c,e){var f=this,g=[];f.$error={};f.$$success={};f.$pending=w;f.$name=e(b.name||b.ngForm||"")(d);f.$dirty=!1;f.$pristine=!0;f.$valid=!0;f.$invalid=!1;f.$submitted=!1;f.$$parentForm=Kb;f.$rollbackViewValue=function(){n(g,function(a){a.$rollbackViewValue()})};f.$commitViewValue=function(){n(g,function(a){a.$commitViewValue()})};f.$addControl=function(a){Ra(a.$name,"input");g.push(a);a.$name&&(f[a.$name]=a);a.$$parentForm=
	f};f.$$renameControl=function(a,b){var c=a.$name;f[c]===a&&delete f[c];f[b]=a;a.$name=b};f.$removeControl=function(a){a.$name&&f[a.$name]===a&&delete f[a.$name];n(f.$pending,function(b,c){f.$setValidity(c,null,a)});n(f.$error,function(b,c){f.$setValidity(c,null,a)});n(f.$$success,function(b,c){f.$setValidity(c,null,a)});ab(g,a);a.$$parentForm=Kb};Kd({ctrl:this,$element:a,set:function(a,b,c){var d=a[b];d?-1===d.indexOf(c)&&d.push(c):a[b]=[c]},unset:function(a,b,c){var d=a[b];d&&(ab(d,c),0===d.length&&
	delete a[b])},$animate:c});f.$setDirty=function(){c.removeClass(a,Wa);c.addClass(a,Lb);f.$dirty=!0;f.$pristine=!1;f.$$parentForm.$setDirty()};f.$setPristine=function(){c.setClass(a,Wa,Lb+" ng-submitted");f.$dirty=!1;f.$pristine=!0;f.$submitted=!1;n(g,function(a){a.$setPristine()})};f.$setUntouched=function(){n(g,function(a){a.$setUntouched()})};f.$setSubmitted=function(){c.addClass(a,"ng-submitted");f.$submitted=!0;f.$$parentForm.$setSubmitted()}}function lc(a){a.$formatters.push(function(b){return a.$isEmpty(b)?
	b:b.toString()})}function kb(a,b,d,c,e,f){var g=K(b[0].type);if(!e.android){var h=!1;b.on("compositionstart",function(a){h=!0});b.on("compositionend",function(){h=!1;k()})}var k=function(a){l&&(f.defer.cancel(l),l=null);if(!h){var e=b.val();a=a&&a.type;"password"===g||d.ngTrim&&"false"===d.ngTrim||(e=T(e));(c.$viewValue!==e||""===e&&c.$$hasNativeValidators)&&c.$setViewValue(e,a)}};if(e.hasEvent("input"))b.on("input",k);else{var l,m=function(a,b,c){l||(l=f.defer(function(){l=null;b&&b.value===c||k(a)}))};
	b.on("keydown",function(a){var b=a.keyCode;91===b||15<b&&19>b||37<=b&&40>=b||m(a,this,this.value)});if(e.hasEvent("paste"))b.on("paste cut",m)}b.on("change",k);c.$render=function(){var a=c.$isEmpty(c.$viewValue)?"":c.$viewValue;b.val()!==a&&b.val(a)}}function Mb(a,b){return function(d,c){var e,f;if(da(d))return d;if(F(d)){'"'==d.charAt(0)&&'"'==d.charAt(d.length-1)&&(d=d.substring(1,d.length-1));if(rg.test(d))return new Date(d);a.lastIndex=0;if(e=a.exec(d))return e.shift(),f=c?{yyyy:c.getFullYear(),
	MM:c.getMonth()+1,dd:c.getDate(),HH:c.getHours(),mm:c.getMinutes(),ss:c.getSeconds(),sss:c.getMilliseconds()/1E3}:{yyyy:1970,MM:1,dd:1,HH:0,mm:0,ss:0,sss:0},n(e,function(a,c){c<b.length&&(f[b[c]]=+a)}),new Date(f.yyyy,f.MM-1,f.dd,f.HH,f.mm,f.ss||0,1E3*f.sss||0)}return NaN}}function lb(a,b,d,c){return function(e,f,g,h,k,l,m){function r(a){return a&&!(a.getTime&&a.getTime()!==a.getTime())}function n(a){return u(a)&&!da(a)?d(a)||w:a}Ld(e,f,g,h);kb(e,f,g,h,k,l);var C=h&&h.$options&&h.$options.timezone,
	y;h.$$parserName=a;h.$parsers.push(function(a){return h.$isEmpty(a)?null:b.test(a)?(a=d(a,y),C&&(a=Rb(a,C)),a):w});h.$formatters.push(function(a){if(a&&!da(a))throw mb("datefmt",a);if(r(a))return(y=a)&&C&&(y=Rb(y,C,!0)),m("date")(a,c,C);y=null;return""});if(u(g.min)||g.ngMin){var s;h.$validators.min=function(a){return!r(a)||q(s)||d(a)>=s};g.$observe("min",function(a){s=n(a);h.$validate()})}if(u(g.max)||g.ngMax){var p;h.$validators.max=function(a){return!r(a)||q(p)||d(a)<=p};g.$observe("max",function(a){p=
	n(a);h.$validate()})}}}function Ld(a,b,d,c){(c.$$hasNativeValidators=G(b[0].validity))&&c.$parsers.push(function(a){var c=b.prop("validity")||{};return c.badInput&&!c.typeMismatch?w:a})}function Md(a,b,d,c,e){if(u(c)){a=a(c);if(!a.constant)throw mb("constexpr",d,c);return a(b)}return e}function mc(a,b){a="ngClass"+a;return["$animate",function(d){function c(a,b){var c=[],d=0;a:for(;d<a.length;d++){for(var e=a[d],m=0;m<b.length;m++)if(e==b[m])continue a;c.push(e)}return c}function e(a){var b=[];return E(a)?
	(n(a,function(a){b=b.concat(e(a))}),b):F(a)?a.split(" "):G(a)?(n(a,function(a,c){a&&(b=b.concat(c.split(" ")))}),b):a}return{restrict:"AC",link:function(f,g,h){function k(a,b){var c=g.data("$classCounts")||ea(),d=[];n(a,function(a){if(0<b||c[a])c[a]=(c[a]||0)+b,c[a]===+(0<b)&&d.push(a)});g.data("$classCounts",c);return d.join(" ")}function l(a){if(!0===b||f.$index%2===b){var l=e(a||[]);if(!m){var n=k(l,1);h.$addClass(n)}else if(!ka(a,m)){var q=e(m),n=c(l,q),l=c(q,l),n=k(n,1),l=k(l,-1);n&&n.length&&
	d.addClass(g,n);l&&l.length&&d.removeClass(g,l)}}m=ha(a)}var m;f.$watch(h[a],l,!0);h.$observe("class",function(b){l(f.$eval(h[a]))});"ngClass"!==a&&f.$watch("$index",function(c,d){var g=c&1;if(g!==(d&1)){var l=e(f.$eval(h[a]));g===b?(g=k(l,1),h.$addClass(g)):(g=k(l,-1),h.$removeClass(g))}})}}}]}function Kd(a){function b(a,b){b&&!f[a]?(k.addClass(e,a),f[a]=!0):!b&&f[a]&&(k.removeClass(e,a),f[a]=!1)}function d(a,c){a=a?"-"+Ac(a,"-"):"";b(nb+a,!0===c);b(Nd+a,!1===c)}var c=a.ctrl,e=a.$element,f={},g=
	a.set,h=a.unset,k=a.$animate;f[Nd]=!(f[nb]=e.hasClass(nb));c.$setValidity=function(a,e,f){q(e)?(c.$pending||(c.$pending={}),g(c.$pending,a,f)):(c.$pending&&h(c.$pending,a,f),Od(c.$pending)&&(c.$pending=w));$a(e)?e?(h(c.$error,a,f),g(c.$$success,a,f)):(g(c.$error,a,f),h(c.$$success,a,f)):(h(c.$error,a,f),h(c.$$success,a,f));c.$pending?(b(Pd,!0),c.$valid=c.$invalid=w,d("",null)):(b(Pd,!1),c.$valid=Od(c.$error),c.$invalid=!c.$valid,d("",c.$valid));e=c.$pending&&c.$pending[a]?w:c.$error[a]?!1:c.$$success[a]?
	!0:null;d(a,e);c.$$parentForm.$setValidity(a,e,c)}}function Od(a){if(a)for(var b in a)if(a.hasOwnProperty(b))return!1;return!0}var sg=/^\/(.+)\/([a-z]*)$/,K=function(a){return F(a)?a.toLowerCase():a},ra=Object.prototype.hasOwnProperty,tb=function(a){return F(a)?a.toUpperCase():a},Ha,A,pa,sa=[].slice,Uf=[].splice,tg=[].push,ta=Object.prototype.toString,sc=Object.getPrototypeOf,Ba=M("ng"),$=S.angular||(S.angular={}),Ub,ob=0;Ha=W.documentMode;z.$inject=[];Ya.$inject=[];var E=Array.isArray,Zd=/^\[object (?:Uint8|Uint8Clamped|Uint16|Uint32|Int8|Int16|Int32|Float32|Float64)Array\]$/,
	T=function(a){return F(a)?a.trim():a},wd=function(a){return a.replace(/([-()\[\]{}+?*.$\^|,:#<!\\])/g,"\\$1").replace(/\x08/g,"\\x08")},Ca=function(){if(!u(Ca.rules)){var a=W.querySelector("[ng-csp]")||W.querySelector("[data-ng-csp]");if(a){var b=a.getAttribute("ng-csp")||a.getAttribute("data-ng-csp");Ca.rules={noUnsafeEval:!b||-1!==b.indexOf("no-unsafe-eval"),noInlineStyle:!b||-1!==b.indexOf("no-inline-style")}}else{a=Ca;try{new Function(""),b=!1}catch(d){b=!0}a.rules={noUnsafeEval:b,noInlineStyle:!1}}}return Ca.rules},
	qb=function(){if(u(qb.name_))return qb.name_;var a,b,d=Oa.length,c,e;for(b=0;b<d;++b)if(c=Oa[b],a=W.querySelector("["+c.replace(":","\\:")+"jq]")){e=a.getAttribute(c+"jq");break}return qb.name_=e},Oa=["ng-","data-ng-","ng:","x-ng-"],fe=/[A-Z]/g,Bc=!1,Tb,Na=3,je={full:"1.4.9",major:1,minor:4,dot:9,codeName:"implicit-superannuation"};P.expando="ng339";var fb=P.cache={},Lf=1;P._data=function(a){return this.cache[a[this.expando]]||{}};var Gf=/([\:\-\_]+(.))/g,Hf=/^moz([A-Z])/,yb={mouseleave:"mouseout",
	mouseenter:"mouseover"},Wb=M("jqLite"),Kf=/^<([\w-]+)\s*\/?>(?:<\/\1>|)$/,Vb=/<|&#?\w+;/,If=/<([\w:-]+)/,Jf=/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:-]+)[^>]*)\/>/gi,ja={option:[1,'<select multiple="multiple">',"</select>"],thead:[1,"<table>","</table>"],col:[2,"<table><colgroup>","</colgroup></table>"],tr:[2,"<table><tbody>","</tbody></table>"],td:[3,"<table><tbody><tr>","</tr></tbody></table>"],_default:[0,"",""]};ja.optgroup=ja.option;ja.tbody=ja.tfoot=ja.colgroup=ja.caption=ja.thead;
	ja.th=ja.td;var Qf=Node.prototype.contains||function(a){return!!(this.compareDocumentPosition(a)&16)},Pa=P.prototype={ready:function(a){function b(){d||(d=!0,a())}var d=!1;"complete"===W.readyState?setTimeout(b):(this.on("DOMContentLoaded",b),P(S).on("load",b))},toString:function(){var a=[];n(this,function(b){a.push(""+b)});return"["+a.join(", ")+"]"},eq:function(a){return 0<=a?A(this[a]):A(this[this.length+a])},length:0,push:tg,sort:[].sort,splice:[].splice},Db={};n("multiple selected checked disabled readOnly required open".split(" "),
	function(a){Db[K(a)]=a});var Sc={};n("input select option textarea button form details".split(" "),function(a){Sc[a]=!0});var ad={ngMinlength:"minlength",ngMaxlength:"maxlength",ngMin:"min",ngMax:"max",ngPattern:"pattern"};n({data:Yb,removeData:wb,hasData:function(a){for(var b in fb[a.ng339])return!0;return!1}},function(a,b){P[b]=a});n({data:Yb,inheritedData:Cb,scope:function(a){return A.data(a,"$scope")||Cb(a.parentNode||a,["$isolateScope","$scope"])},isolateScope:function(a){return A.data(a,"$isolateScope")||
	A.data(a,"$isolateScopeNoTemplate")},controller:Pc,injector:function(a){return Cb(a,"$injector")},removeAttr:function(a,b){a.removeAttribute(b)},hasClass:zb,css:function(a,b,d){b=eb(b);if(u(d))a.style[b]=d;else return a.style[b]},attr:function(a,b,d){var c=a.nodeType;if(c!==Na&&2!==c&&8!==c)if(c=K(b),Db[c])if(u(d))d?(a[b]=!0,a.setAttribute(b,c)):(a[b]=!1,a.removeAttribute(c));else return a[b]||(a.attributes.getNamedItem(b)||z).specified?c:w;else if(u(d))a.setAttribute(b,d);else if(a.getAttribute)return a=
	a.getAttribute(b,2),null===a?w:a},prop:function(a,b,d){if(u(d))a[b]=d;else return a[b]},text:function(){function a(a,d){if(q(d)){var c=a.nodeType;return 1===c||c===Na?a.textContent:""}a.textContent=d}a.$dv="";return a}(),val:function(a,b){if(q(b)){if(a.multiple&&"select"===oa(a)){var d=[];n(a.options,function(a){a.selected&&d.push(a.value||a.text)});return 0===d.length?null:d}return a.value}a.value=b},html:function(a,b){if(q(b))return a.innerHTML;vb(a,!0);a.innerHTML=b},empty:Qc},function(a,b){P.prototype[b]=
	function(b,c){var e,f,g=this.length;if(a!==Qc&&q(2==a.length&&a!==zb&&a!==Pc?b:c)){if(G(b)){for(e=0;e<g;e++)if(a===Yb)a(this[e],b);else for(f in b)a(this[e],f,b[f]);return this}e=a.$dv;g=q(e)?Math.min(g,1):g;for(f=0;f<g;f++){var h=a(this[f],b,c);e=e?e+h:h}return e}for(e=0;e<g;e++)a(this[e],b,c);return this}});n({removeData:wb,on:function(a,b,d,c){if(u(c))throw Wb("onargs");if(Lc(a)){c=xb(a,!0);var e=c.events,f=c.handle;f||(f=c.handle=Nf(a,e));c=0<=b.indexOf(" ")?b.split(" "):[b];for(var g=c.length,
	h=function(b,c,g){var h=e[b];h||(h=e[b]=[],h.specialHandlerWrapper=c,"$destroy"===b||g||a.addEventListener(b,f,!1));h.push(d)};g--;)b=c[g],yb[b]?(h(yb[b],Pf),h(b,w,!0)):h(b)}},off:Oc,one:function(a,b,d){a=A(a);a.on(b,function e(){a.off(b,d);a.off(b,e)});a.on(b,d)},replaceWith:function(a,b){var d,c=a.parentNode;vb(a);n(new P(b),function(b){d?c.insertBefore(b,d.nextSibling):c.replaceChild(b,a);d=b})},children:function(a){var b=[];n(a.childNodes,function(a){1===a.nodeType&&b.push(a)});return b},contents:function(a){return a.contentDocument||
	a.childNodes||[]},append:function(a,b){var d=a.nodeType;if(1===d||11===d){b=new P(b);for(var d=0,c=b.length;d<c;d++)a.appendChild(b[d])}},prepend:function(a,b){if(1===a.nodeType){var d=a.firstChild;n(new P(b),function(b){a.insertBefore(b,d)})}},wrap:function(a,b){b=A(b).eq(0).clone()[0];var d=a.parentNode;d&&d.replaceChild(b,a);b.appendChild(a)},remove:Zb,detach:function(a){Zb(a,!0)},after:function(a,b){var d=a,c=a.parentNode;b=new P(b);for(var e=0,f=b.length;e<f;e++){var g=b[e];c.insertBefore(g,
	d.nextSibling);d=g}},addClass:Bb,removeClass:Ab,toggleClass:function(a,b,d){b&&n(b.split(" "),function(b){var e=d;q(e)&&(e=!zb(a,b));(e?Bb:Ab)(a,b)})},parent:function(a){return(a=a.parentNode)&&11!==a.nodeType?a:null},next:function(a){return a.nextElementSibling},find:function(a,b){return a.getElementsByTagName?a.getElementsByTagName(b):[]},clone:Xb,triggerHandler:function(a,b,d){var c,e,f=b.type||b,g=xb(a);if(g=(g=g&&g.events)&&g[f])c={preventDefault:function(){this.defaultPrevented=!0},isDefaultPrevented:function(){return!0===
	this.defaultPrevented},stopImmediatePropagation:function(){this.immediatePropagationStopped=!0},isImmediatePropagationStopped:function(){return!0===this.immediatePropagationStopped},stopPropagation:z,type:f,target:a},b.type&&(c=N(c,b)),b=ha(g),e=d?[c].concat(d):[c],n(b,function(b){c.isImmediatePropagationStopped()||b.apply(a,e)})}},function(a,b){P.prototype[b]=function(b,c,e){for(var f,g=0,h=this.length;g<h;g++)q(f)?(f=a(this[g],b,c,e),u(f)&&(f=A(f))):Nc(f,a(this[g],b,c,e));return u(f)?f:this};P.prototype.bind=
	P.prototype.on;P.prototype.unbind=P.prototype.off});Sa.prototype={put:function(a,b){this[Da(a,this.nextUid)]=b},get:function(a){return this[Da(a,this.nextUid)]},remove:function(a){var b=this[a=Da(a,this.nextUid)];delete this[a];return b}};var Ef=[function(){this.$get=[function(){return Sa}]}],Uc=/^[^\(]*\(\s*([^\)]*)\)/m,ug=/,/,vg=/^\s*(_?)(\S+?)\1\s*$/,Tc=/((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg,Ea=M("$injector");db.$$annotate=function(a,b,d){var c;if("function"===typeof a){if(!(c=a.$inject)){c=[];if(a.length){if(b)throw F(d)&&
	d||(d=a.name||Rf(a)),Ea("strictdi",d);b=a.toString().replace(Tc,"");b=b.match(Uc);n(b[1].split(ug),function(a){a.replace(vg,function(a,b,d){c.push(d)})})}a.$inject=c}}else E(a)?(b=a.length-1,Qa(a[b],"fn"),c=a.slice(0,b)):Qa(a,"fn",!0);return c};var Qd=M("$animate"),Xe=function(){this.$get=function(){}},Ye=function(){var a=new Sa,b=[];this.$get=["$$AnimateRunner","$rootScope",function(d,c){function e(a,b,c){var d=!1;b&&(b=F(b)?b.split(" "):E(b)?b:[],n(b,function(b){b&&(d=!0,a[b]=c)}));return d}function f(){n(b,
	function(b){var c=a.get(b);if(c){var d=Sf(b.attr("class")),e="",f="";n(c,function(a,b){a!==!!d[b]&&(a?e+=(e.length?" ":"")+b:f+=(f.length?" ":"")+b)});n(b,function(a){e&&Bb(a,e);f&&Ab(a,f)});a.remove(b)}});b.length=0}return{enabled:z,on:z,off:z,pin:z,push:function(g,h,k,l){l&&l();k=k||{};k.from&&g.css(k.from);k.to&&g.css(k.to);if(k.addClass||k.removeClass)if(h=k.addClass,l=k.removeClass,k=a.get(g)||{},h=e(k,h,!0),l=e(k,l,!1),h||l)a.put(g,k),b.push(g),1===b.length&&c.$$postDigest(f);g=new d;g.complete();
	return g}}}]},Ve=["$provide",function(a){var b=this;this.$$registeredAnimations=Object.create(null);this.register=function(d,c){if(d&&"."!==d.charAt(0))throw Qd("notcsel",d);var e=d+"-animation";b.$$registeredAnimations[d.substr(1)]=e;a.factory(e,c)};this.classNameFilter=function(a){if(1===arguments.length&&(this.$$classNameFilter=a instanceof RegExp?a:null)&&/(\s+|\/)ng-animate(\s+|\/)/.test(this.$$classNameFilter.toString()))throw Qd("nongcls","ng-animate");return this.$$classNameFilter};this.$get=
	["$$animateQueue",function(a){function b(a,c,d){if(d){var h;a:{for(h=0;h<d.length;h++){var k=d[h];if(1===k.nodeType){h=k;break a}}h=void 0}!h||h.parentNode||h.previousElementSibling||(d=null)}d?d.after(a):c.prepend(a)}return{on:a.on,off:a.off,pin:a.pin,enabled:a.enabled,cancel:function(a){a.end&&a.end()},enter:function(e,f,g,h){f=f&&A(f);g=g&&A(g);f=f||g.parent();b(e,f,g);return a.push(e,"enter",Fa(h))},move:function(e,f,g,h){f=f&&A(f);g=g&&A(g);f=f||g.parent();b(e,f,g);return a.push(e,"move",Fa(h))},
	leave:function(b,c){return a.push(b,"leave",Fa(c),function(){b.remove()})},addClass:function(b,c,g){g=Fa(g);g.addClass=gb(g.addclass,c);return a.push(b,"addClass",g)},removeClass:function(b,c,g){g=Fa(g);g.removeClass=gb(g.removeClass,c);return a.push(b,"removeClass",g)},setClass:function(b,c,g,h){h=Fa(h);h.addClass=gb(h.addClass,c);h.removeClass=gb(h.removeClass,g);return a.push(b,"setClass",h)},animate:function(b,c,g,h,k){k=Fa(k);k.from=k.from?N(k.from,c):c;k.to=k.to?N(k.to,g):g;k.tempClasses=gb(k.tempClasses,
	h||"ng-inline-animate");return a.push(b,"animate",k)}}}]}],$e=function(){this.$get=["$$rAF",function(a){function b(b){d.push(b);1<d.length||a(function(){for(var a=0;a<d.length;a++)d[a]();d=[]})}var d=[];return function(){var a=!1;b(function(){a=!0});return function(d){a?d():b(d)}}}]},Ze=function(){this.$get=["$q","$sniffer","$$animateAsyncRun","$document","$timeout",function(a,b,d,c,e){function f(a){this.setHost(a);var b=d();this._doneCallbacks=[];this._tick=function(a){var d=c[0];d&&d.hidden?e(a,
	0,!1):b(a)};this._state=0}f.chain=function(a,b){function c(){if(d===a.length)b(!0);else a[d](function(a){!1===a?b(!1):(d++,c())})}var d=0;c()};f.all=function(a,b){function c(f){e=e&&f;++d===a.length&&b(e)}var d=0,e=!0;n(a,function(a){a.done(c)})};f.prototype={setHost:function(a){this.host=a||{}},done:function(a){2===this._state?a():this._doneCallbacks.push(a)},progress:z,getPromise:function(){if(!this.promise){var b=this;this.promise=a(function(a,c){b.done(function(b){!1===b?c():a()})})}return this.promise},
	then:function(a,b){return this.getPromise().then(a,b)},"catch":function(a){return this.getPromise()["catch"](a)},"finally":function(a){return this.getPromise()["finally"](a)},pause:function(){this.host.pause&&this.host.pause()},resume:function(){this.host.resume&&this.host.resume()},end:function(){this.host.end&&this.host.end();this._resolve(!0)},cancel:function(){this.host.cancel&&this.host.cancel();this._resolve(!1)},complete:function(a){var b=this;0===b._state&&(b._state=1,b._tick(function(){b._resolve(a)}))},
	_resolve:function(a){2!==this._state&&(n(this._doneCallbacks,function(b){b(a)}),this._doneCallbacks.length=0,this._state=2)}};return f}]},We=function(){this.$get=["$$rAF","$q","$$AnimateRunner",function(a,b,d){return function(b,e){function f(){a(function(){g.addClass&&(b.addClass(g.addClass),g.addClass=null);g.removeClass&&(b.removeClass(g.removeClass),g.removeClass=null);g.to&&(b.css(g.to),g.to=null);h||k.complete();h=!0});return k}var g=e||{};g.$$prepared||(g=Ma(g));g.cleanupStyles&&(g.from=g.to=
	null);g.from&&(b.css(g.from),g.from=null);var h,k=new d;return{start:f,end:f}}}]},ga=M("$compile");Dc.$inject=["$provide","$$sanitizeUriProvider"];var Yc=/^((?:x|data)[\:\-_])/i,Vf=M("$controller"),Vc=/^(\S+)(\s+as\s+([\w$]+))?$/,ff=function(){this.$get=["$document",function(a){return function(b){b?!b.nodeType&&b instanceof A&&(b=b[0]):b=a[0].body;return b.offsetWidth+1}}]},bd="application/json",bc={"Content-Type":bd+";charset=utf-8"},Xf=/^\[|^\{(?!\{)/,Yf={"[":/]$/,"{":/}$/},Wf=/^\)\]\}',?\n/,wg=
	M("$http"),fd=function(a){return function(){throw wg("legacy",a);}},Ia=$.$interpolateMinErr=M("$interpolate");Ia.throwNoconcat=function(a){throw Ia("noconcat",a);};Ia.interr=function(a,b){return Ia("interr",a,b.toString())};var xg=/^([^\?#]*)(\?([^#]*))?(#(.*))?$/,$f={http:80,https:443,ftp:21},Fb=M("$location"),yg={$$html5:!1,$$replace:!1,absUrl:Gb("$$absUrl"),url:function(a){if(q(a))return this.$$url;var b=xg.exec(a);(b[1]||""===a)&&this.path(decodeURIComponent(b[1]));(b[2]||b[1]||""===a)&&this.search(b[3]||
	"");this.hash(b[5]||"");return this},protocol:Gb("$$protocol"),host:Gb("$$host"),port:Gb("$$port"),path:kd("$$path",function(a){a=null!==a?a.toString():"";return"/"==a.charAt(0)?a:"/"+a}),search:function(a,b){switch(arguments.length){case 0:return this.$$search;case 1:if(F(a)||Q(a))a=a.toString(),this.$$search=yc(a);else if(G(a))a=Ma(a,{}),n(a,function(b,c){null==b&&delete a[c]}),this.$$search=a;else throw Fb("isrcharg");break;default:q(b)||null===b?delete this.$$search[a]:this.$$search[a]=b}this.$$compose();
	return this},hash:kd("$$hash",function(a){return null!==a?a.toString():""}),replace:function(){this.$$replace=!0;return this}};n([jd,ec,dc],function(a){a.prototype=Object.create(yg);a.prototype.state=function(b){if(!arguments.length)return this.$$state;if(a!==dc||!this.$$html5)throw Fb("nostate");this.$$state=q(b)?null:b;return this}});var aa=M("$parse"),ag=Function.prototype.call,bg=Function.prototype.apply,cg=Function.prototype.bind,Nb=ea();n("+ - * / % === !== == != < > <= >= && || ! = |".split(" "),
	function(a){Nb[a]=!0});var zg={n:"\n",f:"\f",r:"\r",t:"\t",v:"\v","'":"'",'"':'"'},gc=function(a){this.options=a};gc.prototype={constructor:gc,lex:function(a){this.text=a;this.index=0;for(this.tokens=[];this.index<this.text.length;)if(a=this.text.charAt(this.index),'"'===a||"'"===a)this.readString(a);else if(this.isNumber(a)||"."===a&&this.isNumber(this.peek()))this.readNumber();else if(this.isIdent(a))this.readIdent();else if(this.is(a,"(){}[].,;:?"))this.tokens.push({index:this.index,text:a}),this.index++;
	else if(this.isWhitespace(a))this.index++;else{var b=a+this.peek(),d=b+this.peek(2),c=Nb[b],e=Nb[d];Nb[a]||c||e?(a=e?d:c?b:a,this.tokens.push({index:this.index,text:a,operator:!0}),this.index+=a.length):this.throwError("Unexpected next character ",this.index,this.index+1)}return this.tokens},is:function(a,b){return-1!==b.indexOf(a)},peek:function(a){a=a||1;return this.index+a<this.text.length?this.text.charAt(this.index+a):!1},isNumber:function(a){return"0"<=a&&"9">=a&&"string"===typeof a},isWhitespace:function(a){return" "===
	a||"\r"===a||"\t"===a||"\n"===a||"\v"===a||"\u00a0"===a},isIdent:function(a){return"a"<=a&&"z">=a||"A"<=a&&"Z">=a||"_"===a||"$"===a},isExpOperator:function(a){return"-"===a||"+"===a||this.isNumber(a)},throwError:function(a,b,d){d=d||this.index;b=u(b)?"s "+b+"-"+this.index+" ["+this.text.substring(b,d)+"]":" "+d;throw aa("lexerr",a,b,this.text);},readNumber:function(){for(var a="",b=this.index;this.index<this.text.length;){var d=K(this.text.charAt(this.index));if("."==d||this.isNumber(d))a+=d;else{var c=
	this.peek();if("e"==d&&this.isExpOperator(c))a+=d;else if(this.isExpOperator(d)&&c&&this.isNumber(c)&&"e"==a.charAt(a.length-1))a+=d;else if(!this.isExpOperator(d)||c&&this.isNumber(c)||"e"!=a.charAt(a.length-1))break;else this.throwError("Invalid exponent")}this.index++}this.tokens.push({index:b,text:a,constant:!0,value:Number(a)})},readIdent:function(){for(var a=this.index;this.index<this.text.length;){var b=this.text.charAt(this.index);if(!this.isIdent(b)&&!this.isNumber(b))break;this.index++}this.tokens.push({index:a,
	text:this.text.slice(a,this.index),identifier:!0})},readString:function(a){var b=this.index;this.index++;for(var d="",c=a,e=!1;this.index<this.text.length;){var f=this.text.charAt(this.index),c=c+f;if(e)"u"===f?(e=this.text.substring(this.index+1,this.index+5),e.match(/[\da-f]{4}/i)||this.throwError("Invalid unicode escape [\\u"+e+"]"),this.index+=4,d+=String.fromCharCode(parseInt(e,16))):d+=zg[f]||f,e=!1;else if("\\"===f)e=!0;else{if(f===a){this.index++;this.tokens.push({index:b,text:c,constant:!0,
	value:d});return}d+=f}this.index++}this.throwError("Unterminated quote",b)}};var s=function(a,b){this.lexer=a;this.options=b};s.Program="Program";s.ExpressionStatement="ExpressionStatement";s.AssignmentExpression="AssignmentExpression";s.ConditionalExpression="ConditionalExpression";s.LogicalExpression="LogicalExpression";s.BinaryExpression="BinaryExpression";s.UnaryExpression="UnaryExpression";s.CallExpression="CallExpression";s.MemberExpression="MemberExpression";s.Identifier="Identifier";s.Literal=
	"Literal";s.ArrayExpression="ArrayExpression";s.Property="Property";s.ObjectExpression="ObjectExpression";s.ThisExpression="ThisExpression";s.NGValueParameter="NGValueParameter";s.prototype={ast:function(a){this.text=a;this.tokens=this.lexer.lex(a);a=this.program();0!==this.tokens.length&&this.throwError("is an unexpected token",this.tokens[0]);return a},program:function(){for(var a=[];;)if(0<this.tokens.length&&!this.peek("}",")",";","]")&&a.push(this.expressionStatement()),!this.expect(";"))return{type:s.Program,
	body:a}},expressionStatement:function(){return{type:s.ExpressionStatement,expression:this.filterChain()}},filterChain:function(){for(var a=this.expression();this.expect("|");)a=this.filter(a);return a},expression:function(){return this.assignment()},assignment:function(){var a=this.ternary();this.expect("=")&&(a={type:s.AssignmentExpression,left:a,right:this.assignment(),operator:"="});return a},ternary:function(){var a=this.logicalOR(),b,d;return this.expect("?")&&(b=this.expression(),this.consume(":"))?
	(d=this.expression(),{type:s.ConditionalExpression,test:a,alternate:b,consequent:d}):a},logicalOR:function(){for(var a=this.logicalAND();this.expect("||");)a={type:s.LogicalExpression,operator:"||",left:a,right:this.logicalAND()};return a},logicalAND:function(){for(var a=this.equality();this.expect("&&");)a={type:s.LogicalExpression,operator:"&&",left:a,right:this.equality()};return a},equality:function(){for(var a=this.relational(),b;b=this.expect("==","!=","===","!==");)a={type:s.BinaryExpression,
	operator:b.text,left:a,right:this.relational()};return a},relational:function(){for(var a=this.additive(),b;b=this.expect("<",">","<=",">=");)a={type:s.BinaryExpression,operator:b.text,left:a,right:this.additive()};return a},additive:function(){for(var a=this.multiplicative(),b;b=this.expect("+","-");)a={type:s.BinaryExpression,operator:b.text,left:a,right:this.multiplicative()};return a},multiplicative:function(){for(var a=this.unary(),b;b=this.expect("*","/","%");)a={type:s.BinaryExpression,operator:b.text,
	left:a,right:this.unary()};return a},unary:function(){var a;return(a=this.expect("+","-","!"))?{type:s.UnaryExpression,operator:a.text,prefix:!0,argument:this.unary()}:this.primary()},primary:function(){var a;this.expect("(")?(a=this.filterChain(),this.consume(")")):this.expect("[")?a=this.arrayDeclaration():this.expect("{")?a=this.object():this.constants.hasOwnProperty(this.peek().text)?a=Ma(this.constants[this.consume().text]):this.peek().identifier?a=this.identifier():this.peek().constant?a=this.constant():
	this.throwError("not a primary expression",this.peek());for(var b;b=this.expect("(","[",".");)"("===b.text?(a={type:s.CallExpression,callee:a,arguments:this.parseArguments()},this.consume(")")):"["===b.text?(a={type:s.MemberExpression,object:a,property:this.expression(),computed:!0},this.consume("]")):"."===b.text?a={type:s.MemberExpression,object:a,property:this.identifier(),computed:!1}:this.throwError("IMPOSSIBLE");return a},filter:function(a){a=[a];for(var b={type:s.CallExpression,callee:this.identifier(),
	arguments:a,filter:!0};this.expect(":");)a.push(this.expression());return b},parseArguments:function(){var a=[];if(")"!==this.peekToken().text){do a.push(this.expression());while(this.expect(","))}return a},identifier:function(){var a=this.consume();a.identifier||this.throwError("is not a valid identifier",a);return{type:s.Identifier,name:a.text}},constant:function(){return{type:s.Literal,value:this.consume().value}},arrayDeclaration:function(){var a=[];if("]"!==this.peekToken().text){do{if(this.peek("]"))break;
	a.push(this.expression())}while(this.expect(","))}this.consume("]");return{type:s.ArrayExpression,elements:a}},object:function(){var a=[],b;if("}"!==this.peekToken().text){do{if(this.peek("}"))break;b={type:s.Property,kind:"init"};this.peek().constant?b.key=this.constant():this.peek().identifier?b.key=this.identifier():this.throwError("invalid key",this.peek());this.consume(":");b.value=this.expression();a.push(b)}while(this.expect(","))}this.consume("}");return{type:s.ObjectExpression,properties:a}},
	throwError:function(a,b){throw aa("syntax",b.text,a,b.index+1,this.text,this.text.substring(b.index));},consume:function(a){if(0===this.tokens.length)throw aa("ueoe",this.text);var b=this.expect(a);b||this.throwError("is unexpected, expecting ["+a+"]",this.peek());return b},peekToken:function(){if(0===this.tokens.length)throw aa("ueoe",this.text);return this.tokens[0]},peek:function(a,b,d,c){return this.peekAhead(0,a,b,d,c)},peekAhead:function(a,b,d,c,e){if(this.tokens.length>a){a=this.tokens[a];
	var f=a.text;if(f===b||f===d||f===c||f===e||!(b||d||c||e))return a}return!1},expect:function(a,b,d,c){return(a=this.peek(a,b,d,c))?(this.tokens.shift(),a):!1},constants:{"true":{type:s.Literal,value:!0},"false":{type:s.Literal,value:!1},"null":{type:s.Literal,value:null},undefined:{type:s.Literal,value:w},"this":{type:s.ThisExpression}}};td.prototype={compile:function(a,b){var d=this,c=this.astBuilder.ast(a);this.state={nextId:0,filters:{},expensiveChecks:b,fn:{vars:[],body:[],own:{}},assign:{vars:[],
	body:[],own:{}},inputs:[]};V(c,d.$filter);var e="",f;this.stage="assign";if(f=rd(c))this.state.computing="assign",e=this.nextId(),this.recurse(f,e),this.return_(e),e="fn.assign="+this.generateFunction("assign","s,v,l");f=pd(c.body);d.stage="inputs";n(f,function(a,b){var c="fn"+b;d.state[c]={vars:[],body:[],own:{}};d.state.computing=c;var e=d.nextId();d.recurse(a,e);d.return_(e);d.state.inputs.push(c);a.watchId=b});this.state.computing="fn";this.stage="main";this.recurse(c);e='"'+this.USE+" "+this.STRICT+
	'";\n'+this.filterPrefix()+"var fn="+this.generateFunction("fn","s,l,a,i")+e+this.watchFns()+"return fn;";e=(new Function("$filter","ensureSafeMemberName","ensureSafeObject","ensureSafeFunction","getStringValue","ensureSafeAssignContext","ifDefined","plus","text",e))(this.$filter,Va,ya,md,ld,nd,dg,od,a);this.state=this.stage=w;e.literal=sd(c);e.constant=c.constant;return e},USE:"use",STRICT:"strict",watchFns:function(){var a=[],b=this.state.inputs,d=this;n(b,function(b){a.push("var "+b+"="+d.generateFunction(b,
	"s"))});b.length&&a.push("fn.inputs=["+b.join(",")+"];");return a.join("")},generateFunction:function(a,b){return"function("+b+"){"+this.varsPrefix(a)+this.body(a)+"};"},filterPrefix:function(){var a=[],b=this;n(this.state.filters,function(d,c){a.push(d+"=$filter("+b.escape(c)+")")});return a.length?"var "+a.join(",")+";":""},varsPrefix:function(a){return this.state[a].vars.length?"var "+this.state[a].vars.join(",")+";":""},body:function(a){return this.state[a].body.join("")},recurse:function(a,b,
	d,c,e,f){var g,h,k=this,l,m;c=c||z;if(!f&&u(a.watchId))b=b||this.nextId(),this.if_("i",this.lazyAssign(b,this.computedMember("i",a.watchId)),this.lazyRecurse(a,b,d,c,e,!0));else switch(a.type){case s.Program:n(a.body,function(b,c){k.recurse(b.expression,w,w,function(a){h=a});c!==a.body.length-1?k.current().body.push(h,";"):k.return_(h)});break;case s.Literal:m=this.escape(a.value);this.assign(b,m);c(m);break;case s.UnaryExpression:this.recurse(a.argument,w,w,function(a){h=a});m=a.operator+"("+this.ifDefined(h,
	0)+")";this.assign(b,m);c(m);break;case s.BinaryExpression:this.recurse(a.left,w,w,function(a){g=a});this.recurse(a.right,w,w,function(a){h=a});m="+"===a.operator?this.plus(g,h):"-"===a.operator?this.ifDefined(g,0)+a.operator+this.ifDefined(h,0):"("+g+")"+a.operator+"("+h+")";this.assign(b,m);c(m);break;case s.LogicalExpression:b=b||this.nextId();k.recurse(a.left,b);k.if_("&&"===a.operator?b:k.not(b),k.lazyRecurse(a.right,b));c(b);break;case s.ConditionalExpression:b=b||this.nextId();k.recurse(a.test,
	b);k.if_(b,k.lazyRecurse(a.alternate,b),k.lazyRecurse(a.consequent,b));c(b);break;case s.Identifier:b=b||this.nextId();d&&(d.context="inputs"===k.stage?"s":this.assign(this.nextId(),this.getHasOwnProperty("l",a.name)+"?l:s"),d.computed=!1,d.name=a.name);Va(a.name);k.if_("inputs"===k.stage||k.not(k.getHasOwnProperty("l",a.name)),function(){k.if_("inputs"===k.stage||"s",function(){e&&1!==e&&k.if_(k.not(k.nonComputedMember("s",a.name)),k.lazyAssign(k.nonComputedMember("s",a.name),"{}"));k.assign(b,k.nonComputedMember("s",
	a.name))})},b&&k.lazyAssign(b,k.nonComputedMember("l",a.name)));(k.state.expensiveChecks||Hb(a.name))&&k.addEnsureSafeObject(b);c(b);break;case s.MemberExpression:g=d&&(d.context=this.nextId())||this.nextId();b=b||this.nextId();k.recurse(a.object,g,w,function(){k.if_(k.notNull(g),function(){if(a.computed)h=k.nextId(),k.recurse(a.property,h),k.getStringValue(h),k.addEnsureSafeMemberName(h),e&&1!==e&&k.if_(k.not(k.computedMember(g,h)),k.lazyAssign(k.computedMember(g,h),"{}")),m=k.ensureSafeObject(k.computedMember(g,
	h)),k.assign(b,m),d&&(d.computed=!0,d.name=h);else{Va(a.property.name);e&&1!==e&&k.if_(k.not(k.nonComputedMember(g,a.property.name)),k.lazyAssign(k.nonComputedMember(g,a.property.name),"{}"));m=k.nonComputedMember(g,a.property.name);if(k.state.expensiveChecks||Hb(a.property.name))m=k.ensureSafeObject(m);k.assign(b,m);d&&(d.computed=!1,d.name=a.property.name)}},function(){k.assign(b,"undefined")});c(b)},!!e);break;case s.CallExpression:b=b||this.nextId();a.filter?(h=k.filter(a.callee.name),l=[],n(a.arguments,
	function(a){var b=k.nextId();k.recurse(a,b);l.push(b)}),m=h+"("+l.join(",")+")",k.assign(b,m),c(b)):(h=k.nextId(),g={},l=[],k.recurse(a.callee,h,g,function(){k.if_(k.notNull(h),function(){k.addEnsureSafeFunction(h);n(a.arguments,function(a){k.recurse(a,k.nextId(),w,function(a){l.push(k.ensureSafeObject(a))})});g.name?(k.state.expensiveChecks||k.addEnsureSafeObject(g.context),m=k.member(g.context,g.name,g.computed)+"("+l.join(",")+")"):m=h+"("+l.join(",")+")";m=k.ensureSafeObject(m);k.assign(b,m)},
	function(){k.assign(b,"undefined")});c(b)}));break;case s.AssignmentExpression:h=this.nextId();g={};if(!qd(a.left))throw aa("lval");this.recurse(a.left,w,g,function(){k.if_(k.notNull(g.context),function(){k.recurse(a.right,h);k.addEnsureSafeObject(k.member(g.context,g.name,g.computed));k.addEnsureSafeAssignContext(g.context);m=k.member(g.context,g.name,g.computed)+a.operator+h;k.assign(b,m);c(b||m)})},1);break;case s.ArrayExpression:l=[];n(a.elements,function(a){k.recurse(a,k.nextId(),w,function(a){l.push(a)})});
	m="["+l.join(",")+"]";this.assign(b,m);c(m);break;case s.ObjectExpression:l=[];n(a.properties,function(a){k.recurse(a.value,k.nextId(),w,function(b){l.push(k.escape(a.key.type===s.Identifier?a.key.name:""+a.key.value)+":"+b)})});m="{"+l.join(",")+"}";this.assign(b,m);c(m);break;case s.ThisExpression:this.assign(b,"s");c("s");break;case s.NGValueParameter:this.assign(b,"v"),c("v")}},getHasOwnProperty:function(a,b){var d=a+"."+b,c=this.current().own;c.hasOwnProperty(d)||(c[d]=this.nextId(!1,a+"&&("+
	this.escape(b)+" in "+a+")"));return c[d]},assign:function(a,b){if(a)return this.current().body.push(a,"=",b,";"),a},filter:function(a){this.state.filters.hasOwnProperty(a)||(this.state.filters[a]=this.nextId(!0));return this.state.filters[a]},ifDefined:function(a,b){return"ifDefined("+a+","+this.escape(b)+")"},plus:function(a,b){return"plus("+a+","+b+")"},return_:function(a){this.current().body.push("return ",a,";")},if_:function(a,b,d){if(!0===a)b();else{var c=this.current().body;c.push("if(",a,
	"){");b();c.push("}");d&&(c.push("else{"),d(),c.push("}"))}},not:function(a){return"!("+a+")"},notNull:function(a){return a+"!=null"},nonComputedMember:function(a,b){return a+"."+b},computedMember:function(a,b){return a+"["+b+"]"},member:function(a,b,d){return d?this.computedMember(a,b):this.nonComputedMember(a,b)},addEnsureSafeObject:function(a){this.current().body.push(this.ensureSafeObject(a),";")},addEnsureSafeMemberName:function(a){this.current().body.push(this.ensureSafeMemberName(a),";")},
	addEnsureSafeFunction:function(a){this.current().body.push(this.ensureSafeFunction(a),";")},addEnsureSafeAssignContext:function(a){this.current().body.push(this.ensureSafeAssignContext(a),";")},ensureSafeObject:function(a){return"ensureSafeObject("+a+",text)"},ensureSafeMemberName:function(a){return"ensureSafeMemberName("+a+",text)"},ensureSafeFunction:function(a){return"ensureSafeFunction("+a+",text)"},getStringValue:function(a){this.assign(a,"getStringValue("+a+",text)")},ensureSafeAssignContext:function(a){return"ensureSafeAssignContext("+
	a+",text)"},lazyRecurse:function(a,b,d,c,e,f){var g=this;return function(){g.recurse(a,b,d,c,e,f)}},lazyAssign:function(a,b){var d=this;return function(){d.assign(a,b)}},stringEscapeRegex:/[^ a-zA-Z0-9]/g,stringEscapeFn:function(a){return"\\u"+("0000"+a.charCodeAt(0).toString(16)).slice(-4)},escape:function(a){if(F(a))return"'"+a.replace(this.stringEscapeRegex,this.stringEscapeFn)+"'";if(Q(a))return a.toString();if(!0===a)return"true";if(!1===a)return"false";if(null===a)return"null";if("undefined"===
	typeof a)return"undefined";throw aa("esc");},nextId:function(a,b){var d="v"+this.state.nextId++;a||this.current().vars.push(d+(b?"="+b:""));return d},current:function(){return this.state[this.state.computing]}};ud.prototype={compile:function(a,b){var d=this,c=this.astBuilder.ast(a);this.expression=a;this.expensiveChecks=b;V(c,d.$filter);var e,f;if(e=rd(c))f=this.recurse(e);e=pd(c.body);var g;e&&(g=[],n(e,function(a,b){var c=d.recurse(a);a.input=c;g.push(c);a.watchId=b}));var h=[];n(c.body,function(a){h.push(d.recurse(a.expression))});
	e=0===c.body.length?function(){}:1===c.body.length?h[0]:function(a,b){var c;n(h,function(d){c=d(a,b)});return c};f&&(e.assign=function(a,b,c){return f(a,c,b)});g&&(e.inputs=g);e.literal=sd(c);e.constant=c.constant;return e},recurse:function(a,b,d){var c,e,f=this,g;if(a.input)return this.inputs(a.input,a.watchId);switch(a.type){case s.Literal:return this.value(a.value,b);case s.UnaryExpression:return e=this.recurse(a.argument),this["unary"+a.operator](e,b);case s.BinaryExpression:return c=this.recurse(a.left),
	e=this.recurse(a.right),this["binary"+a.operator](c,e,b);case s.LogicalExpression:return c=this.recurse(a.left),e=this.recurse(a.right),this["binary"+a.operator](c,e,b);case s.ConditionalExpression:return this["ternary?:"](this.recurse(a.test),this.recurse(a.alternate),this.recurse(a.consequent),b);case s.Identifier:return Va(a.name,f.expression),f.identifier(a.name,f.expensiveChecks||Hb(a.name),b,d,f.expression);case s.MemberExpression:return c=this.recurse(a.object,!1,!!d),a.computed||(Va(a.property.name,
	f.expression),e=a.property.name),a.computed&&(e=this.recurse(a.property)),a.computed?this.computedMember(c,e,b,d,f.expression):this.nonComputedMember(c,e,f.expensiveChecks,b,d,f.expression);case s.CallExpression:return g=[],n(a.arguments,function(a){g.push(f.recurse(a))}),a.filter&&(e=this.$filter(a.callee.name)),a.filter||(e=this.recurse(a.callee,!0)),a.filter?function(a,c,d,f){for(var r=[],n=0;n<g.length;++n)r.push(g[n](a,c,d,f));a=e.apply(w,r,f);return b?{context:w,name:w,value:a}:a}:function(a,
	c,d,m){var n=e(a,c,d,m),t;if(null!=n.value){ya(n.context,f.expression);md(n.value,f.expression);t=[];for(var q=0;q<g.length;++q)t.push(ya(g[q](a,c,d,m),f.expression));t=ya(n.value.apply(n.context,t),f.expression)}return b?{value:t}:t};case s.AssignmentExpression:return c=this.recurse(a.left,!0,1),e=this.recurse(a.right),function(a,d,g,m){var n=c(a,d,g,m);a=e(a,d,g,m);ya(n.value,f.expression);nd(n.context);n.context[n.name]=a;return b?{value:a}:a};case s.ArrayExpression:return g=[],n(a.elements,function(a){g.push(f.recurse(a))}),
	function(a,c,d,e){for(var f=[],n=0;n<g.length;++n)f.push(g[n](a,c,d,e));return b?{value:f}:f};case s.ObjectExpression:return g=[],n(a.properties,function(a){g.push({key:a.key.type===s.Identifier?a.key.name:""+a.key.value,value:f.recurse(a.value)})}),function(a,c,d,e){for(var f={},n=0;n<g.length;++n)f[g[n].key]=g[n].value(a,c,d,e);return b?{value:f}:f};case s.ThisExpression:return function(a){return b?{value:a}:a};case s.NGValueParameter:return function(a,c,d,e){return b?{value:d}:d}}},"unary+":function(a,
	b){return function(d,c,e,f){d=a(d,c,e,f);d=u(d)?+d:0;return b?{value:d}:d}},"unary-":function(a,b){return function(d,c,e,f){d=a(d,c,e,f);d=u(d)?-d:0;return b?{value:d}:d}},"unary!":function(a,b){return function(d,c,e,f){d=!a(d,c,e,f);return b?{value:d}:d}},"binary+":function(a,b,d){return function(c,e,f,g){var h=a(c,e,f,g);c=b(c,e,f,g);h=od(h,c);return d?{value:h}:h}},"binary-":function(a,b,d){return function(c,e,f,g){var h=a(c,e,f,g);c=b(c,e,f,g);h=(u(h)?h:0)-(u(c)?c:0);return d?{value:h}:h}},"binary*":function(a,
	b,d){return function(c,e,f,g){c=a(c,e,f,g)*b(c,e,f,g);return d?{value:c}:c}},"binary/":function(a,b,d){return function(c,e,f,g){c=a(c,e,f,g)/b(c,e,f,g);return d?{value:c}:c}},"binary%":function(a,b,d){return function(c,e,f,g){c=a(c,e,f,g)%b(c,e,f,g);return d?{value:c}:c}},"binary===":function(a,b,d){return function(c,e,f,g){c=a(c,e,f,g)===b(c,e,f,g);return d?{value:c}:c}},"binary!==":function(a,b,d){return function(c,e,f,g){c=a(c,e,f,g)!==b(c,e,f,g);return d?{value:c}:c}},"binary==":function(a,b,
	d){return function(c,e,f,g){c=a(c,e,f,g)==b(c,e,f,g);return d?{value:c}:c}},"binary!=":function(a,b,d){return function(c,e,f,g){c=a(c,e,f,g)!=b(c,e,f,g);return d?{value:c}:c}},"binary<":function(a,b,d){return function(c,e,f,g){c=a(c,e,f,g)<b(c,e,f,g);return d?{value:c}:c}},"binary>":function(a,b,d){return function(c,e,f,g){c=a(c,e,f,g)>b(c,e,f,g);return d?{value:c}:c}},"binary<=":function(a,b,d){return function(c,e,f,g){c=a(c,e,f,g)<=b(c,e,f,g);return d?{value:c}:c}},"binary>=":function(a,b,d){return function(c,
	e,f,g){c=a(c,e,f,g)>=b(c,e,f,g);return d?{value:c}:c}},"binary&&":function(a,b,d){return function(c,e,f,g){c=a(c,e,f,g)&&b(c,e,f,g);return d?{value:c}:c}},"binary||":function(a,b,d){return function(c,e,f,g){c=a(c,e,f,g)||b(c,e,f,g);return d?{value:c}:c}},"ternary?:":function(a,b,d,c){return function(e,f,g,h){e=a(e,f,g,h)?b(e,f,g,h):d(e,f,g,h);return c?{value:e}:e}},value:function(a,b){return function(){return b?{context:w,name:w,value:a}:a}},identifier:function(a,b,d,c,e){return function(f,g,h,k){f=
	g&&a in g?g:f;c&&1!==c&&f&&!f[a]&&(f[a]={});g=f?f[a]:w;b&&ya(g,e);return d?{context:f,name:a,value:g}:g}},computedMember:function(a,b,d,c,e){return function(f,g,h,k){var l=a(f,g,h,k),m,n;null!=l&&(m=b(f,g,h,k),m=ld(m),Va(m,e),c&&1!==c&&l&&!l[m]&&(l[m]={}),n=l[m],ya(n,e));return d?{context:l,name:m,value:n}:n}},nonComputedMember:function(a,b,d,c,e,f){return function(g,h,k,l){g=a(g,h,k,l);e&&1!==e&&g&&!g[b]&&(g[b]={});h=null!=g?g[b]:w;(d||Hb(b))&&ya(h,f);return c?{context:g,name:b,value:h}:h}},inputs:function(a,
	b){return function(d,c,e,f){return f?f[b]:a(d,c,e)}}};var hc=function(a,b,d){this.lexer=a;this.$filter=b;this.options=d;this.ast=new s(this.lexer);this.astCompiler=d.csp?new ud(this.ast,b):new td(this.ast,b)};hc.prototype={constructor:hc,parse:function(a){return this.astCompiler.compile(a,this.options.expensiveChecks)}};var eg=Object.prototype.valueOf,za=M("$sce"),ma={HTML:"html",CSS:"css",URL:"url",RESOURCE_URL:"resourceUrl",JS:"js"},ga=M("$compile"),ba=W.createElement("a"),yd=xa(S.location.href);
	zd.$inject=["$document"];Kc.$inject=["$provide"];var Gd=22,Fd=".",jc="0";Ad.$inject=["$locale"];Cd.$inject=["$locale"];var qg={yyyy:ca("FullYear",4),yy:ca("FullYear",2,0,!0),y:ca("FullYear",1),MMMM:Jb("Month"),MMM:Jb("Month",!0),MM:ca("Month",2,1),M:ca("Month",1,1),dd:ca("Date",2),d:ca("Date",1),HH:ca("Hours",2),H:ca("Hours",1),hh:ca("Hours",2,-12),h:ca("Hours",1,-12),mm:ca("Minutes",2),m:ca("Minutes",1),ss:ca("Seconds",2),s:ca("Seconds",1),sss:ca("Milliseconds",3),EEEE:Jb("Day"),EEE:Jb("Day",!0),
	a:function(a,b){return 12>a.getHours()?b.AMPMS[0]:b.AMPMS[1]},Z:function(a,b,d){a=-1*d;return a=(0<=a?"+":"")+(Ib(Math[0<a?"floor":"ceil"](a/60),2)+Ib(Math.abs(a%60),2))},ww:Id(2),w:Id(1),G:kc,GG:kc,GGG:kc,GGGG:function(a,b){return 0>=a.getFullYear()?b.ERANAMES[0]:b.ERANAMES[1]}},pg=/((?:[^yMdHhmsaZEwG']+)|(?:'(?:[^']|'')*')|(?:E+|y+|M+|d+|H+|h+|m+|s+|a|Z|G+|w+))(.*)/,og=/^\-?\d+$/;Bd.$inject=["$locale"];var jg=na(K),kg=na(tb);Dd.$inject=["$parse"];var le=na({restrict:"E",compile:function(a,b){if(!b.href&&
	!b.xlinkHref)return function(a,b){if("a"===b[0].nodeName.toLowerCase()){var e="[object SVGAnimatedString]"===ta.call(b.prop("href"))?"xlink:href":"href";b.on("click",function(a){b.attr(e)||a.preventDefault()})}}}}),ub={};n(Db,function(a,b){function d(a,d,e){a.$watch(e[c],function(a){e.$set(b,!!a)})}if("multiple"!=a){var c=va("ng-"+b),e=d;"checked"===a&&(e=function(a,b,e){e.ngModel!==e[c]&&d(a,b,e)});ub[c]=function(){return{restrict:"A",priority:100,link:e}}}});n(ad,function(a,b){ub[b]=function(){return{priority:100,
	link:function(a,c,e){if("ngPattern"===b&&"/"==e.ngPattern.charAt(0)&&(c=e.ngPattern.match(sg))){e.$set("ngPattern",new RegExp(c[1],c[2]));return}a.$watch(e[b],function(a){e.$set(b,a)})}}}});n(["src","srcset","href"],function(a){var b=va("ng-"+a);ub[b]=function(){return{priority:99,link:function(d,c,e){var f=a,g=a;"href"===a&&"[object SVGAnimatedString]"===ta.call(c.prop("href"))&&(g="xlinkHref",e.$attr[g]="xlink:href",f=null);e.$observe(b,function(b){b?(e.$set(g,b),Ha&&f&&c.prop(f,e[g])):"href"===
	a&&e.$set(g,null)})}}}});var Kb={$addControl:z,$$renameControl:function(a,b){a.$name=b},$removeControl:z,$setValidity:z,$setDirty:z,$setPristine:z,$setSubmitted:z};Jd.$inject=["$element","$attrs","$scope","$animate","$interpolate"];var Rd=function(a){return["$timeout","$parse",function(b,d){function c(a){return""===a?d('this[""]').assign:d(a).assign||z}return{name:"form",restrict:a?"EAC":"E",require:["form","^^?form"],controller:Jd,compile:function(d,f){d.addClass(Wa).addClass(nb);var g=f.name?"name":
	a&&f.ngForm?"ngForm":!1;return{pre:function(a,d,e,f){var n=f[0];if(!("action"in e)){var t=function(b){a.$apply(function(){n.$commitViewValue();n.$setSubmitted()});b.preventDefault()};d[0].addEventListener("submit",t,!1);d.on("$destroy",function(){b(function(){d[0].removeEventListener("submit",t,!1)},0,!1)})}(f[1]||n.$$parentForm).$addControl(n);var q=g?c(n.$name):z;g&&(q(a,n),e.$observe(g,function(b){n.$name!==b&&(q(a,w),n.$$parentForm.$$renameControl(n,b),q=c(n.$name),q(a,n))}));d.on("$destroy",
	function(){n.$$parentForm.$removeControl(n);q(a,w);N(n,Kb)})}}}}}]},me=Rd(),ze=Rd(!0),rg=/\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d:[0-5]\d\.\d+([+-][0-2]\d:[0-5]\d|Z)/,Ag=/^[a-z][a-z\d.+-]*:\/*(?:[^:@]+(?::[^@]+)?@)?(?:[^\s:/?#]+|\[[a-f\d:]+\])(?::\d+)?(?:\/[^?#]*)?(?:\?[^#]*)?(?:#.*)?$/i,Bg=/^[a-z0-9!#$%&'*+\/=?^_`{|}~.-]+@[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)*$/i,Cg=/^\s*(\-|\+)?(\d+|(\d*(\.\d*)))([eE][+-]?\d+)?\s*$/,Sd=/^(\d{4})-(\d{2})-(\d{2})$/,Td=/^(\d{4})-(\d\d)-(\d\d)T(\d\d):(\d\d)(?::(\d\d)(\.\d{1,3})?)?$/,
	nc=/^(\d{4})-W(\d\d)$/,Ud=/^(\d{4})-(\d\d)$/,Vd=/^(\d\d):(\d\d)(?::(\d\d)(\.\d{1,3})?)?$/,Wd={text:function(a,b,d,c,e,f){kb(a,b,d,c,e,f);lc(c)},date:lb("date",Sd,Mb(Sd,["yyyy","MM","dd"]),"yyyy-MM-dd"),"datetime-local":lb("datetimelocal",Td,Mb(Td,"yyyy MM dd HH mm ss sss".split(" ")),"yyyy-MM-ddTHH:mm:ss.sss"),time:lb("time",Vd,Mb(Vd,["HH","mm","ss","sss"]),"HH:mm:ss.sss"),week:lb("week",nc,function(a,b){if(da(a))return a;if(F(a)){nc.lastIndex=0;var d=nc.exec(a);if(d){var c=+d[1],e=+d[2],f=d=0,g=
	0,h=0,k=Hd(c),e=7*(e-1);b&&(d=b.getHours(),f=b.getMinutes(),g=b.getSeconds(),h=b.getMilliseconds());return new Date(c,0,k.getDate()+e,d,f,g,h)}}return NaN},"yyyy-Www"),month:lb("month",Ud,Mb(Ud,["yyyy","MM"]),"yyyy-MM"),number:function(a,b,d,c,e,f){Ld(a,b,d,c);kb(a,b,d,c,e,f);c.$$parserName="number";c.$parsers.push(function(a){return c.$isEmpty(a)?null:Cg.test(a)?parseFloat(a):w});c.$formatters.push(function(a){if(!c.$isEmpty(a)){if(!Q(a))throw mb("numfmt",a);a=a.toString()}return a});if(u(d.min)||
	d.ngMin){var g;c.$validators.min=function(a){return c.$isEmpty(a)||q(g)||a>=g};d.$observe("min",function(a){u(a)&&!Q(a)&&(a=parseFloat(a,10));g=Q(a)&&!isNaN(a)?a:w;c.$validate()})}if(u(d.max)||d.ngMax){var h;c.$validators.max=function(a){return c.$isEmpty(a)||q(h)||a<=h};d.$observe("max",function(a){u(a)&&!Q(a)&&(a=parseFloat(a,10));h=Q(a)&&!isNaN(a)?a:w;c.$validate()})}},url:function(a,b,d,c,e,f){kb(a,b,d,c,e,f);lc(c);c.$$parserName="url";c.$validators.url=function(a,b){var d=a||b;return c.$isEmpty(d)||
	Ag.test(d)}},email:function(a,b,d,c,e,f){kb(a,b,d,c,e,f);lc(c);c.$$parserName="email";c.$validators.email=function(a,b){var d=a||b;return c.$isEmpty(d)||Bg.test(d)}},radio:function(a,b,d,c){q(d.name)&&b.attr("name",++ob);b.on("click",function(a){b[0].checked&&c.$setViewValue(d.value,a&&a.type)});c.$render=function(){b[0].checked=d.value==c.$viewValue};d.$observe("value",c.$render)},checkbox:function(a,b,d,c,e,f,g,h){var k=Md(h,a,"ngTrueValue",d.ngTrueValue,!0),l=Md(h,a,"ngFalseValue",d.ngFalseValue,
	!1);b.on("click",function(a){c.$setViewValue(b[0].checked,a&&a.type)});c.$render=function(){b[0].checked=c.$viewValue};c.$isEmpty=function(a){return!1===a};c.$formatters.push(function(a){return ka(a,k)});c.$parsers.push(function(a){return a?k:l})},hidden:z,button:z,submit:z,reset:z,file:z},Ec=["$browser","$sniffer","$filter","$parse",function(a,b,d,c){return{restrict:"E",require:["?ngModel"],link:{pre:function(e,f,g,h){h[0]&&(Wd[K(g.type)]||Wd.text)(e,f,g,h[0],b,a,d,c)}}}}],Dg=/^(true|false|\d+)$/,
	Re=function(){return{restrict:"A",priority:100,compile:function(a,b){return Dg.test(b.ngValue)?function(a,b,e){e.$set("value",a.$eval(e.ngValue))}:function(a,b,e){a.$watch(e.ngValue,function(a){e.$set("value",a)})}}}},re=["$compile",function(a){return{restrict:"AC",compile:function(b){a.$$addBindingClass(b);return function(b,c,e){a.$$addBindingInfo(c,e.ngBind);c=c[0];b.$watch(e.ngBind,function(a){c.textContent=q(a)?"":a})}}}}],te=["$interpolate","$compile",function(a,b){return{compile:function(d){b.$$addBindingClass(d);
	return function(c,d,f){c=a(d.attr(f.$attr.ngBindTemplate));b.$$addBindingInfo(d,c.expressions);d=d[0];f.$observe("ngBindTemplate",function(a){d.textContent=q(a)?"":a})}}}}],se=["$sce","$parse","$compile",function(a,b,d){return{restrict:"A",compile:function(c,e){var f=b(e.ngBindHtml),g=b(e.ngBindHtml,function(a){return(a||"").toString()});d.$$addBindingClass(c);return function(b,c,e){d.$$addBindingInfo(c,e.ngBindHtml);b.$watch(g,function(){c.html(a.getTrustedHtml(f(b))||"")})}}}}],Qe=na({restrict:"A",
	require:"ngModel",link:function(a,b,d,c){c.$viewChangeListeners.push(function(){a.$eval(d.ngChange)})}}),ue=mc("",!0),we=mc("Odd",0),ve=mc("Even",1),xe=Ka({compile:function(a,b){b.$set("ngCloak",w);a.removeClass("ng-cloak")}}),ye=[function(){return{restrict:"A",scope:!0,controller:"@",priority:500}}],Jc={},Eg={blur:!0,focus:!0};n("click dblclick mousedown mouseup mouseover mouseout mousemove mouseenter mouseleave keydown keyup keypress submit focus blur copy cut paste".split(" "),function(a){var b=
	va("ng-"+a);Jc[b]=["$parse","$rootScope",function(d,c){return{restrict:"A",compile:function(e,f){var g=d(f[b],null,!0);return function(b,d){d.on(a,function(d){var e=function(){g(b,{$event:d})};Eg[a]&&c.$$phase?b.$evalAsync(e):b.$apply(e)})}}}}]});var Be=["$animate",function(a){return{multiElement:!0,transclude:"element",priority:600,terminal:!0,restrict:"A",$$tlb:!0,link:function(b,d,c,e,f){var g,h,k;b.$watch(c.ngIf,function(b){b?h||f(function(b,e){h=e;b[b.length++]=W.createComment(" end ngIf: "+
	c.ngIf+" ");g={clone:b};a.enter(b,d.parent(),d)}):(k&&(k.remove(),k=null),h&&(h.$destroy(),h=null),g&&(k=sb(g.clone),a.leave(k).then(function(){k=null}),g=null))})}}}],Ce=["$templateRequest","$anchorScroll","$animate",function(a,b,d){return{restrict:"ECA",priority:400,terminal:!0,transclude:"element",controller:$.noop,compile:function(c,e){var f=e.ngInclude||e.src,g=e.onload||"",h=e.autoscroll;return function(c,e,m,n,q){var s=0,y,w,p,x=function(){w&&(w.remove(),w=null);y&&(y.$destroy(),y=null);p&&
	(d.leave(p).then(function(){w=null}),w=p,p=null)};c.$watch(f,function(f){var m=function(){!u(h)||h&&!c.$eval(h)||b()},H=++s;f?(a(f,!0).then(function(a){if(!c.$$destroyed&&H===s){var b=c.$new();n.template=a;a=q(b,function(a){x();d.enter(a,null,e).then(m)});y=b;p=a;y.$emit("$includeContentLoaded",f);c.$eval(g)}},function(){c.$$destroyed||H!==s||(x(),c.$emit("$includeContentError",f))}),c.$emit("$includeContentRequested",f)):(x(),n.template=null)})}}}}],Te=["$compile",function(a){return{restrict:"ECA",
	priority:-400,require:"ngInclude",link:function(b,d,c,e){/SVG/.test(d[0].toString())?(d.empty(),a(Mc(e.template,W).childNodes)(b,function(a){d.append(a)},{futureParentElement:d})):(d.html(e.template),a(d.contents())(b))}}}],De=Ka({priority:450,compile:function(){return{pre:function(a,b,d){a.$eval(d.ngInit)}}}}),Pe=function(){return{restrict:"A",priority:100,require:"ngModel",link:function(a,b,d,c){var e=b.attr(d.$attr.ngList)||", ",f="false"!==d.ngTrim,g=f?T(e):e;c.$parsers.push(function(a){if(!q(a)){var b=
	[];a&&n(a.split(g),function(a){a&&b.push(f?T(a):a)});return b}});c.$formatters.push(function(a){return E(a)?a.join(e):w});c.$isEmpty=function(a){return!a||!a.length}}}},nb="ng-valid",Nd="ng-invalid",Wa="ng-pristine",Lb="ng-dirty",Pd="ng-pending",mb=M("ngModel"),Fg=["$scope","$exceptionHandler","$attrs","$element","$parse","$animate","$timeout","$rootScope","$q","$interpolate",function(a,b,d,c,e,f,g,h,k,l){this.$modelValue=this.$viewValue=Number.NaN;this.$$rawModelValue=w;this.$validators={};this.$asyncValidators=
	{};this.$parsers=[];this.$formatters=[];this.$viewChangeListeners=[];this.$untouched=!0;this.$touched=!1;this.$pristine=!0;this.$dirty=!1;this.$valid=!0;this.$invalid=!1;this.$error={};this.$$success={};this.$pending=w;this.$name=l(d.name||"",!1)(a);this.$$parentForm=Kb;var m=e(d.ngModel),r=m.assign,t=m,s=r,y=null,A,p=this;this.$$setOptions=function(a){if((p.$options=a)&&a.getterSetter){var b=e(d.ngModel+"()"),f=e(d.ngModel+"($$$p)");t=function(a){var c=m(a);B(c)&&(c=b(a));return c};s=function(a,
	b){B(m(a))?f(a,{$$$p:p.$modelValue}):r(a,p.$modelValue)}}else if(!m.assign)throw mb("nonassign",d.ngModel,ua(c));};this.$render=z;this.$isEmpty=function(a){return q(a)||""===a||null===a||a!==a};var x=0;Kd({ctrl:this,$element:c,set:function(a,b){a[b]=!0},unset:function(a,b){delete a[b]},$animate:f});this.$setPristine=function(){p.$dirty=!1;p.$pristine=!0;f.removeClass(c,Lb);f.addClass(c,Wa)};this.$setDirty=function(){p.$dirty=!0;p.$pristine=!1;f.removeClass(c,Wa);f.addClass(c,Lb);p.$$parentForm.$setDirty()};
	this.$setUntouched=function(){p.$touched=!1;p.$untouched=!0;f.setClass(c,"ng-untouched","ng-touched")};this.$setTouched=function(){p.$touched=!0;p.$untouched=!1;f.setClass(c,"ng-touched","ng-untouched")};this.$rollbackViewValue=function(){g.cancel(y);p.$viewValue=p.$$lastCommittedViewValue;p.$render()};this.$validate=function(){if(!Q(p.$modelValue)||!isNaN(p.$modelValue)){var a=p.$$rawModelValue,b=p.$valid,c=p.$modelValue,d=p.$options&&p.$options.allowInvalid;p.$$runValidators(a,p.$$lastCommittedViewValue,
	function(e){d||b===e||(p.$modelValue=e?a:w,p.$modelValue!==c&&p.$$writeModelToScope())})}};this.$$runValidators=function(a,b,c){function d(){var c=!0;n(p.$validators,function(d,e){var g=d(a,b);c=c&&g;f(e,g)});return c?!0:(n(p.$asyncValidators,function(a,b){f(b,null)}),!1)}function e(){var c=[],d=!0;n(p.$asyncValidators,function(e,g){var h=e(a,b);if(!h||!B(h.then))throw mb("nopromise",h);f(g,w);c.push(h.then(function(){f(g,!0)},function(a){d=!1;f(g,!1)}))});c.length?k.all(c).then(function(){g(d)},
	z):g(!0)}function f(a,b){h===x&&p.$setValidity(a,b)}function g(a){h===x&&c(a)}x++;var h=x;(function(){var a=p.$$parserName||"parse";if(q(A))f(a,null);else return A||(n(p.$validators,function(a,b){f(b,null)}),n(p.$asyncValidators,function(a,b){f(b,null)})),f(a,A),A;return!0})()?d()?e():g(!1):g(!1)};this.$commitViewValue=function(){var a=p.$viewValue;g.cancel(y);if(p.$$lastCommittedViewValue!==a||""===a&&p.$$hasNativeValidators)p.$$lastCommittedViewValue=a,p.$pristine&&this.$setDirty(),this.$$parseAndValidate()};
	this.$$parseAndValidate=function(){var b=p.$$lastCommittedViewValue;if(A=q(b)?w:!0)for(var c=0;c<p.$parsers.length;c++)if(b=p.$parsers[c](b),q(b)){A=!1;break}Q(p.$modelValue)&&isNaN(p.$modelValue)&&(p.$modelValue=t(a));var d=p.$modelValue,e=p.$options&&p.$options.allowInvalid;p.$$rawModelValue=b;e&&(p.$modelValue=b,p.$modelValue!==d&&p.$$writeModelToScope());p.$$runValidators(b,p.$$lastCommittedViewValue,function(a){e||(p.$modelValue=a?b:w,p.$modelValue!==d&&p.$$writeModelToScope())})};this.$$writeModelToScope=
	function(){s(a,p.$modelValue);n(p.$viewChangeListeners,function(a){try{a()}catch(c){b(c)}})};this.$setViewValue=function(a,b){p.$viewValue=a;p.$options&&!p.$options.updateOnDefault||p.$$debounceViewValueCommit(b)};this.$$debounceViewValueCommit=function(b){var c=0,d=p.$options;d&&u(d.debounce)&&(d=d.debounce,Q(d)?c=d:Q(d[b])?c=d[b]:Q(d["default"])&&(c=d["default"]));g.cancel(y);c?y=g(function(){p.$commitViewValue()},c):h.$$phase?p.$commitViewValue():a.$apply(function(){p.$commitViewValue()})};a.$watch(function(){var b=
	t(a);if(b!==p.$modelValue&&(p.$modelValue===p.$modelValue||b===b)){p.$modelValue=p.$$rawModelValue=b;A=w;for(var c=p.$formatters,d=c.length,e=b;d--;)e=c[d](e);p.$viewValue!==e&&(p.$viewValue=p.$$lastCommittedViewValue=e,p.$render(),p.$$runValidators(b,e,z))}return b})}],Oe=["$rootScope",function(a){return{restrict:"A",require:["ngModel","^?form","^?ngModelOptions"],controller:Fg,priority:1,compile:function(b){b.addClass(Wa).addClass("ng-untouched").addClass(nb);return{pre:function(a,b,e,f){var g=
	f[0];b=f[1]||g.$$parentForm;g.$$setOptions(f[2]&&f[2].$options);b.$addControl(g);e.$observe("name",function(a){g.$name!==a&&g.$$parentForm.$$renameControl(g,a)});a.$on("$destroy",function(){g.$$parentForm.$removeControl(g)})},post:function(b,c,e,f){var g=f[0];if(g.$options&&g.$options.updateOn)c.on(g.$options.updateOn,function(a){g.$$debounceViewValueCommit(a&&a.type)});c.on("blur",function(c){g.$touched||(a.$$phase?b.$evalAsync(g.$setTouched):b.$apply(g.$setTouched))})}}}}}],Gg=/(\s+|^)default(\s+|$)/,
	Se=function(){return{restrict:"A",controller:["$scope","$attrs",function(a,b){var d=this;this.$options=Ma(a.$eval(b.ngModelOptions));u(this.$options.updateOn)?(this.$options.updateOnDefault=!1,this.$options.updateOn=T(this.$options.updateOn.replace(Gg,function(){d.$options.updateOnDefault=!0;return" "}))):this.$options.updateOnDefault=!0}]}},Ee=Ka({terminal:!0,priority:1E3}),Hg=M("ngOptions"),Ig=/^\s*([\s\S]+?)(?:\s+as\s+([\s\S]+?))?(?:\s+group\s+by\s+([\s\S]+?))?(?:\s+disable\s+when\s+([\s\S]+?))?\s+for\s+(?:([\$\w][\$\w]*)|(?:\(\s*([\$\w][\$\w]*)\s*,\s*([\$\w][\$\w]*)\s*\)))\s+in\s+([\s\S]+?)(?:\s+track\s+by\s+([\s\S]+?))?$/,
	Me=["$compile","$parse",function(a,b){function d(a,c,d){function e(a,b,c,d,f){this.selectValue=a;this.viewValue=b;this.label=c;this.group=d;this.disabled=f}function l(a){var b;if(!q&&Aa(a))b=a;else{b=[];for(var c in a)a.hasOwnProperty(c)&&"$"!==c.charAt(0)&&b.push(c)}return b}var m=a.match(Ig);if(!m)throw Hg("iexp",a,ua(c));var n=m[5]||m[7],q=m[6];a=/ as /.test(m[0])&&m[1];var s=m[9];c=b(m[2]?m[1]:n);var y=a&&b(a)||c,u=s&&b(s),p=s?function(a,b){return u(d,b)}:function(a){return Da(a)},x=function(a,
	b){return p(a,D(a,b))},v=b(m[2]||m[1]),w=b(m[3]||""),H=b(m[4]||""),A=b(m[8]),z={},D=q?function(a,b){z[q]=b;z[n]=a;return z}:function(a){z[n]=a;return z};return{trackBy:s,getTrackByValue:x,getWatchables:b(A,function(a){var b=[];a=a||[];for(var c=l(a),e=c.length,f=0;f<e;f++){var g=a===c?f:c[f],k=D(a[g],g),g=p(a[g],k);b.push(g);if(m[2]||m[1])g=v(d,k),b.push(g);m[4]&&(k=H(d,k),b.push(k))}return b}),getOptions:function(){for(var a=[],b={},c=A(d)||[],f=l(c),g=f.length,m=0;m<g;m++){var n=c===f?m:f[m],r=
	D(c[n],n),q=y(d,r),n=p(q,r),t=v(d,r),u=w(d,r),r=H(d,r),q=new e(n,q,t,u,r);a.push(q);b[n]=q}return{items:a,selectValueMap:b,getOptionFromViewValue:function(a){return b[x(a)]},getViewValueFromOption:function(a){return s?$.copy(a.viewValue):a.viewValue}}}}}var c=W.createElement("option"),e=W.createElement("optgroup");return{restrict:"A",terminal:!0,require:["select","?ngModel"],link:{pre:function(a,b,c,d){d[0].registerOption=z},post:function(b,g,h,k){function l(a,b){a.element=b;b.disabled=a.disabled;
	a.label!==b.label&&(b.label=a.label,b.textContent=a.label);a.value!==b.value&&(b.value=a.selectValue)}function m(a,b,c,d){b&&K(b.nodeName)===c?c=b:(c=d.cloneNode(!1),b?a.insertBefore(c,b):a.appendChild(c));return c}function r(a){for(var b;a;)b=a.nextSibling,Zb(a),a=b}function q(a){var b=x&&x[0],c=z&&z[0];if(b||c)for(;a&&(a===b||a===c||8===a.nodeType||"option"===oa(a)&&""===a.value);)a=a.nextSibling;return a}function s(){var a=B&&u.readValue();B=D.getOptions();var b={},d=g[0].firstChild;H&&g.prepend(x);
	d=q(d);B.items.forEach(function(a){var f,h;a.group?(f=b[a.group],f||(f=m(g[0],d,"optgroup",e),d=f.nextSibling,f.label=a.group,f=b[a.group]={groupElement:f,currentOptionElement:f.firstChild}),h=m(f.groupElement,f.currentOptionElement,"option",c),l(a,h),f.currentOptionElement=h.nextSibling):(h=m(g[0],d,"option",c),l(a,h),d=h.nextSibling)});Object.keys(b).forEach(function(a){r(b[a].currentOptionElement)});r(d);y.$render();if(!y.$isEmpty(a)){var f=u.readValue();(D.trackBy||p?ka(a,f):a===f)||(y.$setViewValue(f),
	y.$render())}}var y=k[1];if(y){var u=k[0],p=h.multiple,x;k=0;for(var v=g.children(),w=v.length;k<w;k++)if(""===v[k].value){x=v.eq(k);break}var H=!!x,z=A(c.cloneNode(!1));z.val("?");var B,D=d(h.ngOptions,g,b);p?(y.$isEmpty=function(a){return!a||0===a.length},u.writeValue=function(a){B.items.forEach(function(a){a.element.selected=!1});a&&a.forEach(function(a){(a=B.getOptionFromViewValue(a))&&!a.disabled&&(a.element.selected=!0)})},u.readValue=function(){var a=g.val()||[],b=[];n(a,function(a){(a=B.selectValueMap[a])&&
	!a.disabled&&b.push(B.getViewValueFromOption(a))});return b},D.trackBy&&b.$watchCollection(function(){if(E(y.$viewValue))return y.$viewValue.map(function(a){return D.getTrackByValue(a)})},function(){y.$render()})):(u.writeValue=function(a){var b=B.getOptionFromViewValue(a);b&&!b.disabled?g[0].value!==b.selectValue&&(z.remove(),H||x.remove(),g[0].value=b.selectValue,b.element.selected=!0,b.element.setAttribute("selected","selected")):null===a||H?(z.remove(),H||g.prepend(x),g.val(""),x.prop("selected",
	!0),x.attr("selected",!0)):(H||x.remove(),g.prepend(z),g.val("?"),z.prop("selected",!0),z.attr("selected",!0))},u.readValue=function(){var a=B.selectValueMap[g.val()];return a&&!a.disabled?(H||x.remove(),z.remove(),B.getViewValueFromOption(a)):null},D.trackBy&&b.$watch(function(){return D.getTrackByValue(y.$viewValue)},function(){y.$render()}));H?(x.remove(),a(x)(b),x.removeClass("ng-scope")):x=A(c.cloneNode(!1));s();b.$watchCollection(D.getWatchables,s)}}}}}],Fe=["$locale","$interpolate","$log",
	function(a,b,d){var c=/{}/g,e=/^when(Minus)?(.+)$/;return{link:function(f,g,h){function k(a){g.text(a||"")}var l=h.count,m=h.$attr.when&&g.attr(h.$attr.when),r=h.offset||0,t=f.$eval(m)||{},s={},u=b.startSymbol(),w=b.endSymbol(),p=u+l+"-"+r+w,x=$.noop,v;n(h,function(a,b){var c=e.exec(b);c&&(c=(c[1]?"-":"")+K(c[2]),t[c]=g.attr(h.$attr[b]))});n(t,function(a,d){s[d]=b(a.replace(c,p))});f.$watch(l,function(b){var c=parseFloat(b),e=isNaN(c);e||c in t||(c=a.pluralCat(c-r));c===v||e&&Q(v)&&isNaN(v)||(x(),
	e=s[c],q(e)?(null!=b&&d.debug("ngPluralize: no rule defined for '"+c+"' in "+m),x=z,k()):x=f.$watch(e,k),v=c)})}}}],Ge=["$parse","$animate",function(a,b){var d=M("ngRepeat"),c=function(a,b,c,d,k,l,m){a[c]=d;k&&(a[k]=l);a.$index=b;a.$first=0===b;a.$last=b===m-1;a.$middle=!(a.$first||a.$last);a.$odd=!(a.$even=0===(b&1))};return{restrict:"A",multiElement:!0,transclude:"element",priority:1E3,terminal:!0,$$tlb:!0,compile:function(e,f){var g=f.ngRepeat,h=W.createComment(" end ngRepeat: "+g+" "),k=g.match(/^\s*([\s\S]+?)\s+in\s+([\s\S]+?)(?:\s+as\s+([\s\S]+?))?(?:\s+track\s+by\s+([\s\S]+?))?\s*$/);
	if(!k)throw d("iexp",g);var l=k[1],m=k[2],r=k[3],q=k[4],k=l.match(/^(?:(\s*[\$\w]+)|\(\s*([\$\w]+)\s*,\s*([\$\w]+)\s*\))$/);if(!k)throw d("iidexp",l);var s=k[3]||k[1],u=k[2];if(r&&(!/^[$a-zA-Z_][$a-zA-Z0-9_]*$/.test(r)||/^(null|undefined|this|\$index|\$first|\$middle|\$last|\$even|\$odd|\$parent|\$root|\$id)$/.test(r)))throw d("badident",r);var z,p,x,v,B={$id:Da};q?z=a(q):(x=function(a,b){return Da(b)},v=function(a){return a});return function(a,e,f,k,l){z&&(p=function(b,c,d){u&&(B[u]=b);B[s]=c;B.$index=
	d;return z(a,B)});var q=ea();a.$watchCollection(m,function(f){var k,m,t=e[0],z,B=ea(),D,F,G,E,I,J,K;r&&(a[r]=f);if(Aa(f))I=f,m=p||x;else for(K in m=p||v,I=[],f)ra.call(f,K)&&"$"!==K.charAt(0)&&I.push(K);D=I.length;K=Array(D);for(k=0;k<D;k++)if(F=f===I?k:I[k],G=f[F],E=m(F,G,k),q[E])J=q[E],delete q[E],B[E]=J,K[k]=J;else{if(B[E])throw n(K,function(a){a&&a.scope&&(q[a.id]=a)}),d("dupes",g,E,G);K[k]={id:E,scope:w,clone:w};B[E]=!0}for(z in q){J=q[z];E=sb(J.clone);b.leave(E);if(E[0].parentNode)for(k=0,m=
	E.length;k<m;k++)E[k].$$NG_REMOVED=!0;J.scope.$destroy()}for(k=0;k<D;k++)if(F=f===I?k:I[k],G=f[F],J=K[k],J.scope){z=t;do z=z.nextSibling;while(z&&z.$$NG_REMOVED);J.clone[0]!=z&&b.move(sb(J.clone),null,A(t));t=J.clone[J.clone.length-1];c(J.scope,k,s,G,u,F,D)}else l(function(a,d){J.scope=d;var e=h.cloneNode(!1);a[a.length++]=e;b.enter(a,null,A(t));t=e;J.clone=a;B[J.id]=J;c(J.scope,k,s,G,u,F,D)});q=B})}}}}],He=["$animate",function(a){return{restrict:"A",multiElement:!0,link:function(b,d,c){b.$watch(c.ngShow,
	function(b){a[b?"removeClass":"addClass"](d,"ng-hide",{tempClasses:"ng-hide-animate"})})}}}],Ae=["$animate",function(a){return{restrict:"A",multiElement:!0,link:function(b,d,c){b.$watch(c.ngHide,function(b){a[b?"addClass":"removeClass"](d,"ng-hide",{tempClasses:"ng-hide-animate"})})}}}],Ie=Ka(function(a,b,d){a.$watch(d.ngStyle,function(a,d){d&&a!==d&&n(d,function(a,c){b.css(c,"")});a&&b.css(a)},!0)}),Je=["$animate",function(a){return{require:"ngSwitch",controller:["$scope",function(){this.cases={}}],
	link:function(b,d,c,e){var f=[],g=[],h=[],k=[],l=function(a,b){return function(){a.splice(b,1)}};b.$watch(c.ngSwitch||c.on,function(b){var c,d;c=0;for(d=h.length;c<d;++c)a.cancel(h[c]);c=h.length=0;for(d=k.length;c<d;++c){var q=sb(g[c].clone);k[c].$destroy();(h[c]=a.leave(q)).then(l(h,c))}g.length=0;k.length=0;(f=e.cases["!"+b]||e.cases["?"])&&n(f,function(b){b.transclude(function(c,d){k.push(d);var e=b.element;c[c.length++]=W.createComment(" end ngSwitchWhen: ");g.push({clone:c});a.enter(c,e.parent(),
	e)})})})}}}],Ke=Ka({transclude:"element",priority:1200,require:"^ngSwitch",multiElement:!0,link:function(a,b,d,c,e){c.cases["!"+d.ngSwitchWhen]=c.cases["!"+d.ngSwitchWhen]||[];c.cases["!"+d.ngSwitchWhen].push({transclude:e,element:b})}}),Le=Ka({transclude:"element",priority:1200,require:"^ngSwitch",multiElement:!0,link:function(a,b,d,c,e){c.cases["?"]=c.cases["?"]||[];c.cases["?"].push({transclude:e,element:b})}}),Ne=Ka({restrict:"EAC",link:function(a,b,d,c,e){if(!e)throw M("ngTransclude")("orphan",
	ua(b));e(function(a){b.empty();b.append(a)})}}),ne=["$templateCache",function(a){return{restrict:"E",terminal:!0,compile:function(b,d){"text/ng-template"==d.type&&a.put(d.id,b[0].text)}}}],Jg={$setViewValue:z,$render:z},Kg=["$element","$scope","$attrs",function(a,b,d){var c=this,e=new Sa;c.ngModelCtrl=Jg;c.unknownOption=A(W.createElement("option"));c.renderUnknownOption=function(b){b="? "+Da(b)+" ?";c.unknownOption.val(b);a.prepend(c.unknownOption);a.val(b)};b.$on("$destroy",function(){c.renderUnknownOption=
	z});c.removeUnknownOption=function(){c.unknownOption.parent()&&c.unknownOption.remove()};c.readValue=function(){c.removeUnknownOption();return a.val()};c.writeValue=function(b){c.hasOption(b)?(c.removeUnknownOption(),a.val(b),""===b&&c.emptyOption.prop("selected",!0)):null==b&&c.emptyOption?(c.removeUnknownOption(),a.val("")):c.renderUnknownOption(b)};c.addOption=function(a,b){Ra(a,'"option value"');""===a&&(c.emptyOption=b);var d=e.get(a)||0;e.put(a,d+1);c.ngModelCtrl.$render();b[0].hasAttribute("selected")&&
	(b[0].selected=!0)};c.removeOption=function(a){var b=e.get(a);b&&(1===b?(e.remove(a),""===a&&(c.emptyOption=w)):e.put(a,b-1))};c.hasOption=function(a){return!!e.get(a)};c.registerOption=function(a,b,d,e,l){if(e){var m;d.$observe("value",function(a){u(m)&&c.removeOption(m);m=a;c.addOption(a,b)})}else l?a.$watch(l,function(a,e){d.$set("value",a);e!==a&&c.removeOption(e);c.addOption(a,b)}):c.addOption(d.value,b);b.on("$destroy",function(){c.removeOption(d.value);c.ngModelCtrl.$render()})}}],oe=function(){return{restrict:"E",
	require:["select","?ngModel"],controller:Kg,priority:1,link:{pre:function(a,b,d,c){var e=c[1];if(e){var f=c[0];f.ngModelCtrl=e;b.on("change",function(){a.$apply(function(){e.$setViewValue(f.readValue())})});if(d.multiple){f.readValue=function(){var a=[];n(b.find("option"),function(b){b.selected&&a.push(b.value)});return a};f.writeValue=function(a){var c=new Sa(a);n(b.find("option"),function(a){a.selected=u(c.get(a.value))})};var g,h=NaN;a.$watch(function(){h!==e.$viewValue||ka(g,e.$viewValue)||(g=
	ha(e.$viewValue),e.$render());h=e.$viewValue});e.$isEmpty=function(a){return!a||0===a.length}}}},post:function(a,b,d,c){var e=c[1];if(e){var f=c[0];e.$render=function(){f.writeValue(e.$viewValue)}}}}}},qe=["$interpolate",function(a){return{restrict:"E",priority:100,compile:function(b,d){if(u(d.value))var c=a(d.value,!0);else{var e=a(b.text(),!0);e||d.$set("value",b.text())}return function(a,b,d){var k=b.parent();(k=k.data("$selectController")||k.parent().data("$selectController"))&&k.registerOption(a,
	b,d,c,e)}}}}],pe=na({restrict:"E",terminal:!1}),Gc=function(){return{restrict:"A",require:"?ngModel",link:function(a,b,d,c){c&&(d.required=!0,c.$validators.required=function(a,b){return!d.required||!c.$isEmpty(b)},d.$observe("required",function(){c.$validate()}))}}},Fc=function(){return{restrict:"A",require:"?ngModel",link:function(a,b,d,c){if(c){var e,f=d.ngPattern||d.pattern;d.$observe("pattern",function(a){F(a)&&0<a.length&&(a=new RegExp("^"+a+"$"));if(a&&!a.test)throw M("ngPattern")("noregexp",
	f,a,ua(b));e=a||w;c.$validate()});c.$validators.pattern=function(a,b){return c.$isEmpty(b)||q(e)||e.test(b)}}}}},Ic=function(){return{restrict:"A",require:"?ngModel",link:function(a,b,d,c){if(c){var e=-1;d.$observe("maxlength",function(a){a=Z(a);e=isNaN(a)?-1:a;c.$validate()});c.$validators.maxlength=function(a,b){return 0>e||c.$isEmpty(b)||b.length<=e}}}}},Hc=function(){return{restrict:"A",require:"?ngModel",link:function(a,b,d,c){if(c){var e=0;d.$observe("minlength",function(a){e=Z(a)||0;c.$validate()});
	c.$validators.minlength=function(a,b){return c.$isEmpty(b)||b.length>=e}}}}};S.angular.bootstrap?console.log("WARNING: Tried to load angular more than once."):(ge(),ie($),$.module("ngLocale",[],["$provide",function(a){function b(a){a+="";var b=a.indexOf(".");return-1==b?0:a.length-b-1}a.value("$locale",{DATETIME_FORMATS:{AMPMS:["AM","PM"],DAY:"Sunday Monday Tuesday Wednesday Thursday Friday Saturday".split(" "),ERANAMES:["Before Christ","Anno Domini"],ERAS:["BC","AD"],FIRSTDAYOFWEEK:6,MONTH:"January February March April May June July August September October November December".split(" "),
	SHORTDAY:"Sun Mon Tue Wed Thu Fri Sat".split(" "),SHORTMONTH:"Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec".split(" "),STANDALONEMONTH:"January February March April May June July August September October November December".split(" "),WEEKENDRANGE:[5,6],fullDate:"EEEE, MMMM d, y",longDate:"MMMM d, y",medium:"MMM d, y h:mm:ss a",mediumDate:"MMM d, y",mediumTime:"h:mm:ss a","short":"M/d/yy h:mm a",shortDate:"M/d/yy",shortTime:"h:mm a"},NUMBER_FORMATS:{CURRENCY_SYM:"$",DECIMAL_SEP:".",GROUP_SEP:",",
	PATTERNS:[{gSize:3,lgSize:3,maxFrac:3,minFrac:0,minInt:1,negPre:"-",negSuf:"",posPre:"",posSuf:""},{gSize:3,lgSize:3,maxFrac:2,minFrac:2,minInt:1,negPre:"-\u00a4",negSuf:"",posPre:"\u00a4",posSuf:""}]},id:"en-us",pluralCat:function(a,c){var e=a|0,f=c;w===f&&(f=Math.min(b(a),3));Math.pow(10,f);return 1==e&&0==f?"one":"other"}})}]),A(W).ready(function(){ce(W,zc)}))})(window,document);!window.angular.$$csp().noInlineStyle&&window.angular.element(document.head).prepend('<style type="text/css">@charset "UTF-8";[ng\\:cloak],[ng-cloak],[data-ng-cloak],[x-ng-cloak],.ng-cloak,.x-ng-cloak,.ng-hide:not(.ng-hide-animate){display:none !important;}ng\\:form{display:block;}.ng-animate-shim{visibility:hidden;}.ng-anchor{position:absolute;}</style>');
	//# sourceMappingURL=angular.min.js.map


/***/ },
/* 5 */
/***/ function(module, exports) {

	/*
	 * angular-ui-bootstrap
	 * http://angular-ui.github.io/bootstrap/

	 * Version: 0.11.2 - 2014-09-26
	 * License: MIT
	 */
	angular.module("ui.bootstrap",["ui.bootstrap.tpls","ui.bootstrap.transition","ui.bootstrap.collapse","ui.bootstrap.accordion","ui.bootstrap.alert","ui.bootstrap.bindHtml","ui.bootstrap.buttons","ui.bootstrap.carousel","ui.bootstrap.dateparser","ui.bootstrap.position","ui.bootstrap.datepicker","ui.bootstrap.dropdown","ui.bootstrap.modal","ui.bootstrap.pagination","ui.bootstrap.tooltip","ui.bootstrap.popover","ui.bootstrap.progressbar","ui.bootstrap.rating","ui.bootstrap.tabs","ui.bootstrap.timepicker","ui.bootstrap.typeahead"]),angular.module("ui.bootstrap.tpls",["template/accordion/accordion-group.html","template/accordion/accordion.html","template/alert/alert.html","template/carousel/carousel.html","template/carousel/slide.html","template/datepicker/datepicker.html","template/datepicker/day.html","template/datepicker/month.html","template/datepicker/popup.html","template/datepicker/year.html","template/modal/backdrop.html","template/modal/window.html","template/pagination/pager.html","template/pagination/pagination.html","template/tooltip/tooltip-html-unsafe-popup.html","template/tooltip/tooltip-popup.html","template/popover/popover.html","template/progressbar/bar.html","template/progressbar/progress.html","template/progressbar/progressbar.html","template/rating/rating.html","template/tabs/tab.html","template/tabs/tabset.html","template/timepicker/timepicker.html","template/typeahead/typeahead-match.html","template/typeahead/typeahead-popup.html"]),angular.module("ui.bootstrap.transition",[]).factory("$transition",["$q","$timeout","$rootScope",function(a,b,c){function d(a){for(var b in a)if(void 0!==f.style[b])return a[b]}var e=function(d,f,g){g=g||{};var h=a.defer(),i=e[g.animation?"animationEndEventName":"transitionEndEventName"],j=function(){c.$apply(function(){d.unbind(i,j),h.resolve(d)})};return i&&d.bind(i,j),b(function(){angular.isString(f)?d.addClass(f):angular.isFunction(f)?f(d):angular.isObject(f)&&d.css(f),i||h.resolve(d)}),h.promise.cancel=function(){i&&d.unbind(i,j),h.reject("Transition cancelled")},h.promise},f=document.createElement("trans"),g={WebkitTransition:"webkitTransitionEnd",MozTransition:"transitionend",OTransition:"oTransitionEnd",transition:"transitionend"},h={WebkitTransition:"webkitAnimationEnd",MozTransition:"animationend",OTransition:"oAnimationEnd",transition:"animationend"};return e.transitionEndEventName=d(g),e.animationEndEventName=d(h),e}]),angular.module("ui.bootstrap.collapse",["ui.bootstrap.transition"]).directive("collapse",["$transition",function(a){return{link:function(b,c,d){function e(b){function d(){j===e&&(j=void 0)}var e=a(c,b);return j&&j.cancel(),j=e,e.then(d,d),e}function f(){k?(k=!1,g()):(c.removeClass("collapse").addClass("collapsing"),e({height:c[0].scrollHeight+"px"}).then(g))}function g(){c.removeClass("collapsing"),c.addClass("collapse in"),c.css({height:"auto"})}function h(){if(k)k=!1,i(),c.css({height:0});else{c.css({height:c[0].scrollHeight+"px"});{c[0].offsetWidth}c.removeClass("collapse in").addClass("collapsing"),e({height:0}).then(i)}}function i(){c.removeClass("collapsing"),c.addClass("collapse")}var j,k=!0;b.$watch(d.collapse,function(a){a?h():f()})}}}]),angular.module("ui.bootstrap.accordion",["ui.bootstrap.collapse"]).constant("accordionConfig",{closeOthers:!0}).controller("AccordionController",["$scope","$attrs","accordionConfig",function(a,b,c){this.groups=[],this.closeOthers=function(d){var e=angular.isDefined(b.closeOthers)?a.$eval(b.closeOthers):c.closeOthers;e&&angular.forEach(this.groups,function(a){a!==d&&(a.isOpen=!1)})},this.addGroup=function(a){var b=this;this.groups.push(a),a.$on("$destroy",function(){b.removeGroup(a)})},this.removeGroup=function(a){var b=this.groups.indexOf(a);-1!==b&&this.groups.splice(b,1)}}]).directive("accordion",function(){return{restrict:"EA",controller:"AccordionController",transclude:!0,replace:!1,templateUrl:"template/accordion/accordion.html"}}).directive("accordionGroup",function(){return{require:"^accordion",restrict:"EA",transclude:!0,replace:!0,templateUrl:"template/accordion/accordion-group.html",scope:{heading:"@",isOpen:"=?",isDisabled:"=?"},controller:function(){this.setHeading=function(a){this.heading=a}},link:function(a,b,c,d){d.addGroup(a),a.$watch("isOpen",function(b){b&&d.closeOthers(a)}),a.toggleOpen=function(){a.isDisabled||(a.isOpen=!a.isOpen)}}}}).directive("accordionHeading",function(){return{restrict:"EA",transclude:!0,template:"",replace:!0,require:"^accordionGroup",link:function(a,b,c,d,e){d.setHeading(e(a,function(){}))}}}).directive("accordionTransclude",function(){return{require:"^accordionGroup",link:function(a,b,c,d){a.$watch(function(){return d[c.accordionTransclude]},function(a){a&&(b.html(""),b.append(a))})}}}),angular.module("ui.bootstrap.alert",[]).controller("AlertController",["$scope","$attrs",function(a,b){a.closeable="close"in b}]).directive("alert",function(){return{restrict:"EA",controller:"AlertController",templateUrl:"template/alert/alert.html",transclude:!0,replace:!0,scope:{type:"@",close:"&"}}}),angular.module("ui.bootstrap.bindHtml",[]).directive("bindHtmlUnsafe",function(){return function(a,b,c){b.addClass("ng-binding").data("$binding",c.bindHtmlUnsafe),a.$watch(c.bindHtmlUnsafe,function(a){b.html(a||"")})}}),angular.module("ui.bootstrap.buttons",[]).constant("buttonConfig",{activeClass:"active",toggleEvent:"click"}).controller("ButtonsController",["buttonConfig",function(a){this.activeClass=a.activeClass||"active",this.toggleEvent=a.toggleEvent||"click"}]).directive("btnRadio",function(){return{require:["btnRadio","ngModel"],controller:"ButtonsController",link:function(a,b,c,d){var e=d[0],f=d[1];f.$render=function(){b.toggleClass(e.activeClass,angular.equals(f.$modelValue,a.$eval(c.btnRadio)))},b.bind(e.toggleEvent,function(){var d=b.hasClass(e.activeClass);(!d||angular.isDefined(c.uncheckable))&&a.$apply(function(){f.$setViewValue(d?null:a.$eval(c.btnRadio)),f.$render()})})}}}).directive("btnCheckbox",function(){return{require:["btnCheckbox","ngModel"],controller:"ButtonsController",link:function(a,b,c,d){function e(){return g(c.btnCheckboxTrue,!0)}function f(){return g(c.btnCheckboxFalse,!1)}function g(b,c){var d=a.$eval(b);return angular.isDefined(d)?d:c}var h=d[0],i=d[1];i.$render=function(){b.toggleClass(h.activeClass,angular.equals(i.$modelValue,e()))},b.bind(h.toggleEvent,function(){a.$apply(function(){i.$setViewValue(b.hasClass(h.activeClass)?f():e()),i.$render()})})}}}),angular.module("ui.bootstrap.carousel",["ui.bootstrap.transition"]).controller("CarouselController",["$scope","$timeout","$transition",function(a,b,c){function d(){e();var c=+a.interval;!isNaN(c)&&c>=0&&(g=b(f,c))}function e(){g&&(b.cancel(g),g=null)}function f(){h?(a.next(),d()):a.pause()}var g,h,i=this,j=i.slides=a.slides=[],k=-1;i.currentSlide=null;var l=!1;i.select=a.select=function(e,f){function g(){if(!l){if(i.currentSlide&&angular.isString(f)&&!a.noTransition&&e.$element){e.$element.addClass(f);{e.$element[0].offsetWidth}angular.forEach(j,function(a){angular.extend(a,{direction:"",entering:!1,leaving:!1,active:!1})}),angular.extend(e,{direction:f,active:!0,entering:!0}),angular.extend(i.currentSlide||{},{direction:f,leaving:!0}),a.$currentTransition=c(e.$element,{}),function(b,c){a.$currentTransition.then(function(){h(b,c)},function(){h(b,c)})}(e,i.currentSlide)}else h(e,i.currentSlide);i.currentSlide=e,k=m,d()}}function h(b,c){angular.extend(b,{direction:"",active:!0,leaving:!1,entering:!1}),angular.extend(c||{},{direction:"",active:!1,leaving:!1,entering:!1}),a.$currentTransition=null}var m=j.indexOf(e);void 0===f&&(f=m>k?"next":"prev"),e&&e!==i.currentSlide&&(a.$currentTransition?(a.$currentTransition.cancel(),b(g)):g())},a.$on("$destroy",function(){l=!0}),i.indexOfSlide=function(a){return j.indexOf(a)},a.next=function(){var b=(k+1)%j.length;return a.$currentTransition?void 0:i.select(j[b],"next")},a.prev=function(){var b=0>k-1?j.length-1:k-1;return a.$currentTransition?void 0:i.select(j[b],"prev")},a.isActive=function(a){return i.currentSlide===a},a.$watch("interval",d),a.$on("$destroy",e),a.play=function(){h||(h=!0,d())},a.pause=function(){a.noPause||(h=!1,e())},i.addSlide=function(b,c){b.$element=c,j.push(b),1===j.length||b.active?(i.select(j[j.length-1]),1==j.length&&a.play()):b.active=!1},i.removeSlide=function(a){var b=j.indexOf(a);j.splice(b,1),j.length>0&&a.active?i.select(b>=j.length?j[b-1]:j[b]):k>b&&k--}}]).directive("carousel",[function(){return{restrict:"EA",transclude:!0,replace:!0,controller:"CarouselController",require:"carousel",templateUrl:"template/carousel/carousel.html",scope:{interval:"=",noTransition:"=",noPause:"="}}}]).directive("slide",function(){return{require:"^carousel",restrict:"EA",transclude:!0,replace:!0,templateUrl:"template/carousel/slide.html",scope:{active:"=?"},link:function(a,b,c,d){d.addSlide(a,b),a.$on("$destroy",function(){d.removeSlide(a)}),a.$watch("active",function(b){b&&d.select(a)})}}}),angular.module("ui.bootstrap.dateparser",[]).service("dateParser",["$locale","orderByFilter",function(a,b){function c(a){var c=[],d=a.split("");return angular.forEach(e,function(b,e){var f=a.indexOf(e);if(f>-1){a=a.split(""),d[f]="("+b.regex+")",a[f]="$";for(var g=f+1,h=f+e.length;h>g;g++)d[g]="",a[g]="$";a=a.join(""),c.push({index:f,apply:b.apply})}}),{regex:new RegExp("^"+d.join("")+"$"),map:b(c,"index")}}function d(a,b,c){return 1===b&&c>28?29===c&&(a%4===0&&a%100!==0||a%400===0):3===b||5===b||8===b||10===b?31>c:!0}this.parsers={};var e={yyyy:{regex:"\\d{4}",apply:function(a){this.year=+a}},yy:{regex:"\\d{2}",apply:function(a){this.year=+a+2e3}},y:{regex:"\\d{1,4}",apply:function(a){this.year=+a}},MMMM:{regex:a.DATETIME_FORMATS.MONTH.join("|"),apply:function(b){this.month=a.DATETIME_FORMATS.MONTH.indexOf(b)}},MMM:{regex:a.DATETIME_FORMATS.SHORTMONTH.join("|"),apply:function(b){this.month=a.DATETIME_FORMATS.SHORTMONTH.indexOf(b)}},MM:{regex:"0[1-9]|1[0-2]",apply:function(a){this.month=a-1}},M:{regex:"[1-9]|1[0-2]",apply:function(a){this.month=a-1}},dd:{regex:"[0-2][0-9]{1}|3[0-1]{1}",apply:function(a){this.date=+a}},d:{regex:"[1-2]?[0-9]{1}|3[0-1]{1}",apply:function(a){this.date=+a}},EEEE:{regex:a.DATETIME_FORMATS.DAY.join("|")},EEE:{regex:a.DATETIME_FORMATS.SHORTDAY.join("|")}};this.parse=function(b,e){if(!angular.isString(b)||!e)return b;e=a.DATETIME_FORMATS[e]||e,this.parsers[e]||(this.parsers[e]=c(e));var f=this.parsers[e],g=f.regex,h=f.map,i=b.match(g);if(i&&i.length){for(var j,k={year:1900,month:0,date:1,hours:0},l=1,m=i.length;m>l;l++){var n=h[l-1];n.apply&&n.apply.call(k,i[l])}return d(k.year,k.month,k.date)&&(j=new Date(k.year,k.month,k.date,k.hours)),j}}}]),angular.module("ui.bootstrap.position",[]).factory("$position",["$document","$window",function(a,b){function c(a,c){return a.currentStyle?a.currentStyle[c]:b.getComputedStyle?b.getComputedStyle(a)[c]:a.style[c]}function d(a){return"static"===(c(a,"position")||"static")}var e=function(b){for(var c=a[0],e=b.offsetParent||c;e&&e!==c&&d(e);)e=e.offsetParent;return e||c};return{position:function(b){var c=this.offset(b),d={top:0,left:0},f=e(b[0]);f!=a[0]&&(d=this.offset(angular.element(f)),d.top+=f.clientTop-f.scrollTop,d.left+=f.clientLeft-f.scrollLeft);var g=b[0].getBoundingClientRect();return{width:g.width||b.prop("offsetWidth"),height:g.height||b.prop("offsetHeight"),top:c.top-d.top,left:c.left-d.left}},offset:function(c){var d=c[0].getBoundingClientRect();return{width:d.width||c.prop("offsetWidth"),height:d.height||c.prop("offsetHeight"),top:d.top+(b.pageYOffset||a[0].documentElement.scrollTop),left:d.left+(b.pageXOffset||a[0].documentElement.scrollLeft)}},positionElements:function(a,b,c,d){var e,f,g,h,i=c.split("-"),j=i[0],k=i[1]||"center";e=d?this.offset(a):this.position(a),f=b.prop("offsetWidth"),g=b.prop("offsetHeight");var l={center:function(){return e.left+e.width/2-f/2},left:function(){return e.left},right:function(){return e.left+e.width}},m={center:function(){return e.top+e.height/2-g/2},top:function(){return e.top},bottom:function(){return e.top+e.height}};switch(j){case"right":h={top:m[k](),left:l[j]()};break;case"left":h={top:m[k](),left:e.left-f};break;case"bottom":h={top:m[j](),left:l[k]()};break;default:h={top:e.top-g,left:l[k]()}}return h}}}]),angular.module("ui.bootstrap.datepicker",["ui.bootstrap.dateparser","ui.bootstrap.position"]).constant("datepickerConfig",{formatDay:"dd",formatMonth:"MMMM",formatYear:"yyyy",formatDayHeader:"EEE",formatDayTitle:"MMMM yyyy",formatMonthTitle:"yyyy",datepickerMode:"day",minMode:"day",maxMode:"year",showWeeks:!0,startingDay:0,yearRange:20,minDate:null,maxDate:null}).controller("DatepickerController",["$scope","$attrs","$parse","$interpolate","$timeout","$log","dateFilter","datepickerConfig",function(a,b,c,d,e,f,g,h){var i=this,j={$setViewValue:angular.noop};this.modes=["day","month","year"],angular.forEach(["formatDay","formatMonth","formatYear","formatDayHeader","formatDayTitle","formatMonthTitle","minMode","maxMode","showWeeks","startingDay","yearRange"],function(c,e){i[c]=angular.isDefined(b[c])?8>e?d(b[c])(a.$parent):a.$parent.$eval(b[c]):h[c]}),angular.forEach(["minDate","maxDate"],function(d){b[d]?a.$parent.$watch(c(b[d]),function(a){i[d]=a?new Date(a):null,i.refreshView()}):i[d]=h[d]?new Date(h[d]):null}),a.datepickerMode=a.datepickerMode||h.datepickerMode,a.uniqueId="datepicker-"+a.$id+"-"+Math.floor(1e4*Math.random()),this.activeDate=angular.isDefined(b.initDate)?a.$parent.$eval(b.initDate):new Date,a.isActive=function(b){return 0===i.compare(b.date,i.activeDate)?(a.activeDateId=b.uid,!0):!1},this.init=function(a){j=a,j.$render=function(){i.render()}},this.render=function(){if(j.$modelValue){var a=new Date(j.$modelValue),b=!isNaN(a);b?this.activeDate=a:f.error('Datepicker directive: "ng-model" value must be a Date object, a number of milliseconds since 01.01.1970 or a string representing an RFC2822 or ISO 8601 date.'),j.$setValidity("date",b)}this.refreshView()},this.refreshView=function(){if(this.element){this._refreshView();var a=j.$modelValue?new Date(j.$modelValue):null;j.$setValidity("date-disabled",!a||this.element&&!this.isDisabled(a))}},this.createDateObject=function(a,b){var c=j.$modelValue?new Date(j.$modelValue):null;return{date:a,label:g(a,b),selected:c&&0===this.compare(a,c),disabled:this.isDisabled(a),current:0===this.compare(a,new Date)}},this.isDisabled=function(c){return this.minDate&&this.compare(c,this.minDate)<0||this.maxDate&&this.compare(c,this.maxDate)>0||b.dateDisabled&&a.dateDisabled({date:c,mode:a.datepickerMode})},this.split=function(a,b){for(var c=[];a.length>0;)c.push(a.splice(0,b));return c},a.select=function(b){if(a.datepickerMode===i.minMode){var c=j.$modelValue?new Date(j.$modelValue):new Date(0,0,0,0,0,0,0);c.setFullYear(b.getFullYear(),b.getMonth(),b.getDate()),j.$setViewValue(c),j.$render()}else i.activeDate=b,a.datepickerMode=i.modes[i.modes.indexOf(a.datepickerMode)-1]},a.move=function(a){var b=i.activeDate.getFullYear()+a*(i.step.years||0),c=i.activeDate.getMonth()+a*(i.step.months||0);i.activeDate.setFullYear(b,c,1),i.refreshView()},a.toggleMode=function(b){b=b||1,a.datepickerMode===i.maxMode&&1===b||a.datepickerMode===i.minMode&&-1===b||(a.datepickerMode=i.modes[i.modes.indexOf(a.datepickerMode)+b])},a.keys={13:"enter",32:"space",33:"pageup",34:"pagedown",35:"end",36:"home",37:"left",38:"up",39:"right",40:"down"};var k=function(){e(function(){i.element[0].focus()},0,!1)};a.$on("datepicker.focus",k),a.keydown=function(b){var c=a.keys[b.which];if(c&&!b.shiftKey&&!b.altKey)if(b.preventDefault(),b.stopPropagation(),"enter"===c||"space"===c){if(i.isDisabled(i.activeDate))return;a.select(i.activeDate),k()}else!b.ctrlKey||"up"!==c&&"down"!==c?(i.handleKeyDown(c,b),i.refreshView()):(a.toggleMode("up"===c?1:-1),k())}}]).directive("datepicker",function(){return{restrict:"EA",replace:!0,templateUrl:"template/datepicker/datepicker.html",scope:{datepickerMode:"=?",dateDisabled:"&"},require:["datepicker","?^ngModel"],controller:"DatepickerController",link:function(a,b,c,d){var e=d[0],f=d[1];f&&e.init(f)}}}).directive("daypicker",["dateFilter",function(a){return{restrict:"EA",replace:!0,templateUrl:"template/datepicker/day.html",require:"^datepicker",link:function(b,c,d,e){function f(a,b){return 1!==b||a%4!==0||a%100===0&&a%400!==0?i[b]:29}function g(a,b){var c=new Array(b),d=new Date(a),e=0;for(d.setHours(12);b>e;)c[e++]=new Date(d),d.setDate(d.getDate()+1);return c}function h(a){var b=new Date(a);b.setDate(b.getDate()+4-(b.getDay()||7));var c=b.getTime();return b.setMonth(0),b.setDate(1),Math.floor(Math.round((c-b)/864e5)/7)+1}b.showWeeks=e.showWeeks,e.step={months:1},e.element=c;var i=[31,28,31,30,31,30,31,31,30,31,30,31];e._refreshView=function(){var c=e.activeDate.getFullYear(),d=e.activeDate.getMonth(),f=new Date(c,d,1),i=e.startingDay-f.getDay(),j=i>0?7-i:-i,k=new Date(f);j>0&&k.setDate(-j+1);for(var l=g(k,42),m=0;42>m;m++)l[m]=angular.extend(e.createDateObject(l[m],e.formatDay),{secondary:l[m].getMonth()!==d,uid:b.uniqueId+"-"+m});b.labels=new Array(7);for(var n=0;7>n;n++)b.labels[n]={abbr:a(l[n].date,e.formatDayHeader),full:a(l[n].date,"EEEE")};if(b.title=a(e.activeDate,e.formatDayTitle),b.rows=e.split(l,7),b.showWeeks){b.weekNumbers=[];for(var o=h(b.rows[0][0].date),p=b.rows.length;b.weekNumbers.push(o++)<p;);}},e.compare=function(a,b){return new Date(a.getFullYear(),a.getMonth(),a.getDate())-new Date(b.getFullYear(),b.getMonth(),b.getDate())},e.handleKeyDown=function(a){var b=e.activeDate.getDate();if("left"===a)b-=1;else if("up"===a)b-=7;else if("right"===a)b+=1;else if("down"===a)b+=7;else if("pageup"===a||"pagedown"===a){var c=e.activeDate.getMonth()+("pageup"===a?-1:1);e.activeDate.setMonth(c,1),b=Math.min(f(e.activeDate.getFullYear(),e.activeDate.getMonth()),b)}else"home"===a?b=1:"end"===a&&(b=f(e.activeDate.getFullYear(),e.activeDate.getMonth()));e.activeDate.setDate(b)},e.refreshView()}}}]).directive("monthpicker",["dateFilter",function(a){return{restrict:"EA",replace:!0,templateUrl:"template/datepicker/month.html",require:"^datepicker",link:function(b,c,d,e){e.step={years:1},e.element=c,e._refreshView=function(){for(var c=new Array(12),d=e.activeDate.getFullYear(),f=0;12>f;f++)c[f]=angular.extend(e.createDateObject(new Date(d,f,1),e.formatMonth),{uid:b.uniqueId+"-"+f});b.title=a(e.activeDate,e.formatMonthTitle),b.rows=e.split(c,3)},e.compare=function(a,b){return new Date(a.getFullYear(),a.getMonth())-new Date(b.getFullYear(),b.getMonth())},e.handleKeyDown=function(a){var b=e.activeDate.getMonth();if("left"===a)b-=1;else if("up"===a)b-=3;else if("right"===a)b+=1;else if("down"===a)b+=3;else if("pageup"===a||"pagedown"===a){var c=e.activeDate.getFullYear()+("pageup"===a?-1:1);e.activeDate.setFullYear(c)}else"home"===a?b=0:"end"===a&&(b=11);e.activeDate.setMonth(b)},e.refreshView()}}}]).directive("yearpicker",["dateFilter",function(){return{restrict:"EA",replace:!0,templateUrl:"template/datepicker/year.html",require:"^datepicker",link:function(a,b,c,d){function e(a){return parseInt((a-1)/f,10)*f+1}var f=d.yearRange;d.step={years:f},d.element=b,d._refreshView=function(){for(var b=new Array(f),c=0,g=e(d.activeDate.getFullYear());f>c;c++)b[c]=angular.extend(d.createDateObject(new Date(g+c,0,1),d.formatYear),{uid:a.uniqueId+"-"+c});a.title=[b[0].label,b[f-1].label].join(" - "),a.rows=d.split(b,5)},d.compare=function(a,b){return a.getFullYear()-b.getFullYear()},d.handleKeyDown=function(a){var b=d.activeDate.getFullYear();"left"===a?b-=1:"up"===a?b-=5:"right"===a?b+=1:"down"===a?b+=5:"pageup"===a||"pagedown"===a?b+=("pageup"===a?-1:1)*d.step.years:"home"===a?b=e(d.activeDate.getFullYear()):"end"===a&&(b=e(d.activeDate.getFullYear())+f-1),d.activeDate.setFullYear(b)},d.refreshView()}}}]).constant("datepickerPopupConfig",{datepickerPopup:"yyyy-MM-dd",currentText:"Today",clearText:"Clear",closeText:"Done",closeOnDateSelection:!0,appendToBody:!1,showButtonBar:!0}).directive("datepickerPopup",["$compile","$parse","$document","$position","dateFilter","dateParser","datepickerPopupConfig",function(a,b,c,d,e,f,g){return{restrict:"EA",require:"ngModel",scope:{isOpen:"=?",currentText:"@",clearText:"@",closeText:"@",dateDisabled:"&"},link:function(h,i,j,k){function l(a){return a.replace(/([A-Z])/g,function(a){return"-"+a.toLowerCase()})}function m(a){if(a){if(angular.isDate(a)&&!isNaN(a))return k.$setValidity("date",!0),a;if(angular.isString(a)){var b=f.parse(a,n)||new Date(a);return isNaN(b)?void k.$setValidity("date",!1):(k.$setValidity("date",!0),b)}return void k.$setValidity("date",!1)}return k.$setValidity("date",!0),null}var n,o=angular.isDefined(j.closeOnDateSelection)?h.$parent.$eval(j.closeOnDateSelection):g.closeOnDateSelection,p=angular.isDefined(j.datepickerAppendToBody)?h.$parent.$eval(j.datepickerAppendToBody):g.appendToBody;h.showButtonBar=angular.isDefined(j.showButtonBar)?h.$parent.$eval(j.showButtonBar):g.showButtonBar,h.getText=function(a){return h[a+"Text"]||g[a+"Text"]},j.$observe("datepickerPopup",function(a){n=a||g.datepickerPopup,k.$render()});var q=angular.element("<div datepicker-popup-wrap><div datepicker></div></div>");q.attr({"ng-model":"date","ng-change":"dateSelection()"});var r=angular.element(q.children()[0]);j.datepickerOptions&&angular.forEach(h.$parent.$eval(j.datepickerOptions),function(a,b){r.attr(l(b),a)}),h.watchData={},angular.forEach(["minDate","maxDate","datepickerMode"],function(a){if(j[a]){var c=b(j[a]);if(h.$parent.$watch(c,function(b){h.watchData[a]=b}),r.attr(l(a),"watchData."+a),"datepickerMode"===a){var d=c.assign;h.$watch("watchData."+a,function(a,b){a!==b&&d(h.$parent,a)})}}}),j.dateDisabled&&r.attr("date-disabled","dateDisabled({ date: date, mode: mode })"),k.$parsers.unshift(m),h.dateSelection=function(a){angular.isDefined(a)&&(h.date=a),k.$setViewValue(h.date),k.$render(),o&&(h.isOpen=!1,i[0].focus())},i.bind("input change keyup",function(){h.$apply(function(){h.date=k.$modelValue})}),k.$render=function(){var a=k.$viewValue?e(k.$viewValue,n):"";i.val(a),h.date=m(k.$modelValue)};var s=function(a){h.isOpen&&a.target!==i[0]&&h.$apply(function(){h.isOpen=!1})},t=function(a){h.keydown(a)};i.bind("keydown",t),h.keydown=function(a){27===a.which?(a.preventDefault(),a.stopPropagation(),h.close()):40!==a.which||h.isOpen||(h.isOpen=!0)},h.$watch("isOpen",function(a){a?(h.$broadcast("datepicker.focus"),h.position=p?d.offset(i):d.position(i),h.position.top=h.position.top+i.prop("offsetHeight"),c.bind("click",s)):c.unbind("click",s)}),h.select=function(a){if("today"===a){var b=new Date;angular.isDate(k.$modelValue)?(a=new Date(k.$modelValue),a.setFullYear(b.getFullYear(),b.getMonth(),b.getDate())):a=new Date(b.setHours(0,0,0,0))}h.dateSelection(a)},h.close=function(){h.isOpen=!1,i[0].focus()};var u=a(q)(h);q.remove(),p?c.find("body").append(u):i.after(u),h.$on("$destroy",function(){u.remove(),i.unbind("keydown",t),c.unbind("click",s)})}}}]).directive("datepickerPopupWrap",function(){return{restrict:"EA",replace:!0,transclude:!0,templateUrl:"template/datepicker/popup.html",link:function(a,b){b.bind("click",function(a){a.preventDefault(),a.stopPropagation()})}}}),angular.module("ui.bootstrap.dropdown",[]).constant("dropdownConfig",{openClass:"open"}).service("dropdownService",["$document",function(a){var b=null;this.open=function(e){b||(a.bind("click",c),a.bind("keydown",d)),b&&b!==e&&(b.isOpen=!1),b=e},this.close=function(e){b===e&&(b=null,a.unbind("click",c),a.unbind("keydown",d))};var c=function(a){var c=b.getToggleElement();a&&c&&c[0].contains(a.target)||b.$apply(function(){b.isOpen=!1})},d=function(a){27===a.which&&(b.focusToggleElement(),c())}}]).controller("DropdownController",["$scope","$attrs","$parse","dropdownConfig","dropdownService","$animate",function(a,b,c,d,e,f){var g,h=this,i=a.$new(),j=d.openClass,k=angular.noop,l=b.onToggle?c(b.onToggle):angular.noop;this.init=function(d){h.$element=d,b.isOpen&&(g=c(b.isOpen),k=g.assign,a.$watch(g,function(a){i.isOpen=!!a}))},this.toggle=function(a){return i.isOpen=arguments.length?!!a:!i.isOpen},this.isOpen=function(){return i.isOpen},i.getToggleElement=function(){return h.toggleElement},i.focusToggleElement=function(){h.toggleElement&&h.toggleElement[0].focus()},i.$watch("isOpen",function(b,c){f[b?"addClass":"removeClass"](h.$element,j),b?(i.focusToggleElement(),e.open(i)):e.close(i),k(a,b),angular.isDefined(b)&&b!==c&&l(a,{open:!!b})}),a.$on("$locationChangeSuccess",function(){i.isOpen=!1}),a.$on("$destroy",function(){i.$destroy()})}]).directive("dropdown",function(){return{restrict:"CA",controller:"DropdownController",link:function(a,b,c,d){d.init(b)}}}).directive("dropdownToggle",function(){return{restrict:"CA",require:"?^dropdown",link:function(a,b,c,d){if(d){d.toggleElement=b;var e=function(e){e.preventDefault(),b.hasClass("disabled")||c.disabled||a.$apply(function(){d.toggle()})};b.bind("click",e),b.attr({"aria-haspopup":!0,"aria-expanded":!1}),a.$watch(d.isOpen,function(a){b.attr("aria-expanded",!!a)}),a.$on("$destroy",function(){b.unbind("click",e)})}}}}),angular.module("ui.bootstrap.modal",["ui.bootstrap.transition"]).factory("$$stackedMap",function(){return{createNew:function(){var a=[];return{add:function(b,c){a.push({key:b,value:c})},get:function(b){for(var c=0;c<a.length;c++)if(b==a[c].key)return a[c]},keys:function(){for(var b=[],c=0;c<a.length;c++)b.push(a[c].key);return b},top:function(){return a[a.length-1]},remove:function(b){for(var c=-1,d=0;d<a.length;d++)if(b==a[d].key){c=d;break}return a.splice(c,1)[0]},removeTop:function(){return a.splice(a.length-1,1)[0]},length:function(){return a.length}}}}}).directive("modalBackdrop",["$timeout",function(a){return{restrict:"EA",replace:!0,templateUrl:"template/modal/backdrop.html",link:function(b,c,d){b.backdropClass=d.backdropClass||"",b.animate=!1,a(function(){b.animate=!0})}}}]).directive("modalWindow",["$modalStack","$timeout",function(a,b){return{restrict:"EA",scope:{index:"@",animate:"="},replace:!0,transclude:!0,templateUrl:function(a,b){return b.templateUrl||"template/modal/window.html"},link:function(c,d,e){d.addClass(e.windowClass||""),c.size=e.size,b(function(){c.animate=!0,d[0].querySelectorAll("[autofocus]").length||d[0].focus()}),c.close=function(b){var c=a.getTop();c&&c.value.backdrop&&"static"!=c.value.backdrop&&b.target===b.currentTarget&&(b.preventDefault(),b.stopPropagation(),a.dismiss(c.key,"backdrop click"))}}}}]).directive("modalTransclude",function(){return{link:function(a,b,c,d,e){e(a.$parent,function(a){b.empty(),b.append(a)})}}}).factory("$modalStack",["$transition","$timeout","$document","$compile","$rootScope","$$stackedMap",function(a,b,c,d,e,f){function g(){for(var a=-1,b=n.keys(),c=0;c<b.length;c++)n.get(b[c]).value.backdrop&&(a=c);return a}function h(a){var b=c.find("body").eq(0),d=n.get(a).value;n.remove(a),j(d.modalDomEl,d.modalScope,300,function(){d.modalScope.$destroy(),b.toggleClass(m,n.length()>0),i()})}function i(){if(k&&-1==g()){var a=l;j(k,l,150,function(){a.$destroy(),a=null}),k=void 0,l=void 0}}function j(c,d,e,f){function g(){g.done||(g.done=!0,c.remove(),f&&f())}d.animate=!1;var h=a.transitionEndEventName;if(h){var i=b(g,e);c.bind(h,function(){b.cancel(i),g(),d.$apply()})}else b(g)}var k,l,m="modal-open",n=f.createNew(),o={};return e.$watch(g,function(a){l&&(l.index=a)}),c.bind("keydown",function(a){var b;27===a.which&&(b=n.top(),b&&b.value.keyboard&&(a.preventDefault(),e.$apply(function(){o.dismiss(b.key,"escape key press")})))}),o.open=function(a,b){n.add(a,{deferred:b.deferred,modalScope:b.scope,backdrop:b.backdrop,keyboard:b.keyboard});var f=c.find("body").eq(0),h=g();if(h>=0&&!k){l=e.$new(!0),l.index=h;var i=angular.element("<div modal-backdrop></div>");i.attr("backdrop-class",b.backdropClass),k=d(i)(l),f.append(k)}var j=angular.element("<div modal-window></div>");j.attr({"template-url":b.windowTemplateUrl,"window-class":b.windowClass,size:b.size,index:n.length()-1,animate:"animate"}).html(b.content);var o=d(j)(b.scope);n.top().value.modalDomEl=o,f.append(o),f.addClass(m)},o.close=function(a,b){var c=n.get(a);c&&(c.value.deferred.resolve(b),h(a))},o.dismiss=function(a,b){var c=n.get(a);c&&(c.value.deferred.reject(b),h(a))},o.dismissAll=function(a){for(var b=this.getTop();b;)this.dismiss(b.key,a),b=this.getTop()},o.getTop=function(){return n.top()},o}]).provider("$modal",function(){var a={options:{backdrop:!0,keyboard:!0},$get:["$injector","$rootScope","$q","$http","$templateCache","$controller","$modalStack",function(b,c,d,e,f,g,h){function i(a){return a.template?d.when(a.template):e.get(angular.isFunction(a.templateUrl)?a.templateUrl():a.templateUrl,{cache:f}).then(function(a){return a.data})}function j(a){var c=[];return angular.forEach(a,function(a){(angular.isFunction(a)||angular.isArray(a))&&c.push(d.when(b.invoke(a)))}),c}var k={};return k.open=function(b){var e=d.defer(),f=d.defer(),k={result:e.promise,opened:f.promise,close:function(a){h.close(k,a)},dismiss:function(a){h.dismiss(k,a)}};if(b=angular.extend({},a.options,b),b.resolve=b.resolve||{},!b.template&&!b.templateUrl)throw new Error("One of template or templateUrl options is required.");var l=d.all([i(b)].concat(j(b.resolve)));return l.then(function(a){var d=(b.scope||c).$new();d.$close=k.close,d.$dismiss=k.dismiss;var f,i={},j=1;b.controller&&(i.$scope=d,i.$modalInstance=k,angular.forEach(b.resolve,function(b,c){i[c]=a[j++]}),f=g(b.controller,i),b.controllerAs&&(d[b.controllerAs]=f)),h.open(k,{scope:d,deferred:e,content:a[0],backdrop:b.backdrop,keyboard:b.keyboard,backdropClass:b.backdropClass,windowClass:b.windowClass,windowTemplateUrl:b.windowTemplateUrl,size:b.size})},function(a){e.reject(a)}),l.then(function(){f.resolve(!0)},function(){f.reject(!1)}),k},k}]};return a}),angular.module("ui.bootstrap.pagination",[]).controller("PaginationController",["$scope","$attrs","$parse",function(a,b,c){var d=this,e={$setViewValue:angular.noop},f=b.numPages?c(b.numPages).assign:angular.noop;this.init=function(f,g){e=f,this.config=g,e.$render=function(){d.render()},b.itemsPerPage?a.$parent.$watch(c(b.itemsPerPage),function(b){d.itemsPerPage=parseInt(b,10),a.totalPages=d.calculateTotalPages()}):this.itemsPerPage=g.itemsPerPage},this.calculateTotalPages=function(){var b=this.itemsPerPage<1?1:Math.ceil(a.totalItems/this.itemsPerPage);return Math.max(b||0,1)},this.render=function(){a.page=parseInt(e.$viewValue,10)||1},a.selectPage=function(b){a.page!==b&&b>0&&b<=a.totalPages&&(e.$setViewValue(b),e.$render())},a.getText=function(b){return a[b+"Text"]||d.config[b+"Text"]},a.noPrevious=function(){return 1===a.page},a.noNext=function(){return a.page===a.totalPages},a.$watch("totalItems",function(){a.totalPages=d.calculateTotalPages()}),a.$watch("totalPages",function(b){f(a.$parent,b),a.page>b?a.selectPage(b):e.$render()})}]).constant("paginationConfig",{itemsPerPage:10,boundaryLinks:!1,directionLinks:!0,firstText:"First",previousText:"Previous",nextText:"Next",lastText:"Last",rotate:!0}).directive("pagination",["$parse","paginationConfig",function(a,b){return{restrict:"EA",scope:{totalItems:"=",firstText:"@",previousText:"@",nextText:"@",lastText:"@"},require:["pagination","?ngModel"],controller:"PaginationController",templateUrl:"template/pagination/pagination.html",replace:!0,link:function(c,d,e,f){function g(a,b,c){return{number:a,text:b,active:c}}function h(a,b){var c=[],d=1,e=b,f=angular.isDefined(k)&&b>k;f&&(l?(d=Math.max(a-Math.floor(k/2),1),e=d+k-1,e>b&&(e=b,d=e-k+1)):(d=(Math.ceil(a/k)-1)*k+1,e=Math.min(d+k-1,b)));for(var h=d;e>=h;h++){var i=g(h,h,h===a);c.push(i)}if(f&&!l){if(d>1){var j=g(d-1,"...",!1);c.unshift(j)}if(b>e){var m=g(e+1,"...",!1);c.push(m)}}return c}var i=f[0],j=f[1];if(j){var k=angular.isDefined(e.maxSize)?c.$parent.$eval(e.maxSize):b.maxSize,l=angular.isDefined(e.rotate)?c.$parent.$eval(e.rotate):b.rotate;c.boundaryLinks=angular.isDefined(e.boundaryLinks)?c.$parent.$eval(e.boundaryLinks):b.boundaryLinks,c.directionLinks=angular.isDefined(e.directionLinks)?c.$parent.$eval(e.directionLinks):b.directionLinks,i.init(j,b),e.maxSize&&c.$parent.$watch(a(e.maxSize),function(a){k=parseInt(a,10),i.render()
	});var m=i.render;i.render=function(){m(),c.page>0&&c.page<=c.totalPages&&(c.pages=h(c.page,c.totalPages))}}}}}]).constant("pagerConfig",{itemsPerPage:10,previousText:"Â« Previous",nextText:"Next Â»",align:!0}).directive("pager",["pagerConfig",function(a){return{restrict:"EA",scope:{totalItems:"=",previousText:"@",nextText:"@"},require:["pager","?ngModel"],controller:"PaginationController",templateUrl:"template/pagination/pager.html",replace:!0,link:function(b,c,d,e){var f=e[0],g=e[1];g&&(b.align=angular.isDefined(d.align)?b.$parent.$eval(d.align):a.align,f.init(g,a))}}}]),angular.module("ui.bootstrap.tooltip",["ui.bootstrap.position","ui.bootstrap.bindHtml"]).provider("$tooltip",function(){function a(a){var b=/[A-Z]/g,c="-";return a.replace(b,function(a,b){return(b?c:"")+a.toLowerCase()})}var b={placement:"top",animation:!0,popupDelay:0},c={mouseenter:"mouseleave",click:"click",focus:"blur"},d={};this.options=function(a){angular.extend(d,a)},this.setTriggers=function(a){angular.extend(c,a)},this.$get=["$window","$compile","$timeout","$parse","$document","$position","$interpolate",function(e,f,g,h,i,j,k){return function(e,l,m){function n(a){var b=a||o.trigger||m,d=c[b]||b;return{show:b,hide:d}}var o=angular.extend({},b,d),p=a(e),q=k.startSymbol(),r=k.endSymbol(),s="<div "+p+'-popup title="'+q+"tt_title"+r+'" content="'+q+"tt_content"+r+'" placement="'+q+"tt_placement"+r+'" animation="tt_animation" is-open="tt_isOpen"></div>';return{restrict:"EA",scope:!0,compile:function(){var a=f(s);return function(b,c,d){function f(){b.tt_isOpen?m():k()}function k(){(!y||b.$eval(d[l+"Enable"]))&&(b.tt_popupDelay?v||(v=g(p,b.tt_popupDelay,!1),v.then(function(a){a()})):p()())}function m(){b.$apply(function(){q()})}function p(){return v=null,u&&(g.cancel(u),u=null),b.tt_content?(r(),t.css({top:0,left:0,display:"block"}),w?i.find("body").append(t):c.after(t),z(),b.tt_isOpen=!0,b.$digest(),z):angular.noop}function q(){b.tt_isOpen=!1,g.cancel(v),v=null,b.tt_animation?u||(u=g(s,500)):s()}function r(){t&&s(),t=a(b,function(){}),b.$digest()}function s(){u=null,t&&(t.remove(),t=null)}var t,u,v,w=angular.isDefined(o.appendToBody)?o.appendToBody:!1,x=n(void 0),y=angular.isDefined(d[l+"Enable"]),z=function(){var a=j.positionElements(c,t,b.tt_placement,w);a.top+="px",a.left+="px",t.css(a)};b.tt_isOpen=!1,d.$observe(e,function(a){b.tt_content=a,!a&&b.tt_isOpen&&q()}),d.$observe(l+"Title",function(a){b.tt_title=a}),d.$observe(l+"Placement",function(a){b.tt_placement=angular.isDefined(a)?a:o.placement}),d.$observe(l+"PopupDelay",function(a){var c=parseInt(a,10);b.tt_popupDelay=isNaN(c)?o.popupDelay:c});var A=function(){c.unbind(x.show,k),c.unbind(x.hide,m)};d.$observe(l+"Trigger",function(a){A(),x=n(a),x.show===x.hide?c.bind(x.show,f):(c.bind(x.show,k),c.bind(x.hide,m))});var B=b.$eval(d[l+"Animation"]);b.tt_animation=angular.isDefined(B)?!!B:o.animation,d.$observe(l+"AppendToBody",function(a){w=angular.isDefined(a)?h(a)(b):w}),w&&b.$on("$locationChangeSuccess",function(){b.tt_isOpen&&q()}),b.$on("$destroy",function(){g.cancel(u),g.cancel(v),A(),s()})}}}}}]}).directive("tooltipPopup",function(){return{restrict:"EA",replace:!0,scope:{content:"@",placement:"@",animation:"&",isOpen:"&"},templateUrl:"template/tooltip/tooltip-popup.html"}}).directive("tooltip",["$tooltip",function(a){return a("tooltip","tooltip","mouseenter")}]).directive("tooltipHtmlUnsafePopup",function(){return{restrict:"EA",replace:!0,scope:{content:"@",placement:"@",animation:"&",isOpen:"&"},templateUrl:"template/tooltip/tooltip-html-unsafe-popup.html"}}).directive("tooltipHtmlUnsafe",["$tooltip",function(a){return a("tooltipHtmlUnsafe","tooltip","mouseenter")}]),angular.module("ui.bootstrap.popover",["ui.bootstrap.tooltip"]).directive("popoverPopup",function(){return{restrict:"EA",replace:!0,scope:{title:"@",content:"@",placement:"@",animation:"&",isOpen:"&"},templateUrl:"template/popover/popover.html"}}).directive("popover",["$tooltip",function(a){return a("popover","popover","click")}]),angular.module("ui.bootstrap.progressbar",[]).constant("progressConfig",{animate:!0,max:100}).controller("ProgressController",["$scope","$attrs","progressConfig",function(a,b,c){var d=this,e=angular.isDefined(b.animate)?a.$parent.$eval(b.animate):c.animate;this.bars=[],a.max=angular.isDefined(b.max)?a.$parent.$eval(b.max):c.max,this.addBar=function(b,c){e||c.css({transition:"none"}),this.bars.push(b),b.$watch("value",function(c){b.percent=+(100*c/a.max).toFixed(2)}),b.$on("$destroy",function(){c=null,d.removeBar(b)})},this.removeBar=function(a){this.bars.splice(this.bars.indexOf(a),1)}}]).directive("progress",function(){return{restrict:"EA",replace:!0,transclude:!0,controller:"ProgressController",require:"progress",scope:{},templateUrl:"template/progressbar/progress.html"}}).directive("bar",function(){return{restrict:"EA",replace:!0,transclude:!0,require:"^progress",scope:{value:"=",type:"@"},templateUrl:"template/progressbar/bar.html",link:function(a,b,c,d){d.addBar(a,b)}}}).directive("progressbar",function(){return{restrict:"EA",replace:!0,transclude:!0,controller:"ProgressController",scope:{value:"=",type:"@"},templateUrl:"template/progressbar/progressbar.html",link:function(a,b,c,d){d.addBar(a,angular.element(b.children()[0]))}}}),angular.module("ui.bootstrap.rating",[]).constant("ratingConfig",{max:5,stateOn:null,stateOff:null}).controller("RatingController",["$scope","$attrs","ratingConfig",function(a,b,c){var d={$setViewValue:angular.noop};this.init=function(e){d=e,d.$render=this.render,this.stateOn=angular.isDefined(b.stateOn)?a.$parent.$eval(b.stateOn):c.stateOn,this.stateOff=angular.isDefined(b.stateOff)?a.$parent.$eval(b.stateOff):c.stateOff;var f=angular.isDefined(b.ratingStates)?a.$parent.$eval(b.ratingStates):new Array(angular.isDefined(b.max)?a.$parent.$eval(b.max):c.max);a.range=this.buildTemplateObjects(f)},this.buildTemplateObjects=function(a){for(var b=0,c=a.length;c>b;b++)a[b]=angular.extend({index:b},{stateOn:this.stateOn,stateOff:this.stateOff},a[b]);return a},a.rate=function(b){!a.readonly&&b>=0&&b<=a.range.length&&(d.$setViewValue(b),d.$render())},a.enter=function(b){a.readonly||(a.value=b),a.onHover({value:b})},a.reset=function(){a.value=d.$viewValue,a.onLeave()},a.onKeydown=function(b){/(37|38|39|40)/.test(b.which)&&(b.preventDefault(),b.stopPropagation(),a.rate(a.value+(38===b.which||39===b.which?1:-1)))},this.render=function(){a.value=d.$viewValue}}]).directive("rating",function(){return{restrict:"EA",require:["rating","ngModel"],scope:{readonly:"=?",onHover:"&",onLeave:"&"},controller:"RatingController",templateUrl:"template/rating/rating.html",replace:!0,link:function(a,b,c,d){var e=d[0],f=d[1];f&&e.init(f)}}}),angular.module("ui.bootstrap.tabs",[]).controller("TabsetController",["$scope",function(a){var b=this,c=b.tabs=a.tabs=[];b.select=function(a){angular.forEach(c,function(b){b.active&&b!==a&&(b.active=!1,b.onDeselect())}),a.active=!0,a.onSelect()},b.addTab=function(a){c.push(a),1===c.length?a.active=!0:a.active&&b.select(a)},b.removeTab=function(a){var d=c.indexOf(a);if(a.active&&c.length>1){var e=d==c.length-1?d-1:d+1;b.select(c[e])}c.splice(d,1)}}]).directive("tabset",function(){return{restrict:"EA",transclude:!0,replace:!0,scope:{type:"@"},controller:"TabsetController",templateUrl:"template/tabs/tabset.html",link:function(a,b,c){a.vertical=angular.isDefined(c.vertical)?a.$parent.$eval(c.vertical):!1,a.justified=angular.isDefined(c.justified)?a.$parent.$eval(c.justified):!1}}}).directive("tab",["$parse",function(a){return{require:"^tabset",restrict:"EA",replace:!0,templateUrl:"template/tabs/tab.html",transclude:!0,scope:{active:"=?",heading:"@",onSelect:"&select",onDeselect:"&deselect"},controller:function(){},compile:function(b,c,d){return function(b,c,e,f){b.$watch("active",function(a){a&&f.select(b)}),b.disabled=!1,e.disabled&&b.$parent.$watch(a(e.disabled),function(a){b.disabled=!!a}),b.select=function(){b.disabled||(b.active=!0)},f.addTab(b),b.$on("$destroy",function(){f.removeTab(b)}),b.$transcludeFn=d}}}}]).directive("tabHeadingTransclude",[function(){return{restrict:"A",require:"^tab",link:function(a,b){a.$watch("headingElement",function(a){a&&(b.html(""),b.append(a))})}}}]).directive("tabContentTransclude",function(){function a(a){return a.tagName&&(a.hasAttribute("tab-heading")||a.hasAttribute("data-tab-heading")||"tab-heading"===a.tagName.toLowerCase()||"data-tab-heading"===a.tagName.toLowerCase())}return{restrict:"A",require:"^tabset",link:function(b,c,d){var e=b.$eval(d.tabContentTransclude);e.$transcludeFn(e.$parent,function(b){angular.forEach(b,function(b){a(b)?e.headingElement=b:c.append(b)})})}}}),angular.module("ui.bootstrap.timepicker",[]).constant("timepickerConfig",{hourStep:1,minuteStep:1,showMeridian:!0,meridians:null,readonlyInput:!1,mousewheel:!0}).controller("TimepickerController",["$scope","$attrs","$parse","$log","$locale","timepickerConfig",function(a,b,c,d,e,f){function g(){var b=parseInt(a.hours,10),c=a.showMeridian?b>0&&13>b:b>=0&&24>b;return c?(a.showMeridian&&(12===b&&(b=0),a.meridian===p[1]&&(b+=12)),b):void 0}function h(){var b=parseInt(a.minutes,10);return b>=0&&60>b?b:void 0}function i(a){return angular.isDefined(a)&&a.toString().length<2?"0"+a:a}function j(a){k(),o.$setViewValue(new Date(n)),l(a)}function k(){o.$setValidity("time",!0),a.invalidHours=!1,a.invalidMinutes=!1}function l(b){var c=n.getHours(),d=n.getMinutes();a.showMeridian&&(c=0===c||12===c?12:c%12),a.hours="h"===b?c:i(c),a.minutes="m"===b?d:i(d),a.meridian=n.getHours()<12?p[0]:p[1]}function m(a){var b=new Date(n.getTime()+6e4*a);n.setHours(b.getHours(),b.getMinutes()),j()}var n=new Date,o={$setViewValue:angular.noop},p=angular.isDefined(b.meridians)?a.$parent.$eval(b.meridians):f.meridians||e.DATETIME_FORMATS.AMPMS;this.init=function(c,d){o=c,o.$render=this.render;var e=d.eq(0),g=d.eq(1),h=angular.isDefined(b.mousewheel)?a.$parent.$eval(b.mousewheel):f.mousewheel;h&&this.setupMousewheelEvents(e,g),a.readonlyInput=angular.isDefined(b.readonlyInput)?a.$parent.$eval(b.readonlyInput):f.readonlyInput,this.setupInputEvents(e,g)};var q=f.hourStep;b.hourStep&&a.$parent.$watch(c(b.hourStep),function(a){q=parseInt(a,10)});var r=f.minuteStep;b.minuteStep&&a.$parent.$watch(c(b.minuteStep),function(a){r=parseInt(a,10)}),a.showMeridian=f.showMeridian,b.showMeridian&&a.$parent.$watch(c(b.showMeridian),function(b){if(a.showMeridian=!!b,o.$error.time){var c=g(),d=h();angular.isDefined(c)&&angular.isDefined(d)&&(n.setHours(c),j())}else l()}),this.setupMousewheelEvents=function(b,c){var d=function(a){a.originalEvent&&(a=a.originalEvent);var b=a.wheelDelta?a.wheelDelta:-a.deltaY;return a.detail||b>0};b.bind("mousewheel wheel",function(b){a.$apply(d(b)?a.incrementHours():a.decrementHours()),b.preventDefault()}),c.bind("mousewheel wheel",function(b){a.$apply(d(b)?a.incrementMinutes():a.decrementMinutes()),b.preventDefault()})},this.setupInputEvents=function(b,c){if(a.readonlyInput)return a.updateHours=angular.noop,void(a.updateMinutes=angular.noop);var d=function(b,c){o.$setViewValue(null),o.$setValidity("time",!1),angular.isDefined(b)&&(a.invalidHours=b),angular.isDefined(c)&&(a.invalidMinutes=c)};a.updateHours=function(){var a=g();angular.isDefined(a)?(n.setHours(a),j("h")):d(!0)},b.bind("blur",function(){!a.invalidHours&&a.hours<10&&a.$apply(function(){a.hours=i(a.hours)})}),a.updateMinutes=function(){var a=h();angular.isDefined(a)?(n.setMinutes(a),j("m")):d(void 0,!0)},c.bind("blur",function(){!a.invalidMinutes&&a.minutes<10&&a.$apply(function(){a.minutes=i(a.minutes)})})},this.render=function(){var a=o.$modelValue?new Date(o.$modelValue):null;isNaN(a)?(o.$setValidity("time",!1),d.error('Timepicker directive: "ng-model" value must be a Date object, a number of milliseconds since 01.01.1970 or a string representing an RFC2822 or ISO 8601 date.')):(a&&(n=a),k(),l())},a.incrementHours=function(){m(60*q)},a.decrementHours=function(){m(60*-q)},a.incrementMinutes=function(){m(r)},a.decrementMinutes=function(){m(-r)},a.toggleMeridian=function(){m(720*(n.getHours()<12?1:-1))}}]).directive("timepicker",function(){return{restrict:"EA",require:["timepicker","?^ngModel"],controller:"TimepickerController",replace:!0,scope:{},templateUrl:"template/timepicker/timepicker.html",link:function(a,b,c,d){var e=d[0],f=d[1];f&&e.init(f,b.find("input"))}}}),angular.module("ui.bootstrap.typeahead",["ui.bootstrap.position","ui.bootstrap.bindHtml"]).factory("typeaheadParser",["$parse",function(a){var b=/^\s*([\s\S]+?)(?:\s+as\s+([\s\S]+?))?\s+for\s+(?:([\$\w][\$\w\d]*))\s+in\s+([\s\S]+?)$/;return{parse:function(c){var d=c.match(b);if(!d)throw new Error('Expected typeahead specification in form of "_modelValue_ (as _label_)? for _item_ in _collection_" but got "'+c+'".');return{itemName:d[3],source:a(d[4]),viewMapper:a(d[2]||d[1]),modelMapper:a(d[1])}}}}]).directive("typeahead",["$compile","$parse","$q","$timeout","$document","$position","typeaheadParser",function(a,b,c,d,e,f,g){var h=[9,13,27,38,40];return{require:"ngModel",link:function(i,j,k,l){var m,n=i.$eval(k.typeaheadMinLength)||1,o=i.$eval(k.typeaheadWaitMs)||0,p=i.$eval(k.typeaheadEditable)!==!1,q=b(k.typeaheadLoading).assign||angular.noop,r=b(k.typeaheadOnSelect),s=k.typeaheadInputFormatter?b(k.typeaheadInputFormatter):void 0,t=k.typeaheadAppendToBody?i.$eval(k.typeaheadAppendToBody):!1,u=b(k.ngModel).assign,v=g.parse(k.typeahead),w=i.$new();i.$on("$destroy",function(){w.$destroy()});var x="typeahead-"+w.$id+"-"+Math.floor(1e4*Math.random());j.attr({"aria-autocomplete":"list","aria-expanded":!1,"aria-owns":x});var y=angular.element("<div typeahead-popup></div>");y.attr({id:x,matches:"matches",active:"activeIdx",select:"select(activeIdx)",query:"query",position:"position"}),angular.isDefined(k.typeaheadTemplateUrl)&&y.attr("template-url",k.typeaheadTemplateUrl);var z=function(){w.matches=[],w.activeIdx=-1,j.attr("aria-expanded",!1)},A=function(a){return x+"-option-"+a};w.$watch("activeIdx",function(a){0>a?j.removeAttr("aria-activedescendant"):j.attr("aria-activedescendant",A(a))});var B=function(a){var b={$viewValue:a};q(i,!0),c.when(v.source(i,b)).then(function(c){var d=a===l.$viewValue;if(d&&m)if(c.length>0){w.activeIdx=0,w.matches.length=0;for(var e=0;e<c.length;e++)b[v.itemName]=c[e],w.matches.push({id:A(e),label:v.viewMapper(w,b),model:c[e]});w.query=a,w.position=t?f.offset(j):f.position(j),w.position.top=w.position.top+j.prop("offsetHeight"),j.attr("aria-expanded",!0)}else z();d&&q(i,!1)},function(){z(),q(i,!1)})};z(),w.query=void 0;var C,D=function(a){C=d(function(){B(a)},o)},E=function(){C&&d.cancel(C)};l.$parsers.unshift(function(a){return m=!0,a&&a.length>=n?o>0?(E(),D(a)):B(a):(q(i,!1),E(),z()),p?a:a?void l.$setValidity("editable",!1):(l.$setValidity("editable",!0),a)}),l.$formatters.push(function(a){var b,c,d={};return s?(d.$model=a,s(i,d)):(d[v.itemName]=a,b=v.viewMapper(i,d),d[v.itemName]=void 0,c=v.viewMapper(i,d),b!==c?b:a)}),w.select=function(a){var b,c,e={};e[v.itemName]=c=w.matches[a].model,b=v.modelMapper(i,e),u(i,b),l.$setValidity("editable",!0),r(i,{$item:c,$model:b,$label:v.viewMapper(i,e)}),z(),d(function(){j[0].focus()},0,!1)},j.bind("keydown",function(a){0!==w.matches.length&&-1!==h.indexOf(a.which)&&(a.preventDefault(),40===a.which?(w.activeIdx=(w.activeIdx+1)%w.matches.length,w.$digest()):38===a.which?(w.activeIdx=(w.activeIdx?w.activeIdx:w.matches.length)-1,w.$digest()):13===a.which||9===a.which?w.$apply(function(){w.select(w.activeIdx)}):27===a.which&&(a.stopPropagation(),z(),w.$digest()))}),j.bind("blur",function(){m=!1});var F=function(a){j[0]!==a.target&&(z(),w.$digest())};e.bind("click",F),i.$on("$destroy",function(){e.unbind("click",F)});var G=a(y)(w);t?e.find("body").append(G):j.after(G)}}}]).directive("typeaheadPopup",function(){return{restrict:"EA",scope:{matches:"=",query:"=",active:"=",position:"=",select:"&"},replace:!0,templateUrl:"template/typeahead/typeahead-popup.html",link:function(a,b,c){a.templateUrl=c.templateUrl,a.isOpen=function(){return a.matches.length>0},a.isActive=function(b){return a.active==b},a.selectActive=function(b){a.active=b},a.selectMatch=function(b){a.select({activeIdx:b})}}}}).directive("typeaheadMatch",["$http","$templateCache","$compile","$parse",function(a,b,c,d){return{restrict:"EA",scope:{index:"=",match:"=",query:"="},link:function(e,f,g){var h=d(g.templateUrl)(e.$parent)||"template/typeahead/typeahead-match.html";a.get(h,{cache:b}).success(function(a){f.replaceWith(c(a.trim())(e))})}}}]).filter("typeaheadHighlight",function(){function a(a){return a.replace(/([.?*+^$[\]\\(){}|-])/g,"\\$1")}return function(b,c){return c?(""+b).replace(new RegExp(a(c),"gi"),"<strong>$&</strong>"):b}}),angular.module("template/accordion/accordion-group.html",[]).run(["$templateCache",function(a){a.put("template/accordion/accordion-group.html",'<div class="panel panel-default">\n  <div class="panel-heading">\n    <h4 class="panel-title">\n      <a class="accordion-toggle" ng-click="toggleOpen()" accordion-transclude="heading"><span ng-class="{\'text-muted\': isDisabled}">{{heading}}</span></a>\n    </h4>\n  </div>\n  <div class="panel-collapse" collapse="!isOpen">\n	  <div class="panel-body" ng-transclude></div>\n  </div>\n</div>')}]),angular.module("template/accordion/accordion.html",[]).run(["$templateCache",function(a){a.put("template/accordion/accordion.html",'<div class="panel-group" ng-transclude></div>')}]),angular.module("template/alert/alert.html",[]).run(["$templateCache",function(a){a.put("template/alert/alert.html",'<div class="alert" ng-class="[\'alert-\' + (type || \'warning\'), closeable ? \'alert-dismissable\' : null]" role="alert">\n    <button ng-show="closeable" type="button" class="close" ng-click="close()">\n        <span aria-hidden="true">&times;</span>\n        <span class="sr-only">Close</span>\n    </button>\n    <div ng-transclude></div>\n</div>\n')}]),angular.module("template/carousel/carousel.html",[]).run(["$templateCache",function(a){a.put("template/carousel/carousel.html",'<div ng-mouseenter="pause()" ng-mouseleave="play()" class="carousel" ng-swipe-right="prev()" ng-swipe-left="next()">\n    <ol class="carousel-indicators" ng-show="slides.length > 1">\n        <li ng-repeat="slide in slides track by $index" ng-class="{active: isActive(slide)}" ng-click="select(slide)"></li>\n    </ol>\n    <div class="carousel-inner" ng-transclude></div>\n    <a class="left carousel-control" ng-click="prev()" ng-show="slides.length > 1"><span class="glyphicon glyphicon-chevron-left"></span></a>\n    <a class="right carousel-control" ng-click="next()" ng-show="slides.length > 1"><span class="glyphicon glyphicon-chevron-right"></span></a>\n</div>\n')}]),angular.module("template/carousel/slide.html",[]).run(["$templateCache",function(a){a.put("template/carousel/slide.html","<div ng-class=\"{\n    'active': leaving || (active && !entering),\n    'prev': (next || active) && direction=='prev',\n    'next': (next || active) && direction=='next',\n    'right': direction=='prev',\n    'left': direction=='next'\n  }\" class=\"item text-center\" ng-transclude></div>\n")}]),angular.module("template/datepicker/datepicker.html",[]).run(["$templateCache",function(a){a.put("template/datepicker/datepicker.html",'<div ng-switch="datepickerMode" role="application" ng-keydown="keydown($event)">\n  <daypicker ng-switch-when="day" tabindex="0"></daypicker>\n  <monthpicker ng-switch-when="month" tabindex="0"></monthpicker>\n  <yearpicker ng-switch-when="year" tabindex="0"></yearpicker>\n</div>')}]),angular.module("template/datepicker/day.html",[]).run(["$templateCache",function(a){a.put("template/datepicker/day.html",'<table role="grid" aria-labelledby="{{uniqueId}}-title" aria-activedescendant="{{activeDateId}}">\n  <thead>\n    <tr>\n      <th><button type="button" class="btn btn-default btn-sm pull-left" ng-click="move(-1)" tabindex="-1"><i class="glyphicon glyphicon-chevron-left"></i></button></th>\n      <th colspan="{{5 + showWeeks}}"><button id="{{uniqueId}}-title" role="heading" aria-live="assertive" aria-atomic="true" type="button" class="btn btn-default btn-sm" ng-click="toggleMode()" tabindex="-1" style="width:100%;"><strong>{{title}}</strong></button></th>\n      <th><button type="button" class="btn btn-default btn-sm pull-right" ng-click="move(1)" tabindex="-1"><i class="glyphicon glyphicon-chevron-right"></i></button></th>\n    </tr>\n    <tr>\n      <th ng-show="showWeeks" class="text-center"></th>\n      <th ng-repeat="label in labels track by $index" class="text-center"><small aria-label="{{label.full}}">{{label.abbr}}</small></th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr ng-repeat="row in rows track by $index">\n      <td ng-show="showWeeks" class="text-center h6"><em>{{ weekNumbers[$index] }}</em></td>\n      <td ng-repeat="dt in row track by dt.date" class="text-center" role="gridcell" id="{{dt.uid}}" aria-disabled="{{!!dt.disabled}}">\n        <button type="button" style="width:100%;" class="btn btn-default btn-sm" ng-class="{\'btn-info\': dt.selected, active: isActive(dt)}" ng-click="select(dt.date)" ng-disabled="dt.disabled" tabindex="-1"><span ng-class="{\'text-muted\': dt.secondary, \'text-info\': dt.current}">{{dt.label}}</span></button>\n      </td>\n    </tr>\n  </tbody>\n</table>\n')}]),angular.module("template/datepicker/month.html",[]).run(["$templateCache",function(a){a.put("template/datepicker/month.html",'<table role="grid" aria-labelledby="{{uniqueId}}-title" aria-activedescendant="{{activeDateId}}">\n  <thead>\n    <tr>\n      <th><button type="button" class="btn btn-default btn-sm pull-left" ng-click="move(-1)" tabindex="-1"><i class="glyphicon glyphicon-chevron-left"></i></button></th>\n      <th><button id="{{uniqueId}}-title" role="heading" aria-live="assertive" aria-atomic="true" type="button" class="btn btn-default btn-sm" ng-click="toggleMode()" tabindex="-1" style="width:100%;"><strong>{{title}}</strong></button></th>\n      <th><button type="button" class="btn btn-default btn-sm pull-right" ng-click="move(1)" tabindex="-1"><i class="glyphicon glyphicon-chevron-right"></i></button></th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr ng-repeat="row in rows track by $index">\n      <td ng-repeat="dt in row track by dt.date" class="text-center" role="gridcell" id="{{dt.uid}}" aria-disabled="{{!!dt.disabled}}">\n        <button type="button" style="width:100%;" class="btn btn-default" ng-class="{\'btn-info\': dt.selected, active: isActive(dt)}" ng-click="select(dt.date)" ng-disabled="dt.disabled" tabindex="-1"><span ng-class="{\'text-info\': dt.current}">{{dt.label}}</span></button>\n      </td>\n    </tr>\n  </tbody>\n</table>\n')}]),angular.module("template/datepicker/popup.html",[]).run(["$templateCache",function(a){a.put("template/datepicker/popup.html",'<ul class="dropdown-menu" ng-style="{display: (isOpen && \'block\') || \'none\', top: position.top+\'px\', left: position.left+\'px\'}" ng-keydown="keydown($event)">\n	<li ng-transclude></li>\n	<li ng-if="showButtonBar" style="padding:10px 9px 2px">\n		<span class="btn-group">\n			<button type="button" class="btn btn-sm btn-info" ng-click="select(\'today\')">{{ getText(\'current\') }}</button>\n			<button type="button" class="btn btn-sm btn-danger" ng-click="select(null)">{{ getText(\'clear\') }}</button>\n		</span>\n		<button type="button" class="btn btn-sm btn-success pull-right" ng-click="close()">{{ getText(\'close\') }}</button>\n	</li>\n</ul>\n')}]),angular.module("template/datepicker/year.html",[]).run(["$templateCache",function(a){a.put("template/datepicker/year.html",'<table role="grid" aria-labelledby="{{uniqueId}}-title" aria-activedescendant="{{activeDateId}}">\n  <thead>\n    <tr>\n      <th><button type="button" class="btn btn-default btn-sm pull-left" ng-click="move(-1)" tabindex="-1"><i class="glyphicon glyphicon-chevron-left"></i></button></th>\n      <th colspan="3"><button id="{{uniqueId}}-title" role="heading" aria-live="assertive" aria-atomic="true" type="button" class="btn btn-default btn-sm" ng-click="toggleMode()" tabindex="-1" style="width:100%;"><strong>{{title}}</strong></button></th>\n      <th><button type="button" class="btn btn-default btn-sm pull-right" ng-click="move(1)" tabindex="-1"><i class="glyphicon glyphicon-chevron-right"></i></button></th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr ng-repeat="row in rows track by $index">\n      <td ng-repeat="dt in row track by dt.date" class="text-center" role="gridcell" id="{{dt.uid}}" aria-disabled="{{!!dt.disabled}}">\n        <button type="button" style="width:100%;" class="btn btn-default" ng-class="{\'btn-info\': dt.selected, active: isActive(dt)}" ng-click="select(dt.date)" ng-disabled="dt.disabled" tabindex="-1"><span ng-class="{\'text-info\': dt.current}">{{dt.label}}</span></button>\n      </td>\n    </tr>\n  </tbody>\n</table>\n')}]),angular.module("template/modal/backdrop.html",[]).run(["$templateCache",function(a){a.put("template/modal/backdrop.html",'<div class="modal-backdrop fade {{ backdropClass }}"\n     ng-class="{in: animate}"\n     ng-style="{\'z-index\': 1040 + (index && 1 || 0) + index*10}"\n></div>\n')}]),angular.module("template/modal/window.html",[]).run(["$templateCache",function(a){a.put("template/modal/window.html",'<div tabindex="-1" role="dialog" class="modal fade" ng-class="{in: animate}" ng-style="{\'z-index\': 1050 + index*10, display: \'block\'}" ng-click="close($event)">\n    <div class="modal-dialog" ng-class="{\'modal-sm\': size == \'sm\', \'modal-lg\': size == \'lg\'}"><div class="modal-content" modal-transclude></div></div>\n</div>')}]),angular.module("template/pagination/pager.html",[]).run(["$templateCache",function(a){a.put("template/pagination/pager.html",'<ul class="pager">\n  <li ng-class="{disabled: noPrevious(), previous: align}"><a href ng-click="selectPage(page - 1)">{{getText(\'previous\')}}</a></li>\n  <li ng-class="{disabled: noNext(), next: align}"><a href ng-click="selectPage(page + 1)">{{getText(\'next\')}}</a></li>\n</ul>')}]),angular.module("template/pagination/pagination.html",[]).run(["$templateCache",function(a){a.put("template/pagination/pagination.html",'<ul class="pagination">\n  <li ng-if="boundaryLinks" ng-class="{disabled: noPrevious()}"><a href ng-click="selectPage(1)">{{getText(\'first\')}}</a></li>\n  <li ng-if="directionLinks" ng-class="{disabled: noPrevious()}"><a href ng-click="selectPage(page - 1)">{{getText(\'previous\')}}</a></li>\n  <li ng-repeat="page in pages track by $index" ng-class="{active: page.active}"><a href ng-click="selectPage(page.number)">{{page.text}}</a></li>\n  <li ng-if="directionLinks" ng-class="{disabled: noNext()}"><a href ng-click="selectPage(page + 1)">{{getText(\'next\')}}</a></li>\n  <li ng-if="boundaryLinks" ng-class="{disabled: noNext()}"><a href ng-click="selectPage(totalPages)">{{getText(\'last\')}}</a></li>\n</ul>')}]),angular.module("template/tooltip/tooltip-html-unsafe-popup.html",[]).run(["$templateCache",function(a){a.put("template/tooltip/tooltip-html-unsafe-popup.html",'<div class="tooltip {{placement}}" ng-class="{ in: isOpen(), fade: animation() }">\n  <div class="tooltip-arrow"></div>\n  <div class="tooltip-inner" bind-html-unsafe="content"></div>\n</div>\n')}]),angular.module("template/tooltip/tooltip-popup.html",[]).run(["$templateCache",function(a){a.put("template/tooltip/tooltip-popup.html",'<div class="tooltip {{placement}}" ng-class="{ in: isOpen(), fade: animation() }">\n  <div class="tooltip-arrow"></div>\n  <div class="tooltip-inner" ng-bind="content"></div>\n</div>\n')}]),angular.module("template/popover/popover.html",[]).run(["$templateCache",function(a){a.put("template/popover/popover.html",'<div class="popover {{placement}}" ng-class="{ in: isOpen(), fade: animation() }">\n  <div class="arrow"></div>\n\n  <div class="popover-inner">\n      <h3 class="popover-title" ng-bind="title" ng-show="title"></h3>\n      <div class="popover-content" ng-bind="content"></div>\n  </div>\n</div>\n')}]),angular.module("template/progressbar/bar.html",[]).run(["$templateCache",function(a){a.put("template/progressbar/bar.html",'<div class="progress-bar" ng-class="type && \'progress-bar-\' + type" role="progressbar" aria-valuenow="{{value}}" aria-valuemin="0" aria-valuemax="{{max}}" ng-style="{width: percent + \'%\'}" aria-valuetext="{{percent | number:0}}%" ng-transclude></div>')}]),angular.module("template/progressbar/progress.html",[]).run(["$templateCache",function(a){a.put("template/progressbar/progress.html",'<div class="progress" ng-transclude></div>')}]),angular.module("template/progressbar/progressbar.html",[]).run(["$templateCache",function(a){a.put("template/progressbar/progressbar.html",'<div class="progress">\n  <div class="progress-bar" ng-class="type && \'progress-bar-\' + type" role="progressbar" aria-valuenow="{{value}}" aria-valuemin="0" aria-valuemax="{{max}}" ng-style="{width: percent + \'%\'}" aria-valuetext="{{percent | number:0}}%" ng-transclude></div>\n</div>')}]),angular.module("template/rating/rating.html",[]).run(["$templateCache",function(a){a.put("template/rating/rating.html",'<span ng-mouseleave="reset()" ng-keydown="onKeydown($event)" tabindex="0" role="slider" aria-valuemin="0" aria-valuemax="{{range.length}}" aria-valuenow="{{value}}">\n    <i ng-repeat="r in range track by $index" ng-mouseenter="enter($index + 1)" ng-click="rate($index + 1)" class="glyphicon" ng-class="$index < value && (r.stateOn || \'glyphicon-star\') || (r.stateOff || \'glyphicon-star-empty\')">\n        <span class="sr-only">({{ $index < value ? \'*\' : \' \' }})</span>\n    </i>\n</span>')}]),angular.module("template/tabs/tab.html",[]).run(["$templateCache",function(a){a.put("template/tabs/tab.html",'<li ng-class="{active: active, disabled: disabled}">\n  <a ng-click="select()" tab-heading-transclude>{{heading}}</a>\n</li>\n')}]),angular.module("template/tabs/tabset.html",[]).run(["$templateCache",function(a){a.put("template/tabs/tabset.html",'<div>\n  <ul class="nav nav-{{type || \'tabs\'}}" ng-class="{\'nav-stacked\': vertical, \'nav-justified\': justified}" ng-transclude></ul>\n  <div class="tab-content">\n    <div class="tab-pane" \n         ng-repeat="tab in tabs" \n         ng-class="{active: tab.active}"\n         tab-content-transclude="tab">\n    </div>\n  </div>\n</div>\n')}]),angular.module("template/timepicker/timepicker.html",[]).run(["$templateCache",function(a){a.put("template/timepicker/timepicker.html",'<table>\n	<tbody>\n		<tr class="text-center">\n			<td><a ng-click="incrementHours()" class="btn btn-link"><span class="glyphicon glyphicon-chevron-up"></span></a></td>\n			<td>&nbsp;</td>\n			<td><a ng-click="incrementMinutes()" class="btn btn-link"><span class="glyphicon glyphicon-chevron-up"></span></a></td>\n			<td ng-show="showMeridian"></td>\n		</tr>\n		<tr>\n			<td style="width:50px;" class="form-group" ng-class="{\'has-error\': invalidHours}">\n				<input type="text" ng-model="hours" ng-change="updateHours()" class="form-control text-center" ng-mousewheel="incrementHours()" ng-readonly="readonlyInput" maxlength="2">\n			</td>\n			<td>:</td>\n			<td style="width:50px;" class="form-group" ng-class="{\'has-error\': invalidMinutes}">\n				<input type="text" ng-model="minutes" ng-change="updateMinutes()" class="form-control text-center" ng-readonly="readonlyInput" maxlength="2">\n			</td>\n			<td ng-show="showMeridian"><button type="button" class="btn btn-default text-center" ng-click="toggleMeridian()">{{meridian}}</button></td>\n		</tr>\n		<tr class="text-center">\n			<td><a ng-click="decrementHours()" class="btn btn-link"><span class="glyphicon glyphicon-chevron-down"></span></a></td>\n			<td>&nbsp;</td>\n			<td><a ng-click="decrementMinutes()" class="btn btn-link"><span class="glyphicon glyphicon-chevron-down"></span></a></td>\n			<td ng-show="showMeridian"></td>\n		</tr>\n	</tbody>\n</table>\n')}]),angular.module("template/typeahead/typeahead-match.html",[]).run(["$templateCache",function(a){a.put("template/typeahead/typeahead-match.html",'<a tabindex="-1" bind-html-unsafe="match.label | typeaheadHighlight:query"></a>')
	}]),angular.module("template/typeahead/typeahead-popup.html",[]).run(["$templateCache",function(a){a.put("template/typeahead/typeahead-popup.html",'<ul class="dropdown-menu" ng-show="isOpen()" ng-style="{top: position.top+\'px\', left: position.left+\'px\'}" style="display: block;" role="listbox" aria-hidden="{{!isOpen()}}">\n    <li ng-repeat="match in matches track by $index" ng-class="{active: isActive($index) }" ng-mouseenter="selectActive($index)" ng-click="selectMatch($index)" role="option" id="{{match.id}}">\n        <div typeahead-match index="$index" match="match" query="query" template-url="templateUrl"></div>\n    </li>\n</ul>\n')}]);

/***/ },
/* 6 */
/***/ function(module, exports) {

	/*
	 AngularJS v1.4.9
	 (c) 2010-2015 Google, Inc. http://angularjs.org
	 License: MIT
	*/
	(function(p,c,C){'use strict';function v(r,h,g){return{restrict:"ECA",terminal:!0,priority:400,transclude:"element",link:function(a,f,b,d,y){function z(){k&&(g.cancel(k),k=null);l&&(l.$destroy(),l=null);m&&(k=g.leave(m),k.then(function(){k=null}),m=null)}function x(){var b=r.current&&r.current.locals;if(c.isDefined(b&&b.$template)){var b=a.$new(),d=r.current;m=y(b,function(b){g.enter(b,null,m||f).then(function(){!c.isDefined(t)||t&&!a.$eval(t)||h()});z()});l=d.scope=b;l.$emit("$viewContentLoaded");
	l.$eval(w)}else z()}var l,m,k,t=b.autoscroll,w=b.onload||"";a.$on("$routeChangeSuccess",x);x()}}}function A(c,h,g){return{restrict:"ECA",priority:-400,link:function(a,f){var b=g.current,d=b.locals;f.html(d.$template);var y=c(f.contents());b.controller&&(d.$scope=a,d=h(b.controller,d),b.controllerAs&&(a[b.controllerAs]=d),f.data("$ngControllerController",d),f.children().data("$ngControllerController",d));y(a)}}}p=c.module("ngRoute",["ng"]).provider("$route",function(){function r(a,f){return c.extend(Object.create(a),
	f)}function h(a,c){var b=c.caseInsensitiveMatch,d={originalPath:a,regexp:a},g=d.keys=[];a=a.replace(/([().])/g,"\\$1").replace(/(\/)?:(\w+)([\?\*])?/g,function(a,c,b,d){a="?"===d?d:null;d="*"===d?d:null;g.push({name:b,optional:!!a});c=c||"";return""+(a?"":c)+"(?:"+(a?c:"")+(d&&"(.+?)"||"([^/]+)")+(a||"")+")"+(a||"")}).replace(/([\/$\*])/g,"\\$1");d.regexp=new RegExp("^"+a+"$",b?"i":"");return d}var g={};this.when=function(a,f){var b=c.copy(f);c.isUndefined(b.reloadOnSearch)&&(b.reloadOnSearch=!0);
	c.isUndefined(b.caseInsensitiveMatch)&&(b.caseInsensitiveMatch=this.caseInsensitiveMatch);g[a]=c.extend(b,a&&h(a,b));if(a){var d="/"==a[a.length-1]?a.substr(0,a.length-1):a+"/";g[d]=c.extend({redirectTo:a},h(d,b))}return this};this.caseInsensitiveMatch=!1;this.otherwise=function(a){"string"===typeof a&&(a={redirectTo:a});this.when(null,a);return this};this.$get=["$rootScope","$location","$routeParams","$q","$injector","$templateRequest","$sce",function(a,f,b,d,h,p,x){function l(b){var e=s.current;
	(v=(n=k())&&e&&n.$$route===e.$$route&&c.equals(n.pathParams,e.pathParams)&&!n.reloadOnSearch&&!w)||!e&&!n||a.$broadcast("$routeChangeStart",n,e).defaultPrevented&&b&&b.preventDefault()}function m(){var u=s.current,e=n;if(v)u.params=e.params,c.copy(u.params,b),a.$broadcast("$routeUpdate",u);else if(e||u)w=!1,(s.current=e)&&e.redirectTo&&(c.isString(e.redirectTo)?f.path(t(e.redirectTo,e.params)).search(e.params).replace():f.url(e.redirectTo(e.pathParams,f.path(),f.search())).replace()),d.when(e).then(function(){if(e){var a=
	c.extend({},e.resolve),b,f;c.forEach(a,function(b,e){a[e]=c.isString(b)?h.get(b):h.invoke(b,null,null,e)});c.isDefined(b=e.template)?c.isFunction(b)&&(b=b(e.params)):c.isDefined(f=e.templateUrl)&&(c.isFunction(f)&&(f=f(e.params)),c.isDefined(f)&&(e.loadedTemplateUrl=x.valueOf(f),b=p(f)));c.isDefined(b)&&(a.$template=b);return d.all(a)}}).then(function(f){e==s.current&&(e&&(e.locals=f,c.copy(e.params,b)),a.$broadcast("$routeChangeSuccess",e,u))},function(b){e==s.current&&a.$broadcast("$routeChangeError",
	e,u,b)})}function k(){var a,b;c.forEach(g,function(d,g){var q;if(q=!b){var h=f.path();q=d.keys;var l={};if(d.regexp)if(h=d.regexp.exec(h)){for(var k=1,m=h.length;k<m;++k){var n=q[k-1],p=h[k];n&&p&&(l[n.name]=p)}q=l}else q=null;else q=null;q=a=q}q&&(b=r(d,{params:c.extend({},f.search(),a),pathParams:a}),b.$$route=d)});return b||g[null]&&r(g[null],{params:{},pathParams:{}})}function t(a,b){var d=[];c.forEach((a||"").split(":"),function(a,c){if(0===c)d.push(a);else{var f=a.match(/(\w+)(?:[?*])?(.*)/),
	g=f[1];d.push(b[g]);d.push(f[2]||"");delete b[g]}});return d.join("")}var w=!1,n,v,s={routes:g,reload:function(){w=!0;a.$evalAsync(function(){l();m()})},updateParams:function(a){if(this.current&&this.current.$$route)a=c.extend({},this.current.params,a),f.path(t(this.current.$$route.originalPath,a)),f.search(a);else throw B("norout");}};a.$on("$locationChangeStart",l);a.$on("$locationChangeSuccess",m);return s}]});var B=c.$$minErr("ngRoute");p.provider("$routeParams",function(){this.$get=function(){return{}}});
	p.directive("ngView",v);p.directive("ngView",A);v.$inject=["$route","$anchorScroll","$animate"];A.$inject=["$compile","$controller","$route"]})(window,window.angular);
	//# sourceMappingURL=angular-route.min.js.map


/***/ },
/* 7 */
/***/ function(module, exports) {

	/*
	 AngularJS v1.4.9
	 (c) 2010-2015 Google, Inc. http://angularjs.org
	 License: MIT
	*/
	(function(E,l,Va){'use strict';function xa(a,b,c){if(!a)throw Ka("areq",b||"?",c||"required");return a}function ya(a,b){if(!a&&!b)return"";if(!a)return b;if(!b)return a;aa(a)&&(a=a.join(" "));aa(b)&&(b=b.join(" "));return a+" "+b}function La(a){var b={};a&&(a.to||a.from)&&(b.to=a.to,b.from=a.from);return b}function W(a,b,c){var d="";a=aa(a)?a:a&&R(a)&&a.length?a.split(/\s+/):[];u(a,function(a,m){a&&0<a.length&&(d+=0<m?" ":"",d+=c?b+a:a+b)});return d}function Ma(a){if(a instanceof I)switch(a.length){case 0:return[];
	case 1:if(1===a[0].nodeType)return a;break;default:return I(oa(a))}if(1===a.nodeType)return I(a)}function oa(a){if(!a[0])return a;for(var b=0;b<a.length;b++){var c=a[b];if(1==c.nodeType)return c}}function Na(a,b,c){u(b,function(b){a.addClass(b,c)})}function Oa(a,b,c){u(b,function(b){a.removeClass(b,c)})}function T(a){return function(b,c){c.addClass&&(Na(a,b,c.addClass),c.addClass=null);c.removeClass&&(Oa(a,b,c.removeClass),c.removeClass=null)}}function la(a){a=a||{};if(!a.$$prepared){var b=a.domOperation||
	P;a.domOperation=function(){a.$$domOperationFired=!0;b();b=P};a.$$prepared=!0}return a}function ea(a,b){za(a,b);Aa(a,b)}function za(a,b){b.from&&(a.css(b.from),b.from=null)}function Aa(a,b){b.to&&(a.css(b.to),b.to=null)}function U(a,b,c){var d=(b.addClass||"")+" "+(c.addClass||""),f=(b.removeClass||"")+" "+(c.removeClass||"");a=Pa(a.attr("class"),d,f);c.preparationClasses&&(b.preparationClasses=ba(c.preparationClasses,b.preparationClasses),delete c.preparationClasses);d=b.domOperation!==P?b.domOperation:
	null;Ba(b,c);d&&(b.domOperation=d);b.addClass=a.addClass?a.addClass:null;b.removeClass=a.removeClass?a.removeClass:null;return b}function Pa(a,b,c){function d(a){R(a)&&(a=a.split(" "));var b={};u(a,function(a){a.length&&(b[a]=!0)});return b}var f={};a=d(a);b=d(b);u(b,function(a,b){f[b]=1});c=d(c);u(c,function(a,b){f[b]=1===f[b]?null:-1});var m={addClass:"",removeClass:""};u(f,function(b,c){var d,f;1===b?(d="addClass",f=!a[c]):-1===b&&(d="removeClass",f=a[c]);f&&(m[d].length&&(m[d]+=" "),m[d]+=c)});
	return m}function F(a){return a instanceof l.element?a[0]:a}function Qa(a,b,c){var d="";b&&(d=W(b,"ng-",!0));c.addClass&&(d=ba(d,W(c.addClass,"-add")));c.removeClass&&(d=ba(d,W(c.removeClass,"-remove")));d.length&&(c.preparationClasses=d,a.addClass(d))}function ma(a,b){var c=b?"-"+b+"s":"";ia(a,[ja,c]);return[ja,c]}function pa(a,b){var c=b?"paused":"",d=X+"PlayState";ia(a,[d,c]);return[d,c]}function ia(a,b){a.style[b[0]]=b[1]}function ba(a,b){return a?b?a+" "+b:a:b}function Ca(a,b,c){var d=Object.create(null),
	f=a.getComputedStyle(b)||{};u(c,function(a,b){var c=f[a];if(c){var D=c.charAt(0);if("-"===D||"+"===D||0<=D)c=Ra(c);0===c&&(c=null);d[b]=c}});return d}function Ra(a){var b=0;a=a.split(/\s*,\s*/);u(a,function(a){"s"==a.charAt(a.length-1)&&(a=a.substring(0,a.length-1));a=parseFloat(a)||0;b=b?Math.max(a,b):a});return b}function qa(a){return 0===a||null!=a}function Da(a,b){var c=S,d=a+"s";b?c+="Duration":d+=" linear all";return[c,d]}function Ea(){var a=Object.create(null);return{flush:function(){a=Object.create(null)},
	count:function(b){return(b=a[b])?b.total:0},get:function(b){return(b=a[b])&&b.value},put:function(b,c){a[b]?a[b].total++:a[b]={total:1,value:c}}}}function Fa(a,b,c){u(c,function(c){a[c]=Y(a[c])?a[c]:b.style.getPropertyValue(c)})}var P=l.noop,Ga=l.copy,Ba=l.extend,I=l.element,u=l.forEach,aa=l.isArray,R=l.isString,ra=l.isObject,O=l.isUndefined,Y=l.isDefined,Ha=l.isFunction,sa=l.isElement,S,ta,X,ua;O(E.ontransitionend)&&Y(E.onwebkittransitionend)?(S="WebkitTransition",ta="webkitTransitionEnd transitionend"):
	(S="transition",ta="transitionend");O(E.onanimationend)&&Y(E.onwebkitanimationend)?(X="WebkitAnimation",ua="webkitAnimationEnd animationend"):(X="animation",ua="animationend");var na=X+"Delay",va=X+"Duration",ja=S+"Delay";E=S+"Duration";var Ka=l.$$minErr("ng"),Sa={transitionDuration:E,transitionDelay:ja,transitionProperty:S+"Property",animationDuration:va,animationDelay:na,animationIterationCount:X+"IterationCount"},Ta={transitionDuration:E,transitionDelay:ja,animationDuration:va,animationDelay:na};
	l.module("ngAnimate",[]).directive("ngAnimateChildren",[function(){return function(a,b,c){a=c.ngAnimateChildren;l.isString(a)&&0===a.length?b.data("$$ngAnimateChildren",!0):c.$observe("ngAnimateChildren",function(a){b.data("$$ngAnimateChildren","on"===a||"true"===a)})}}]).factory("$$rAFScheduler",["$$rAF",function(a){function b(a){d=d.concat(a);c()}function c(){if(d.length){for(var b=d.shift(),J=0;J<b.length;J++)b[J]();f||a(function(){f||c()})}}var d,f;d=b.queue=[];b.waitUntilQuiet=function(b){f&&
	f();f=a(function(){f=null;b();c()})};return b}]).provider("$$animateQueue",["$animateProvider",function(a){function b(a){if(!a)return null;a=a.split(" ");var b=Object.create(null);u(a,function(a){b[a]=!0});return b}function c(a,c){if(a&&c){var d=b(c);return a.split(" ").some(function(a){return d[a]})}}function d(a,b,c,d){return m[a].some(function(a){return a(b,c,d)})}function f(a,b){a=a||{};var c=0<(a.addClass||"").length,d=0<(a.removeClass||"").length;return b?c&&d:c||d}var m=this.rules={skip:[],
	cancel:[],join:[]};m.join.push(function(a,b,c){return!b.structural&&f(b.options)});m.skip.push(function(a,b,c){return!b.structural&&!f(b.options)});m.skip.push(function(a,b,c){return"leave"==c.event&&b.structural});m.skip.push(function(a,b,c){return c.structural&&2===c.state&&!b.structural});m.cancel.push(function(a,b,c){return c.structural&&b.structural});m.cancel.push(function(a,b,c){return 2===c.state&&b.structural});m.cancel.push(function(a,b,d){a=b.options.addClass;b=b.options.removeClass;var f=
	d.options.addClass;d=d.options.removeClass;return O(a)&&O(b)||O(f)&&O(d)?!1:c(a,d)||c(b,f)});this.$get=["$$rAF","$rootScope","$rootElement","$document","$$HashMap","$$animation","$$AnimateRunner","$templateRequest","$$jqLite","$$forceReflow",function(b,c,D,m,h,l,x,z,v,k){function N(){var a=!1;return function(b){a?b():c.$$postDigest(function(){a=!0;b()})}}function y(a,b,c){var e=F(b),d=F(a),g=[];(a=G[c])&&u(a,function(a){s.call(a.node,e)?g.push(a.callback):"leave"===c&&s.call(a.node,d)&&g.push(a.callback)});
	return g}function w(a,e,g){function w(c,e,g,d){D(function(){var c=y(q,a,e);c.length&&b(function(){u(c,function(b){b(a,g,d)})})});c.progress(e,g,d)}function k(b){var c=a,e=n;e.preparationClasses&&(c.removeClass(e.preparationClasses),e.preparationClasses=null);e.activeClasses&&(c.removeClass(e.activeClasses),e.activeClasses=null);Ja(a,n);ea(a,n);n.domOperation();s.complete(!b)}var n=Ga(g),G,q;if(a=Ma(a))G=F(a),q=a.parent();var n=la(n),s=new x,D=N();aa(n.addClass)&&(n.addClass=n.addClass.join(" "));
	n.addClass&&!R(n.addClass)&&(n.addClass=null);aa(n.removeClass)&&(n.removeClass=n.removeClass.join(" "));n.removeClass&&!R(n.removeClass)&&(n.removeClass=null);n.from&&!ra(n.from)&&(n.from=null);n.to&&!ra(n.to)&&(n.to=null);if(!G)return k(),s;g=[G.className,n.addClass,n.removeClass].join(" ");if(!Ua(g))return k(),s;var v=0<=["enter","move","leave"].indexOf(e),h=!H||m[0].hidden||B.get(G);g=!h&&t.get(G)||{};var z=!!g.state;h||z&&1==g.state||(h=!r(a,q,e));if(h)return k(),s;v&&wa(a);h={structural:v,element:a,
	event:e,close:k,options:n,runner:s};if(z){if(d("skip",a,h,g)){if(2===g.state)return k(),s;U(a,g.options,n);return g.runner}if(d("cancel",a,h,g))if(2===g.state)g.runner.end();else if(g.structural)g.close();else return U(a,g.options,h.options),g.runner;else if(d("join",a,h,g))if(2===g.state)U(a,n,{});else return Qa(a,v?e:null,n),e=h.event=g.event,n=U(a,g.options,h.options),g.runner}else U(a,n,{});(z=h.structural)||(z="animate"===h.event&&0<Object.keys(h.options.to||{}).length||f(h.options));if(!z)return k(),
	L(a),s;var M=(g.counter||0)+1;h.counter=M;A(a,1,h);c.$$postDigest(function(){var b=t.get(G),c=!b,b=b||{},g=0<(a.parent()||[]).length&&("animate"===b.event||b.structural||f(b.options));if(c||b.counter!==M||!g){c&&(Ja(a,n),ea(a,n));if(c||v&&b.event!==e)n.domOperation(),s.end();g||L(a)}else e=!b.structural&&f(b.options,!0)?"setClass":b.event,A(a,2),b=l(a,e,b.options),b.done(function(b){k(!b);(b=t.get(G))&&b.counter===M&&L(F(a));w(s,e,"close",{})}),s.setHost(b),w(s,e,"start",{})});return s}function wa(a){a=
	F(a).querySelectorAll("[data-ng-animate]");u(a,function(a){var b=parseInt(a.getAttribute("data-ng-animate")),c=t.get(a);if(c)switch(b){case 2:c.runner.end();case 1:t.remove(a)}})}function L(a){a=F(a);a.removeAttribute("data-ng-animate");t.remove(a)}function q(a,b){return F(a)===F(b)}function r(a,b,c){c=I(m[0].body);var e=q(a,c)||"HTML"===a[0].nodeName,g=q(a,D),d=!1,H,w=B.get(F(a));for((a=a.data("$ngAnimatePin"))&&(b=a);b&&b.length;){g||(g=q(b,D));var k=b[0];if(1!==k.nodeType)break;a=t.get(k)||{};
	if(!d){k=B.get(k);if(!0===k&&!1!==w){w=!0;break}else!1===k&&(w=!1);d=a.structural}if(O(H)||!0===H)a=b.data("$$ngAnimateChildren"),Y(a)&&(H=a);if(d&&!1===H)break;e||(e=q(b,c));if(e&&g)break;if(!g&&(a=b.data("$ngAnimatePin"))){b=a;continue}b=b.parent()}return(!d||H)&&!0!==w&&g&&e}function A(a,b,c){c=c||{};c.state=b;a=F(a);a.setAttribute("data-ng-animate",b);c=(b=t.get(a))?Ba(b,c):c;t.put(a,c)}var t=new h,B=new h,H=null,e=c.$watch(function(){return 0===z.totalPendingRequests},function(a){a&&(e(),c.$$postDigest(function(){c.$$postDigest(function(){null===
	H&&(H=!0)})}))}),G={},g=a.classNameFilter(),Ua=g?function(a){return g.test(a)}:function(){return!0},Ja=T(v),s=Node.prototype.contains||function(a){return this===a||!!(this.compareDocumentPosition(a)&16)};return{on:function(a,b,c){b=oa(b);G[a]=G[a]||[];G[a].push({node:b,callback:c})},off:function(a,b,c){function e(a,b,c){var g=oa(b);return a.filter(function(a){return!(a.node===g&&(!c||a.callback===c))})}var g=G[a];g&&(G[a]=1===arguments.length?null:e(g,b,c))},pin:function(a,b){xa(sa(a),"element","not an element");
	xa(sa(b),"parentElement","not an element");a.data("$ngAnimatePin",b)},push:function(a,b,c,e){c=c||{};c.domOperation=e;return w(a,b,c)},enabled:function(a,b){var c=arguments.length;if(0===c)b=!!H;else if(sa(a)){var e=F(a),g=B.get(e);1===c?b=!g:B.put(e,!b)}else b=H=!!a;return b}}}]}]).provider("$$animation",["$animateProvider",function(a){function b(a){return a.data("$$animationRunner")}var c=this.drivers=[];this.$get=["$$jqLite","$rootScope","$injector","$$AnimateRunner","$$HashMap","$$rAFScheduler",
	function(a,f,m,J,ha,D){function Q(a){function b(a){if(a.processed)return a;a.processed=!0;var d=a.domNode,k=d.parentNode;f.put(d,a);for(var q;k;){if(q=f.get(k)){q.processed||(q=b(q));break}k=k.parentNode}(q||c).children.push(a);return a}var c={children:[]},d,f=new ha;for(d=0;d<a.length;d++){var h=a[d];f.put(h.domNode,a[d]={domNode:h.domNode,fn:h.fn,children:[]})}for(d=0;d<a.length;d++)b(a[d]);return function(a){var b=[],c=[],d;for(d=0;d<a.children.length;d++)c.push(a.children[d]);a=c.length;var k=
	0,f=[];for(d=0;d<c.length;d++){var t=c[d];0>=a&&(a=k,k=0,b.push(f),f=[]);f.push(t.fn);t.children.forEach(function(a){k++;c.push(a)});a--}f.length&&b.push(f);return b}(c)}var h=[],l=T(a);return function(x,z,v){function k(a){a=a.hasAttribute("ng-animate-ref")?[a]:a.querySelectorAll("[ng-animate-ref]");var b=[];u(a,function(a){var c=a.getAttribute("ng-animate-ref");c&&c.length&&b.push(a)});return b}function N(a){var b=[],c={};u(a,function(a,g){var d=F(a.element),H=0<=["enter","move"].indexOf(a.event),
	d=a.structural?k(d):[];if(d.length){var f=H?"to":"from";u(d,function(a){var b=a.getAttribute("ng-animate-ref");c[b]=c[b]||{};c[b][f]={animationID:g,element:I(a)}})}else b.push(a)});var g={},d={};u(c,function(c,f){var k=c.from,w=c.to;if(k&&w){var B=a[k.animationID],t=a[w.animationID],A=k.animationID.toString();if(!d[A]){var h=d[A]={structural:!0,beforeStart:function(){B.beforeStart();t.beforeStart()},close:function(){B.close();t.close()},classes:y(B.classes,t.classes),from:B,to:t,anchors:[]};h.classes.length?
	b.push(h):(b.push(B),b.push(t))}d[A].anchors.push({out:k.element,"in":w.element})}else k=k?k.animationID:w.animationID,w=k.toString(),g[w]||(g[w]=!0,b.push(a[k]))});return b}function y(a,b){a=a.split(" ");b=b.split(" ");for(var c=[],d=0;d<a.length;d++){var k=a[d];if("ng-"!==k.substring(0,3))for(var w=0;w<b.length;w++)if(k===b[w]){c.push(k);break}}return c.join(" ")}function w(a){for(var b=c.length-1;0<=b;b--){var d=c[b];if(m.has(d)&&(d=m.get(d)(a)))return d}}function wa(a,c){a.from&&a.to?(b(a.from.element).setHost(c),
	b(a.to.element).setHost(c)):b(a.element).setHost(c)}function L(){var a=b(x);!a||"leave"===z&&v.$$domOperationFired||a.end()}function q(b){x.off("$destroy",L);x.removeData("$$animationRunner");l(x,v);ea(x,v);v.domOperation();B&&a.removeClass(x,B);x.removeClass("ng-animate");A.complete(!b)}v=la(v);var r=0<=["enter","move","leave"].indexOf(z),A=new J({end:function(){q()},cancel:function(){q(!0)}});if(!c.length)return q(),A;x.data("$$animationRunner",A);var t=ya(x.attr("class"),ya(v.addClass,v.removeClass)),
	B=v.tempClasses;B&&(t+=" "+B,v.tempClasses=null);h.push({element:x,classes:t,event:z,structural:r,options:v,beforeStart:function(){x.addClass("ng-animate");B&&a.addClass(x,B)},close:q});x.on("$destroy",L);if(1<h.length)return A;f.$$postDigest(function(){var a=[];u(h,function(c){b(c.element)?a.push(c):c.close()});h.length=0;var c=N(a),d=[];u(c,function(a){d.push({domNode:F(a.from?a.from.element:a.element),fn:function(){a.beforeStart();var c,d=a.close;if(b(a.anchors?a.from.element||a.to.element:a.element)){var e=
	w(a);e&&(c=e.start)}c?(c=c(),c.done(function(a){d(!a)}),wa(a,c)):d()}})});D(Q(d))});return A}}]}]).provider("$animateCss",["$animateProvider",function(a){var b=Ea(),c=Ea();this.$get=["$window","$$jqLite","$$AnimateRunner","$timeout","$$forceReflow","$sniffer","$$rAFScheduler","$$animateQueue",function(a,f,m,J,l,D,Q,h){function Ia(a,b){var c=a.parentNode;return(c.$$ngAnimateParentKey||(c.$$ngAnimateParentKey=++N))+"-"+a.getAttribute("class")+"-"+b}function x(k,h,L,q){var r;0<b.count(L)&&(r=c.get(L),
	r||(h=W(h,"-stagger"),f.addClass(k,h),r=Ca(a,k,q),r.animationDuration=Math.max(r.animationDuration,0),r.transitionDuration=Math.max(r.transitionDuration,0),f.removeClass(k,h),c.put(L,r)));return r||{}}function z(a){y.push(a);Q.waitUntilQuiet(function(){b.flush();c.flush();for(var a=l(),d=0;d<y.length;d++)y[d](a);y.length=0})}function v(c,k,f){k=b.get(f);k||(k=Ca(a,c,Sa),"infinite"===k.animationIterationCount&&(k.animationIterationCount=1));b.put(f,k);c=k;f=c.animationDelay;k=c.transitionDelay;c.maxDelay=
	f&&k?Math.max(f,k):f||k;c.maxDuration=Math.max(c.animationDuration*c.animationIterationCount,c.transitionDuration);return c}var k=T(f),N=0,y=[];return function(a,c){function d(){r()}function q(){r(!0)}function r(b){if(!(l||ha&&N)){l=!0;N=!1;e.$$skipPreparationClasses||f.removeClass(a,ca);f.removeClass(a,ba);pa(g,!1);ma(g,!1);u(y,function(a){g.style[a[0]]=""});k(a,e);ea(a,e);Object.keys(G).length&&u(G,function(a,b){a?g.style.setProperty(b,a):g.style.removeProperty(b)});if(e.onDone)e.onDone();da&&da.length&&
	a.off(da.join(" "),B);E&&E.complete(!b)}}function A(a){p.blockTransition&&ma(g,a);p.blockKeyframeAnimation&&pa(g,!!a)}function t(){E=new m({end:d,cancel:q});z(P);r();return{$$willAnimate:!1,start:function(){return E},end:d}}function B(a){a.stopPropagation();var b=a.originalEvent||a;a=b.$manualTimeStamp||Date.now();b=parseFloat(b.elapsedTime.toFixed(3));Math.max(a-T,0)>=O&&b>=K&&(ha=!0,r())}function H(){function b(){if(!l){A(!1);u(y,function(a){g.style[a[0]]=a[1]});k(a,e);f.addClass(a,ba);if(p.recalculateTimingStyles){ka=
	g.className+" "+ca;fa=Ia(g,ka);C=v(g,ka,fa);Z=C.maxDelay;n=Math.max(Z,0);K=C.maxDuration;if(0===K){r();return}p.hasTransitions=0<C.transitionDuration;p.hasAnimations=0<C.animationDuration}p.applyAnimationDelay&&(Z="boolean"!==typeof e.delay&&qa(e.delay)?parseFloat(e.delay):Z,n=Math.max(Z,0),C.animationDelay=Z,$=[na,Z+"s"],y.push($),g.style[$[0]]=$[1]);O=1E3*n;R=1E3*K;if(e.easing){var d,h=e.easing;p.hasTransitions&&(d=S+"TimingFunction",y.push([d,h]),g.style[d]=h);p.hasAnimations&&(d=X+"TimingFunction",
	y.push([d,h]),g.style[d]=h)}C.transitionDuration&&da.push(ta);C.animationDuration&&da.push(ua);T=Date.now();var t=O+1.5*R;d=T+t;var h=a.data("$$animateCss")||[],H=!0;if(h.length){var s=h[0];(H=d>s.expectedEndTime)?J.cancel(s.timer):h.push(r)}H&&(t=J(c,t,!1),h[0]={timer:t,expectedEndTime:d},h.push(r),a.data("$$animateCss",h));if(da.length)a.on(da.join(" "),B);e.to&&(e.cleanupStyles&&Fa(G,g,Object.keys(e.to)),Aa(a,e))}}function c(){var b=a.data("$$animateCss");if(b){for(var d=1;d<b.length;d++)b[d]();
	a.removeData("$$animateCss")}}if(!l)if(g.parentNode){var d=function(a){if(ha)N&&a&&(N=!1,r());else if(N=!a,C.animationDuration)if(a=pa(g,N),N)y.push(a);else{var b=y,c=b.indexOf(a);0<=a&&b.splice(c,1)}},h=0<Y&&(C.transitionDuration&&0===V.transitionDuration||C.animationDuration&&0===V.animationDuration)&&Math.max(V.animationDelay,V.transitionDelay);h?J(b,Math.floor(h*Y*1E3),!1):b();I.resume=function(){d(!0)};I.pause=function(){d(!1)}}else r()}var e=c||{};e.$$prepared||(e=la(Ga(e)));var G={},g=F(a);
	if(!g||!g.parentNode||!h.enabled())return t();var y=[],Q=a.attr("class"),s=La(e),l,N,ha,E,I,n,O,K,R,T,da=[];if(0===e.duration||!D.animations&&!D.transitions)return t();var ga=e.event&&aa(e.event)?e.event.join(" "):e.event,U="",M="";ga&&e.structural?U=W(ga,"ng-",!0):ga&&(U=ga);e.addClass&&(M+=W(e.addClass,"-add"));e.removeClass&&(M.length&&(M+=" "),M+=W(e.removeClass,"-remove"));e.applyClassesEarly&&M.length&&k(a,e);var ca=[U,M].join(" ").trim(),ka=Q+" "+ca,ba=W(ca,"-active"),Q=s.to&&0<Object.keys(s.to).length;
	if(!(0<(e.keyframeStyle||"").length||Q||ca))return t();var fa,V;0<e.stagger?(s=parseFloat(e.stagger),V={transitionDelay:s,animationDelay:s,transitionDuration:0,animationDuration:0}):(fa=Ia(g,ka),V=x(g,ca,fa,Ta));e.$$skipPreparationClasses||f.addClass(a,ca);e.transitionStyle&&(s=[S,e.transitionStyle],ia(g,s),y.push(s));0<=e.duration&&(s=0<g.style[S].length,s=Da(e.duration,s),ia(g,s),y.push(s));e.keyframeStyle&&(s=[X,e.keyframeStyle],ia(g,s),y.push(s));var Y=V?0<=e.staggerIndex?e.staggerIndex:b.count(fa):
	0;(ga=0===Y)&&!e.skipBlocking&&ma(g,9999);var C=v(g,ka,fa),Z=C.maxDelay;n=Math.max(Z,0);K=C.maxDuration;var p={};p.hasTransitions=0<C.transitionDuration;p.hasAnimations=0<C.animationDuration;p.hasTransitionAll=p.hasTransitions&&"all"==C.transitionProperty;p.applyTransitionDuration=Q&&(p.hasTransitions&&!p.hasTransitionAll||p.hasAnimations&&!p.hasTransitions);p.applyAnimationDuration=e.duration&&p.hasAnimations;p.applyTransitionDelay=qa(e.delay)&&(p.applyTransitionDuration||p.hasTransitions);p.applyAnimationDelay=
	qa(e.delay)&&p.hasAnimations;p.recalculateTimingStyles=0<M.length;if(p.applyTransitionDuration||p.applyAnimationDuration)K=e.duration?parseFloat(e.duration):K,p.applyTransitionDuration&&(p.hasTransitions=!0,C.transitionDuration=K,s=0<g.style[S+"Property"].length,y.push(Da(K,s))),p.applyAnimationDuration&&(p.hasAnimations=!0,C.animationDuration=K,y.push([va,K+"s"]));if(0===K&&!p.recalculateTimingStyles)return t();if(null!=e.delay){var $;"boolean"!==typeof e.delay&&($=parseFloat(e.delay),n=Math.max($,
	0));p.applyTransitionDelay&&y.push([ja,$+"s"]);p.applyAnimationDelay&&y.push([na,$+"s"])}null==e.duration&&0<C.transitionDuration&&(p.recalculateTimingStyles=p.recalculateTimingStyles||ga);O=1E3*n;R=1E3*K;e.skipBlocking||(p.blockTransition=0<C.transitionDuration,p.blockKeyframeAnimation=0<C.animationDuration&&0<V.animationDelay&&0===V.animationDuration);e.from&&(e.cleanupStyles&&Fa(G,g,Object.keys(e.from)),za(a,e));p.blockTransition||p.blockKeyframeAnimation?A(K):e.skipBlocking||ma(g,!1);return{$$willAnimate:!0,
	end:d,start:function(){if(!l)return I={end:d,cancel:q,resume:null,pause:null},E=new m(I),z(H),E}}}}]}]).provider("$$animateCssDriver",["$$animationProvider",function(a){a.drivers.push("$$animateCssDriver");this.$get=["$animateCss","$rootScope","$$AnimateRunner","$rootElement","$sniffer","$$jqLite","$document",function(a,c,d,f,m,J,l){function D(a){return a.replace(/\bng-\S+\b/g,"")}function Q(a,b){R(a)&&(a=a.split(" "));R(b)&&(b=b.split(" "));return a.filter(function(a){return-1===b.indexOf(a)}).join(" ")}
	function h(c,f,h){function m(a){var b={},c=F(a).getBoundingClientRect();u(["width","height","top","left"],function(a){var d=c[a];switch(a){case "top":d+=z.scrollTop;break;case "left":d+=z.scrollLeft}b[a]=Math.floor(d)+"px"});return b}function l(){var c=D(h.attr("class")||""),d=Q(c,r),c=Q(r,c),d=a(q,{to:m(h),addClass:"ng-anchor-in "+d,removeClass:"ng-anchor-out "+c,delay:!0});return d.$$willAnimate?d:null}function J(){q.remove();f.removeClass("ng-animate-shim");h.removeClass("ng-animate-shim")}var q=
	I(F(f).cloneNode(!0)),r=D(q.attr("class")||"");f.addClass("ng-animate-shim");h.addClass("ng-animate-shim");q.addClass("ng-anchor");v.append(q);var A;c=function(){var c=a(q,{addClass:"ng-anchor-out",delay:!0,from:m(f)});return c.$$willAnimate?c:null}();if(!c&&(A=l(),!A))return J();var t=c||A;return{start:function(){function a(){c&&c.end()}var b,c=t.start();c.done(function(){c=null;if(!A&&(A=l()))return c=A.start(),c.done(function(){c=null;J();b.complete()}),c;J();b.complete()});return b=new d({end:a,
	cancel:a})}}}function E(a,b,c,f){var m=x(a,P),D=x(b,P),q=[];u(f,function(a){(a=h(c,a.out,a["in"]))&&q.push(a)});if(m||D||0!==q.length)return{start:function(){function a(){u(b,function(a){a.end()})}var b=[];m&&b.push(m.start());D&&b.push(D.start());u(q,function(a){b.push(a.start())});var c=new d({end:a,cancel:a});d.all(b,function(a){c.complete(a)});return c}}}function x(c){var d=c.element,f=c.options||{};c.structural&&(f.event=c.event,f.structural=!0,f.applyClassesEarly=!0,"leave"===c.event&&(f.onDone=
	f.domOperation));f.preparationClasses&&(f.event=ba(f.event,f.preparationClasses));c=a(d,f);return c.$$willAnimate?c:null}if(!m.animations&&!m.transitions)return P;var z=l[0].body;c=F(f);var v=I(c.parentNode&&11===c.parentNode.nodeType||z.contains(c)?c:z);T(J);return function(a){return a.from&&a.to?E(a.from,a.to,a.classes,a.anchors):x(a)}}]}]).provider("$$animateJs",["$animateProvider",function(a){this.$get=["$injector","$$AnimateRunner","$$jqLite",function(b,c,d){function f(c){c=aa(c)?c:c.split(" ");
	for(var d=[],f={},m=0;m<c.length;m++){var h=c[m],l=a.$$registeredAnimations[h];l&&!f[h]&&(d.push(b.get(l)),f[h]=!0)}return d}var m=T(d);return function(a,b,d,l){function h(){l.domOperation();m(a,l)}function F(a,b,d,f,e){switch(d){case "animate":b=[b,f.from,f.to,e];break;case "setClass":b=[b,k,E,e];break;case "addClass":b=[b,k,e];break;case "removeClass":b=[b,E,e];break;default:b=[b,e]}b.push(f);if(a=a.apply(a,b))if(Ha(a.start)&&(a=a.start()),a instanceof c)a.done(e);else if(Ha(a))return a;return P}
	function x(a,b,d,f,e){var h=[];u(f,function(f){var k=f[e];k&&h.push(function(){var e,f,g=!1,h=function(a){g||(g=!0,(f||P)(a),e.complete(!a))};e=new c({end:function(){h()},cancel:function(){h(!0)}});f=F(k,a,b,d,function(a){h(!1===a)});return e})});return h}function z(a,b,d,f,e){var h=x(a,b,d,f,e);if(0===h.length){var g,k;"beforeSetClass"===e?(g=x(a,"removeClass",d,f,"beforeRemoveClass"),k=x(a,"addClass",d,f,"beforeAddClass")):"setClass"===e&&(g=x(a,"removeClass",d,f,"removeClass"),k=x(a,"addClass",
	d,f,"addClass"));g&&(h=h.concat(g));k&&(h=h.concat(k))}if(0!==h.length)return function(a){var b=[];h.length&&u(h,function(a){b.push(a())});b.length?c.all(b,a):a();return function(a){u(b,function(b){a?b.cancel():b.end()})}}}var v=!1;3===arguments.length&&ra(d)&&(l=d,d=null);l=la(l);d||(d=a.attr("class")||"",l.addClass&&(d+=" "+l.addClass),l.removeClass&&(d+=" "+l.removeClass));var k=l.addClass,E=l.removeClass,y=f(d),w,I;if(y.length){var L,q;"leave"==b?(q="leave",L="afterLeave"):(q="before"+b.charAt(0).toUpperCase()+
	b.substr(1),L=b);"enter"!==b&&"move"!==b&&(w=z(a,b,l,y,q));I=z(a,b,l,y,L)}if(w||I){var r;return{$$willAnimate:!0,end:function(){r?r.end():(v=!0,h(),ea(a,l),r=new c,r.complete(!0));return r},start:function(){function b(c){v=!0;h();ea(a,l);r.complete(c)}if(r)return r;r=new c;var d,f=[];w&&f.push(function(a){d=w(a)});f.length?f.push(function(a){h();a(!0)}):h();I&&f.push(function(a){d=I(a)});r.setHost({end:function(){v||((d||P)(void 0),b(void 0))},cancel:function(){v||((d||P)(!0),b(!0))}});c.chain(f,
	b);return r}}}}}]}]).provider("$$animateJsDriver",["$$animationProvider",function(a){a.drivers.push("$$animateJsDriver");this.$get=["$$animateJs","$$AnimateRunner",function(a,c){function d(c){return a(c.element,c.event,c.classes,c.options)}return function(a){if(a.from&&a.to){var b=d(a.from),l=d(a.to);if(b||l)return{start:function(){function a(){return function(){u(d,function(a){a.end()})}}var d=[];b&&d.push(b.start());l&&d.push(l.start());c.all(d,function(a){f.complete(a)});var f=new c({end:a(),cancel:a()});
	return f}}}else return d(a)}}]}])})(window,window.angular);
	//# sourceMappingURL=angular-animate.min.js.map


/***/ },
/* 8 */
/***/ function(module, exports) {

	/*
	 AngularJS v1.4.9
	 (c) 2010-2015 Google, Inc. http://angularjs.org
	 License: MIT
	*/
	(function(n,h,p){'use strict';function E(a){var f=[];r(f,h.noop).chars(a);return f.join("")}function g(a,f){var d={},c=a.split(","),b;for(b=0;b<c.length;b++)d[f?h.lowercase(c[b]):c[b]]=!0;return d}function F(a,f){function d(a,b,d,l){b=h.lowercase(b);if(s[b])for(;e.last()&&t[e.last()];)c("",e.last());u[b]&&e.last()==b&&c("",b);(l=v[b]||!!l)||e.push(b);var m={};d.replace(G,function(b,a,f,c,d){m[a]=q(f||c||d||"")});f.start&&f.start(b,m,l)}function c(b,a){var c=0,d;if(a=h.lowercase(a))for(c=e.length-
	1;0<=c&&e[c]!=a;c--);if(0<=c){for(d=e.length-1;d>=c;d--)f.end&&f.end(e[d]);e.length=c}}"string"!==typeof a&&(a=null===a||"undefined"===typeof a?"":""+a);var b,k,e=[],m=a,l;for(e.last=function(){return e[e.length-1]};a;){l="";k=!0;if(e.last()&&w[e.last()])a=a.replace(new RegExp("([\\W\\w]*)<\\s*\\/\\s*"+e.last()+"[^>]*>","i"),function(a,b){b=b.replace(H,"$1").replace(I,"$1");f.chars&&f.chars(q(b));return""}),c("",e.last());else{if(0===a.indexOf("\x3c!--"))b=a.indexOf("--",4),0<=b&&a.lastIndexOf("--\x3e",
	b)===b&&(f.comment&&f.comment(a.substring(4,b)),a=a.substring(b+3),k=!1);else if(x.test(a)){if(b=a.match(x))a=a.replace(b[0],""),k=!1}else if(J.test(a)){if(b=a.match(y))a=a.substring(b[0].length),b[0].replace(y,c),k=!1}else K.test(a)&&((b=a.match(z))?(b[4]&&(a=a.substring(b[0].length),b[0].replace(z,d)),k=!1):(l+="<",a=a.substring(1)));k&&(b=a.indexOf("<"),l+=0>b?a:a.substring(0,b),a=0>b?"":a.substring(b),f.chars&&f.chars(q(l)))}if(a==m)throw L("badparse",a);m=a}c()}function q(a){if(!a)return"";A.innerHTML=
	a.replace(/</g,"&lt;");return A.textContent}function B(a){return a.replace(/&/g,"&amp;").replace(M,function(a){var d=a.charCodeAt(0);a=a.charCodeAt(1);return"&#"+(1024*(d-55296)+(a-56320)+65536)+";"}).replace(N,function(a){return"&#"+a.charCodeAt(0)+";"}).replace(/</g,"&lt;").replace(/>/g,"&gt;")}function r(a,f){var d=!1,c=h.bind(a,a.push);return{start:function(a,k,e){a=h.lowercase(a);!d&&w[a]&&(d=a);d||!0!==C[a]||(c("<"),c(a),h.forEach(k,function(d,e){var k=h.lowercase(e),g="img"===a&&"src"===k||
	"background"===k;!0!==O[k]||!0===D[k]&&!f(d,g)||(c(" "),c(e),c('="'),c(B(d)),c('"'))}),c(e?"/>":">"))},end:function(a){a=h.lowercase(a);d||!0!==C[a]||(c("</"),c(a),c(">"));a==d&&(d=!1)},chars:function(a){d||c(B(a))}}}var L=h.$$minErr("$sanitize"),z=/^<((?:[a-zA-Z])[\w:-]*)((?:\s+[\w:-]+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)\s*(>?)/,y=/^<\/\s*([\w:-]+)[^>]*>/,G=/([\w:-]+)(?:\s*=\s*(?:(?:"((?:[^"])*)")|(?:'((?:[^'])*)')|([^>\s]+)))?/g,K=/^</,J=/^<\//,H=/\x3c!--(.*?)--\x3e/g,x=/<!DOCTYPE([^>]*?)>/i,
	I=/<!\[CDATA\[(.*?)]]\x3e/g,M=/[\uD800-\uDBFF][\uDC00-\uDFFF]/g,N=/([^\#-~| |!])/g,v=g("area,br,col,hr,img,wbr");n=g("colgroup,dd,dt,li,p,tbody,td,tfoot,th,thead,tr");p=g("rp,rt");var u=h.extend({},p,n),s=h.extend({},n,g("address,article,aside,blockquote,caption,center,del,dir,div,dl,figure,figcaption,footer,h1,h2,h3,h4,h5,h6,header,hgroup,hr,ins,map,menu,nav,ol,pre,script,section,table,ul")),t=h.extend({},p,g("a,abbr,acronym,b,bdi,bdo,big,br,cite,code,del,dfn,em,font,i,img,ins,kbd,label,map,mark,q,ruby,rp,rt,s,samp,small,span,strike,strong,sub,sup,time,tt,u,var"));
	n=g("circle,defs,desc,ellipse,font-face,font-face-name,font-face-src,g,glyph,hkern,image,linearGradient,line,marker,metadata,missing-glyph,mpath,path,polygon,polyline,radialGradient,rect,stop,svg,switch,text,title,tspan,use");var w=g("script,style"),C=h.extend({},v,s,t,u,n),D=g("background,cite,href,longdesc,src,usemap,xlink:href");n=g("abbr,align,alt,axis,bgcolor,border,cellpadding,cellspacing,class,clear,color,cols,colspan,compact,coords,dir,face,headers,height,hreflang,hspace,ismap,lang,language,nohref,nowrap,rel,rev,rows,rowspan,rules,scope,scrolling,shape,size,span,start,summary,tabindex,target,title,type,valign,value,vspace,width");
	p=g("accent-height,accumulate,additive,alphabetic,arabic-form,ascent,baseProfile,bbox,begin,by,calcMode,cap-height,class,color,color-rendering,content,cx,cy,d,dx,dy,descent,display,dur,end,fill,fill-rule,font-family,font-size,font-stretch,font-style,font-variant,font-weight,from,fx,fy,g1,g2,glyph-name,gradientUnits,hanging,height,horiz-adv-x,horiz-origin-x,ideographic,k,keyPoints,keySplines,keyTimes,lang,marker-end,marker-mid,marker-start,markerHeight,markerUnits,markerWidth,mathematical,max,min,offset,opacity,orient,origin,overline-position,overline-thickness,panose-1,path,pathLength,points,preserveAspectRatio,r,refX,refY,repeatCount,repeatDur,requiredExtensions,requiredFeatures,restart,rotate,rx,ry,slope,stemh,stemv,stop-color,stop-opacity,strikethrough-position,strikethrough-thickness,stroke,stroke-dasharray,stroke-dashoffset,stroke-linecap,stroke-linejoin,stroke-miterlimit,stroke-opacity,stroke-width,systemLanguage,target,text-anchor,to,transform,type,u1,u2,underline-position,underline-thickness,unicode,unicode-range,units-per-em,values,version,viewBox,visibility,width,widths,x,x-height,x1,x2,xlink:actuate,xlink:arcrole,xlink:role,xlink:show,xlink:title,xlink:type,xml:base,xml:lang,xml:space,xmlns,xmlns:xlink,y,y1,y2,zoomAndPan",
	!0);var O=h.extend({},D,p,n),A=document.createElement("pre");h.module("ngSanitize",[]).provider("$sanitize",function(){this.$get=["$$sanitizeUri",function(a){return function(f){var d=[];F(f,r(d,function(c,b){return!/^unsafe/.test(a(c,b))}));return d.join("")}}]});h.module("ngSanitize").filter("linky",["$sanitize",function(a){var f=/((ftp|https?):\/\/|(www\.)|(mailto:)?[A-Za-z0-9._%+-]+@)\S*[^\s.;,(){}<>"\u201d\u2019]/i,d=/^mailto:/i;return function(c,b){function k(a){a&&g.push(E(a))}function e(a,
	c){g.push("<a ");h.isDefined(b)&&g.push('target="',b,'" ');g.push('href="',a.replace(/"/g,"&quot;"),'">');k(c);g.push("</a>")}if(!c)return c;for(var m,l=c,g=[],n,p;m=l.match(f);)n=m[0],m[2]||m[4]||(n=(m[3]?"http://":"mailto:")+n),p=m.index,k(l.substr(0,p)),e(n,m[0].replace(d,"")),l=l.substring(p+m[0].length);k(l);return a(g.join(""))}}])})(window,window.angular);
	//# sourceMappingURL=angular-sanitize.min.js.map


/***/ },
/* 9 */
/***/ function(module, exports) {

	(function (angular) {

	    'use strict';

	    //Generic   

	    function makeArray(arr) {
	        if(!arr){
	            return [];
	        }
	        return angular.isArray(arr) ? arr : [arr];
	    }

	    //Angular

	    function provideRootElement(modules, element) {
	        element = angular.element(element);
	        modules.unshift(['$provide',
	            function ($provide) {
	                $provide.value('$rootElement', element);
	            }]);
	    }

	    function createInjector(injectorModules, element) {
	        var modules = ['ng'].concat(makeArray(injectorModules));
	        if (element) {
	            provideRootElement(modules, element);
	        }
	        return angular.injector(modules);
	    }

	    function bootstrapApplication(angularApp) {
	        angular.element(document).ready(function () {
	        	if(angular.isArray(angularApp)){
	        		angular.bootstrap(document, angularApp);
	        	}else{
	        		angular.bootstrap(document, [angularApp]);
	        	}
	        });
	    }

	    angular.lazy = function (app, modules) {

	        var injector = createInjector(modules),
	            $q = injector.get('$q'),
	            promises = [],
	            errorCallback = angular.noop,
	            loadingCallback = angular.noop,
	            doneCallback = angular.noop;

	        return {

	            resolve: function (promise) {
	                promise = $q.when(injector.instantiate(promise));
	                promises.push(promise);
	                return this;
	            },

	            bootstrap: function () {

	                loadingCallback();

	                return $q.all(promises)
	                    .then(function () {
	                        bootstrapApplication(app);
	                    }, errorCallback)
	                    .finally(doneCallback);
	            },

	            loading: function(callback){
	                loadingCallback = callback;
	                return this;
	            },

	            done: function(callback){
	                doneCallback = callback;
	                return this;
	            },

	            error: function(callback){
	                errorCallback = callback;
	                return this;
	            }
	        };

	    };

	})(angular);

/***/ },
/* 10 */
/***/ function(module, exports) {

	;(function($, window, document, undefined) {

	    var pluginName = "metisMenu",
	        defaults = {
	            toggle: true,
	            doubleTapToGo: false
	        };

	    function Plugin(element, options) {
	        this.element = $(element);
	        this.settings = $.extend({}, defaults, options);
	        this._defaults = defaults;
	        this._name = pluginName;
	        this.init();
	    }

	    Plugin.prototype = {
	        init: function() {

	            var $this = this.element,
	                $toggle = this.settings.toggle,
	                obj = this;

	            if (this.isIE() <= 9) {
	                $this.find("li.active").has("ul").children("ul").collapse("show");
	                $this.find("li").not(".active").has("ul").children("ul").collapse("hide");
	            } else {
	                $this.find("li.active").has("ul").children("ul").addClass("collapse in");
	                $this.find("li").not(".active").has("ul").children("ul").addClass("collapse");
	            }

	            //add the "doubleTapToGo" class to active items if needed
	            if (obj.settings.doubleTapToGo) {
	                $this.find("li.active").has("ul").children("a").addClass("doubleTapToGo");
	            }

	            $this.find("li").has("ul").children("a").on("click" + "." + pluginName, function(e) {
	                e.preventDefault();

	                //Do we need to enable the double tap
	                if (obj.settings.doubleTapToGo) {

	                    //if we hit a second time on the link and the href is valid, navigate to that url
	                    if (obj.doubleTapToGo($(this)) && $(this).attr("href") !== "#" && $(this).attr("href") !== "") {
	                        e.stopPropagation();
	                        document.location = $(this).attr("href");
	                        return;
	                    }
	                }

	                $(this).parent("li").toggleClass("active").children("ul").collapse("toggle");

	                if ($toggle) {
	                    $(this).parent("li").siblings().removeClass("active").children("ul.in").collapse("hide");
	                    $(this).find('.fa-angle-left').toggleClass('s-rotate');
	                }

	            });
	        },

	        isIE: function() { //https://gist.github.com/padolsey/527683
	            var undef,
	                v = 3,
	                div = document.createElement("div"),
	                all = div.getElementsByTagName("i");

	            while (
	                div.innerHTML = "<!--[if gt IE " + (++v) + "]><i></i><![endif]-->",
	                all[0]
	            ) {
	                return v > 4 ? v : undef;
	            }
	        },

	        //Enable the link on the second click.
	        doubleTapToGo: function(elem) {
	            var $this = this.element;

	            //if the class "doubleTapToGo" exists, remove it and return
	            if (elem.hasClass("doubleTapToGo")) {
	                elem.removeClass("doubleTapToGo");
	                return true;
	            }

	            //does not exists, add a new class and return false
	            if (elem.parent().children("ul").length) {
	                 //first remove all other class
	                $this.find(".doubleTapToGo").removeClass("doubleTapToGo");
	                //add the class on the current element
	                elem.addClass("doubleTapToGo");
	                return false;
	            }
	        },

	        remove: function() {
	            this.element.off("." + pluginName);
	            this.element.removeData(pluginName);
	        }

	    };

	    $.fn[pluginName] = function(options) {
	        this.each(function () {
	            var el = $(this);
	            if (el.data(pluginName)) {
	                el.data(pluginName).remove();
	            }
	            el.data(pluginName, new Plugin(this, options));
	        });
	        return this;
	    };

	})(jQuery, window, document);


/***/ },
/* 11 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path='../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../typings/tsd.d.ts' />
	var hibachiinterceptor_1 = __webpack_require__(12);
	//constant
	var hibachipathbuilder_1 = __webpack_require__(13);
	//services
	var publicservice_1 = __webpack_require__(14);
	var utilityservice_1 = __webpack_require__(15);
	var selectionservice_1 = __webpack_require__(17);
	var observerservice_1 = __webpack_require__(18);
	var formservice_1 = __webpack_require__(19);
	var metadataservice_1 = __webpack_require__(20);
	var rbkeyservice_1 = __webpack_require__(21);
	var hibachiservice_1 = __webpack_require__(22);
	//controllers
	var globalsearch_1 = __webpack_require__(23);
	//filters
	var percentage_1 = __webpack_require__(24);
	var entityrbkey_1 = __webpack_require__(25);
	//directives
	//  components
	var swactioncaller_1 = __webpack_require__(26);
	var swtypeaheadsearch_1 = __webpack_require__(27);
	var swtypeaheadsearchlineitem_1 = __webpack_require__(28);
	var swactioncallerdropdown_1 = __webpack_require__(29);
	var swcolumnsorter_1 = __webpack_require__(30);
	var swconfirm_1 = __webpack_require__(31);
	var swentityactionbar_1 = __webpack_require__(32);
	var swentityactionbarbuttongroup_1 = __webpack_require__(33);
	var swexpandablerecord_1 = __webpack_require__(34);
	var swgravatar_1 = __webpack_require__(35);
	var swlistingdisplay_1 = __webpack_require__(40);
	var swlistingaggregate_1 = __webpack_require__(41);
	var swlistingcolorfilter_1 = __webpack_require__(42);
	var swlistingcolumn_1 = __webpack_require__(43);
	var swlistingfilter_1 = __webpack_require__(44);
	var swlistingorderby_1 = __webpack_require__(45);
	var swlogin_1 = __webpack_require__(46);
	var swnumbersonly_1 = __webpack_require__(47);
	var swloading_1 = __webpack_require__(48);
	var swscrolltrigger_1 = __webpack_require__(49);
	var swtooltip_1 = __webpack_require__(50);
	var swrbkey_1 = __webpack_require__(51);
	var swoptions_1 = __webpack_require__(52);
	var swselection_1 = __webpack_require__(53);
	var swclickoutside_1 = __webpack_require__(54);
	var swdirective_1 = __webpack_require__(55);
	var swexportaction_1 = __webpack_require__(56);
	var swhref_1 = __webpack_require__(57);
	var swprocesscaller_1 = __webpack_require__(58);
	var swsortable_1 = __webpack_require__(59);
	var swlistingglobalsearch_1 = __webpack_require__(60);
	var coremodule = angular.module('hibachi.core', [
	    //Angular Modules
	    'ngAnimate',
	    'ngSanitize',
	    //3rdParty modules
	    'ui.bootstrap'
	]).config(['$httpProvider', '$logProvider', '$filterProvider', '$provide', 'hibachiPathBuilder', 'appConfig', function ($httpProvider, $logProvider, $filterProvider, $provide, hibachiPathBuilder, appConfig) {
	        hibachiPathBuilder.setBaseURL(appConfig.baseURL);
	        hibachiPathBuilder.setBasePartialsPath('/org/Hibachi/client/src/');
	        $logProvider.debugEnabled(appConfig.debugFlag);
	        $filterProvider.register('likeFilter', function () {
	            return function (text) {
	                if (angular.isDefined(text) && angular.isString(text)) {
	                    return text.replace(new RegExp('%', 'g'), '');
	                }
	            };
	        });
	        $filterProvider.register('truncate', function () {
	            return function (input, chars, breakOnWord) {
	                if (isNaN(chars))
	                    return input;
	                if (chars <= 0)
	                    return '';
	                if (input && input.length > chars) {
	                    input = input.substring(0, chars);
	                    if (!breakOnWord) {
	                        var lastspace = input.lastIndexOf(' ');
	                        //get last space
	                        if (lastspace !== -1) {
	                            input = input.substr(0, lastspace);
	                        }
	                    }
	                    else {
	                        while (input.charAt(input.length - 1) === ' ') {
	                            input = input.substr(0, input.length - 1);
	                        }
	                    }
	                    return input + '...';
	                }
	                return input;
	            };
	        });
	        hibachiPathBuilder.setBaseURL(appConfig.baseURL);
	        hibachiPathBuilder.setBasePartialsPath('/org/Hibachi/client/src/');
	        $provide.decorator('$hibachi', [
	            "$delegate",
	            '$http',
	            '$timeout',
	            '$log',
	            '$rootScope',
	            '$location',
	            '$anchorScroll',
	            '$q',
	            'utilityService',
	            'formService',
	            'rbkeyService',
	            'appConfig',
	            function ($delegate, $http, $timeout, $log, $rootScope, $location, $anchorScroll, $q, utilityService, formService, rbkeyService, appConfig) {
	                var _deferred = {};
	                console.log($delegate);
	                console.log(appConfig);
	                var _config = appConfig;
	                var _jsEntities = {};
	                var _jsEntityInstances = {};
	                var entities = appConfig.modelConfig.entities, validations = appConfig.modelConfig.validations, defaultValues = appConfig.modelConfig.defaultValues;
	                angular.forEach(entities, function (entity) {
	                    $delegate['get' + entity.className] = function (options) {
	                        var entityInstance = $delegate.newEntity(entity.className);
	                        var entityDataPromise = $delegate.getEntity(entity.className, options);
	                        entityDataPromise.then(function (response) {
	                            if (angular.isDefined(response.processData)) {
	                                entityInstance.$$init(response.data);
	                                var processObjectInstance = $delegate['new' + entity.className + '_' + options.processContext.charAt(0).toUpperCase() + options.processContext.slice(1)]();
	                                processObjectInstance.$$init(response.processData);
	                                processObjectInstance.data[entity.className.charAt(0).toLowerCase() + entity.className.slice(1)] = entityInstance;
	                                entityInstance.processObject = processObjectInstance;
	                            }
	                            else {
	                                entityInstance.$$init(response);
	                            }
	                        });
	                        return {
	                            promise: entityDataPromise,
	                            value: entityInstance
	                        };
	                    };
	                    $delegate['get' + entity.className] = function (options) {
	                        var entityInstance = $delegate.newEntity(entity.className);
	                        var entityDataPromise = $delegate.getEntity(entity.className, options);
	                        entityDataPromise.then(function (response) {
	                            if (angular.isDefined(response.processData)) {
	                                entityInstance.$$init(response.data);
	                                var processObjectInstance = $delegate['new' + entity.className + options.processContext.charAt(0).toUpperCase() + options.processContext.slice(1)]();
	                                processObjectInstance.$$init(response.processData);
	                                processObjectInstance.data[entity.className.charAt(0).toLowerCase() + entity.className.slice(1)] = entityInstance;
	                                entityInstance.processObject = processObjectInstance;
	                            }
	                            else {
	                                entityInstance.$$init(response);
	                            }
	                        });
	                        return {
	                            promise: entityDataPromise,
	                            value: entityInstance
	                        };
	                    };
	                    $delegate['new' + entity.className] = function () {
	                        return $delegate.newEntity(entity.className);
	                    };
	                    entity.isProcessObject = entity.className.indexOf('_') >= 0;
	                    _jsEntities[entity.className] = function () {
	                        this.validations = validations[entity.className];
	                        this.metaData = entity;
	                        this.metaData.className = entity.className;
	                        if (entity.hb_parentPropertyName) {
	                            this.metaData.hb_parentPropertyName = entity.hb_parentPropertyName;
	                        }
	                        if (entity.hb_childPropertyName) {
	                            this.metaData.hb_childPropertyName = entity.hb_childPropertyName;
	                        }
	                        this.metaData.$$getRBKey = function (rbKey, replaceStringData) {
	                            return rbkeyService.rbKey(rbKey, replaceStringData);
	                        };
	                        this.metaData.$$getPropertyTitle = function (propertyName) {
	                            return _getPropertyTitle(propertyName, this);
	                        };
	                        this.metaData.$$getPropertyHint = function (propertyName) {
	                            return _getPropertyHint(propertyName, this);
	                        };
	                        this.metaData.$$getManyToManyName = function (singularname) {
	                            var metaData = this;
	                            for (var i in metaData) {
	                                if (metaData[i].singularname === singularname) {
	                                    return metaData[i].name;
	                                }
	                            }
	                        };
	                        this.metaData.$$getPropertyFieldType = function (propertyName) {
	                            return _getPropertyFieldType(propertyName, this);
	                        };
	                        this.metaData.$$getPropertyFormatType = function (propertyName) {
	                            return _getPropertyFormatType(propertyName, this);
	                        };
	                        this.metaData.$$getDetailTabs = function () {
	                            var deferred = $q.defer();
	                            var urlString = _config.baseURL + '/index.cfm/?' + appConfig.action + '=api:main.getDetailTabs&entityName=' + this.className;
	                            var detailTabs = [];
	                            $http.get(urlString)
	                                .success(function (data) {
	                                deferred.resolve(data);
	                            }).error(function (reason) {
	                                deferred.reject(reason);
	                            });
	                            return deferred.promise;
	                        };
	                        this.$$getFormattedValue = function (propertyName, formatType) {
	                            return _getFormattedValue(propertyName, formatType, this);
	                        };
	                        this.data = {};
	                        this.modifiedData = {};
	                        var jsEntity = this;
	                        if (entity.isProcessObject) {
	                            (function (entity) {
	                                _jsEntities[entity.className].prototype = {
	                                    $$getID: function () {
	                                        return '';
	                                    },
	                                    $$getIDName: function () {
	                                        var IDNameString = '';
	                                        return IDNameString;
	                                    }
	                                };
	                            })(entity);
	                        }
	                        angular.forEach(entity, function (property) {
	                            if (angular.isObject(property) && angular.isDefined(property.name)) {
	                                if (angular.isDefined(defaultValues[entity.className][property.name])) {
	                                    jsEntity.data[property.name] = defaultValues[entity.className][property.name];
	                                }
	                            }
	                        });
	                    };
	                    _jsEntities[entity.className].prototype = {
	                        $$getPropertyByName: function (propertyName) {
	                            return this['$$get' + propertyName.charAt(0).toUpperCase() + propertyName.slice(1)]();
	                        },
	                        $$isPersisted: function () {
	                            if (this.$$getID() === '') {
	                                return false;
	                            }
	                            else {
	                                return true;
	                            }
	                        },
	                        $$init: function (data) {
	                            _init(this, data);
	                        },
	                        $$save: function () {
	                            return _save(this);
	                        },
	                        $$delete: function () {
	                            var deletePromise = _delete(this);
	                            return deletePromise;
	                        },
	                        $$getValidationsByProperty: function (property) {
	                            return _getValidationsByProperty(this, property);
	                        },
	                        $$getValidationByPropertyAndContext: function (property, context) {
	                            return _getValidationByPropertyAndContext(this, property, context);
	                        },
	                        $$getTitleByPropertyIdentifier: function (propertyIdentifier) {
	                            if (propertyIdentifier.split('.').length > 1) {
	                                var listFirst = utilityService.listFirst(propertyIdentifier, '.');
	                                var relatedEntityName = this.metaData[listFirst].cfc;
	                                var exampleEntity = $delegate.newEntity(relatedEntityName);
	                                return exampleEntity = exampleEntity.$$getTitleByPropertyIdentifier(propertyIdentifier.replace(listFirst, ''));
	                            }
	                            return this.metaData.$$getPropertyTitle(propertyIdentifier);
	                        },
	                        $$getMetaData: function (propertyName) {
	                            if (propertyName === undefined) {
	                                return this.metaData;
	                            }
	                            else {
	                                if (angular.isDefined(this.metaData[propertyName].name) && angular.isUndefined(this.metaData[propertyName].nameCapitalCase)) {
	                                    this.metaData[propertyName].nameCapitalCase = this.metaData[propertyName].name.charAt(0).toUpperCase() + this.metaData[propertyName].name.slice(1);
	                                }
	                                if (angular.isDefined(this.metaData[propertyName].cfc) && angular.isUndefined(this.metaData[propertyName].cfcProperCase)) {
	                                    this.metaData[propertyName].cfcProperCase = this.metaData[propertyName].cfc.charAt(0).toLowerCase() + this.metaData[propertyName].cfc.slice(1);
	                                }
	                                return this.metaData[propertyName];
	                            }
	                        }
	                    };
	                    angular.forEach(entity, function (property) {
	                        if (angular.isObject(property) && angular.isDefined(property.name)) {
	                            if (angular.isUndefined(property.persistent)) {
	                                if (angular.isDefined(property.fieldtype)) {
	                                    if (['many-to-one'].indexOf(property.fieldtype) >= 0) {
	                                        _jsEntities[entity.className].prototype['$$get' + property.name.charAt(0).toUpperCase() + property.name.slice(1)] = function () {
	                                            var thisEntityInstance = this;
	                                            if (angular.isDefined(this['$$get' + this.$$getIDName().charAt(0).toUpperCase() + this.$$getIDName().slice(1)]())) {
	                                                var options = {
	                                                    columnsConfig: angular.toJson([
	                                                        {
	                                                            "propertyIdentifier": "_" + this.metaData.className.toLowerCase() + "_" + property.name
	                                                        }
	                                                    ]),
	                                                    joinsConfig: angular.toJson([
	                                                        {
	                                                            "associationName": property.name,
	                                                            "alias": "_" + this.metaData.className.toLowerCase() + "_" + property.name
	                                                        }
	                                                    ]),
	                                                    filterGroupsConfig: angular.toJson([{
	                                                            "filterGroup": [
	                                                                {
	                                                                    "propertyIdentifier": "_" + this.metaData.className.toLowerCase() + "." + this.$$getIDName(),
	                                                                    "comparisonOperator": "=",
	                                                                    "value": this.$$getID()
	                                                                }
	                                                            ]
	                                                        }]),
	                                                    allRecords: true
	                                                };
	                                                var collectionPromise = $delegate.getEntity(entity.className, options);
	                                                collectionPromise.then(function (response) {
	                                                    for (var i in response.records) {
	                                                        var entityInstance = $delegate.newEntity(thisEntityInstance.metaData[property.name].cfc);
	                                                        //Removed the array index here at the end of local.property.name.
	                                                        if (angular.isArray(response.records[i][property.name])) {
	                                                            entityInstance.$$init(response.records[i][property.name][0]);
	                                                        }
	                                                        else {
	                                                            entityInstance.$$init(response.records[i][property.name]); //Shouldn't have the array index'
	                                                        }
	                                                        thisEntityInstance['$$set' + property.name.charAt(0).toUpperCase() + property.name.slice(1)](entityInstance);
	                                                    }
	                                                });
	                                                return collectionPromise;
	                                            }
	                                            return null;
	                                        };
	                                        _jsEntities[entity.className].prototype['$$set' + property.name.charAt(0).toUpperCase() + property.name.slice(1)] = function (entityInstance) {
	                                            var thisEntityInstance = this;
	                                            var metaData = this.metaData;
	                                            var manyToManyName = '';
	                                            if (property.name === 'parent' + this.metaData.className) {
	                                                var childName = 'child' + this.metaData.className;
	                                                manyToManyName = entityInstance.metaData.$$getManyToManyName(childName);
	                                            }
	                                            else {
	                                                manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + this.metaData.className.slice(1));
	                                            }
	                                            if (angular.isUndefined(thisEntityInstance.parents)) {
	                                                thisEntityInstance.parents = [];
	                                            }
	                                            thisEntityInstance.parents.push(thisEntityInstance.metaData[property.name]);
	                                            if (angular.isDefined(manyToManyName)) {
	                                                if (angular.isUndefined(entityInstance.children)) {
	                                                    entityInstance.children = [];
	                                                }
	                                                var child = entityInstance.metaData[manyToManyName];
	                                                ;
	                                                if (entityInstance.children.indexOf(child) === -1) {
	                                                    entityInstance.children.push(child);
	                                                }
	                                                if (angular.isUndefined(entityInstance.data[manyToManyName])) {
	                                                    entityInstance.data[manyToManyName] = [];
	                                                }
	                                                entityInstance.data[manyToManyName].push(thisEntityInstance);
	                                            }
	                                            thisEntityInstance.data[property.name] = entityInstance;
	                                        };
	                                    }
	                                    else if (['one-to-many', 'many-to-many'].indexOf(property.fieldtype) >= 0) {
	                                        _jsEntities[entity.className].prototype['$$add' + property.singularname.charAt(0).toUpperCase() + property.singularname.slice(1)] = function () {
	                                            var entityInstance = $delegate.newEntity(this.metaData[property.name].cfc);
	                                            var metaData = this.metaData;
	                                            if (metaData[property.name].fieldtype === 'one-to-many') {
	                                                entityInstance.data[metaData[property.name].fkcolumn.slice(0, -2)] = this;
	                                            }
	                                            else if (metaData[property.name].fieldtype === 'many-to-many') {
	                                                var manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + this.metaData.className.slice(1));
	                                                if (angular.isUndefined(entityInstance.data[manyToManyName])) {
	                                                    entityInstance.data[manyToManyName] = [];
	                                                }
	                                                entityInstance.data[manyToManyName].push(this);
	                                            }
	                                            if (angular.isDefined(metaData[property.name])) {
	                                                if (angular.isDefined(entityInstance.metaData[metaData[property.name].fkcolumn.slice(0, -2)])) {
	                                                    if (angular.isUndefined(entityInstance.parents)) {
	                                                        entityInstance.parents = [];
	                                                    }
	                                                    entityInstance.parents.push(entityInstance.metaData[metaData[property.name].fkcolumn.slice(0, -2)]);
	                                                }
	                                                if (angular.isUndefined(this.children)) {
	                                                    this.children = [];
	                                                }
	                                                var child = metaData[property.name];
	                                                if (this.children.indexOf(child) === -1) {
	                                                    this.children.push(child);
	                                                }
	                                            }
	                                            if (angular.isUndefined(this.data[property.name])) {
	                                                this.data[property.name] = [];
	                                            }
	                                            this.data[property.name].push(entityInstance);
	                                            return entityInstance;
	                                        };
	                                        _jsEntities[entity.className].prototype['$$get' + property.name.charAt(0).toUpperCase() + property.name.slice(1)] = function () {
	                                            var thisEntityInstance = this;
	                                            if (angular.isDefined(this['$$get' + this.$$getIDName().charAt(0).toUpperCase() + this.$$getIDName().slice(1)])) {
	                                                var options = {
	                                                    filterGroupsConfig: angular.toJson([{
	                                                            "filterGroup": [
	                                                                {
	                                                                    "propertyIdentifier": "_" + property.cfc.toLowerCase() + "." + property.fkcolumn.replace('ID', '') + "." + this.$$getIDName(),
	                                                                    "comparisonOperator": "=",
	                                                                    "value": this.$$getID()
	                                                                }
	                                                            ]
	                                                        }]),
	                                                    allRecords: true
	                                                };
	                                                var collectionPromise = $delegate.getEntity(property.cfc, options);
	                                                collectionPromise.then(function (response) {
	                                                    for (var i in response.records) {
	                                                        var entityInstance = thisEntityInstance['$$add' + thisEntityInstance.metaData[property.name].singularname.charAt(0).toUpperCase() + thisEntityInstance.metaData[property.name].singularname.slice(1)]();
	                                                        entityInstance.$$init(response.records[i]);
	                                                        if (angular.isUndefined(thisEntityInstance[property.name])) {
	                                                            thisEntityInstance[property.name] = [];
	                                                        }
	                                                        thisEntityInstance[property.name].push(entityInstance);
	                                                    }
	                                                });
	                                                return collectionPromise;
	                                            }
	                                        };
	                                    }
	                                    else {
	                                        if (['id'].indexOf(property.fieldtype) >= 0) {
	                                            _jsEntities[entity.className].prototype['$$getID'] = function () {
	                                                //this should retreive id from the metadata
	                                                return this.data[this.$$getIDName()];
	                                            };
	                                            _jsEntities[entity.className].prototype['$$getIDName'] = function () {
	                                                var IDNameString = property.name;
	                                                return IDNameString;
	                                            };
	                                        }
	                                        _jsEntities[entity.className].prototype['$$get' + property.name.charAt(0).toUpperCase() + property.name.slice(1)] = function () {
	                                            return this.data[property.name];
	                                        };
	                                    }
	                                }
	                                else {
	                                    _jsEntities[entity.className].prototype['$$get' + property.name.charAt(0).toUpperCase() + property.name.slice(1)] = function () {
	                                        return this.data[property.name];
	                                    };
	                                }
	                            }
	                        }
	                    });
	                });
	                $delegate.setJsEntities(_jsEntities);
	                angular.forEach(_jsEntities, function (jsEntity) {
	                    var jsEntityInstance = new jsEntity;
	                    _jsEntityInstances[jsEntityInstance.metaData.className] = jsEntityInstance;
	                });
	                $delegate.setJsEntityInstances(_jsEntityInstances);
	                var _init = function (entityInstance, data) {
	                    for (var key in data) {
	                        if (key.charAt(0) !== '$' && angular.isDefined(entityInstance.metaData[key])) {
	                            var propertyMetaData = entityInstance.metaData[key];
	                            if (angular.isDefined(propertyMetaData) && angular.isDefined(propertyMetaData.hb_formfieldtype) && propertyMetaData.hb_formfieldtype === 'json') {
	                                if (data[key].trim() !== '') {
	                                    entityInstance.data[key] = angular.fromJson(data[key]);
	                                }
	                            }
	                            else {
	                                entityInstance.data[key] = data[key];
	                            }
	                        }
	                    }
	                };
	                var _getPropertyTitle = function (propertyName, metaData) {
	                    var propertyMetaData = metaData[propertyName];
	                    if (angular.isDefined(propertyMetaData['hb_rbkey'])) {
	                        return metaData.$$getRBKey(propertyMetaData['hb_rbkey']);
	                    }
	                    else if (angular.isUndefined(propertyMetaData['persistent'])) {
	                        if (angular.isDefined(propertyMetaData['fieldtype'])
	                            && angular.isDefined(propertyMetaData['cfc'])
	                            && ["one-to-many", "many-to-many"].indexOf(propertyMetaData.fieldtype) > -1) {
	                            return metaData.$$getRBKey("entity." + metaData.className.toLowerCase() + "." + propertyName + ',entity.' + propertyMetaData.cfc + '_plural');
	                        }
	                        else if (angular.isDefined(propertyMetaData.fieldtype)
	                            && angular.isDefined(propertyMetaData.cfc)
	                            && ["many-to-one"].indexOf(propertyMetaData.fieldtype) > -1) {
	                            return metaData.$$getRBKey("entity." + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase() + ',entity.' + propertyMetaData.cfc);
	                        }
	                        return metaData.$$getRBKey('entity.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase());
	                    }
	                    else if (metaData.isProcessObject) {
	                        if (angular.isDefined(propertyMetaData.fieldtype)
	                            && angular.isDefined(propertyMetaData.cfc)
	                            && ["one-to-many", "many-to-many"].indexOf(propertyMetaData.fieldtype) > -1) {
	                            return metaData.$$getRBKey('processObject.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase() + ',entity.' + propertyMetaData.cfc.toLowerCase() + '_plural');
	                        }
	                        else if (angular.isDefined(propertyMetaData.fieldtype)
	                            && angular.isDefined(propertyMetaData.cfc)) {
	                            return metaData.$$getRBKey('processObject.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase() + ',entity.' + propertyMetaData.cfc.toLowerCase());
	                        }
	                        return metaData.$$getRBKey('processObject.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase());
	                    }
	                    return metaData.$$getRBKey('object.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase());
	                };
	                var _getPropertyHint = function (propertyName, metaData) {
	                    var propertyMetaData = metaData[propertyName];
	                    var keyValue = '';
	                    if (angular.isDefined(propertyMetaData['hb_rbkey'])) {
	                        keyValue = metaData.$$getRBKey(propertyMetaData['hb_rbkey'] + '_hint');
	                    }
	                    else if (angular.isUndefined(propertyMetaData['persistent']) || (angular.isDefined(propertyMetaData['persistent']) && propertyMetaData['persistent'] === true)) {
	                        keyValue = metaData.$$getRBKey('entity.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase() + '_hint');
	                    }
	                    else {
	                        keyValue = metaData.$$getRBKey('object.' + metaData.className.toLowerCase() + '.' + propertyName.toLowerCase());
	                    }
	                    if (keyValue.slice(-8) !== '_missing') {
	                        return keyValue;
	                    }
	                    return '';
	                };
	                var _getPropertyFieldType = function (propertyName, metaData) {
	                    var propertyMetaData = metaData[propertyName];
	                    if (angular.isDefined(propertyMetaData['hb_formfieldtype'])) {
	                        return propertyMetaData['hb_formfieldtype'];
	                    }
	                    if (angular.isUndefined(propertyMetaData.fieldtype) || propertyMetaData.fieldtype === 'column') {
	                        var dataType = "";
	                        if (angular.isDefined(propertyMetaData.ormtype)) {
	                            dataType = propertyMetaData.ormtype;
	                        }
	                        else if (angular.isDefined(propertyMetaData.type)) {
	                            dataType = propertyMetaData.type;
	                        }
	                        if (["boolean", "yes_no", "true_false"].indexOf(dataType) > -1) {
	                            return "yesno";
	                        }
	                        else if (["date", "timestamp"].indexOf(dataType) > -1) {
	                            return "dateTime";
	                        }
	                        else if ("array" === dataType) {
	                            return "select";
	                        }
	                        else if ("struct" === dataType) {
	                            return "checkboxgroup";
	                        }
	                        else if (propertyName.indexOf('password') > -1) {
	                            return "password";
	                        }
	                    }
	                    else if (angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'many-to-one') {
	                        return 'select';
	                    }
	                    else if (angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'one-to-many') {
	                        return 'There is no property field type for one-to-many relationship properties, which means that you cannot get a fieldtype for ' + propertyName;
	                    }
	                    else if (angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'many-to-many') {
	                        return "listingMultiselect";
	                    }
	                    return "text";
	                };
	                var _getPropertyFormatType = function (propertyName, metaData) {
	                    var propertyMetaData = metaData[propertyName];
	                    if (angular.isDefined(propertyMetaData['hb_formattype'])) {
	                        return propertyMetaData['hb_formattype'];
	                    }
	                    else if (angular.isUndefined(propertyMetaData.fieldtype) || propertyMetaData.fieldtype === 'column') {
	                        var dataType = "";
	                        if (angular.isDefined(propertyMetaData.ormtype)) {
	                            dataType = propertyMetaData.ormtype;
	                        }
	                        else if (angular.isDefined(propertyMetaData.type)) {
	                            dataType = propertyMetaData.type;
	                        }
	                        if (["boolean", "yes_no", "true_false"].indexOf(dataType) > -1) {
	                            return "yesno";
	                        }
	                        else if (["date", "timestamp"].indexOf(dataType) > -1) {
	                            return "dateTime";
	                        }
	                        else if (["big_decimal"].indexOf(dataType) > -1 && propertyName.slice(-6) === 'weight') {
	                            return "weight";
	                        }
	                        else if (["big_decimal"].indexOf(dataType) > -1) {
	                            return "currency";
	                        }
	                    }
	                    return 'none';
	                };
	                var _isSimpleValue = function (value) {
	                    if (angular.isString(value) || angular.isNumber(value)
	                        || angular.isDate(value) || value === false || value === true) {
	                        return true;
	                    }
	                    else {
	                        return false;
	                    }
	                };
	                var _getFormattedValue = function (propertyName, formatType, entityInstance) {
	                    var value = entityInstance.$$getPropertyByName(propertyName);
	                    if (angular.isUndefined(formatType)) {
	                        formatType = entityInstance.metaData.$$getPropertyFormatType(propertyName);
	                    }
	                    if (formatType === "custom") {
	                    }
	                    else if (formatType === "rbkey") {
	                        if (angular.isDefined(value)) {
	                            return entityInstance.$$getRBKey('entity.' + entityInstance.metaData.className.toLowerCase() + '.' + propertyName.toLowerCase() + '.' + value);
	                        }
	                        else {
	                            return '';
	                        }
	                    }
	                    if (angular.isUndefined(value)) {
	                        var propertyMeta = entityInstance.metaData[propertyName];
	                        if (angular.isDefined(propertyMeta['hb_nullRBKey'])) {
	                            return entityInstance.$$getRbKey(propertyMeta['hb_nullRBKey']);
	                        }
	                        return "";
	                    }
	                    else if (_isSimpleValue(value)) {
	                        var formatDetails = {};
	                        if (angular.isDefined(entityInstance.data['currencyCode'])) {
	                            formatDetails.currencyCode = entityInstance.$$getCurrencyCode();
	                        }
	                        return utilityService.formatValue(value, formatType, formatDetails, entityInstance);
	                    }
	                };
	                var _delete = function (entityInstance) {
	                    var entityName = entityInstance.metaData.className;
	                    var entityID = entityInstance.$$getID();
	                    var context = 'delete';
	                    var deletePromise = $delegate.saveEntity(entityName, entityID, {}, context);
	                    return deletePromise;
	                };
	                var _setValueByPropertyPath = function (obj, path, value) {
	                    var a = path.split('.');
	                    var context = obj;
	                    var selector;
	                    var myregexp = /([a-zA-Z]+)(\[(\d)\])+/; // matches:  item[0]
	                    var match = null;
	                    for (var i = 0; i < a.length - 1; i += 1) {
	                        match = myregexp.exec(a[i]);
	                        if (match !== null)
	                            context = context[match[1]][match[3]];
	                        else
	                            context = context[a[i]];
	                    }
	                    // check for ending item[xx] syntax
	                    match = myregexp.exec([a[a.length - 1]]);
	                    if (match !== null)
	                        context[match[1]][match[3]] = value;
	                    else
	                        context[a[a.length - 1]] = value;
	                };
	                var _getValueByPropertyPath = function (obj, path) {
	                    var paths = path.split('.'), current = obj, i;
	                    for (i = 0; i < paths.length; ++i) {
	                        if (current[paths[i]] == undefined) {
	                            return undefined;
	                        }
	                        else {
	                            current = current[paths[i]];
	                        }
	                    }
	                    return current;
	                };
	                var _addReturnedIDs = function (returnedIDs, entityInstance) {
	                    for (var key in returnedIDs) {
	                        if (angular.isArray(returnedIDs[key])) {
	                            var arrayItems = returnedIDs[key];
	                            var entityInstanceArray = entityInstance.data[key];
	                            for (var i in arrayItems) {
	                                var arrayItem = arrayItems[i];
	                                var entityInstanceArrayItem = entityInstance.data[key][i];
	                                _addReturnedIDs(arrayItem, entityInstanceArrayItem);
	                            }
	                        }
	                        else if (angular.isObject(returnedIDs[key])) {
	                            for (var k in returnedIDs[key]) {
	                                _addReturnedIDs(returnedIDs[key][k], entityInstance.data[key][k]);
	                            }
	                        }
	                        else {
	                            entityInstance.data[key] = returnedIDs[key];
	                        }
	                    }
	                };
	                var _save = function (entityInstance) {
	                    var deferred = $q.defer();
	                    $timeout(function () {
	                        //$log.debug('save begin');
	                        //$log.debug(entityInstance);
	                        var entityID = entityInstance.$$getID();
	                        var modifiedData = _getModifiedData(entityInstance);
	                        //$log.debug('modifiedData complete');
	                        //$log.debug(modifiedData);
	                        //timeoutPromise.valid = modifiedData.valid;
	                        if (modifiedData.valid) {
	                            var params = {};
	                            params.serializedJsonData = angular.toJson(modifiedData.value);
	                            //if we have a process object then the context is different from the standard save
	                            var entityName = '';
	                            var context = 'save';
	                            if (entityInstance.metaData.isProcessObject === 1) {
	                                var processStruct = modifiedData.objectLevel.metaData.className.split('_');
	                                entityName = processStruct[0];
	                                context = processStruct[1];
	                            }
	                            else {
	                                entityName = modifiedData.objectLevel.metaData.className;
	                            }
	                            var savePromise = $delegate.saveEntity(entityName, entityInstance.$$getID(), params, context);
	                            savePromise.then(function (response) {
	                                var returnedIDs = response.data;
	                                if (angular.isDefined(response.SUCCESS) && response.SUCCESS === true) {
	                                    _addReturnedIDs(returnedIDs, modifiedData.objectLevel);
	                                    deferred.resolve(returnedIDs);
	                                }
	                                else {
	                                    deferred.reject(angular.isDefined(response.messages) ? response.messages : response);
	                                }
	                            }, function (reason) {
	                                deferred.reject(reason);
	                            });
	                        }
	                        else {
	                            //select first, visible, and enabled input with a class of ng-invalid
	                            var target = $('input.ng-invalid:first:visible:enabled');
	                            //$log.debug('input is invalid');
	                            //$log.debug(target);
	                            target.focus();
	                            var targetID = target.attr('id');
	                            $anchorScroll();
	                            deferred.reject('input is invalid');
	                        }
	                    });
	                    //return timeoutPromise;
	                    return deferred.promise;
	                    /*
	    
	    
	    
	    
	                    */
	                };
	                var _getModifiedData = function (entityInstance) {
	                    var modifiedData = {};
	                    modifiedData = getModifiedDataByInstance(entityInstance);
	                    return modifiedData;
	                };
	                var getObjectSaveLevel = function (entityInstance) {
	                    var objectLevel = entityInstance;
	                    var entityID = entityInstance.$$getID();
	                    angular.forEach(entityInstance.parents, function (parentObject) {
	                        if (angular.isDefined(entityInstance.data[parentObject.name]) && entityInstance.data[parentObject.name].$$getID() === '' && (angular.isUndefined(entityID) || !entityID.trim().length)) {
	                            var parentEntityInstance = entityInstance.data[parentObject.name];
	                            var parentEntityID = parentEntityInstance.$$getID();
	                            if (parentEntityID === '' && parentEntityInstance.forms) {
	                                objectLevel = getObjectSaveLevel(parentEntityInstance);
	                            }
	                        }
	                    });
	                    return objectLevel;
	                };
	                var validateObject = function (entityInstance) {
	                    var modifiedData = {};
	                    var valid = true;
	                    var forms = entityInstance.forms;
	                    //$log.debug('process base level data');
	                    for (var f in forms) {
	                        var form = forms[f];
	                        form.$setSubmitted(); //Sets the form to submitted for the validation errors to pop up.
	                        if (form.$dirty && form.$valid) {
	                            for (var key in form) {
	                                //$log.debug('key:'+key);
	                                if (key.charAt(0) !== '$' && angular.isObject(form[key])) {
	                                    var inputField = form[key];
	                                    if (angular.isDefined(inputField.$valid) && inputField.$valid === true && (inputField.$dirty === true || (form.autoDirty && form.autoDirty == true))) {
	                                        if (angular.isDefined(entityInstance.metaData[key])
	                                            && angular.isDefined(entityInstance.metaData[key].hb_formfieldtype)
	                                            && entityInstance.metaData[key].hb_formfieldtype === 'json') {
	                                            modifiedData[key] = angular.toJson(form[key].$modelValue);
	                                        }
	                                        else {
	                                            modifiedData[key] = form[key].$modelValue;
	                                        }
	                                    }
	                                }
	                            }
	                        }
	                        else {
	                            if (!form.$valid) {
	                                valid = false;
	                            }
	                        }
	                    }
	                    modifiedData[entityInstance.$$getIDName()] = entityInstance.$$getID();
	                    //$log.debug(modifiedData);
	                    //$log.debug('process parent data');
	                    if (angular.isDefined(entityInstance.parents)) {
	                        for (var p in entityInstance.parents) {
	                            var parentObject = entityInstance.parents[p];
	                            var parentInstance = entityInstance.data[parentObject.name];
	                            if (angular.isUndefined(modifiedData[parentObject.name])) {
	                                modifiedData[parentObject.name] = {};
	                            }
	                            var forms = parentInstance.forms;
	                            for (var f in forms) {
	                                var form = forms[f];
	                                form.$setSubmitted();
	                                if (form.$dirty && form.$valid) {
	                                    for (var key in form) {
	                                        if (key.charAt(0) !== '$' && angular.isObject(form[key])) {
	                                            var inputField = form[key];
	                                            if (angular.isDefined(inputField) && angular.isDefined(inputField.$valid) && inputField.$valid === true && (inputField.$dirty === true || (form.autoDirty && form.autoDirty == true))) {
	                                                if (angular.isDefined(parentInstance.metaData[key])
	                                                    && angular.isDefined(parentInstance.metaData[key].hb_formfieldtype)
	                                                    && parentInstance.metaData[key].hb_formfieldtype === 'json') {
	                                                    modifiedData[parentObject.name][key] = angular.toJson(form[key].$modelValue);
	                                                }
	                                                else {
	                                                    modifiedData[parentObject.name][key] = form[key].$modelValue;
	                                                }
	                                            }
	                                        }
	                                    }
	                                }
	                                else {
	                                    if (!form.$valid) {
	                                        valid = false;
	                                    }
	                                }
	                            }
	                            modifiedData[parentObject.name][parentInstance.$$getIDName()] = parentInstance.$$getID();
	                        }
	                    }
	                    //$log.debug(modifiedData);
	                    //$log.debug('begin child data');
	                    var childrenData = validateChildren(entityInstance);
	                    //$log.debug('child Data');
	                    //$log.debug(childrenData);
	                    angular.extend(modifiedData, childrenData);
	                    return {
	                        valid: valid,
	                        value: modifiedData
	                    };
	                };
	                var validateChildren = function (entityInstance) {
	                    var data = {};
	                    if (angular.isDefined(entityInstance.children) && entityInstance.children.length) {
	                        data = getDataFromChildren(entityInstance);
	                    }
	                    return data;
	                };
	                var processChild = function (entityInstance, entityInstanceParent) {
	                    var data = {};
	                    var forms = entityInstance.forms;
	                    for (var f in forms) {
	                        var form = forms[f];
	                        angular.extend(data, processForm(form, entityInstance));
	                    }
	                    if (angular.isDefined(entityInstance.children) && entityInstance.children.length) {
	                        var childData = getDataFromChildren(entityInstance);
	                        angular.extend(data, childData);
	                    }
	                    if (angular.isDefined(entityInstance.parents) && entityInstance.parents.length) {
	                        var parentData = getDataFromParents(entityInstance, entityInstanceParent);
	                        angular.extend(data, parentData);
	                    }
	                    return data;
	                };
	                var processParent = function (entityInstance) {
	                    var data = {};
	                    if (entityInstance.$$getID() !== '') {
	                        data[entityInstance.$$getIDName()] = entityInstance.$$getID();
	                    }
	                    //$log.debug('processParent');
	                    //$log.debug(entityInstance);
	                    var forms = entityInstance.forms;
	                    for (var f in forms) {
	                        var form = forms[f];
	                        data = angular.extend(data, processForm(form, entityInstance));
	                    }
	                    return data;
	                };
	                var processForm = function (form, entityInstance) {
	                    //$log.debug('begin process form');
	                    var data = {};
	                    form.$setSubmitted();
	                    for (var key in form) {
	                        if (key.charAt(0) !== '$' && angular.isObject(form[key])) {
	                            var inputField = form[key];
	                            if (angular.isDefined(inputField) && angular.isDefined(inputField) && inputField.$valid === true && (inputField.$dirty === true || (form.autoDirty && form.autoDirty == true))) {
	                                if (angular.isDefined(entityInstance.metaData[key]) && angular.isDefined(entityInstance.metaData[key].hb_formfieldtype) && entityInstance.metaData[key].hb_formfieldtype === 'json') {
	                                    data[key] = angular.toJson(form[key].$modelValue);
	                                }
	                                else {
	                                    data[key] = form[key].$modelValue;
	                                }
	                            }
	                        }
	                    }
	                    data[entityInstance.$$getIDName()] = entityInstance.$$getID();
	                    //$log.debug('process form data');
	                    //$log.debug(data);
	                    return data;
	                };
	                var getDataFromParents = function (entityInstance, entityInstanceParent) {
	                    var data = {};
	                    for (var c in entityInstance.parents) {
	                        var parentMetaData = entityInstance.parents[c];
	                        if (angular.isDefined(parentMetaData)) {
	                            var parent = entityInstance.data[parentMetaData.name];
	                            if (angular.isObject(parent) && entityInstanceParent !== parent && parent.$$getID() !== '') {
	                                if (angular.isUndefined(data[parentMetaData.name])) {
	                                    data[parentMetaData.name] = {};
	                                }
	                                var parentData = processParent(parent);
	                                //$log.debug('parentData:'+parentMetaData.name);
	                                //$log.debug(parentData);
	                                angular.extend(data[parentMetaData.name], parentData);
	                            }
	                            else {
	                            }
	                        }
	                    }
	                    ;
	                    return data;
	                };
	                var getDataFromChildren = function (entityInstance) {
	                    var data = {};
	                    //$log.debug('childrenFound');
	                    //$log.debug(entityInstance.children);
	                    for (var c in entityInstance.children) {
	                        var childMetaData = entityInstance.children[c];
	                        var children = entityInstance.data[childMetaData.name];
	                        //$log.debug(childMetaData);
	                        //$log.debug(children);
	                        if (angular.isArray(entityInstance.data[childMetaData.name])) {
	                            if (angular.isUndefined(data[childMetaData.name])) {
	                                data[childMetaData.name] = [];
	                            }
	                            angular.forEach(entityInstance.data[childMetaData.name], function (child, key) {
	                                //$log.debug('process child array item')
	                                var childData = processChild(child, entityInstance);
	                                //$log.debug('process child return');
	                                //$log.debug(childData);
	                                data[childMetaData.name].push(childData);
	                            });
	                        }
	                        else {
	                            if (angular.isUndefined(data[childMetaData.name])) {
	                                data[childMetaData.name] = {};
	                            }
	                            var child = entityInstance.data[childMetaData.name];
	                            //$log.debug('begin process child');
	                            var childData = processChild(child, entityInstance);
	                            //$log.debug('process child return');
	                            //$log.debug(childData);
	                            angular.extend(data, childData);
	                        }
	                    }
	                    //$log.debug('returning child data');
	                    //$log.debug(data);
	                    return data;
	                };
	                var getModifiedDataByInstance = function (entityInstance) {
	                    var modifiedData = {};
	                    var objectSaveLevel = getObjectSaveLevel(entityInstance);
	                    //$log.debug('objectSaveLevel : ' + objectSaveLevel );
	                    var valueStruct = validateObject(objectSaveLevel);
	                    //$log.debug('validateObject data');
	                    //$log.debug(valueStruct.value);
	                    modifiedData = {
	                        objectLevel: objectSaveLevel,
	                        value: valueStruct.value,
	                        valid: valueStruct.valid
	                    };
	                    return modifiedData;
	                };
	                var _getValidationsByProperty = function (entityInstance, property) {
	                    return entityInstance.validations.properties[property];
	                };
	                var _getValidationByPropertyAndContext = function (entityInstance, property, context) {
	                    var validations = _getValidationsByProperty(entityInstance, property);
	                    for (var i in validations) {
	                        var contexts = validations[i].contexts.split(',');
	                        for (var j in contexts) {
	                            if (contexts[j] === context) {
	                                return validations[i];
	                            }
	                        }
	                    }
	                };
	                return $delegate;
	            }
	        ]);
	        $httpProvider.interceptors.push('hibachiInterceptor');
	    }])
	    .run(['$rootScope', '$hibachi', function ($rootScope, $hibachi) {
	        $rootScope.buildUrl = $hibachi.buildUrl;
	    }])
	    .constant('hibachiPathBuilder', new hibachipathbuilder_1.HibachiPathBuilder())
	    .constant('corePartialsPath', 'core/components/')
	    .service('publicService', publicservice_1.PublicService)
	    .service('utilityService', utilityservice_1.UtilityService)
	    .service('selectionService', selectionservice_1.SelectionService)
	    .service('observerService', observerservice_1.ObserverService)
	    .service('formService', formservice_1.FormService)
	    .service('metadataService', metadataservice_1.MetaDataService)
	    .service('rbkeyService', rbkeyservice_1.RbKeyService)
	    .provider('$hibachi', hibachiservice_1.$Hibachi)
	    .service('hibachiInterceptor', hibachiinterceptor_1.HibachiInterceptor.Factory())
	    .controller('globalSearch', globalsearch_1.GlobalSearchController)
	    .filter('percentage', [percentage_1.PercentageFilter.Factory])
	    .filter('entityRBKey', ['rbkeyService', entityrbkey_1.EntityRBKey.Factory])
	    .directive('swTypeaheadSearch', swtypeaheadsearch_1.SWTypeaheadSearch.Factory())
	    .directive('swTypeaheadSearchLineItem', swtypeaheadsearchlineitem_1.SWTypeaheadSearchLineItem.Factory())
	    .directive('swActionCaller', swactioncaller_1.SWActionCaller.Factory())
	    .directive('swActionCallerDropdown', swactioncallerdropdown_1.SWActionCallerDropdown.Factory())
	    .directive('swColumnSorter', swcolumnsorter_1.SWColumnSorter.Factory())
	    .directive('swConfirm', swconfirm_1.SWConfirm.Factory())
	    .directive('swEntityActionBar', swentityactionbar_1.SWEntityActionBar.Factory())
	    .directive('swEntityActionBarButtonGroup', swentityactionbarbuttongroup_1.SWEntityActionBarButtonGroup.Factory())
	    .directive('swExpandableRecord', swexpandablerecord_1.SWExpandableRecord.Factory())
	    .directive('swGravatar', swgravatar_1.SWGravatar.Factory())
	    .directive('swListingDisplay', swlistingdisplay_1.SWListingDisplay.Factory())
	    .directive('swListingAggregate', swlistingaggregate_1.SWListingAggregate.Factory())
	    .directive('swListingColorFilter', swlistingcolorfilter_1.SWListingColorFilter.Factory())
	    .directive('swListingColumn', swlistingcolumn_1.SWListingColumn.Factory())
	    .directive('swListingFilter', swlistingfilter_1.SWListingFilter.Factory())
	    .directive('swListingOrderBy', swlistingorderby_1.SWListingOrderBy.Factory())
	    .directive('swLogin', swlogin_1.SWLogin.Factory())
	    .directive('swNumbersOnly', swnumbersonly_1.SWNumbersOnly.Factory())
	    .directive('swLoading', swloading_1.SWLoading.Factory())
	    .directive('swScrollTrigger', swscrolltrigger_1.SWScrollTrigger.Factory())
	    .directive('swRbkey', swrbkey_1.SWRbKey.Factory())
	    .directive('swOptions', swoptions_1.SWOptions.Factory())
	    .directive('swSelection', swselection_1.SWSelection.Factory())
	    .directive('swTooltip', swtooltip_1.SWTooltip.Factory())
	    .directive('swClickOutside', swclickoutside_1.SWClickOutside.Factory())
	    .directive('swDirective', swdirective_1.SWDirective.Factory())
	    .directive('swExportAction', swexportaction_1.SWExportAction.Factory())
	    .directive('swHref', swhref_1.SWHref.Factory())
	    .directive('swProcessCaller', swprocesscaller_1.SWProcessCaller.Factory())
	    .directive('sw:sortable', swsortable_1.SWSortable.Factory())
	    .directive('swListingGlobalSearch', swlistingglobalsearch_1.SWListingGlobalSearch.Factory());
	exports.coremodule = coremodule;


/***/ },
/* 12 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var HibachiInterceptor = (function () {
	    //@ngInject
	    function HibachiInterceptor($location, $window, $q, $log, $injector, alertService, appConfig, dialogService, utilityService, hibachiPathBuilder) {
	        var _this = this;
	        this.$location = $location;
	        this.$window = $window;
	        this.$q = $q;
	        this.$log = $log;
	        this.$injector = $injector;
	        this.alertService = alertService;
	        this.appConfig = appConfig;
	        this.dialogService = dialogService;
	        this.utilityService = utilityService;
	        this.hibachiPathBuilder = hibachiPathBuilder;
	        this.urlParam = null;
	        this.authHeader = 'Authorization';
	        this.authPrefix = 'Bearer ';
	        this.request = function (config) {
	            _this.$log.debug('request');
	            //bypass interceptor rules when checking template cache
	            if (config.url.charAt(0) !== '/') {
	                return config;
	            }
	            if (config.method == 'GET' && config.url.indexOf('.html') > 0 && config.url.indexOf('admin/client/partials') > 0) {
	                //all partials are bound to instantiation key
	                config.url = config.url + '?instantiationKey=' + $.hibachi.getConfig().instantiationKey;
	                return config;
	            }
	            config.cache = true;
	            config.headers = config.headers || {};
	            if (_this.$window.localStorage.getItem('token') && _this.$window.localStorage.getItem('token') !== "undefined") {
	                config.headers.Authorization = 'Bearer ' + _this.$window.localStorage.getItem('token');
	            }
	            var queryParams = _this.utilityService.getQueryParamsFromUrl(config.url);
	            if (config.method == 'GET' && (queryParams[_this.appConfig.action] && queryParams[_this.appConfig.action] === 'api:main.get')) {
	                _this.$log.debug(config);
	                config.method = 'POST';
	                config.data = {};
	                var data = {};
	                if (angular.isDefined(config.params)) {
	                    data = config.params;
	                }
	                var params = {};
	                params.serializedJsonData = angular.toJson(data);
	                params.context = "GET";
	                config.data = $.param(params);
	                delete config.params;
	                config.headers['Content-Type'] = 'application/x-www-form-urlencoded';
	            }
	            return config;
	        };
	        this.requestError = function (rejection) {
	            _this.$log.debug('requestError');
	            return _this.$q.reject(rejection);
	        };
	        this.response = function (response) {
	            _this.$log.debug('response');
	            console.log(response);
	            if (response.data.messages) {
	                var alerts = _this.alertService.formatMessagesToAlerts(response.data.messages);
	                _this.alertService.addAlerts(alerts);
	            }
	            return response;
	        };
	        this.responseError = function (rejection) {
	            _this.$log.debug('responseReject');
	            if (angular.isDefined(rejection.status) && rejection.status !== 404 && rejection.status !== 403 && rejection.status !== 401) {
	                if (rejection.data && rejection.data.messages) {
	                    var alerts = _this.alertService.formatMessagesToAlerts(rejection.data.messages);
	                    _this.alertService.addAlerts(alerts);
	                }
	                else {
	                    var message = {
	                        msg: 'there was error retrieving data',
	                        type: 'error'
	                    };
	                    _this.alertService.addAlert(message);
	                }
	            }
	            if (rejection.status === 401) {
	                // handle the case where the user is not authenticated
	                if (rejection.data && rejection.data.messages) {
	                    //var deferred = $q.defer();
	                    var $http = _this.$injector.get('$http');
	                    if (rejection.data.messages[0].message === 'timeout') {
	                        //open dialog
	                        _this.dialogService.addPageDialog(_this.hibachiPathBuilder.buildPartialsPath('preprocesslogin'), {});
	                    }
	                    else if (rejection.data.messages[0].message === 'invalid_token') {
	                        return $http.get(_this.baseUrl + '/index.cfm/api/auth/login').then(function (loginResponse) {
	                            _this.$window.localStorage.setItem('token', loginResponse.data.token);
	                            rejection.config.headers = rejection.config.headers || {};
	                            rejection.config.headers.Authorization = 'Bearer ' + _this.$window.localStorage.getItem('token');
	                            return $http(rejection.config).then(function (response) {
	                                return response;
	                            });
	                        }, function (rejection) {
	                            return rejection;
	                        });
	                    }
	                }
	            }
	            return rejection;
	        };
	        this.$location = $location;
	        this.$window = $window;
	        this.$q = $q;
	        this.$log = $log;
	        this.$injector = $injector;
	        this.alertService = alertService;
	        this.appConfig = appConfig;
	        this.baseUrl = appConfig.baseUrl;
	        this.dialogService = dialogService;
	        this.utilityService = utilityService;
	        this.hibachiPathBuilder = hibachiPathBuilder;
	    }
	    HibachiInterceptor.Factory = function () {
	        var eventHandler = function ($location, $window, $q, $log, $injector, alertService, appConfig, dialogService, utilityService, hibachiPathBuilder) {
	            return new HibachiInterceptor($location, $window, $q, $log, $injector, alertService, appConfig, dialogService, utilityService, hibachiPathBuilder);
	        };
	        eventHandler.$inject = [
	            '$location',
	            '$window',
	            '$q',
	            '$log',
	            '$injector',
	            'alertService',
	            'appConfig',
	            'dialogService',
	            'utilityService',
	            'hibachiPathBuilder'
	        ];
	        return eventHandler;
	    };
	    return HibachiInterceptor;
	})();
	exports.HibachiInterceptor = HibachiInterceptor;


/***/ },
/* 13 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/*services return promises which can be handled uniquely based on success or failure by the controller*/
	var HibachiPathBuilder = (function () {
	    //@ngInject
	    function HibachiPathBuilder() {
	        var _this = this;
	        this.setBaseURL = function (baseURL) {
	            _this.baseURL = baseURL;
	        };
	        this.setBasePartialsPath = function (basePartialsPath) {
	            _this.basePartialsPath = basePartialsPath;
	        };
	        this.buildPartialsPath = function (componentsPath) {
	            if (angular.isDefined(_this.baseURL) && angular.isDefined(_this.basePartialsPath)) {
	                return _this.baseURL + _this.basePartialsPath + componentsPath;
	            }
	            else {
	                throw ('need to define baseURL and basePartialsPath in hibachiPathBuilder. Inject hibachiPathBuilder into module and configure it there');
	            }
	        };
	    }
	    return HibachiPathBuilder;
	})();
	exports.HibachiPathBuilder = HibachiPathBuilder;


/***/ },
/* 14 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var PublicService = (function () {
	    ///index.cfm/api/scope/
	    //@ngInject
	    function PublicService($http, $q, $window) {
	        var _this = this;
	        this.$http = $http;
	        this.$q = $q;
	        this.$window = $window;
	        this.formType = { 'Content-Type': "application/x-www-form-urlencoded" };
	        this.ajaxRequestParam = "?ajaxRequest=1";
	        this.loading = false;
	        this.baseActionPath = "";
	        this.months = [{ name: '01 - JAN', value: 1 }, { name: '02 - FEB', value: 2 }, { name: '03 - MAR', value: 3 }, { name: '04 - APR', value: 4 }, { name: '05 - MAY', value: 5 }, { name: '06 - JUN', value: 6 }, { name: '07 - JUL', value: 7 }, { name: '08 - AUG', value: 8 }, { name: '09 - SEP', value: 9 }, { name: '10 - OCT', value: 10 }, { name: '11 - NOV', value: 11 }, { name: '12 - DEC', value: 12 }];
	        this.years = [];
	        this.shippingAddress = "";
	        this.billingAddress = "";
	        /** grab the valid expiration years for credit cards  */
	        this.getExpirationYears = function () {
	            var baseDate = new Date();
	            var today = baseDate.getFullYear();
	            var start = today;
	            for (var i = 0; i <= 5; i++) {
	                console.log("I:", start + i);
	                _this.years.push(start + i);
	            }
	            console.log("This Years", _this.years);
	        };
	        /** accessors for account */
	        this.getAccount = function () {
	            var urlBase = '/index.cfm/api/scope/getAccount/';
	            return _this.getData(urlBase, "account", "");
	        };
	        /** accessors for cart */
	        this.getCart = function () {
	            var urlBase = '/index.cfm/api/scope/getCart/';
	            return _this.getData(urlBase, "cart", "");
	        };
	        /** accessors for countries */
	        this.getCountries = function () {
	            var urlBase = '/index.cfm/api/scope/getCountries/';
	            return _this.getData(urlBase, "countries", "");
	        };
	        /** accessors for states */
	        this.getStates = function (countryCode) {
	            if (!angular.isDefined(countryCode))
	                countryCode = "US";
	            var urlBase = '/index.cfm/api/scope/getStateCodeOptionsByCountryCode/';
	            return _this.getData(urlBase, "states", "&countryCode=" + countryCode);
	        };
	        /** accessors for states */
	        this.getAddressOptions = function (countryCode) {
	            if (!angular.isDefined(countryCode))
	                countryCode = "US";
	            var urlBase = '/index.cfm/api/scope/getAddressOptionsByCountryCode/';
	            return _this.getData(urlBase, "addressOptions", "&countryCode=" + countryCode);
	        };
	        /** accessors for states */
	        this.getData = function (url, setter, param) {
	            _this.loading = true;
	            var urlBase = url + _this.ajaxRequestParam + param;
	            var deferred = _this.$q.defer();
	            _this.$http.get(urlBase).success(function (result) {
	                //don't need account and cart for anything other than account and cart calls.
	                if (setter.indexOf('account') == -1 || setter.indexOf('cart') == -1) {
	                    if (result['account']) {
	                        delete result['account'];
	                    }
	                    if (result['cart']) {
	                        delete result['cart'];
	                    }
	                    console.log("Result Sans", result);
	                }
	                _this[setter] = result;
	                _this.loading = false;
	                deferred.resolve(result);
	            }).error(function (reason) {
	                _this.loading = false;
	                deferred.reject(reason);
	            });
	            return deferred.promise;
	        };
	        /** sets the current shipping address */
	        this.setShippingAddress = function (shippingAddress) {
	            _this.shippingAddress = shippingAddress;
	        };
	        /** sets the current shipping address */
	        this.setBillingAddress = function (billingAddress) {
	            _this.billingAddress = billingAddress;
	        };
	        /** this is the generic method used to call all server side actions.
	        *  @param action {string} the name of the action (method) to call in the public service.
	        *  @param data   {object} the params as key value pairs to pass in the post request.
	        *  @return a deferred promise that resolves server response or error. also includes updated account and cart.
	        */
	        this.doAction = function (action, data) {
	            _this.loading = true;
	            var method = "";
	            if (!action) {
	                throw "Action is required exception";
	            }
	            if (action != undefined && data == undefined) {
	                method = "get";
	            }
	            else {
	                method = "post";
	            }
	            //check if the caller is defining a path to hit, otherwise use the public scope.
	            if (action.indexOf("/") !== -1) {
	                _this.baseActionPath = action; //any path
	            }
	            else {
	                _this.baseActionPath = "/index.cfm/api/scope/" + action; //public path
	            }
	            _this.hasErrors = false;
	            _this.success = false;
	            _this.errors = undefined;
	            _this.header = { headers: _this.formType };
	            var deferred = _this.$q.defer();
	            var urlBase = _this.baseActionPath + _this.ajaxRequestParam;
	            if (method == "post") {
	                data.returnJsonObjects = "cart,account";
	                //post
	                var promise = _this.$http.post(urlBase, _this.toFormParams(data), _this.header).then(function (result) {
	                    /** update the account and the cart */
	                    _this.account = result.data.account;
	                    _this.cart = result.data.cart;
	                    //if the action that was called was successful, then success is true.
	                    if (result.data.successfulActions.length) {
	                        _this.success = true;
	                        for (var action in result.data.successfulActions) {
	                            if (result.data.successfulActions[action].indexOf('public:cart.placeOrder') !== -1) {
	                                _this.window.location.href = _this.confirmationUrl;
	                                console.log(_this.window);
	                            }
	                        }
	                    }
	                    if (result.data.failureActions.length) {
	                        _this.hasErrors = true;
	                        console.log("Errors:", result.data.errors);
	                    }
	                    _this.loading = false;
	                    deferred.resolve(result);
	                }).catch(function (response) {
	                    console.log("There was an error making this http call", response.status, response.data);
	                    _this.loading = false;
	                    deferred.reject(response);
	                });
	                return deferred.promise;
	            }
	            else {
	                //get
	                var url = urlBase + "&returnJsonObject=cart,account";
	                var deferred = _this.$q.defer();
	                _this.$http.get(url).success(function (result) {
	                    deferred.resolve(result);
	                }).error(function (reason) {
	                    deferred.reject(reason);
	                });
	                return deferred.promise;
	            }
	        };
	        /** used to turn data into a correct format for the post */
	        this.toFormParams = function (data) {
	            return data = $.param(data) || "";
	        };
	        /**
	         * Helper methods so that everything in account and cart can be accessed using getters.
	         */
	        this.userIsLoggedIn = function () {
	            if (_this.account !== undefined && _this.account.accountID !== '') {
	                return true;
	            }
	            return false;
	        };
	        /**
	         * Helper methods for getting errors from the cart
	         */
	        this.getErrors = function () {
	            if (_this.errors !== undefined) {
	                return _this.errors;
	            }
	            return {};
	        };
	        this.baseActionPath = "/index.cfm/api/scope/"; //default path
	        this.confirmationUrl = "/order-confirmation";
	        this.$http = $http;
	        this.$q = $q;
	        this.getExpirationYears();
	        this.window = $window;
	        console.log("Window: ", $window);
	    }
	    return PublicService;
	})();
	exports.PublicService = PublicService;


/***/ },
/* 15 */
/***/ function(module, exports, __webpack_require__) {

	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/*services return promises which can be handled uniquely based on success or failure by the controller*/
	var baseservice_1 = __webpack_require__(16);
	var UtilityService = (function (_super) {
	    __extends(UtilityService, _super);
	    function UtilityService() {
	        var _this = this;
	        _super.call(this);
	        this.getQueryParamsFromUrl = function (url) {
	            // This function is anonymous, is executed immediately and
	            // the return value is assigned to QueryString!
	            var query_string = {};
	            if (url && url.split) {
	                var spliturl = url.split('?');
	                if (spliturl.length) {
	                    url = spliturl[1];
	                    if (url && url.split) {
	                        var vars = url.split("&");
	                        if (vars && vars.length) {
	                            for (var i = 0; i < vars.length; i++) {
	                                var pair = vars[i].split("=");
	                                // If first entry with this name
	                                if (typeof query_string[pair[0]] === "undefined") {
	                                    query_string[pair[0]] = pair[1];
	                                }
	                                else if (typeof query_string[pair[0]] === "string") {
	                                    var arr = [query_string[pair[0]], pair[1]];
	                                    query_string[pair[0]] = arr;
	                                }
	                                else {
	                                    query_string[pair[0]].push(pair[1]);
	                                }
	                            }
	                        }
	                    }
	                }
	            }
	            return query_string;
	        };
	        this.ArrayFindByPropertyValue = function (arr, property, value) {
	            var currentIndex = -1;
	            arr.forEach(function (arrItem, index) {
	                if (arrItem[property] && arrItem[property] === value) {
	                    currentIndex = index;
	                }
	            });
	            return currentIndex;
	        };
	        this.listLast = function (list, delimiter) {
	            if (list === void 0) { list = ''; }
	            if (delimiter === void 0) { delimiter = ','; }
	            var listArray = list.split(delimiter);
	            return listArray[listArray.length - 1];
	        };
	        this.listRest = function (list, delimiter) {
	            if (list === void 0) { list = ''; }
	            if (delimiter === void 0) { delimiter = ","; }
	            var listArray = list.split(delimiter);
	            if (listArray.length) {
	                listArray.splice(0, 1);
	            }
	            return listArray.join(delimiter);
	        };
	        this.listFirst = function (list, delimiter) {
	            if (list === void 0) { list = ''; }
	            if (delimiter === void 0) { delimiter = ','; }
	            var listArray = list.split(delimiter);
	            return listArray[0];
	        };
	        this.listPrepend = function (list, substring, delimiter) {
	            if (list === void 0) { list = ''; }
	            if (delimiter === void 0) { delimiter = ','; }
	            var listArray = list.split(delimiter);
	            if (listArray.length) {
	                return substring + delimiter + list;
	            }
	            else {
	                return substring;
	            }
	        };
	        this.listAppend = function (list, substring, delimiter) {
	            if (list === void 0) { list = ''; }
	            if (delimiter === void 0) { delimiter = ','; }
	            var listArray = list.split(delimiter);
	            if (listArray.length) {
	                return list + delimiter + substring;
	            }
	            else {
	                return substring;
	            }
	        };
	        this.formatValue = function (value, formatType, formatDetails, entityInstance) {
	            if (angular.isUndefined(formatDetails)) {
	                formatDetails = {};
	            }
	            var typeList = ["currency", "date", "datetime", "pixels", "percentage", "second", "time", "truefalse", "url", "weight", "yesno"];
	            if (typeList.indexOf(formatType)) {
	                _this['format_' + formatType](value, formatDetails, entityInstance);
	            }
	            return value;
	        };
	        this.format_currency = function (value, formatDetails, entityInstance) {
	            if (angular.isUndefined) {
	                formatDetails = {};
	            }
	        };
	        this.format_date = function (value, formatDetails, entityInstance) {
	            if (angular.isUndefined) {
	                formatDetails = {};
	            }
	        };
	        this.format_datetime = function (value, formatDetails, entityInstance) {
	            if (angular.isUndefined) {
	                formatDetails = {};
	            }
	        };
	        this.format_pixels = function (value, formatDetails, entityInstance) {
	            if (angular.isUndefined) {
	                formatDetails = {};
	            }
	        };
	        this.format_yesno = function (value, formatDetails, entityInstance) {
	            if (angular.isUndefined) {
	                formatDetails = {};
	            }
	            if (Boolean(value) === true) {
	                return entityInstance.metaData.$$getRBKey("define.yes");
	            }
	            else if (value === false || value.trim() === 'No' || value.trim === 'NO' || value.trim() === '0') {
	                return entityInstance.metaData.$$getRBKey("define.no");
	            }
	        };
	        this.left = function (stringItem, count) {
	            return stringItem.substring(0, count);
	        };
	        this.right = function (stringItem, count) {
	            return stringItem.substring(stringItem.length - count, stringItem.length);
	        };
	        //this.utilityService.mid(propertyIdentifier,1,propertyIdentifier.lastIndexOf('.'));
	        this.mid = function (stringItem, start, count) {
	            var end = start + count;
	            return stringItem.substring(start, end);
	        };
	        this.getPropertiesFromString = function (stringItem) {
	            if (!stringItem)
	                return;
	            var capture = false;
	            var property = '';
	            var results = [];
	            for (var i = 0; i < stringItem.length; i++) {
	                if (!capture && stringItem.substr(i, 2) == "${") {
	                    property = '';
	                    capture = true;
	                    i = i + 1; //skip the ${
	                }
	                else if (capture && stringItem[i] != '}') {
	                    property = property.concat(stringItem[i]);
	                }
	                else if (capture) {
	                    results.push(property);
	                    capture = false;
	                }
	            }
	            return results;
	        };
	        this.replacePropertiesWithData = function (stringItem, data) {
	            var results = _this.getPropertiesFromString(stringItem);
	            for (var i = 0; i < results.length; i++) {
	                stringItem = stringItem.replace('${' + results[i] + '}', data[i]);
	            }
	            return stringItem;
	        };
	        this.replaceAll = function (stringItem, find, replace) {
	            return stringItem.replace(new RegExp(_this.escapeRegExp(find), 'g'), replace);
	        };
	        this.escapeRegExp = function (stringItem) {
	            return stringItem.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
	        };
	        this.createID = function (count) {
	            var count = count || 26;
	            var text = "";
	            var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	            for (var i = 0; i < count; i++)
	                text += possible.charAt(Math.floor(Math.random() * possible.length));
	            return text;
	        };
	        //list functions
	        this.arrayToList = function (array, delimiter) {
	            if (delimiter != null) {
	                return array.join(delimiter);
	            }
	            else {
	                return array.join();
	            }
	        };
	        this.isDescendantElement = function (parent, child) {
	            var node = child.parentNode;
	            while (node != null) {
	                if (node == parent) {
	                    return true;
	                }
	                node = node.parentNode;
	            }
	            return false;
	        };
	        this.listFind = function (list, value, delimiter) {
	            if (list === void 0) { list = ''; }
	            if (delimiter === void 0) { delimiter = ','; }
	            var splitString = list.split(delimiter);
	            var stringFound = -1;
	            for (var i = 0; i < splitString.length; i++) {
	                var stringPart = splitString[i];
	                if (stringPart === value) {
	                    stringFound = i;
	                }
	            }
	            return stringFound;
	        };
	        this.listLen = function (list, delimiter) {
	            if (list === void 0) { list = ''; }
	            if (delimiter === void 0) { delimiter = ','; }
	            var splitString = list.split(delimiter);
	            return splitString.length;
	        };
	        //This will enable you to sort by two separate keys in the order they are passed in
	        this.arraySorter = function (array, keysToSortBy) {
	            var arrayOfTypes = [], returnArray = [], firstKey = keysToSortBy[0];
	            if (angular.isDefined(keysToSortBy[1])) {
	                var secondKey = keysToSortBy[1];
	            }
	            for (var itemIndex in array) {
	                if (!(arrayOfTypes.indexOf(array[itemIndex][firstKey]) > -1)) {
	                    arrayOfTypes.push(array[itemIndex][firstKey]);
	                }
	            }
	            arrayOfTypes.sort(function (a, b) {
	                if (a < b) {
	                    return -1;
	                }
	                else if (a > b) {
	                    return 1;
	                }
	                else {
	                    return 0;
	                }
	            });
	            for (var typeIndex in arrayOfTypes) {
	                var tempArray = [];
	                for (var itemIndex in array) {
	                    if (array[itemIndex][firstKey] == arrayOfTypes[typeIndex]) {
	                        tempArray.push(array[itemIndex]);
	                    }
	                }
	                if (keysToSortBy[1] != null) {
	                    tempArray.sort(function (a, b) {
	                        if (a[secondKey] < b[secondKey]) {
	                            return -1;
	                        }
	                        else if (a[secondKey] > b[secondKey]) {
	                            return 1;
	                        }
	                        else {
	                            return 0;
	                        }
	                    });
	                }
	                for (var finalIndex in tempArray) {
	                    returnArray.push(tempArray[finalIndex]);
	                }
	            }
	            return returnArray;
	        };
	    }
	    return UtilityService;
	})(baseservice_1.BaseService);
	exports.UtilityService = UtilityService;


/***/ },
/* 16 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var BaseService = (function () {
	    function BaseService() {
	    }
	    return BaseService;
	})();
	exports.BaseService = BaseService;


/***/ },
/* 17 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/*services return promises which can be handled uniquely based on success or failure by the controller*/
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var baseservice_1 = __webpack_require__(16);
	var SelectionService = (function (_super) {
	    __extends(SelectionService, _super);
	    function SelectionService() {
	        var _this = this;
	        _super.call(this);
	        this._selection = {};
	        this.radioSelection = function (selectionid, selection) {
	            _this._selection[selectionid] = [];
	            _this._selection[selectionid].push(selection);
	        };
	        this.addSelection = function (selectionid, selection) {
	            if (angular.isUndefined(_this._selection[selectionid])) {
	                _this._selection[selectionid] = [];
	            }
	            _this._selection[selectionid].push(selection);
	        };
	        this.setSelection = function (selectionid, selections) {
	            _this._selection[selectionid] = selections;
	        };
	        this.removeSelection = function (selection, selectionid) {
	            if (angular.isUndefined(_this._selection[selectionid])) {
	                _this._selection[selectionid] = [];
	            }
	            var index = _this._selection[selectionid].indexOf(selection);
	            if (index > -1) {
	                _this._selection[selectionid].splice(index, 1);
	            }
	        };
	        this.hasSelection = function (selectionid, selection) {
	            if (angular.isUndefined(_this._selection[selectionid])) {
	                return false;
	            }
	            var index = _this._selection[selectionid].indexOf(selection);
	            if (index > -1) {
	                return true;
	            }
	        };
	        this.getSelections = function (selectionid) {
	            return _this._selection[selectionid];
	        };
	        this.clearSelection = function (selectionid) {
	            _this._selection[selectionid] = [];
	        };
	    }
	    return SelectionService;
	})(baseservice_1.BaseService);
	exports.SelectionService = SelectionService;


/***/ },
/* 18 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * @ngdoc service
	 * @name sdt.models:ObserverService
	 * @description
	 * # ObserverService
	 * Manages all events inside the application
	 *
	 */
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var baseservice_1 = __webpack_require__(16);
	var ObserverService = (function (_super) {
	    __extends(ObserverService, _super);
	    //@ngInject
	    function ObserverService(utilityService) {
	        var _this = this;
	        /**
	         * @ngdoc property
	         * @name ObserverService#observers
	         * @propertyOf sdt.models:ObserverService
	         * @description object to store all observers in
	         * @returns {object} object
	         */
	        _super.call(this);
	        this.utilityService = utilityService;
	        /* Declare methods */
	        /**
	         * @ngdoc method
	         * @name ObserverService#attach
	         * @methodOf sdt.models:ObserverService
	         * @param {function} callback the callback function to fire
	         * @param {string} event name of the event
	         * @param {string} id unique id for the object that is listening i.e. namespace
	         * @description adds events listeners
	         */
	        this.attach = function (callback, event, id) {
	            console.log('event attached:' + event);
	            if (!id) {
	                id = _this.utilityService.createID();
	            }
	            if (!_this.observers[event]) {
	                _this.observers[event] = {};
	            }
	            if (!_this.observers[event][id])
	                _this.observers[event][id] = [];
	            _this.observers[event][id].push(callback);
	        };
	        /**
	         * @ngdoc method
	         * @name ObserverService#detachById
	         * @methodOf sdt.models:ObserverService
	         * @param {string} id unique id for the object that is listening i.e. namespace
	         * @description removes all events for a specific id from the observers object
	         */
	        this.detachById = function (id) {
	            for (var event in _this.observers) {
	                _this.detachByEventAndId(event, id);
	            }
	        };
	        /**
	         * @ngdoc method
	         * @name ObserverService#detachById
	         * @methodOf sdt.models:ObserverService
	         * @param {string} event name of the event
	         * @description removes removes all the event from the observer object
	         */
	        this.detachByEvent = function (event) {
	            if (event in _this.observers) {
	                delete _this.observers[event];
	            }
	        };
	        /**
	         * @ngdoc method
	         * @name ObserverService#detachByEventAndId
	         * @methodOf sdt.models:ObserverService
	         * @param {string} event name of the event
	         * @param {string} id unique id for the object that is listening i.e. namespace
	         * @description removes removes all callbacks for an id in a specific event from the observer object
	         */
	        this.detachByEventAndId = function (event, id) {
	            if (event in _this.observers) {
	                if (id in _this.observers[event]) {
	                    delete _this.observers[event][id];
	                }
	            }
	        };
	        /**
	         * @ngdoc method
	         * @name ObserverService#notify
	         * @methodOf sdt.models:ObserverService
	         * @param {string} event name of the event
	         * @param {string|object|array|number} parameters pass whatever your listener is expecting
	         * @description notifies all observers of a specific event
	         */
	        this.notify = function (event, parameters) {
	            console.log('event called:' + event);
	            for (var id in _this.observers[event]) {
	                angular.forEach(_this.observers[event][id], function (callback) {
	                    callback(parameters);
	                });
	            }
	        };
	        this.notifyById = function (event, eventId, parameters) {
	            console.log('event called:' + event);
	            for (var id in _this.observers[event]) {
	                if (id != eventId)
	                    continue;
	                angular.forEach(_this.observers[event][id], function (callback) {
	                    callback(parameters);
	                });
	            }
	        };
	        this.observers = {};
	    }
	    return ObserverService;
	})(baseservice_1.BaseService);
	exports.ObserverService = ObserverService;


/***/ },
/* 19 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var Form = (function () {
	    //@ngInject
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
	            _this.$log.debug('resetting form');
	            _this.$log.debug(form);
	            for (var key in form) {
	                if (angular.isDefined(form[key])
	                    && typeof form[key].$setViewValue == 'function'
	                    && angular.isDefined(form[key].$viewValue)) {
	                    _this.$log.debug(form[key]);
	                    if (angular.isDefined(_this.getPristinePropertyValue(key))) {
	                        form[key].$setViewValue(_this.getPristinePropertyValue(key));
	                    }
	                    else {
	                        form[key].$setViewValue('');
	                    }
	                    form[key].$setUntouched(true);
	                    form[key].$render();
	                    _this.$log.debug(form[key]);
	                }
	            }
	            form.$submitted = false;
	            form.$setPristine();
	            form.$setUntouched();
	        };
	        this.$log = $log;
	        this._forms = {};
	        this._pristinePropertyValue = {};
	    }
	    FormService.$inject = ['$log'];
	    return FormService;
	})();
	exports.FormService = FormService;


/***/ },
/* 20 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var MetaDataService = (function () {
	    //@ngInject
	    function MetaDataService($filter, $log) {
	        var _this = this;
	        this.$filter = $filter;
	        this.$log = $log;
	        this.getPropertiesList = function () {
	            return _this._propertiesList;
	        };
	        this.getPropertiesListByBaseEntityAlias = function (baseEntityAlias) {
	            return _this._propertiesList[baseEntityAlias];
	        };
	        this.setPropertiesList = function (value, key) {
	            _this._propertiesList[key] = value;
	        };
	        this.formatPropertiesList = function (propertiesList, propertyIdentifier) {
	            var simpleGroup = {
	                $$group: 'simple',
	            };
	            propertiesList.data.push(simpleGroup);
	            var drillDownGroup = {
	                $$group: 'drilldown',
	            };
	            propertiesList.data.push(drillDownGroup);
	            var compareCollections = {
	                $$group: 'compareCollections',
	            };
	            propertiesList.data.push(compareCollections);
	            var attributeCollections = {
	                $$group: 'attribute',
	            };
	            propertiesList.data.push(attributeCollections);
	            for (var i in propertiesList.data) {
	                if (angular.isDefined(propertiesList.data[i].ormtype)) {
	                    if (angular.isDefined(propertiesList.data[i].attributeID)) {
	                        propertiesList.data[i].$$group = 'attribute';
	                    }
	                    else {
	                        propertiesList.data[i].$$group = 'simple';
	                    }
	                }
	                if (angular.isDefined(propertiesList.data[i].fieldtype)) {
	                    if (propertiesList.data[i].fieldtype === 'id') {
	                        propertiesList.data[i].$$group = 'simple';
	                    }
	                    if (propertiesList.data[i].fieldtype === 'many-to-one') {
	                        propertiesList.data[i].$$group = 'drilldown';
	                    }
	                    if (propertiesList.data[i].fieldtype === 'many-to-many' || propertiesList.data[i].fieldtype === 'one-to-many') {
	                        propertiesList.data[i].$$group = 'compareCollections';
	                    }
	                }
	                propertiesList.data[i].propertyIdentifier = propertyIdentifier + '.' + propertiesList.data[i].name;
	            }
	            //propertiesList.data = _orderBy(propertiesList.data,['displayPropertyIdentifier'],false);
	            //--------------------------------Removes empty lines from dropdown.
	            var temp = [];
	            for (var i = 0; i <= propertiesList.data.length - 1; i++) {
	                if (propertiesList.data[i].propertyIdentifier.indexOf(".undefined") != -1) {
	                    _this.$log.debug("removing: " + propertiesList.data[i].displayPropertyIdentifier);
	                    propertiesList.data[i].displayPropertyIdentifier = "hide";
	                }
	                else {
	                    temp.push(propertiesList.data[i]);
	                    _this.$log.debug(propertiesList.data[i]);
	                }
	            }
	            temp.sort;
	            propertiesList.data = temp;
	            _this.$log.debug("----------------------PropertyList\n\n\n\n\n");
	            propertiesList.data = _this._orderBy(propertiesList.data, ['propertyIdentifier'], false);
	            //--------------------------------End remove empty lines.
	        };
	        this.orderBy = function (propertiesList, predicate, reverse) {
	            return _this._orderBy(propertiesList, predicate, reverse);
	        };
	        this.$filter = $filter;
	        this.$log = $log;
	        this._propertiesList = {};
	        this._orderBy = $filter('orderBy');
	    }
	    MetaDataService.$inject = [
	        '$filter',
	        '$log'
	    ];
	    return MetaDataService;
	})();
	exports.MetaDataService = MetaDataService;


/***/ },
/* 21 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var RbKeyService = (function () {
	    //@ngInject
	    function RbKeyService($http, $q, appConfig, resourceBundles) {
	        var _this = this;
	        this.$http = $http;
	        this.$q = $q;
	        this.appConfig = appConfig;
	        this.resourceBundles = resourceBundles;
	        this._resourceBundle = {};
	        this._resourceBundleLastModified = '';
	        this._loadingResourceBundle = false;
	        this._loadedResourceBundle = false;
	        this.getRBLoaded = function () {
	            return _this._loadedResourceBundle;
	        };
	        this.rbKey = function (key, replaceStringData) {
	            ////$log.debug('rbkey');
	            ////$log.debug(key);
	            ////$log.debug(this.getConfig().rbLocale);
	            var keyValue = _this.getRBKey(key, _this.appConfig.rbLocale);
	            ////$log.debug(keyValue);
	            return keyValue;
	        };
	        this.getRBKey = function (key, locale, checkedKeys, originalKey) {
	            ////$log.debug('getRBKey');
	            ////$log.debug('loading:'+this._loadingResourceBundle);
	            ////$log.debug('loaded'+this._loadedResourceBundle);
	            if (_this.resourceBundles) {
	                key = key.toLowerCase();
	                checkedKeys = checkedKeys || "";
	                locale = locale || 'en_us';
	                ////$log.debug('locale');
	                ////$log.debug(locale);
	                var keyListArray = key.split(',');
	                ////$log.debug('keylistAray');
	                ////$log.debug(keyListArray);
	                if (keyListArray.length > 1) {
	                    var keyValue = "";
	                    for (var i = 0; i < keyListArray.length; i++) {
	                        keyValue = _this.getRBKey(keyListArray[i], locale, keyValue);
	                        //$log.debug('keyvalue:'+keyValue);
	                        if (keyValue.slice(-8) != "_missing") {
	                            break;
	                        }
	                    }
	                    return keyValue;
	                }
	                var bundle = _this.resourceBundles[locale];
	                if (angular.isDefined(bundle[key])) {
	                    //$log.debug('rbkeyfound:'+bundle[key]);
	                    return bundle[key];
	                }
	                var checkedKeysListArray = checkedKeys.split(',');
	                checkedKeysListArray.push(key + '_' + locale + '_missing');
	                checkedKeys = checkedKeysListArray.join(",");
	                if (angular.isUndefined(originalKey)) {
	                    originalKey = key;
	                }
	                //$log.debug('originalKey:'+key);
	                //$log.debug(checkedKeysListArray);
	                var localeListArray = locale.split('_');
	                //$log.debug(localeListArray);
	                if (localeListArray.length === 2) {
	                    bundle = _this.resourceBundles[localeListArray[0]];
	                    if (angular.isDefined(bundle[key])) {
	                        //$log.debug('rbkey found:'+bundle[key]);
	                        return bundle[key];
	                    }
	                    checkedKeysListArray.push(key + '_' + localeListArray[0] + '_missing');
	                    checkedKeys = checkedKeysListArray.join(",");
	                }
	                var keyDotListArray = key.split('.');
	                if (keyDotListArray.length >= 3
	                    && keyDotListArray[keyDotListArray.length - 2] === 'define') {
	                    var newKey = key.replace(keyDotListArray[keyDotListArray.length - 3] + '.define', 'define');
	                    //$log.debug('newkey1:'+newKey);
	                    return _this.getRBKey(newKey, locale, checkedKeys, originalKey);
	                }
	                else if (keyDotListArray.length >= 2 && keyDotListArray[keyDotListArray.length - 2] !== 'define') {
	                    var newKey = key.replace(keyDotListArray[keyDotListArray.length - 2] + '.', 'define.');
	                    //$log.debug('newkey:'+newKey);
	                    return _this.getRBKey(newKey, locale, checkedKeys, originalKey);
	                }
	                //$log.debug(localeListArray);
	                if (localeListArray[0] !== "en") {
	                    return _this.getRBKey(originalKey, 'en', checkedKeys);
	                }
	                return checkedKeys;
	            }
	            return '';
	        };
	        this.$q = $q;
	        this.$http = $http;
	        this.appConfig = appConfig;
	        this.resourceBundles = resourceBundles;
	    }
	    return RbKeyService;
	})();
	exports.RbKeyService = RbKeyService;


/***/ },
/* 22 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	// interface ISlatwallRootScopeService extends ng.IRootScopeService{
	//     loadedResourceBundle:boolean;
	// 	loadingResourceBundle:boolean;
	// }
	var HibachiService = (function () {
	    //@ngInject
	    function HibachiService($window, $q, $http, $timeout, $log, $rootScope, $location, $anchorScroll, utilityService, formService, rbkeyService, appConfig, _config, _jsEntities, _jsEntityInstances) {
	        var _this = this;
	        this.$window = $window;
	        this.$q = $q;
	        this.$http = $http;
	        this.$timeout = $timeout;
	        this.$log = $log;
	        this.$rootScope = $rootScope;
	        this.$location = $location;
	        this.$anchorScroll = $anchorScroll;
	        this.utilityService = utilityService;
	        this.formService = formService;
	        this.rbkeyService = rbkeyService;
	        this.appConfig = appConfig;
	        this._config = _config;
	        this._jsEntities = _jsEntities;
	        this._jsEntityInstances = _jsEntityInstances;
	        this._deferred = {};
	        this._resourceBundle = {};
	        this.buildUrl = function (action, queryString) {
	            //actionName example: slatAction. defined in FW1 and populated to config
	            var actionName = _this.appConfig.action;
	            var baseUrl = _this.appConfig.baseURL;
	            queryString = queryString || '';
	            if (angular.isDefined(queryString) && queryString.length) {
	                if (queryString.indexOf('&') !== 0) {
	                    queryString = '&' + queryString;
	                }
	            }
	            return baseUrl + '?' + actionName + '=' + action + queryString;
	        };
	        this.getJsEntities = function () {
	            return _this._jsEntities;
	        };
	        this.setJsEntities = function (jsEntities) {
	            _this._jsEntities = jsEntities;
	        };
	        this.getJsEntityInstances = function () {
	            return _this._jsEntityInstances;
	        };
	        this.setJsEntityInstances = function (jsEntityInstances) {
	            _this._jsEntityInstances = jsEntityInstances;
	        };
	        this.getEntityExample = function (entityName) {
	            return _this._jsEntityInstances[entityName];
	        };
	        this.getEntityMetaData = function (entityName) {
	            return _this._jsEntityInstances[entityName].metaData;
	        };
	        this.getPropertyByEntityNameAndPropertyName = function (entityName, propertyName) {
	            return _this.getEntityMetaData(entityName)[propertyName];
	        };
	        this.getPrimaryIDPropertyNameByEntityName = function (entityName) {
	            return _this.getEntityMetaData(entityName).$$getIDName();
	        };
	        this.getEntityHasPropertyByEntityName = function (entityName, propertyName) {
	            return angular.isDefined(_this.getEntityMetaData(entityName)[propertyName]);
	        };
	        this.getPropertyIsObjectByEntityNameAndPropertyIdentifier = function (entityName, propertyIdentifier) {
	            var lastEntity = _this.getLastEntityNameInPropertyIdentifier(entityName, propertyIdentifier);
	            var entityMetaData = _this.getEntityMetaData(lastEntity);
	            return angular.isDefined(entityMetaData[_this.utilityService.listLast(propertyIdentifier, '.')].cfc);
	        };
	        this.getLastEntityNameInPropertyIdentifier = function (entityName, propertyIdentifier) {
	            if (!entityName) {
	                throw ('no entity name supplied');
	            }
	            //strip alias if it exists
	            if (propertyIdentifier.charAt(0) === '_') {
	                propertyIdentifier = _this.utilityService.listRest(propertyIdentifier, '.');
	            }
	            if (propertyIdentifier.split('.').length > 1) {
	                var propertiesStruct = _this.getEntityMetaData(entityName);
	                if (!propertiesStruct[_this.utilityService.listFirst(propertyIdentifier, '.')]
	                    || !propertiesStruct[_this.utilityService.listFirst(propertyIdentifier, '.')].cfc) {
	                    throw ("The Property Identifier " + propertyIdentifier + " is invalid for the entity " + entityName);
	                }
	                var currentEntityName = _this.utilityService.listLast(propertiesStruct[_this.utilityService.listFirst(propertyIdentifier, '.')].cfc, '.');
	                var currentPropertyIdentifier = _this.utilityService.right(propertyIdentifier, propertyIdentifier.length - (_this.utilityService.listFirst(propertyIdentifier, '.').length + 1));
	                return _this.getLastEntityNameInPropertyIdentifier(currentEntityName, currentPropertyIdentifier);
	            }
	            return entityName;
	        };
	        //service method used to transform collection data to collection objects based on a collectionconfig
	        this.populateCollection = function (collectionData, collectionConfig) {
	            //create array to hold objects
	            var entities = [];
	            //loop over all collection data to create objects
	            var hibachiService = _this;
	            angular.forEach(collectionData, function (collectionItemData, key) {
	                //create base Entity
	                var entity = hibachiService['new' + collectionConfig.baseEntityName.replace('Slatwall', '')]();
	                //populate entity with data based on the collectionConfig
	                angular.forEach(collectionConfig.columns, function (column, key) {
	                    //get objects base properties
	                    var propertyIdentifier = column.propertyIdentifier.replace(collectionConfig.baseEntityAlias.toLowerCase() + '.', '');
	                    var propertyIdentifierArray = propertyIdentifier.split('.');
	                    var propertyIdentifierKey = propertyIdentifier.replace(/\./g, '_');
	                    var currentEntity = entity;
	                    angular.forEach(propertyIdentifierArray, function (property, key) {
	                        if (key === propertyIdentifierArray.length - 1) {
	                            //if we are on the last item in the array
	                            if (angular.isObject(collectionItemData[propertyIdentifierKey]) && currentEntity.metaData[property].fieldtype === 'many-to-one') {
	                                var relatedEntity = hibachiService['new' + currentEntity.metaData[property].cfc]();
	                                relatedEntity.$$init(collectionItemData[propertyIdentifierKey][0]);
	                                currentEntity['$$set' + currentEntity.metaData[property].name.charAt(0).toUpperCase() + currentEntity.metaData[property].name.slice(1)](relatedEntity);
	                            }
	                            else if (angular.isArray(collectionItemData[propertyIdentifierKey]) && (currentEntity.metaData[property].fieldtype === 'one-to-many')) {
	                                angular.forEach(collectionItemData[propertyIdentifierKey], function (arrayItem, key) {
	                                    var relatedEntity = hibachiService['new' + currentEntity.metaData[property].cfc]();
	                                    relatedEntity.$$init(arrayItem);
	                                    currentEntity['$$add' + currentEntity.metaData[property].singularname.charAt(0).toUpperCase() + currentEntity.metaData[property].singularname.slice(1)](relatedEntity);
	                                });
	                            }
	                            else {
	                                currentEntity.data[property] = collectionItemData[propertyIdentifierKey];
	                            }
	                        }
	                        else {
	                            var propertyMetaData = currentEntity.metaData[property];
	                            if (angular.isUndefined(currentEntity.data[property])) {
	                                if (propertyMetaData.fieldtype === 'one-to-many') {
	                                    relatedEntity = [];
	                                }
	                                else {
	                                    relatedEntity = hibachiService['new' + propertyMetaData.cfc]();
	                                }
	                            }
	                            else {
	                                relatedEntity = currentEntity.data[property];
	                            }
	                            currentEntity['$$set' + propertyMetaData.name.charAt(0).toUpperCase() + propertyMetaData.name.slice(1)](relatedEntity);
	                            currentEntity = relatedEntity;
	                        }
	                    });
	                });
	                entities.push(entity);
	            });
	            return entities;
	        };
	        /*basic entity getter where id is optional, returns a promise*/
	        this.getDefer = function (deferKey) {
	            return _this._deferred[deferKey];
	        };
	        this.cancelPromise = function (deferKey) {
	            var deferred = _this.getDefer(deferKey);
	            if (angular.isDefined(deferred)) {
	                deferred.resolve({ messages: [{ messageType: 'error', message: 'User Cancelled' }] });
	            }
	        };
	        this.newEntity = function (entityName) {
	            return new _this._jsEntities[entityName];
	        };
	        /*basic entity getter where id is optional, returns a promise*/
	        this.getEntity = function (entityName, options) {
	            /*
	                *
	                * getEntity('Product', '12345-12345-12345-12345');
	                * getEntity('Product', {keywords='Hello'});
	                *
	                */
	            if (angular.isUndefined(options)) {
	                options = {};
	            }
	            if (angular.isDefined(options.deferKey)) {
	                _this.cancelPromise(options.deferKey);
	            }
	            var params = {};
	            if (typeof options === 'string') {
	                var urlString = _this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.get&entityName=' + entityName + '&entityID=' + options;
	            }
	            else {
	                params['P:Current'] = options.currentPage || 1;
	                params['P:Show'] = options.pageShow || 10;
	                params.keywords = options.keywords || '';
	                params.columnsConfig = options.columnsConfig || '';
	                params.filterGroupsConfig = options.filterGroupsConfig || '';
	                params.joinsConfig = options.joinsConfig || '';
	                params.orderByConfig = options.orderByConfig || '';
	                params.groupBysConfig = options.groupBysConfig || '';
	                params.isDistinct = options.isDistinct || false;
	                params.propertyIdentifiersList = options.propertyIdentifiersList || '';
	                params.allRecords = options.allRecords || '';
	                params.defaultColumns = options.defaultColumns || true;
	                params.processContext = options.processContext || '';
	                console.log(_this.appConfig);
	                console.log(_this.appConfig);
	                var urlString = _this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.get&entityName=' + entityName;
	            }
	            var deferred = _this.$q.defer();
	            if (angular.isDefined(options.id)) {
	                urlString += '&entityId=' + options.id;
	            }
	            /*var transformRequest = (data) => {
	    
	                return data;
	            };
	            //check if we are using a service to transform the request
	            if(angular.isDefined(options.transformRequest)) => {
	                transformRequest=options.trasformRequest;
	            }*/
	            var transformResponse = function (data) {
	                if (angular.isString(data)) {
	                    data = JSON.parse(data);
	                }
	                return data;
	            };
	            //check if we are using a service to transform the response
	            if (angular.isDefined(options.transformResponse)) {
	                transformResponse = function (data) {
	                    var data = JSON.parse(data);
	                    if (angular.isDefined(data.records)) {
	                        data = options.transformResponse(data.records);
	                    }
	                    return data;
	                };
	            }
	            _this.$http.get(urlString, {
	                params: params,
	                timeout: deferred.promise,
	                //transformRequest:transformRequest,
	                transformResponse: transformResponse
	            })
	                .success(function (data) {
	                deferred.resolve(data);
	            }).error(function (reason) {
	                deferred.reject(reason);
	            });
	            if (options.deferKey) {
	                _this._deferred[options.deferKey] = deferred;
	            }
	            return deferred.promise;
	        };
	        this.getResizedImageByProfileName = function (profileName, skuIDs) {
	            var deferred = _this.$q.defer();
	            return _this.$http.get(_this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.getResizedImageByProfileName&profileName=' + profileName + '&skuIDs=' + skuIDs)
	                .success(function (data) {
	                deferred.resolve(data);
	            }).error(function (reason) {
	                deferred.reject(reason);
	            });
	        };
	        this.getEventOptions = function (entityName) {
	            var deferred = _this.$q.defer();
	            var urlString = _this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.getEventOptionsByEntityName&entityName=' + entityName;
	            _this.$http.get(urlString)
	                .success(function (data) {
	                deferred.resolve(data);
	            }).error(function (reason) {
	                deferred.reject(reason);
	            });
	            return deferred.promise;
	        };
	        this.checkUniqueOrNullValue = function (object, property, value) {
	            return _this.$http.get(_this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.getValidationPropertyStatus&object=' + object + '&propertyidentifier=' + property +
	                '&value=' + escape(value)).then(function (results) {
	                return results.data.uniqueStatus;
	            });
	        };
	        this.checkUniqueValue = function (object, property, value) {
	            return _this.$http.get(_this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.getValidationPropertyStatus&object=' + object + '&propertyidentifier=' + property +
	                '&value=' + escape(value)).then(function (results) {
	                return results.data.uniqueStatus;
	            });
	        };
	        this.getPropertyDisplayData = function (entityName, options) {
	            var deferred = _this.$q.defer();
	            var urlString = _this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.getPropertyDisplayData&entityName=' + entityName;
	            var params = {};
	            params.propertyIdentifiersList = options.propertyIdentifiersList || '';
	            _this.$http.get(urlString, { params: params })
	                .success(function (data) {
	                deferred.resolve(data);
	            }).error(function (reason) {
	                deferred.reject(reason);
	            });
	            return deferred.promise;
	        };
	        this.getPropertyDisplayOptions = function (entityName, options) {
	            var deferred = _this.$q.defer();
	            var urlString = _this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.getPropertyDisplayOptions&entityName=' + entityName;
	            var params = {};
	            params.property = options.property || '';
	            if (angular.isDefined(options.argument1)) {
	                params.argument1 = options.argument1;
	            }
	            _this.$http.get(urlString, { params: params })
	                .success(function (data) {
	                deferred.resolve(data);
	            }).error(function (reason) {
	                deferred.reject(reason);
	            });
	            return deferred.promise;
	        };
	        this.saveEntity = function (entityName, id, params, context) {
	            //$log.debug('save'+ entityName);
	            var deferred = _this.$q.defer();
	            var urlString = _this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.post';
	            if (angular.isDefined(entityName)) {
	                params.entityName = entityName;
	            }
	            if (angular.isDefined(id)) {
	                params.entityID = id;
	            }
	            if (angular.isDefined(context)) {
	                params.context = context;
	            }
	            _this.$http({
	                url: urlString,
	                method: 'POST',
	                data: $.param(params),
	                headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
	            })
	                .success(function (data) {
	                deferred.resolve(data);
	            }).error(function (reason) {
	                deferred.reject(reason);
	            });
	            return deferred.promise;
	        };
	        this.getExistingCollectionsByBaseEntity = function (entityName) {
	            var deferred = _this.$q.defer();
	            var urlString = _this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.getExistingCollectionsByBaseEntity&entityName=' + entityName;
	            _this.$http.get(urlString)
	                .success(function (data) {
	                deferred.resolve(data);
	            }).error(function (reason) {
	                deferred.reject(reason);
	            });
	            return deferred.promise;
	        };
	        this.getFilterPropertiesByBaseEntityName = function (entityName) {
	            var deferred = _this.$q.defer();
	            var urlString = _this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.getFilterPropertiesByBaseEntityName&EntityName=' + entityName;
	            _this.$http.get(urlString)
	                .success(function (data) {
	                deferred.resolve(data);
	            }).error(function (reason) {
	                deferred.reject(reason);
	            });
	            return deferred.promise;
	        };
	        this.login = function (emailAddress, password) {
	            var deferred = _this.$q.defer();
	            var urlString = _this.appConfig.baseURL + '/index.cfm/api/auth/login';
	            var params = {
	                emailAddress: emailAddress,
	                password: password
	            };
	            return _this.$http.get(urlString, { params: params }).success(function (response) {
	                deferred.resolve(response);
	            }).error(function (response) {
	                deferred.reject(response);
	            });
	        };
	        this.getResourceBundle = function (locale) {
	            var deferred = _this.$q.defer();
	            var locale = locale || _this.appConfig.rbLocale;
	            if (_this._resourceBundle[locale]) {
	                return _this._resourceBundle[locale];
	            }
	            var urlString = _this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.getResourceBundle&instantiationKey=' + _this.appConfig.instantiationKey + '&locale=' + locale;
	            _this.$http({
	                url: urlString,
	                method: "GET"
	            }).success(function (response, status, headersGetter) {
	                _this._resourceBundle[locale] = response.data;
	                deferred.resolve(response);
	            }).error(function (response) {
	                _this._resourceBundle[locale] = {};
	                deferred.reject(response);
	            });
	            return deferred.promise;
	        };
	        this.getCurrencies = function () {
	            var deferred = _this.$q.defer();
	            var urlString = _this.appConfig.baseURL + '/index.cfm/?' + _this.appConfig.action + '=api:main.getCurrencies&instantiationKey=' + _this.appConfig.instantiationKey;
	            _this.$http.get(urlString).success(function (response) {
	                deferred.resolve(response);
	            }).error(function (response) {
	                deferred.reject(response);
	            });
	            return deferred.promise;
	        };
	        this.getConfig = function () {
	            return _this._config;
	        };
	        this.getConfigValue = function (key) {
	            return _this._config[key];
	        };
	        this.setConfigValue = function (key, value) {
	            _this._config[key] = value;
	        };
	        this.setConfig = function (config) {
	            _this._config = config;
	        };
	        this.$window = $window;
	        this.$q = $q;
	        this.$http = $http;
	        this.$timeout = $timeout;
	        this.$log = $log;
	        this.$rootScope = $rootScope;
	        this.$location = $location;
	        this.$anchorScroll = $anchorScroll;
	        this.utilityService = utilityService;
	        this.formService = formService;
	        this.rbkeyService = rbkeyService;
	        this.appConfig = appConfig;
	        this._config = _config;
	        this._jsEntities = _jsEntities;
	        this._jsEntityInstances = _jsEntityInstances;
	    }
	    return HibachiService;
	})();
	exports.HibachiService = HibachiService;
	var $Hibachi = (function () {
	    //@ngInject
	    function $Hibachi(appConfig) {
	        var _this = this;
	        this._config = {};
	        this.angular = angular;
	        this.setJsEntities = function (jsEntities) {
	            _this._jsEntities = jsEntities;
	        };
	        this.getConfig = function () {
	            return _this._config;
	        };
	        this.getConfigValue = function (key) {
	            return _this._config[key];
	        };
	        this.setConfigValue = function (key, value) {
	            _this._config[key] = value;
	        };
	        this.setConfig = function (config) {
	            _this._config = config;
	        };
	        this._config = appConfig;
	        this.$get.$inject = [
	            '$window',
	            '$q',
	            '$http',
	            '$timeout',
	            '$log',
	            '$rootScope',
	            '$location',
	            '$anchorScroll',
	            'utilityService',
	            'formService',
	            'rbkeyService',
	            'appConfig'
	        ];
	    }
	    $Hibachi.prototype.$get = function ($window, $q, $http, $timeout, $log, $rootScope, $location, $anchorScroll, utilityService, formService, rbkeyService, appConfig) {
	        return new HibachiService($window, $q, $http, $timeout, $log, $rootScope, $location, $anchorScroll, utilityService, formService, rbkeyService, appConfig, this._config, this._jsEntities, this._jsEntityInstances);
	    };
	    return $Hibachi;
	})();
	exports.$Hibachi = $Hibachi;


/***/ },
/* 23 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var GlobalSearchController = (function () {
	    //@ngInject
	    function GlobalSearchController($scope, $log, $window, $timeout, $hibachi, rbkeyService) {
	        $scope.keywords = '';
	        $scope.searchResultsOpen = false;
	        $scope.sidebarClass = 'sidebar';
	        $scope.loading = false; //Set loading wheel to false
	        $scope.resultsFound = true; // Set the results Found to true because no search has been done yet
	        $scope.searchResults = {
	            'product': {
	                'title': 'Products',
	                'resultNameFilter': function (data) {
	                    return data['productName'];
	                },
	                'results': [],
	                'id': function (data) {
	                    return data['productID'];
	                }
	            },
	            'brand': {
	                'title': rbkeyService.getRBKey('entity.Brands'),
	                'resultNameFilter': function (data) {
	                    return data['brandName'];
	                },
	                'results': [],
	                'id': function (data) {
	                    return data['brandID'];
	                }
	            },
	            'account': {
	                'title': 'Accounts',
	                'resultNameFilter': function (data) {
	                    return data['firstName'] + ' ' + data['lastName'];
	                },
	                'results': [],
	                'id': function (data) {
	                    return data['accountID'];
	                }
	            },
	            'vendor': {
	                'title': 'Vendors',
	                'resultNameFilter': function (data) {
	                    return data['vendorName'];
	                },
	                'results': [],
	                'id': function (data) {
	                    return data['vendorID'];
	                }
	            }
	        };
	        var _timeoutPromise;
	        var _loadingCount = 0;
	        $scope.updateSearchResults = function () {
	            $scope.loading = true;
	            $scope.showResults();
	            if (_timeoutPromise) {
	                $timeout.cancel(_timeoutPromise);
	            }
	            _timeoutPromise = $timeout(function () {
	                // If no keywords, then set everything back to their defaults
	                if ($scope.keywords === '') {
	                    $scope.hideResults();
	                }
	                else {
	                    $scope.showResults();
	                    // Set the loadingCount to the number of AJAX Calls we are about to do
	                    _loadingCount = Object.keys($scope.searchResults).length;
	                    for (var entityName in $scope.searchResults) {
	                        (function (entityName) {
	                            var searchPromise = $hibachi.getEntity(entityName, { keywords: $scope.keywords, pageShow: 4, deferkey: 'global-search-' + entityName });
	                            searchPromise.then(function (data) {
	                                // Clear out the old Results
	                                $scope.searchResults[entityName].results = [];
	                                $scope.searchResults[entityName].title = rbkeyService.getRBKey('entity.' + entityName.toLowerCase() + '_plural');
	                                // push in the new results
	                                for (var i in data.pageRecords) {
	                                    $scope.searchResults[entityName].results.push({
	                                        'name': $scope.searchResults[entityName].resultNameFilter(data.pageRecords[i]),
	                                        'link': $hibachi.buildUrl('entity.detail' + entityName) + '&' + entityName + 'ID=' + $scope.searchResults[entityName].id(data.pageRecords[i]),
	                                    });
	                                }
	                                // Increment Down The Loading Count
	                                _loadingCount--;
	                                // If the loadingCount drops to 0, then we can update scope
	                                if (_loadingCount == 0) {
	                                    $scope.loading = false;
	                                    var _foundResults = false;
	                                    for (var _thisEntityName in $scope.searchResults) {
	                                        if ($scope.searchResults[_thisEntityName].results.length) {
	                                            _foundResults = true;
	                                            break;
	                                        }
	                                    }
	                                    $scope.resultsFound = _foundResults;
	                                }
	                            });
	                        })(entityName);
	                    }
	                }
	            }, 500);
	        };
	        $scope.showResults = function () {
	            $scope.searchResultsOpen = true;
	            $scope.sidebarClass = 'sidebar s-search-width';
	            $window.onclick = function (event) {
	                var _targetClassOfSearch = event.target.parentElement.offsetParent.classList.contains('sidebar');
	                if (!_targetClassOfSearch) {
	                    $scope.hideResults();
	                    $scope.$apply();
	                }
	            };
	        };
	        $scope.hideResults = function () {
	            $scope.searchResultsOpen = false;
	            $scope.sidebarClass = 'sidebar';
	            $scope.search.$setPristine();
	            $scope.keywords = "";
	            $window.onclick = null;
	            $scope.loading = false;
	            $scope.resultsFound = true;
	            for (var entityName in $scope.searchResults) {
	                $scope.searchResults[entityName].results = [];
	            }
	        };
	    }
	    return GlobalSearchController;
	})();
	exports.GlobalSearchController = GlobalSearchController;


/***/ },
/* 24 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var PercentageFilter = (function () {
	    function PercentageFilter() {
	    }
	    PercentageFilter.Factory = function () {
	        return function (input, decimals, suffix) {
	            decimals = angular.isNumber(decimals) ? decimals : 3;
	            suffix = suffix || '%';
	            if (isNaN(input)) {
	                return '';
	            }
	            return Math.round(input * Math.pow(10, decimals + 2)) / Math.pow(10, decimals) + suffix;
	        };
	    };
	    return PercentageFilter;
	})();
	exports.PercentageFilter = PercentageFilter;


/***/ },
/* 25 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var EntityRBKey = (function () {
	    function EntityRBKey() {
	    }
	    //@ngInject
	    EntityRBKey.Factory = function (rbkeyService) {
	        return function (text) {
	            if (angular.isDefined(text) && angular.isString(text)) {
	                text = text.replace('_', '').toLowerCase();
	                text = rbkeyService.getRBKey('entity.' + text);
	            }
	            return text;
	        };
	    };
	    return EntityRBKey;
	})();
	exports.EntityRBKey = EntityRBKey;


/***/ },
/* 26 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWActionCallerController = (function () {
	    //@ngInject
	    function SWActionCallerController($scope, $element, $templateRequest, $compile, corePartialsPath, utilityService, $hibachi, rbkeyService, hibachiPathBuilder) {
	        var _this = this;
	        this.$scope = $scope;
	        this.$element = $element;
	        this.$templateRequest = $templateRequest;
	        this.$compile = $compile;
	        this.corePartialsPath = corePartialsPath;
	        this.utilityService = utilityService;
	        this.$hibachi = $hibachi;
	        this.rbkeyService = rbkeyService;
	        this.init = function () {
	            //			this.class = this.utilityService.replaceAll(this.utilityService.replaceAll(this.getAction(),':',''),'.','') + ' ' + this.class;
	            _this.type = _this.type || 'link';
	            if (_this.type == "button" || _this.type == "submit" || _this.isPublic) {
	                //handle submit.
	                /** in order to attach the correct controller to local vm, we need a watch to bind */
	                var unbindWatcher = _this.$scope.$watch(function () { return _this.$scope.formController; }, function (newValue, oldValue) {
	                    if (newValue !== undefined) {
	                        _this.formCtrl = newValue;
	                        unbindWatcher();
	                    }
	                });
	            }
	            //			this.actionItem = this.getActionItem();
	            //			this.actionItemEntityName = this.getActionItemEntityName();
	            //			this.text = this.getText();
	            //			if(this.getDisabled()){
	            //				this.getDisabledText();
	            //			}else if(this.getConfirm()){
	            //				this.getConfirmText();
	            //			}
	            //
	            //			if(this.modalFullWidth && !this.getDisabled()){
	            //				this.class = this.class + " modalload-fullwidth";
	            //			}
	            //
	            //			if(this.modal && !this.getDisabled() && !this.modalFullWidth){
	            //				this.class = this.class + " modalload";
	            //			}
	            /*need authentication lookup by api to disable
	            <cfif not attributes.hibachiScope.authenticateAction(action=attributes.action)>
	                <cfset attributes.class &= " disabled" />
	            </cfif>
	            */
	        };
	        /** submit function delegates back to the form */
	        this.submit = function () {
	            _this.formCtrl.submit(_this.action);
	        };
	        this.getAction = function () {
	            return _this.action || '';
	        };
	        this.getActionItem = function () {
	            return _this.utilityService.listLast(_this.getAction(), '.');
	        };
	        this.getActionItemEntityName = function () {
	            var firstFourLetters = _this.utilityService.left(_this.actionItem, 4);
	            var firstSixLetters = _this.utilityService.left(_this.actionItem, 6);
	            var minus4letters = _this.utilityService.right(_this.actionItem, 4);
	            var minus6letters = _this.utilityService.right(_this.actionItem, 6);
	            var actionItemEntityName = "";
	            if (firstFourLetters === 'list' && _this.actionItem.length > 4) {
	                actionItemEntityName = minus4letters;
	            }
	            else if (firstFourLetters === 'edit' && _this.actionItem.length > 4) {
	                actionItemEntityName = minus4letters;
	            }
	            else if (firstFourLetters === 'save' && _this.actionItem.length > 4) {
	                actionItemEntityName = minus4letters;
	            }
	            else if (firstSixLetters === 'create' && _this.actionItem.length > 6) {
	                actionItemEntityName = minus6letters;
	            }
	            else if (firstSixLetters === 'detail' && _this.actionItem.length > 6) {
	                actionItemEntityName = minus6letters;
	            }
	            else if (firstSixLetters === 'delete' && _this.actionItem.length > 6) {
	                actionItemEntityName = minus6letters;
	            }
	            return actionItemEntityName;
	        };
	        this.getTitle = function () {
	            //if title is undefined then use text
	            if (angular.isUndefined(_this.title) || !_this.title.length) {
	                _this.title = _this.getText();
	            }
	            return _this.title;
	        };
	        this.getTextByRBKeyByAction = function (actionItemType, plural) {
	            if (plural === void 0) { plural = false; }
	            var navRBKey = _this.rbkeyService.getRBKey('admin.define.' + actionItemType + '_nav');
	            var entityRBKey = '';
	            var replaceKey = '';
	            if (plural) {
	                entityRBKey = _this.rbkeyService.getRBKey('entity.' + _this.actionItemEntityName + '_plural');
	                replaceKey = '${itemEntityNamePlural}';
	            }
	            else {
	                entityRBKey = _this.rbkeyService.getRBKey('entity.' + _this.actionItemEntityName);
	                replaceKey = '${itemEntityName}';
	            }
	            return _this.utilityService.replaceAll(navRBKey, replaceKey, entityRBKey);
	        };
	        this.getText = function () {
	            //if we don't have text then make it up based on rbkeys
	            if (angular.isUndefined(_this.text) || (angular.isDefined(_this.text) && !_this.text.length)) {
	                _this.text = _this.rbkeyService.getRBKey(_this.utilityService.replaceAll(_this.getAction(), ":", ".") + '_nav');
	                var minus8letters = _this.utilityService.right(_this.text, 8);
	                //if rbkey is still missing. then can we infer it
	                if (minus8letters === '_missing') {
	                    var firstFourLetters = _this.utilityService.left(_this.actionItem, 4);
	                    var firstSixLetters = _this.utilityService.left(_this.actionItem, 6);
	                    var minus4letters = _this.utilityService.right(_this.actionItem, 4);
	                    var minus6letters = _this.utilityService.right(_this.actionItem, 6);
	                    if (firstFourLetters === 'list' && _this.actionItem.length > 4) {
	                        _this.text = _this.getTextByRBKeyByAction('list', true);
	                    }
	                    else if (firstFourLetters === 'edit' && _this.actionItem.length > 4) {
	                        _this.text = _this.getTextByRBKeyByAction('edit', false);
	                    }
	                    else if (firstFourLetters === 'save' && _this.actionItem.length > 4) {
	                        _this.text = _this.getTextByRBKeyByAction('save', false);
	                    }
	                    else if (firstSixLetters === 'create' && _this.actionItem.length > 6) {
	                        _this.text = _this.getTextByRBKeyByAction('create', false);
	                    }
	                    else if (firstSixLetters === 'detail' && _this.actionItem.length > 6) {
	                        _this.text = _this.getTextByRBKeyByAction('detail', false);
	                    }
	                    else if (firstSixLetters === 'delete' && _this.actionItem.length > 6) {
	                        _this.text = _this.getTextByRBKeyByAction('delete', false);
	                    }
	                }
	                if (_this.utilityService.right(_this.text, 8)) {
	                    _this.text = _this.rbkeyService.getRBKey(_this.utilityService.replaceAll(_this.getAction(), ":", "."));
	                }
	            }
	            if (!_this.title || (_this.title && !_this.title.length)) {
	                _this.title = _this.text;
	            }
	            return _this.text;
	        };
	        this.getDisabled = function () {
	            //if item is disabled
	            if (angular.isDefined(_this.disabled) && _this.disabled) {
	                return true;
	            }
	            else {
	                return false;
	            }
	        };
	        this.getDisabledText = function () {
	            if (_this.getDisabled()) {
	                //and no disabled text specified
	                if (angular.isUndefined(_this.disabledtext) || !_this.disabledtext.length) {
	                    var disabledrbkey = _this.utilityService.replaceAll(_this.action, ':', '.') + '_disabled';
	                    _this.disabledtext = _this.rbkeyService.getRBKey(disabledrbkey);
	                }
	                //add disabled class
	                _this.class += " btn-disabled";
	                _this.confirm = false;
	                return _this.disabledtext;
	            }
	            return "";
	        };
	        this.getConfirm = function () {
	            if (angular.isDefined(_this.confirm) && _this.confirm) {
	                return true;
	            }
	            else {
	                return false;
	            }
	        };
	        this.getConfirmText = function () {
	            if (_this.getConfirm()) {
	                if (angular.isUndefined(_this.confirmtext) && _this.confirmtext.length) {
	                    var confirmrbkey = _this.utilityService.replaceAll(_this.action, ':', '.') + '_confirm';
	                    _this.confirmtext = _this.rbkeyService.getRBKey(confirmrbkey);
	                }
	                _this.class += " alert-confirm";
	                return _this.confirm;
	            }
	            return "";
	        };
	        this.$scope = $scope;
	        this.$element = $element;
	        this.$templateRequest = $templateRequest;
	        this.$compile = $compile;
	        this.rbkeyService = rbkeyService;
	        this.$hibachi = $hibachi;
	        this.utilityService = utilityService;
	        this.hibachiPathBuilder = hibachiPathBuilder;
	        this.$templateRequest(this.hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "actioncaller.html").then(function (html) {
	            var template = angular.element(html);
	            _this.$element.parent().append(template);
	            $compile(template)($scope);
	            //need to perform init after promise completes
	            _this.init();
	        });
	    }
	    return SWActionCallerController;
	})();
	exports.SWActionCallerController = SWActionCallerController;
	var SWActionCaller = (function () {
	    function SWActionCaller() {
	        this.restrict = 'EA';
	        this.scope = {};
	        this.bindToController = {
	            action: "@",
	            text: "@",
	            type: "@",
	            queryString: "@",
	            title: "@",
	            'class': "@",
	            icon: "@",
	            iconOnly: "=",
	            name: "@",
	            confirm: "=",
	            confirmtext: "@",
	            disabled: "=",
	            disabledtext: "@",
	            modal: "=",
	            modalFullWidth: "=",
	            id: "@",
	            isPublic: "@?"
	        };
	        this.controller = SWActionCallerController;
	        this.controllerAs = "swActionCaller";
	        this.require = "^?swForm";
	        this.link = function (scope, element, attrs, formController) {
	            if (angular.isDefined(formController)) {
	                scope.formController = formController;
	            }
	        };
	    }
	    SWActionCaller.Factory = function () {
	        var directive = function () { return new SWActionCaller(); };
	        return directive;
	    };
	    return SWActionCaller;
	})();
	exports.SWActionCaller = SWActionCaller;


/***/ },
/* 27 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWTypeaheadSearchController = (function () {
	    // @ngInject
	    function SWTypeaheadSearchController($scope, $q, $transclude, $hibachi, $timeout, utilityService, collectionConfigService) {
	        var _this = this;
	        this.$scope = $scope;
	        this.$q = $q;
	        this.$transclude = $transclude;
	        this.$hibachi = $hibachi;
	        this.$timeout = $timeout;
	        this.utilityService = utilityService;
	        this.collectionConfigService = collectionConfigService;
	        this.searchText = "";
	        this.results = [];
	        this.displayList = [];
	        this.hideSearch = true;
	        this.clearSearch = function () {
	            _this.searchText = "";
	            _this.hideSearch = true;
	        };
	        this.toggleOptions = function () {
	            if (_this.hideSearch && !_this.searchText.length) {
	                _this.search(_this.searchText);
	            }
	            else {
	                _this.hideSearch = !_this.hideSearch;
	            }
	        };
	        this.search = function (search) {
	            if (_this._timeoutPromise) {
	                _this.$timeout.cancel(_this._timeoutPromise);
	            }
	            _this.typeaheadCollectionConfig.setKeywords(search);
	            if (angular.isDefined(_this.filterGroupsConfig)) {
	                //allows for filtering on search text
	                var filterConfig = _this.filterGroupsConfig.replace("replaceWithSearchString", search);
	                filterConfig = filterConfig.trim();
	                _this.typeaheadCollectionConfig.loadFilterGroups(JSON.parse(filterConfig));
	            }
	            if (search.length > 2) {
	                _this._timeoutPromise = _this.$timeout(function () {
	                    var promise = _this.typeaheadCollectionConfig.getEntity();
	                    promise.then(function (response) {
	                        if (angular.isDefined(_this.allRecords) && _this.allRecords == false) {
	                            _this.results = response.pageRecords;
	                        }
	                        else {
	                            _this.results = response.records;
	                        }
	                        //Custom method for gravatar on accounts (non-persistant-property)
	                        //if(angular.isDefined(this.results) && this.entity == "Account"){
	                        //	angular.forEach(this.results,(account)=>{
	                        //		account.gravatar = "http://www.gravatar.com/avatar/" + md5(account.primaryEmailAddress_emailAddress.toLowerCase().trim());
	                        //	});
	                        //}
	                    }).finally(function () {
	                        _this.resultsDeferred.resolve();
	                        _this.hideSearch = false;
	                    });
	                }, 500);
	            }
	            else if (search.length == 0) {
	                _this._timeoutPromise = _this.$timeout(function () {
	                    var promise = _this.typeaheadCollectionConfig.getEntity();
	                    promise.then(function (response) {
	                        if (angular.isDefined(_this.allRecords) && _this.allRecords == false) {
	                            _this.results = response.pageRecords;
	                        }
	                        else {
	                            _this.results = response.records;
	                        }
	                    }).finally(function () {
	                        _this.resultsDeferred.resolve();
	                        _this.hideSearch = false;
	                    });
	                });
	            }
	            else {
	                _this.results = [];
	                _this.hideSearch = true;
	            }
	        };
	        this.addItem = function (item) {
	            if (!_this.hideSearch) {
	                _this.hideSearch = true;
	            }
	            if (angular.isDefined(_this.displayList)) {
	                _this.searchText = item[_this.displayList[0]];
	            }
	            if (angular.isDefined(_this.addFunction)) {
	                _this.addFunction()(item);
	            }
	        };
	        this.addButtonItem = function () {
	            if (!_this.hideSearch) {
	                _this.hideSearch = true;
	            }
	            if (angular.isDefined(_this.addButtonFunction)) {
	                _this.addButtonFunction()(_this.searchText);
	            }
	        };
	        this.closeThis = function (clickOutsideArgs) {
	            _this.hideSearch = true;
	            if (angular.isDefined(clickOutsideArgs)) {
	                for (var callBackAction in clickOutsideArgs.callBackActions) {
	                    clickOutsideArgs.callBackActions[callBackAction]();
	                }
	            }
	        };
	        this.resultsDeferred = $q.defer();
	        this.resultsPromise = this.resultsDeferred.promise;
	        if (angular.isDefined(this.collectionConfig)) {
	            this.typeaheadCollectionConfig = this.collectionConfig;
	        }
	        else if (angular.isDefined(this.entity)) {
	            this.typeaheadCollectionConfig = collectionConfigService.newCollectionConfig(this.entity);
	        }
	        else {
	            throw ("You did not pass the correct collection config data to swTypeaheadSearch");
	        }
	        if (angular.isDefined(this.propertiesToDisplay)) {
	            this.displayList = this.propertiesToDisplay.split(",");
	        }
	        //init timeoutPromise for link
	        this._timeoutPromise = this.$timeout(function () { }, 500);
	        //populate the displayList
	        this.$transclude = this.$transclude;
	        this.$transclude($scope, function () { });
	        this.typeaheadCollectionConfig.addDisplayProperty(this.utilityService.arrayToList(this.displayList));
	        if (angular.isDefined(this.allRecords)) {
	            this.typeaheadCollectionConfig.setAllRecords(this.allRecords);
	        }
	        else {
	            this.typeaheadCollectionConfig.setAllRecords(true);
	        }
	    }
	    return SWTypeaheadSearchController;
	})();
	exports.SWTypeaheadSearchController = SWTypeaheadSearchController;
	var SWTypeaheadSearch = (function () {
	    function SWTypeaheadSearch($hibachi, $compile, $timeout, utilityService, collectionConfigService, corePartialsPath, hibachiPathBuilder) {
	        var _this = this;
	        this.$hibachi = $hibachi;
	        this.$compile = $compile;
	        this.$timeout = $timeout;
	        this.utilityService = utilityService;
	        this.collectionConfigService = collectionConfigService;
	        this.corePartialsPath = corePartialsPath;
	        this.transclude = true;
	        this.restrict = "EA";
	        this.scope = {};
	        this.bindToController = {
	            collectionConfig: "=?",
	            entity: "@?",
	            properties: "@?",
	            propertiesToDisplay: "@?",
	            filterGroupsConfig: "@?",
	            placeholderText: "@?",
	            searchText: "=?",
	            results: "=?",
	            addFunction: "&?",
	            addButtonFunction: "&?",
	            hideSearch: "=?",
	            clickOutsideArguments: "=?"
	        };
	        this.controller = SWTypeaheadSearchController;
	        this.controllerAs = "swTypeaheadSearch";
	        this.link = function (scope, element, attrs, controller, transclude) {
	            var target = element.find(".dropdown-menu");
	            var listItemTemplate = angular.element('<li ng-repeat="item in swTypeaheadSearch.results"></li>');
	            var actionTemplate = angular.element('<a ng-click="swTypeaheadSearch.addItem(item)" ></a>');
	            var transcludeContent = transclude(scope, function () { });
	            actionTemplate.append(transcludeContent);
	            listItemTemplate.append(actionTemplate);
	            scope.swTypeaheadSearch.resultsPromise.then(function () {
	                target.append(_this.$compile(listItemTemplate)(scope));
	            });
	        };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "typeaheadsearch.html";
	    }
	    SWTypeaheadSearch.Factory = function () {
	        var directive = function ($hibachi, $compile, $timeout, utilityService, collectionConfigService, corePartialsPath, hibachiPathBuilder) {
	            return new SWTypeaheadSearch($hibachi, $compile, $timeout, utilityService, collectionConfigService, corePartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = ["$hibachi", "$compile", "$timeout", "utilityService", "collectionConfigService", "corePartialsPath",
	            'hibachiPathBuilder'];
	        return directive;
	    };
	    SWTypeaheadSearch.$inject = ["$hibachi", "$timeout", "collectionConfigService", "corePartialsPath",
	        'hibachiPathBuilder'];
	    return SWTypeaheadSearch;
	})();
	exports.SWTypeaheadSearch = SWTypeaheadSearch;


/***/ },
/* 28 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	var SWTypeaheadSearchLineItemController = (function () {
	    function SWTypeaheadSearchLineItemController() {
	        this.init = function () {
	        };
	        this.init();
	    }
	    return SWTypeaheadSearchLineItemController;
	})();
	exports.SWTypeaheadSearchLineItemController = SWTypeaheadSearchLineItemController;
	var SWTypeaheadSearchLineItem = (function () {
	    function SWTypeaheadSearchLineItem(utilityService) {
	        this.utilityService = utilityService;
	        this.restrict = 'EA';
	        this.scope = true;
	        this.bindToController = {
	            propertyIdentifier: "@"
	        };
	        this.controller = SWTypeaheadSearchLineItemController;
	        this.controllerAs = "swTypeaheadSearchLineItem";
	        this.link = function (scope, element, attrs) {
	            if (angular.isDefined(scope.$parent.swTypeaheadSearch)) {
	                scope.$parent.swTypeaheadSearch.displayList.push(scope.swTypeaheadSearchLineItem.propertyIdentifier);
	            }
	        };
	    }
	    SWTypeaheadSearchLineItem.Factory = function () {
	        var directive = function (utilityService) {
	            return new SWTypeaheadSearchLineItem(utilityService);
	        };
	        directive.$inject = [
	            'utilityService'
	        ];
	        return directive;
	    };
	    SWTypeaheadSearchLineItem.$inject = ['utilityService'];
	    return SWTypeaheadSearchLineItem;
	})();
	exports.SWTypeaheadSearchLineItem = SWTypeaheadSearchLineItem;


/***/ },
/* 29 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWActionCallerDropdownController = (function () {
	    function SWActionCallerDropdownController() {
	        this.title = this.title || '';
	        this.icon = this.icon || 'plus';
	        this.type = this.type || 'button';
	        this.dropdownClass = this.dropdownClass || '';
	        this.dropdownId = this.dropdownId || '';
	        this.buttonClass = this.buttonClass || 'btn-primary';
	    }
	    return SWActionCallerDropdownController;
	})();
	exports.SWActionCallerDropdownController = SWActionCallerDropdownController;
	var SWActionCallerDropdown = (function () {
	    function SWActionCallerDropdown(corePartialsPath, hibachiPathBuilder) {
	        this.corePartialsPath = corePartialsPath;
	        this.restrict = 'E';
	        this.scope = {};
	        this.transclude = true;
	        this.bindToController = {
	            title: "@",
	            icon: "@",
	            type: "=",
	            dropdownClass: "@",
	            dropdownId: "@",
	            buttonClass: "@"
	        };
	        this.controller = SWActionCallerDropdownController;
	        this.controllerAs = "swActionCallerDropdown";
	        this.link = function (scope, element, attrs) {
	        };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + 'actioncallerdropdown.html';
	    }
	    SWActionCallerDropdown.Factory = function () {
	        var directive = function (corePartialsPath, hibachiPathBuilder) { return new SWActionCallerDropdown(corePartialsPath, hibachiPathBuilder); };
	        directive.$inject = ['corePartialsPath', 'hibachiPathBuilder'];
	        return directive;
	    };
	    return SWActionCallerDropdown;
	})();
	exports.SWActionCallerDropdown = SWActionCallerDropdown;


/***/ },
/* 30 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWColumnSorter = (function () {
	    //@ngInject
	    function SWColumnSorter($log, observerService, corePartialsPath, hibachiPathBuilder) {
	        return {
	            restrict: 'AE',
	            scope: {
	                column: "=",
	            },
	            templateUrl: hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "columnsorter.html",
	            link: function (scope, element, attrs) {
	                var orderBy = {
	                    "propertyIdentifier": scope.column.propertyIdentifier,
	                };
	                scope.sortAsc = function () {
	                    orderBy.direction = 'Asc';
	                    this.observerService.notify('sortByColumn', orderBy);
	                };
	                scope.sortDesc = function () {
	                    orderBy.direction = 'Desc';
	                    observerService.notify('sortByColumn', orderBy);
	                };
	            }
	        };
	    }
	    SWColumnSorter.Factory = function () {
	        var directive = function ($log, observerService, corePartialsPath, hibachiPathBuilder) {
	            return new SWColumnSorter($log, observerService, corePartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            'observerService',
	            'corePartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWColumnSorter;
	})();
	exports.SWColumnSorter = SWColumnSorter;


/***/ },
/* 31 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
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
	var SWConfirm = (function () {
	    //@ngInject
	    function SWConfirm($hibachi, $log, $compile, $modal, partialsPath) {
	        var buildConfirmationModal = function (simple, useRbKey, confirmText, messageText, noText, yesText) {
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
	            var startTag = "\"'";
	            var endTag = "'\"";
	            var startParen = "'";
	            var endParen = "'";
	            var empty = "";
	            /* Modal String */
	            var parsedKeyString = "";
	            var finishedString = "";
	            //Figure out which version of this tag we are using
	            var templateString = "<div>" +
	                "<div class='modal-header'><a class='close' data-dismiss='modal' ng-click='cancel()'>×</a><h3 [confirm]><confirm></h3></div>" +
	                "<div class='modal-body' [message]>" + "<message>" + "</div>" +
	                "<div class='modal-footer'>" +
	                "<button class='btn btn-sm btn-default btn-inverse' ng-click='cancel()' [no]><no></button>" +
	                "<button class='btn btn-sm btn-default btn-primary' ng-click='fireCallback(callback)' [yes]><yes></button></div></div></div>";
	            /* Use RbKeys or Not? */
	            if (useRbKey === "true") {
	                $log.debug("Using RbKey? " + useRbKey);
	                /* Then decorate the template with the keys. */
	                confirmText = swRbKey + startTag + confirmText + endTag;
	                messageText = swRbKey + startTag + messageText + endTag;
	                yesText = swRbKey + startTag + yesText + endTag;
	                noText = swRbKey + startTag + noText + endTag;
	                parsedKeyString = templateString.replace(confirmKey, confirmText)
	                    .replace(messageText, messageText)
	                    .replace(noKey, noText)
	                    .replace(yesKey, yesText);
	                $log.debug(finishedString);
	                finishedString = parsedKeyString.replace(confirmKey, empty)
	                    .replace(messageVal, empty)
	                    .replace(noVal, empty)
	                    .replace(yesVal, empty);
	                $log.debug(finishedString);
	                return finishedString;
	            }
	            else {
	                /* Then decorate the template without the keys. */
	                $log.debug("Using RbKey? " + useRbKey);
	                parsedKeyString = templateString.replace(confirmVal, confirmText)
	                    .replace(messageVal, messageText)
	                    .replace(noVal, noText)
	                    .replace(yesVal, yesText);
	                finishedString = parsedKeyString.replace(confirmKey, empty)
	                    .replace(messageKey, empty)
	                    .replace(noKey, empty)
	                    .replace(yesKey, empty);
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
	                    var templateString = buildConfirmationModal(simple, useRbKey, confirmText, messageText, noText, yesText);
	                    var modalInstance = $modal.open({
	                        template: templateString,
	                        controller: 'confirmationController',
	                        scope: scope
	                    });
	                    /**
	                        * Handles the result - callback or dismissed
	                        */
	                    modalInstance.result.then(function (result) {
	                        $log.debug("Result:" + result);
	                        return true;
	                    }, function () {
	                        //There was an error
	                    });
	                }); //<--end bind
	            }
	        };
	    }
	    SWConfirm.Factory = function () {
	        var directive = function ($hibachi, $log, $compile, $modal, partialsPath) {
	            return new SWConfirm($hibachi, $log, $compile, $modal, partialsPath);
	        };
	        directive.$inject = ['$hibachi', '$log', '$compile', '$modal', 'partialsPath'];
	        return directive;
	    };
	    return SWConfirm;
	})();
	exports.SWConfirm = SWConfirm;


/***/ },
/* 32 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWEntityActionBarController = (function () {
	    function SWEntityActionBarController() {
	        this.init = function () {
	        };
	        this.init();
	    }
	    return SWEntityActionBarController;
	})();
	var SWEntityActionBar = (function () {
	    //@ngInject
	    function SWEntityActionBar(corePartialsPath, hibachiPathBuilder) {
	        this.corePartialsPath = corePartialsPath;
	        this.restrict = 'E';
	        this.scope = {};
	        this.transclude = true;
	        this.bindToController = {
	            /*Core settings*/
	            type: "@",
	            object: "=",
	            pageTitle: "@",
	            edit: "=",
	            /*Action Callers (top buttons)*/
	            showcancel: "=",
	            showcreate: "=",
	            showedit: "=",
	            showdelete: "=",
	            /*Basic Action Caller Overrides*/
	            createModal: "=",
	            createAction: "=",
	            createQueryString: "=",
	            backAction: "=",
	            backQueryString: "=",
	            cancelAction: "=",
	            cancelQueryString: "=",
	            deleteAction: "=",
	            deleteQueryString: "=",
	            /*Process Specific Values*/
	            processAction: "=",
	            processContext: "="
	        };
	        this.controller = SWEntityActionBarController;
	        this.controllerAs = "swEntityActionBar";
	        this.link = function (scope, element, attrs) {
	        };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + 'entityactionbar.html';
	    }
	    SWEntityActionBar.Factory = function () {
	        var directive = function (corePartialsPath, hibachiPathBuilder) {
	            return new SWEntityActionBar(corePartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = ['corePartialsPath', 'hibachiPathBuilder'];
	        return directive;
	    };
	    return SWEntityActionBar;
	})();
	exports.SWEntityActionBar = SWEntityActionBar;
	//	angular.module('slatwalladmin').directive('swEntityActionBar',['corePartialsPath',(corePartialsPath) => new SWEntityActionBar(corePartialsPath)]);


/***/ },
/* 33 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWEntityActionBarButtonGroupController = (function () {
	    function SWEntityActionBarButtonGroupController() {
	    }
	    return SWEntityActionBarButtonGroupController;
	})();
	var SWEntityActionBarButtonGroup = (function () {
	    //@ngInject
	    function SWEntityActionBarButtonGroup(corePartialsPath, hibachiPathBuilder) {
	        this.corePartialsPath = corePartialsPath;
	        this.restrict = 'E';
	        this.scope = {};
	        this.transclude = true;
	        this.bindToController = {};
	        this.controller = SWEntityActionBarButtonGroupController;
	        this.controllerAs = "swEntityActionBarButtonGroup";
	        this.link = function (scope, element, attrs) {
	        };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + 'entityactionbarbuttongroup.html';
	    }
	    SWEntityActionBarButtonGroup.Factory = function () {
	        var directive = function (corePartialsPath, hibachiPathBuilder) {
	            return new SWEntityActionBarButtonGroup(corePartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = ['corePartialsPath',
	            'hibachiPathBuilder'];
	        return directive;
	    };
	    return SWEntityActionBarButtonGroup;
	})();
	exports.SWEntityActionBarButtonGroup = SWEntityActionBarButtonGroup;


/***/ },
/* 34 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWExpandableRecordController = (function () {
	    //@ngInject
	    function SWExpandableRecordController($timeout, utilityService, $hibachi, collectionConfigService) {
	        var _this = this;
	        this.$timeout = $timeout;
	        this.utilityService = utilityService;
	        this.$hibachi = $hibachi;
	        this.collectionConfigService = collectionConfigService;
	        this.childrenLoaded = false;
	        this.childrenOpen = false;
	        this.children = [];
	        this.toggleChild = function () {
	            _this.$timeout(function () {
	                _this.childrenOpen = !_this.childrenOpen;
	                if (!_this.childrenLoaded) {
	                    var childCollectionConfig = _this.collectionConfigService.newCollectionConfig(_this.entity.metaData.className);
	                    //set up parent
	                    var parentName = _this.entity.metaData.hb_parentPropertyName;
	                    var parentCFC = _this.entity.metaData[parentName].cfc;
	                    var parentIDName = _this.$hibachi.getEntityExample(parentCFC).$$getIDName();
	                    //set up child
	                    var childName = _this.entity.metaData.hb_childPropertyName;
	                    var childCFC = _this.entity.metaData[childName].cfc;
	                    var childIDName = _this.$hibachi.getEntityExample(childCFC).$$getIDName();
	                    childCollectionConfig.clearFilterGroups();
	                    childCollectionConfig.collection = _this.entity;
	                    childCollectionConfig.addFilter(parentName + '.' + parentIDName, _this.parentId);
	                    childCollectionConfig.setAllRecords(true);
	                    angular.forEach(_this.collectionConfig.columns, function (column) {
	                        childCollectionConfig.addColumn(column.propertyIdentifier, column.tilte, column);
	                    });
	                    angular.forEach(_this.collectionConfig.joins, function (join) {
	                        childCollectionConfig.addJoin(join);
	                    });
	                    childCollectionConfig.groupBys = _this.collectionConfig.groupBys;
	                    _this.collectionPromise = childCollectionConfig.getEntity();
	                    _this.collectionPromise.then(function (data) {
	                        _this.collectionData = data;
	                        _this.collectionData.pageRecords = _this.collectionData.pageRecords || _this.collectionData.records;
	                        if (_this.collectionData.pageRecords.length) {
	                            angular.forEach(_this.collectionData.pageRecords, function (pageRecord) {
	                                pageRecord.dataparentID = _this.recordID;
	                                pageRecord.depth = _this.recordDepth || 0;
	                                pageRecord.depth++;
	                                _this.children.push(pageRecord);
	                                _this.records.splice(_this.recordIndex + 1, 0, pageRecord);
	                            });
	                        }
	                        _this.childrenLoaded = true;
	                    });
	                }
	                angular.forEach(_this.children, function (child) {
	                    child.dataIsVisible = _this.childrenOpen;
	                });
	            });
	        };
	        this.$timeout = $timeout;
	        this.$hibachi = $hibachi;
	        this.utilityService = utilityService;
	        this.collectionConfigService = collectionConfigService;
	    }
	    SWExpandableRecordController.$inject = ['$timeout', 'utilityService', '$hibachi', 'collectionConfigService'];
	    return SWExpandableRecordController;
	})();
	var SWExpandableRecord = (function () {
	    function SWExpandableRecord($compile, $templateRequest, $timeout, corePartialsPath, utilityService, hibachiPathBuilder) {
	        var _this = this;
	        this.$compile = $compile;
	        this.$templateRequest = $templateRequest;
	        this.$timeout = $timeout;
	        this.corePartialsPath = corePartialsPath;
	        this.utilityService = utilityService;
	        this.hibachiPathBuilder = hibachiPathBuilder;
	        this.restrict = 'EA';
	        this.scope = {};
	        this.bindToController = {
	            recordValue: "=",
	            link: "@",
	            expandable: "=",
	            parentId: "=",
	            entity: "=",
	            collectionConfig: "=",
	            records: "=",
	            recordIndex: "=",
	            recordDepth: "=",
	            childCount: "=",
	            autoOpen: "=",
	            multiselectIdPaths: "="
	        };
	        this.controller = SWExpandableRecordController;
	        this.controllerAs = "swExpandableRecord";
	        this.link = function (scope, element, attrs) {
	            if (scope.swExpandableRecord.expandable && scope.swExpandableRecord.childCount) {
	                if (scope.swExpandableRecord.recordValue) {
	                    var id = scope.swExpandableRecord.records[scope.swExpandableRecord.recordIndex][scope.swExpandableRecord.entity.$$getIDName()];
	                    if (scope.swExpandableRecord.multiselectIdPaths && scope.swExpandableRecord.multiselectIdPaths.length) {
	                        var multiselectIdPathsArray = scope.swExpandableRecord.multiselectIdPaths.split(',');
	                        angular.forEach(multiselectIdPathsArray, function (multiselectIdPath) {
	                            var position = _this.utilityService.listFind(multiselectIdPath, id, '/');
	                            var multiselectPathLength = multiselectIdPath.split('/').length;
	                            if (position !== -1 && position < multiselectPathLength - 1) {
	                                scope.swExpandableRecord.toggleChild();
	                            }
	                        });
	                    }
	                }
	                _this.$templateRequest(_this.hibachiPathBuilder.buildPartialsPath(_this.corePartialsPath) + "expandablerecord.html").then(function (html) {
	                    var template = angular.element(html);
	                    //get autoopen reference to ensure only the root is autoopenable
	                    var autoOpen = angular.copy(scope.swExpandableRecord.autoOpen);
	                    scope.swExpandableRecord.autoOpen = false;
	                    template = _this.$compile(template)(scope);
	                    element.html(template);
	                    element.on('click', scope.swExpandableRecord.toggleChild);
	                    if (autoOpen) {
	                        scope.swExpandableRecord.toggleChild();
	                    }
	                });
	            }
	        };
	        this.$compile = $compile;
	        this.$templateRequest = $templateRequest;
	        this.corePartialsPath = corePartialsPath;
	        this.$timeout = $timeout;
	        this.utilityService = utilityService;
	        this.hibachiPathBuilder = hibachiPathBuilder;
	    }
	    SWExpandableRecord.Factory = function () {
	        var directive = function ($compile, $templateRequest, $timeout, corePartialsPath, utilityService, hibachiPathBuilder) {
	            return new SWExpandableRecord($compile, $templateRequest, $timeout, corePartialsPath, utilityService, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$compile',
	            '$templateRequest',
	            '$timeout',
	            'corePartialsPath',
	            'utilityService',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    SWExpandableRecord.$inject = ['$compile', '$templateRequest', '$timeout', 'corePartialsPath', 'utilityService',
	        'hibachiPathBuilder'];
	    return SWExpandableRecord;
	})();
	exports.SWExpandableRecord = SWExpandableRecord;


/***/ },
/* 35 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var md5 = __webpack_require__(36);
	var SWGravatarController = (function () {
	    // @ngInject
	    function SWGravatarController() {
	        this.gravatarURL = "http://www.gravatar.com/avatar/" + md5(this.emailAddress.toLowerCase().trim());
	    }
	    return SWGravatarController;
	})();
	exports.SWGravatarController = SWGravatarController;
	var SWGravatar = (function () {
	    function SWGravatar() {
	        this.template = "<img src='{{swGravatar.gravatarURL}}' />";
	        this.transclude = false;
	        this.restrict = "E";
	        this.scope = {};
	        this.bindToController = {
	            emailAddress: "@"
	        };
	        this.controller = SWGravatarController;
	        this.controllerAs = "swGravatar";
	        this.link = function (scope, element, attrs, controller, transclude) {
	        };
	    }
	    SWGravatar.Factory = function () {
	        var directive = function () { return new SWGravatar(); };
	        directive.$inject = [];
	        return directive;
	    };
	    SWGravatar.$inject = ["$hibachi", "$timeout", "collectionConfigService", "corePartialsPath",
	        'hibachiPathBuilder'];
	    return SWGravatar;
	})();
	exports.SWGravatar = SWGravatar;


/***/ },
/* 36 */
/***/ function(module, exports, __webpack_require__) {

	(function(){
	  var crypt = __webpack_require__(37),
	      utf8 = __webpack_require__(38).utf8,
	      isBuffer = __webpack_require__(39),
	      bin = __webpack_require__(38).bin,

	  // The core
	  md5 = function (message, options) {
	    // Convert to byte array
	    if (message.constructor == String)
	      if (options && options.encoding === 'binary')
	        message = bin.stringToBytes(message);
	      else
	        message = utf8.stringToBytes(message);
	    else if (isBuffer(message))
	      message = Array.prototype.slice.call(message, 0);
	    else if (!Array.isArray(message))
	      message = message.toString();
	    // else, assume byte array already

	    var m = crypt.bytesToWords(message),
	        l = message.length * 8,
	        a =  1732584193,
	        b = -271733879,
	        c = -1732584194,
	        d =  271733878;

	    // Swap endian
	    for (var i = 0; i < m.length; i++) {
	      m[i] = ((m[i] <<  8) | (m[i] >>> 24)) & 0x00FF00FF |
	             ((m[i] << 24) | (m[i] >>>  8)) & 0xFF00FF00;
	    }

	    // Padding
	    m[l >>> 5] |= 0x80 << (l % 32);
	    m[(((l + 64) >>> 9) << 4) + 14] = l;

	    // Method shortcuts
	    var FF = md5._ff,
	        GG = md5._gg,
	        HH = md5._hh,
	        II = md5._ii;

	    for (var i = 0; i < m.length; i += 16) {

	      var aa = a,
	          bb = b,
	          cc = c,
	          dd = d;

	      a = FF(a, b, c, d, m[i+ 0],  7, -680876936);
	      d = FF(d, a, b, c, m[i+ 1], 12, -389564586);
	      c = FF(c, d, a, b, m[i+ 2], 17,  606105819);
	      b = FF(b, c, d, a, m[i+ 3], 22, -1044525330);
	      a = FF(a, b, c, d, m[i+ 4],  7, -176418897);
	      d = FF(d, a, b, c, m[i+ 5], 12,  1200080426);
	      c = FF(c, d, a, b, m[i+ 6], 17, -1473231341);
	      b = FF(b, c, d, a, m[i+ 7], 22, -45705983);
	      a = FF(a, b, c, d, m[i+ 8],  7,  1770035416);
	      d = FF(d, a, b, c, m[i+ 9], 12, -1958414417);
	      c = FF(c, d, a, b, m[i+10], 17, -42063);
	      b = FF(b, c, d, a, m[i+11], 22, -1990404162);
	      a = FF(a, b, c, d, m[i+12],  7,  1804603682);
	      d = FF(d, a, b, c, m[i+13], 12, -40341101);
	      c = FF(c, d, a, b, m[i+14], 17, -1502002290);
	      b = FF(b, c, d, a, m[i+15], 22,  1236535329);

	      a = GG(a, b, c, d, m[i+ 1],  5, -165796510);
	      d = GG(d, a, b, c, m[i+ 6],  9, -1069501632);
	      c = GG(c, d, a, b, m[i+11], 14,  643717713);
	      b = GG(b, c, d, a, m[i+ 0], 20, -373897302);
	      a = GG(a, b, c, d, m[i+ 5],  5, -701558691);
	      d = GG(d, a, b, c, m[i+10],  9,  38016083);
	      c = GG(c, d, a, b, m[i+15], 14, -660478335);
	      b = GG(b, c, d, a, m[i+ 4], 20, -405537848);
	      a = GG(a, b, c, d, m[i+ 9],  5,  568446438);
	      d = GG(d, a, b, c, m[i+14],  9, -1019803690);
	      c = GG(c, d, a, b, m[i+ 3], 14, -187363961);
	      b = GG(b, c, d, a, m[i+ 8], 20,  1163531501);
	      a = GG(a, b, c, d, m[i+13],  5, -1444681467);
	      d = GG(d, a, b, c, m[i+ 2],  9, -51403784);
	      c = GG(c, d, a, b, m[i+ 7], 14,  1735328473);
	      b = GG(b, c, d, a, m[i+12], 20, -1926607734);

	      a = HH(a, b, c, d, m[i+ 5],  4, -378558);
	      d = HH(d, a, b, c, m[i+ 8], 11, -2022574463);
	      c = HH(c, d, a, b, m[i+11], 16,  1839030562);
	      b = HH(b, c, d, a, m[i+14], 23, -35309556);
	      a = HH(a, b, c, d, m[i+ 1],  4, -1530992060);
	      d = HH(d, a, b, c, m[i+ 4], 11,  1272893353);
	      c = HH(c, d, a, b, m[i+ 7], 16, -155497632);
	      b = HH(b, c, d, a, m[i+10], 23, -1094730640);
	      a = HH(a, b, c, d, m[i+13],  4,  681279174);
	      d = HH(d, a, b, c, m[i+ 0], 11, -358537222);
	      c = HH(c, d, a, b, m[i+ 3], 16, -722521979);
	      b = HH(b, c, d, a, m[i+ 6], 23,  76029189);
	      a = HH(a, b, c, d, m[i+ 9],  4, -640364487);
	      d = HH(d, a, b, c, m[i+12], 11, -421815835);
	      c = HH(c, d, a, b, m[i+15], 16,  530742520);
	      b = HH(b, c, d, a, m[i+ 2], 23, -995338651);

	      a = II(a, b, c, d, m[i+ 0],  6, -198630844);
	      d = II(d, a, b, c, m[i+ 7], 10,  1126891415);
	      c = II(c, d, a, b, m[i+14], 15, -1416354905);
	      b = II(b, c, d, a, m[i+ 5], 21, -57434055);
	      a = II(a, b, c, d, m[i+12],  6,  1700485571);
	      d = II(d, a, b, c, m[i+ 3], 10, -1894986606);
	      c = II(c, d, a, b, m[i+10], 15, -1051523);
	      b = II(b, c, d, a, m[i+ 1], 21, -2054922799);
	      a = II(a, b, c, d, m[i+ 8],  6,  1873313359);
	      d = II(d, a, b, c, m[i+15], 10, -30611744);
	      c = II(c, d, a, b, m[i+ 6], 15, -1560198380);
	      b = II(b, c, d, a, m[i+13], 21,  1309151649);
	      a = II(a, b, c, d, m[i+ 4],  6, -145523070);
	      d = II(d, a, b, c, m[i+11], 10, -1120210379);
	      c = II(c, d, a, b, m[i+ 2], 15,  718787259);
	      b = II(b, c, d, a, m[i+ 9], 21, -343485551);

	      a = (a + aa) >>> 0;
	      b = (b + bb) >>> 0;
	      c = (c + cc) >>> 0;
	      d = (d + dd) >>> 0;
	    }

	    return crypt.endian([a, b, c, d]);
	  };

	  // Auxiliary functions
	  md5._ff  = function (a, b, c, d, x, s, t) {
	    var n = a + (b & c | ~b & d) + (x >>> 0) + t;
	    return ((n << s) | (n >>> (32 - s))) + b;
	  };
	  md5._gg  = function (a, b, c, d, x, s, t) {
	    var n = a + (b & d | c & ~d) + (x >>> 0) + t;
	    return ((n << s) | (n >>> (32 - s))) + b;
	  };
	  md5._hh  = function (a, b, c, d, x, s, t) {
	    var n = a + (b ^ c ^ d) + (x >>> 0) + t;
	    return ((n << s) | (n >>> (32 - s))) + b;
	  };
	  md5._ii  = function (a, b, c, d, x, s, t) {
	    var n = a + (c ^ (b | ~d)) + (x >>> 0) + t;
	    return ((n << s) | (n >>> (32 - s))) + b;
	  };

	  // Package private blocksize
	  md5._blocksize = 16;
	  md5._digestsize = 16;

	  module.exports = function (message, options) {
	    if(typeof message == 'undefined')
	      return;

	    var digestbytes = crypt.wordsToBytes(md5(message, options));
	    return options && options.asBytes ? digestbytes :
	        options && options.asString ? bin.bytesToString(digestbytes) :
	        crypt.bytesToHex(digestbytes);
	  };

	})();


/***/ },
/* 37 */
/***/ function(module, exports) {

	(function() {
	  var base64map
	      = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/',

	  crypt = {
	    // Bit-wise rotation left
	    rotl: function(n, b) {
	      return (n << b) | (n >>> (32 - b));
	    },

	    // Bit-wise rotation right
	    rotr: function(n, b) {
	      return (n << (32 - b)) | (n >>> b);
	    },

	    // Swap big-endian to little-endian and vice versa
	    endian: function(n) {
	      // If number given, swap endian
	      if (n.constructor == Number) {
	        return crypt.rotl(n, 8) & 0x00FF00FF | crypt.rotl(n, 24) & 0xFF00FF00;
	      }

	      // Else, assume array and swap all items
	      for (var i = 0; i < n.length; i++)
	        n[i] = crypt.endian(n[i]);
	      return n;
	    },

	    // Generate an array of any length of random bytes
	    randomBytes: function(n) {
	      for (var bytes = []; n > 0; n--)
	        bytes.push(Math.floor(Math.random() * 256));
	      return bytes;
	    },

	    // Convert a byte array to big-endian 32-bit words
	    bytesToWords: function(bytes) {
	      for (var words = [], i = 0, b = 0; i < bytes.length; i++, b += 8)
	        words[b >>> 5] |= bytes[i] << (24 - b % 32);
	      return words;
	    },

	    // Convert big-endian 32-bit words to a byte array
	    wordsToBytes: function(words) {
	      for (var bytes = [], b = 0; b < words.length * 32; b += 8)
	        bytes.push((words[b >>> 5] >>> (24 - b % 32)) & 0xFF);
	      return bytes;
	    },

	    // Convert a byte array to a hex string
	    bytesToHex: function(bytes) {
	      for (var hex = [], i = 0; i < bytes.length; i++) {
	        hex.push((bytes[i] >>> 4).toString(16));
	        hex.push((bytes[i] & 0xF).toString(16));
	      }
	      return hex.join('');
	    },

	    // Convert a hex string to a byte array
	    hexToBytes: function(hex) {
	      for (var bytes = [], c = 0; c < hex.length; c += 2)
	        bytes.push(parseInt(hex.substr(c, 2), 16));
	      return bytes;
	    },

	    // Convert a byte array to a base-64 string
	    bytesToBase64: function(bytes) {
	      for (var base64 = [], i = 0; i < bytes.length; i += 3) {
	        var triplet = (bytes[i] << 16) | (bytes[i + 1] << 8) | bytes[i + 2];
	        for (var j = 0; j < 4; j++)
	          if (i * 8 + j * 6 <= bytes.length * 8)
	            base64.push(base64map.charAt((triplet >>> 6 * (3 - j)) & 0x3F));
	          else
	            base64.push('=');
	      }
	      return base64.join('');
	    },

	    // Convert a base-64 string to a byte array
	    base64ToBytes: function(base64) {
	      // Remove non-base-64 characters
	      base64 = base64.replace(/[^A-Z0-9+\/]/ig, '');

	      for (var bytes = [], i = 0, imod4 = 0; i < base64.length;
	          imod4 = ++i % 4) {
	        if (imod4 == 0) continue;
	        bytes.push(((base64map.indexOf(base64.charAt(i - 1))
	            & (Math.pow(2, -2 * imod4 + 8) - 1)) << (imod4 * 2))
	            | (base64map.indexOf(base64.charAt(i)) >>> (6 - imod4 * 2)));
	      }
	      return bytes;
	    }
	  };

	  module.exports = crypt;
	})();


/***/ },
/* 38 */
/***/ function(module, exports) {

	var charenc = {
	  // UTF-8 encoding
	  utf8: {
	    // Convert a string to a byte array
	    stringToBytes: function(str) {
	      return charenc.bin.stringToBytes(unescape(encodeURIComponent(str)));
	    },

	    // Convert a byte array to a string
	    bytesToString: function(bytes) {
	      return decodeURIComponent(escape(charenc.bin.bytesToString(bytes)));
	    }
	  },

	  // Binary encoding
	  bin: {
	    // Convert a string to a byte array
	    stringToBytes: function(str) {
	      for (var bytes = [], i = 0; i < str.length; i++)
	        bytes.push(str.charCodeAt(i) & 0xFF);
	      return bytes;
	    },

	    // Convert a byte array to a string
	    bytesToString: function(bytes) {
	      for (var str = [], i = 0; i < bytes.length; i++)
	        str.push(String.fromCharCode(bytes[i]));
	      return str.join('');
	    }
	  }
	};

	module.exports = charenc;


/***/ },
/* 39 */
/***/ function(module, exports) {

	/**
	 * Determine if an object is Buffer
	 *
	 * Author:   Feross Aboukhadijeh <feross@feross.org> <http://feross.org>
	 * License:  MIT
	 *
	 * `npm install is-buffer`
	 */

	module.exports = function (obj) {
	  return !!(
	    obj != null &&
	    obj.constructor &&
	    typeof obj.constructor.isBuffer === 'function' &&
	    obj.constructor.isBuffer(obj)
	  )
	}


/***/ },
/* 40 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWListingDisplayController = (function () {
	    //@ngInject
	    function SWListingDisplayController($scope, $element, $transclude, $timeout, $q, $hibachi, utilityService, collectionConfigService, paginationService, selectionService, observerService, rbkeyService) {
	        var _this = this;
	        this.$scope = $scope;
	        this.$element = $element;
	        this.$transclude = $transclude;
	        this.$timeout = $timeout;
	        this.$q = $q;
	        this.$hibachi = $hibachi;
	        this.utilityService = utilityService;
	        this.collectionConfigService = collectionConfigService;
	        this.paginationService = paginationService;
	        this.selectionService = selectionService;
	        this.observerService = observerService;
	        this.rbkeyService = rbkeyService;
	        /* local state variables */
	        this.actions = [];
	        this.allpropertyidentifiers = "";
	        this.allprocessobjectproperties = "false";
	        this.aggregates = [];
	        this.buttonGroup = [];
	        this.colorFilters = [];
	        this.columns = [];
	        this.exampleEntity = "";
	        this.filters = [];
	        this.multiselectable = false;
	        this.orderBys = [];
	        this.orderByStates = {};
	        this.orderByIndices = {};
	        this.searching = false;
	        this.selectable = false;
	        this.sortable = false;
	        this.intialSetup = function () {
	            //default search is available
	            if (angular.isUndefined(_this.hasSearch)) {
	                _this.hasSearch = true;
	            }
	            if (angular.isString(_this.showSearch)) {
	                _this.showSearch = (_this.showSearch.toLowerCase() === 'true');
	            }
	            if (angular.isString(_this.showTopPagination)) {
	                _this.showTopPagination = (_this.showTopPagination.toLowerCase() === 'true');
	            }
	            ;
	            _this.paginator = _this.paginationService.createPagination();
	            _this.hasCollectionPromise = false;
	            if (angular.isUndefined(_this.getChildCount)) {
	                _this.getChildCount = false;
	            }
	            if (!_this.collection || !angular.isString(_this.collection)) {
	                _this.hasCollectionPromise = true;
	            }
	            else {
	                _this.collectionObject = _this.collection;
	                _this.collectionConfig = _this.collectionConfigService.newCollectionConfig(_this.collectionObject);
	            }
	            _this.setupDefaultCollectionInfo();
	            //if columns doesn't exist then make it
	            if (!_this.collectionConfig.columns) {
	                _this.collectionConfig.columns = [];
	            }
	            //if a collectionConfig was not passed in then we can run run swListingColumns
	            //this is performed early to populate columns with swlistingcolumn info
	            _this.$transclude(_this.$scope, function () { });
	            //add filters
	            _this.setupColumns();
	            angular.forEach(_this.filters, function (filter) {
	                _this.collectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator);
	            });
	            //add order bys
	            angular.forEach(_this.orderBys, function (orderBy) {
	                _this.collectionConfig.addOrderBy(orderBy.orderBy);
	            });
	            angular.forEach(_this.aggregates, function (aggregate) {
	                _this.collectionConfig.addDisplayAggregate(aggregate.propertyIdentifier, aggregate.aggregateFunction, aggregate.aggregateAlias);
	            });
	            //make sure we have necessary properties to make the actions 
	            angular.forEach(_this.actions, function (action) {
	                if (angular.isDefined(action.queryString)) {
	                    var parsedProperties = _this.utilityService.getPropertiesFromString(action.queryString);
	                    if (parsedProperties && parsedProperties.length) {
	                        _this.collectionConfig.addDisplayProperty(_this.utilityService.arrayToList(parsedProperties), "", { isVisible: false });
	                    }
	                }
	            });
	            //also make sure we have necessary color filter properties
	            angular.forEach(_this.colorFilters, function (colorFilter) {
	                if (angular.isDefined(colorFilter.propertyToCompare)) {
	                    _this.collectionConfig.addDisplayProperty(colorFilter.propertyToCompare, "", { isVisible: false });
	                }
	            });
	            _this.exampleEntity = _this.$hibachi.newEntity(_this.collectionObject);
	            _this.collectionConfig.addDisplayProperty(_this.exampleEntity.$$getIDName(), undefined, { isVisible: false });
	            _this.initData();
	            _this.$scope.$watch('swListingDisplay.collectionPromise', function (newValue, oldValue) {
	                if (newValue) {
	                    _this.$q.when(_this.collectionPromise).then(function (data) {
	                        _this.collectionData = data;
	                        _this.setupDefaultCollectionInfo();
	                        _this.setupColumns();
	                        _this.collectionData.pageRecords = _this.collectionData.pageRecords || _this.collectionData.records;
	                        _this.paginator.setPageRecordsInfo(_this.collectionData);
	                        _this.searching = false;
	                    });
	                }
	            });
	            _this.tableID = 'LD' + _this.utilityService.createID();
	            //if getCollection doesn't exist then create it
	            if (angular.isUndefined(_this.getCollection)) {
	                _this.getCollection = _this.setupDefaultGetCollection();
	            }
	            _this.paginator.getCollection = _this.getCollection;
	            //this.getCollection();
	        };
	        this.setupDefaultCollectionInfo = function () {
	            if (_this.hasCollectionPromise) {
	                _this.collectionObject = _this.collection.collectionObject;
	                _this.collectionConfig = _this.collectionConfigService.newCollectionConfig(_this.collectionObject);
	                _this.collectionConfig.loadJson(_this.collection.collectionConfig);
	            }
	            _this.collectionConfig.setPageShow(_this.paginator.getPageShow());
	            _this.collectionConfig.setCurrentPage(_this.paginator.getCurrentPage());
	            //this.collectionConfig.setKeywords(this.paginator.keywords);
	        };
	        this.setupDefaultGetCollection = function () {
	            _this.collectionPromise = _this.collectionConfig.getEntity();
	            return function () {
	                _this.collectionConfig.setCurrentPage(_this.paginator.getCurrentPage());
	                _this.collectionConfig.setPageShow(_this.paginator.getPageShow());
	                _this.collectionConfig.getEntity().then(function (data) {
	                    _this.collectionData = data;
	                    _this.setupDefaultCollectionInfo();
	                    _this.setupColumns();
	                    _this.collectionData.pageRecords = _this.collectionData.pageRecords || _this.collectionData.records;
	                    _this.paginator.setPageRecordsInfo(_this.collectionData);
	                });
	            };
	        };
	        this.initData = function () {
	            _this.collectionConfig.setPageShow(_this.paginator.pageShow);
	            _this.collectionConfig.setCurrentPage(_this.paginator.currentPage);
	            //setup export action
	            if (angular.isDefined(_this.exportAction)) {
	                _this.exportAction = _this.$hibachi.buildUrl('main.collectionExport') + '&collectionExportID=';
	            }
	            //Setup Select
	            if (_this.selectFieldName && _this.selectFieldName.length) {
	                _this.selectable = true;
	                _this.tableclass = _this.utilityService.listAppend(_this.tableclass, 'table-select', ' ');
	                _this.tableattributes = _this.utilityService.listAppend(_this.tableattributes, 'data-selectfield="' + _this.selectFieldName + '"', ' ');
	            }
	            //Setup MultiSelect
	            if (_this.multiselectFieldName && _this.multiselectFieldName.length) {
	                _this.multiselectable = true;
	                _this.tableclass = _this.utilityService.listAppend(_this.tableclass, 'table-multiselect', ' ');
	                _this.tableattributes = _this.utilityService.listAppend(_this.tableattributes, 'data-multiselectpropertyidentifier="' + _this.multiselectPropertyIdentifier + '"', ' ');
	                //attach observer so we know when a selection occurs
	                _this.observerService.attach(_this.updateMultiselectValues, 'swSelectionToggleSelection', _this.collectionObject);
	            }
	            if (_this.multiselectable && !_this.columns.length) {
	                //check if it has an active flag and if so then add the active flag
	                if (_this.exampleEntity.metaData.activeProperty && !_this.hasCollectionPromise) {
	                    _this.collectionConfig.addFilter('activeFlag', 1);
	                }
	            }
	            //Look for Hierarchy in example entity
	            if (!_this.parentPropertyName || (_this.parentPropertyName && !_this.parentPropertyName.length)) {
	                if (_this.exampleEntity.metaData.hb_parentPropertyName) {
	                    _this.parentPropertyName = _this.exampleEntity.metaData.hb_parentPropertyName;
	                }
	            }
	            if (!_this.childPropertyName || (_this.childPropertyName && !_this.childPropertyName.length)) {
	                if (_this.exampleEntity.metaData.hb_childPropertyName) {
	                    _this.childPropertyName = _this.exampleEntity.metaData.hb_childPropertyName;
	                }
	            }
	            //Setup Hierachy Expandable
	            if (_this.parentPropertyName && _this.parentPropertyName.length) {
	                if (angular.isUndefined(_this.expandable)) {
	                    _this.expandable = true;
	                }
	                _this.tableclass = _this.utilityService.listAppend(_this.tableclass, 'table-expandable', ' ');
	                //add parent property root filter
	                if (!_this.hasCollectionPromise) {
	                    _this.collectionConfig.addFilter(_this.parentPropertyName + '.' + _this.exampleEntity.$$getIDName(), 'NULL', 'IS');
	                }
	                //this.collectionConfig.addDisplayProperty(this.exampleEntity.$$getIDName()+'Path',undefined,{isVisible:false});
	                //add children column
	                if (_this.childPropertyName && _this.childPropertyName.length) {
	                    if (_this.getChildCount || !_this.hasCollectionPromise) {
	                        _this.collectionConfig.addDisplayAggregate(_this.childPropertyName, 'COUNT', _this.childPropertyName + 'Count');
	                    }
	                }
	                _this.allpropertyidentifiers = _this.utilityService.listAppend(_this.allpropertyidentifiers, _this.exampleEntity.$$getIDName() + 'Path');
	                _this.tableattributes = _this.utilityService.listAppend(_this.tableattributes, 'data-parentidproperty=' + _this.parentPropertyName + '.' + _this.exampleEntity.$$getIDName(), ' ');
	                _this.collectionConfig.setAllRecords(true);
	            }
	            //            if(
	            //                !this.edit
	            //                && this.multiselectable
	            //                && (!this.parentPropertyName || !!this.parentPropertyName.length)
	            //                && (this.multiselectPropertyIdentifier && this.multiselectPropertyIdentifier.length)
	            //            ){
	            //                if(this.multiselectValues && this.multiselectValues.length){
	            //                    this.collectionConfig.addFilter(this.multiselectPropertyIdentifier,this.multiselectValues,'IN');
	            //                }else{
	            //                    this.collectionConfig.addFilter(this.multiselectPropertyIdentifier,'_','IN');
	            //                }
	            //            }
	            if (_this.multiselectIdPaths && _this.multiselectIdPaths.length) {
	                angular.forEach(_this.multiselectIdPaths.split(','), function (value) {
	                    var id = _this.utilityService.listLast(value, '/');
	                    _this.selectionService.addSelection('ListingDisplay', id);
	                });
	            }
	            if (_this.multiselectValues && _this.multiselectValues.length) {
	                //select all owned ids
	                angular.forEach(_this.multiselectValues.split(','), function (value) {
	                    _this.selectionService.addSelection('ListingDisplay', value);
	                });
	            }
	            //set defaults if value is not specified
	            //this.edit = this.edit || $location.edit
	            _this.processObjectProperties = _this.processObjectProperties || '';
	            _this.recordProcessButtonDisplayFlag = _this.recordProcessButtonDisplayFlag || true;
	            //this.collectionConfig = this.collectionConfig || this.collectionData.collectionConfig;
	            _this.norecordstext = _this.rbkeyService.getRBKey('entity.' + _this.collectionObject + '.norecords');
	            //Setup Sortability
	            if (_this.sortProperty && _this.sortProperty.length) {
	            }
	            //Setup the admin meta info
	            _this.administrativeCount = 0;
	            //Detail
	            if (_this.recordDetailAction && _this.recordDetailAction.length) {
	                _this.administrativeCount++;
	                _this.adminattributes = _this.getAdminAttributesByType('detail');
	            }
	            //Edit
	            if (_this.recordEditAction && _this.recordEditAction.length) {
	                _this.administrativeCount++;
	                _this.adminattributes = _this.getAdminAttributesByType('edit');
	            }
	            //Delete
	            if (_this.recordDeleteAction && _this.recordDeleteAction.length) {
	                _this.administrativeCount++;
	                _this.adminattributes = _this.getAdminAttributesByType('delete');
	            }
	            //Add
	            if (_this.recordAddAction && _this.recordAddAction.length) {
	                _this.administrativeCount++;
	                _this.adminattributes = _this.getAdminAttributesByType('add');
	            }
	            //Process
	            // if(this.recordProcessAction && this.recordProcessAction.length && this.recordProcessButtonDisplayFlag){
	            //     this.administrativeCount++;
	            //     this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processcontext="'+this.recordProcessContext+'"', " ");
	            //     this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processentity="'+this.recordProcessEntity.metaData.className+'"', " ");
	            //     this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processentityid="'+this.recordProcessEntity.$$getID+'"', " ");
	            //     this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processaction="'+this.recordProcessAction+'"', " ");
	            //     this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processcontext="'+this.recordProcessContext+'"', " ");
	            //     this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processquerystring="'+this.recordProcessQueryString+'"', " ");
	            //     this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processupdatetableid="'+this.recordProcessUpdateTableID+'"', " ");
	            // }
	            //Setup the primary representation column if no columns were passed in
	            /*
	            <cfif not arrayLen(thistag.columns)>
	                <cfset arrayAppend(thistag.columns, {
	                    propertyIdentifier = thistag.exampleentity.getSimpleRepresentationPropertyName(),
	                    title = "",
	                    tdclass="primary",
	                    search = true,
	                    sort = true,
	                    filter = false,
	                    range = false,
	                    editable = false,
	                    buttonGroup = true
	                }) />
	            </cfif>
	            */
	            //Setup the list of all property identifiers to be used later
	            angular.forEach(_this.columns, function (column) {
	                //If this is a standard propertyIdentifier
	                if (column.propertyIdentifier) {
	                    //Add to the all property identifiers
	                    _this.allpropertyidentifiers = _this.utilityService.listAppend(_this.allpropertyidentifiers, column.propertyIdentifier);
	                    //Check to see if we need to setup the dynamic filters, etc
	                    //<cfif not len(column.search) || not len(column.sort) || not len(column.filter) || not len(column.range)>
	                    if (!column.searchable || !!column.searchable.length || !column.sort || !column.sort.length) {
	                        //Get the entity object to get property metaData
	                        var thisEntityName = _this.$hibachi.getLastEntityNameInPropertyIdentifier(_this.exampleEntity.metaData.className, column.propertyIdentifier);
	                        var thisPropertyName = _this.utilityService.listLast(column.propertyIdentifier, '.');
	                        var thisPropertyMeta = _this.$hibachi.getPropertyByEntityNameAndPropertyName(thisEntityName, thisPropertyName);
	                    }
	                }
	                else if (column.processObjectProperty) {
	                    column.searchable = false;
	                    column.sort = false;
	                    /*
	                    <cfset column.filter = false />
	                    <cfset column.range = false />
	                    */
	                    _this.allprocessobjectproperties = _this.utilityService.listAppend(_this.allprocessobjectproperties, column.processObjectProperty);
	                }
	                if (column.tdclass) {
	                    var tdclassArray = column.tdclass.split(' ');
	                    if (tdclassArray.indexOf("primary") >= 0 && _this.expandable) {
	                        _this.tableattributes = _this.utilityService.listAppend(_this.tableattributes, 'data-expandsortproperty=' + column.propertyIdentifier, " ");
	                        column.sort = false;
	                    }
	                }
	            });
	            //Setup a variable for the number of columns so that the none can have a proper colspan
	            _this.columnCount = _this.columns.length;
	            if (_this.selectable) {
	                _this.columnCount++;
	            }
	            if (_this.multiselectable) {
	                _this.columnCount++;
	            }
	            if (_this.sortable) {
	                _this.columnCount++;
	            }
	            if (_this.administrativeCount) {
	                _this.administrativeCount++;
	            }
	            //Setup table class
	            _this.tableclass = _this.tableclass || '';
	            _this.tableclass = _this.utilityService.listPrepend(_this.tableclass, 'table table-bordered table-hover', ' ');
	        };
	        this.setupColumns = function () {
	            //assumes no alias formatting
	            angular.forEach(_this.columns.reverse(), function (column) {
	                var lastEntity = _this.$hibachi.getLastEntityNameInPropertyIdentifier(_this.collectionObject, column.propertyIdentifier);
	                var title = _this.rbkeyService.getRBKey('entity.' + lastEntity.toLowerCase() + '.' + _this.utilityService.listLast(column.propertyIdentifier, '.'));
	                if (angular.isUndefined(column.isVisible)) {
	                    column.isVisible = true;
	                }
	                var metadata = _this.$hibachi.getPropertyByEntityNameAndPropertyName(lastEntity, _this.utilityService.listLast(column.propertyIdentifier, '.'));
	                if (angular.isDefined(metadata) && angular.isDefined(metadata.hb_formattype)) {
	                    column.type = metadata.hb_formattype;
	                }
	                else {
	                    column.type = "none";
	                }
	                if (angular.isDefined(column.tooltip)) {
	                    var parsedProperties = _this.utilityService.getPropertiesFromString(column.tooltip);
	                    if (parsedProperties && parsedProperties.length) {
	                        _this.collectionConfig.addDisplayProperty(_this.utilityService.arrayToList(parsedProperties), "", { isVisible: false });
	                    }
	                }
	                else {
	                    column.tooltip = '';
	                }
	                if (angular.isDefined(column.queryString)) {
	                    var parsedProperties = _this.utilityService.getPropertiesFromString(column.queryString);
	                    if (parsedProperties && parsedProperties.length) {
	                        _this.collectionConfig.addDisplayProperty(_this.utilityService.arrayToList(parsedProperties), "", { isVisible: false });
	                    }
	                }
	                _this.columnOrderBy(column);
	                _this.collectionConfig.addDisplayProperty(column.propertyIdentifier, title, column);
	            });
	            //if the passed in collection has columns perform some formatting
	            if (_this.hasCollectionPromise) {
	                //assumes alias formatting from collectionConfig
	                angular.forEach(_this.collectionConfig.columns, function (column) {
	                    var lastEntity = _this.$hibachi.getLastEntityNameInPropertyIdentifier(_this.collectionObject, _this.utilityService.listRest(column.propertyIdentifier, '.'));
	                    column.title = column.title || _this.rbkeyService.getRBKey('entity.' + lastEntity.toLowerCase() + '.' + _this.utilityService.listLast(column.propertyIdentifier, '.'));
	                    if (angular.isUndefined(column.isVisible)) {
	                        column.isVisible = true;
	                    }
	                });
	            }
	        };
	        this.getColorFilterNGClassObject = function (pageRecord) {
	            var classObjectString = "{";
	            angular.forEach(_this.colorFilters, function (colorFilter, index) {
	                classObjectString = classObjectString.concat("'" + colorFilter.colorClass + "':" + _this.getColorFilterConditionString(colorFilter, pageRecord));
	                if (index < _this.colorFilters.length - 1) {
	                    classObjectString = classObjectString.concat(",");
	                }
	            });
	            return classObjectString + "}";
	        };
	        this.getColorFilterConditionString = function (colorFilter, pageRecord) {
	            if (angular.isDefined(colorFilter.comparisonProperty)) {
	                return pageRecord[colorFilter.propertyToCompare.replace('.', '_')] + colorFilter.comparisonOperator + pageRecord[colorFilter.comparisonProperty.replace('.', '_')];
	            }
	            else {
	                return pageRecord[colorFilter.propertyToCompare.replace('.', '_')] + colorFilter.comparisonOperator + colorFilter.comparisonValue;
	            }
	        };
	        this.toggleOrderBy = function (column) {
	            _this.collectionConfig.toggleOrderBy(column.propertyIdentifier);
	            _this.getCollection();
	        };
	        this.columnOrderBy = function (column) {
	            var found = false;
	            angular.forEach(_this.collectionConfig.orderBy, function (orderBy, index) {
	                if (column.propertyIdentifier == orderBy.propertyIdentifier) {
	                    found = true;
	                    _this.orderByStates[column.propertyIdentifier] = orderBy.direction;
	                }
	            });
	            if (!found) {
	                _this.orderByStates[column.propertyIdentifier] = '';
	            }
	            return _this.orderByStates[column.propertyIdentifier];
	        };
	        this.columnOrderByIndex = function (column) {
	            var found = false;
	            angular.forEach(_this.collectionConfig.orderBy, function (orderBy, index) {
	                if (column.propertyIdentifier == orderBy.propertyIdentifier) {
	                    found = true;
	                    _this.orderByIndices[column.propertyIdentifier] = index + 1;
	                }
	            });
	            if (!found) {
	                _this.orderByIndices[column.propertyIdentifier] = '';
	            }
	            return _this.orderByIndices[column.propertyIdentifier];
	        };
	        this.updateMultiselectValues = function () {
	            _this.multiselectValues = _this.selectionService.getSelections('ListingDisplay');
	        };
	        this.escapeRegExp = function (str) {
	            return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
	        };
	        this.replaceAll = function (str, find, replace) {
	            return str.replace(new RegExp(_this.escapeRegExp(find), 'g'), replace);
	        };
	        this.getPageRecordKey = function (propertyIdentifier) {
	            if (propertyIdentifier) {
	                var propertyIdentifierWithoutAlias = '';
	                if (propertyIdentifier.indexOf('_') === 0) {
	                    propertyIdentifierWithoutAlias = propertyIdentifier.substring(propertyIdentifier.indexOf('.') + 1, propertyIdentifier.length);
	                }
	                else {
	                    propertyIdentifierWithoutAlias = propertyIdentifier;
	                }
	                return _this.replaceAll(propertyIdentifierWithoutAlias, '.', '_');
	            }
	            return '';
	        };
	        this.getAdminAttributesByType = function (type) {
	            var recordActionName = 'record' + type.toUpperCase() + 'Action';
	            var recordActionPropertyName = recordActionName + 'Property';
	            var recordActionQueryStringName = recordActionName + 'QueryString';
	            var recordActionModalName = recordActionName + 'Modal';
	            _this.adminattributes = _this.utilityService.listAppend(_this.adminattributes, 'data-' + type + 'action="' + _this[recordActionName] + '"', " ");
	            if (_this[recordActionPropertyName] && _this[recordActionPropertyName].length) {
	                _this.adminattributes = _this.utilityService.listAppend(_this.adminattributes, 'data-' + type + 'actionproperty="' + _this[recordActionPropertyName] + '"', " ");
	            }
	            _this.adminattributes = _this.utilityService.listAppend(_this.adminattributes, 'data-' + type + 'querystring="' + _this[recordActionQueryStringName] + '"', " ");
	            _this.adminattributes = _this.utilityService.listAppend(_this.adminattributes, 'data-' + type + 'modal="' + _this[recordActionModalName] + '"', " ");
	        };
	        this.getExportAction = function () {
	            return _this.exportAction + _this.collectionID;
	        };
	        console.log('here');
	        console.log(this);
	        this.$q = $q;
	        this.$timeout = $timeout;
	        this.$hibachi = $hibachi;
	        this.$transclude = $transclude;
	        this.utilityService = utilityService;
	        this.$scope = $scope;
	        this.$element = $element;
	        this.collectionConfigService = collectionConfigService;
	        this.paginationService = paginationService;
	        this.selectionService = selectionService;
	        this.observerService = observerService;
	        this.rbkeyService = rbkeyService;
	        this.intialSetup();
	        this.$scope.$on('$destroy', function () {
	            _this.observerService.detachById(_this.$scope.collection);
	        });
	    }
	    return SWListingDisplayController;
	})();
	var SWListingDisplay = (function () {
	    //@ngInject
	    function SWListingDisplay(corePartialsPath, hibachiPathBuilder) {
	        this.corePartialsPath = corePartialsPath;
	        this.hibachiPathBuilder = hibachiPathBuilder;
	        this.restrict = 'E';
	        this.scope = {};
	        this.transclude = true;
	        this.bindToController = {
	            isRadio: "=?",
	            //angularLink:true || false
	            angularLinks: "=?",
	            name: "@?",
	            /*required*/
	            collection: "=?",
	            collectionConfig: "=?",
	            getCollection: "&?",
	            collectionPromise: "=?",
	            edit: "=?",
	            /*Optional*/
	            title: "@?",
	            /*Admin Actions*/
	            actions: "=?",
	            recordEditAction: "@?",
	            recordEditActionProperty: "@?",
	            recordEditQueryString: "@?",
	            recordEditModal: "=?",
	            recordEditDisabled: "=?",
	            recordDetailAction: "@?",
	            recordDetailActionProperty: "@?",
	            recordDetailQueryString: "@?",
	            recordDetailModal: "=?",
	            recordDeleteAction: "@?",
	            recordDeleteActionProperty: "@?",
	            recordDeleteQueryString: "@?",
	            recordAddAction: "@?",
	            recordAddActionProperty: "@?",
	            recordAddQueryString: "@?",
	            recordAddModal: "=?",
	            recordAddDisabled: "=?",
	            recordProcessesConfig: "=?",
	            /* record processes config is an array of actions. Example:
	            [
	            {
	                recordProcessAction:"@",
	                recordProcessActionProperty:"@",
	                recordProcessQueryString:"@",
	                recordProcessContext:"@",
	                recordProcessEntity:"=",
	                recordProcessEntityData:"=",
	                recordProcessUpdateTableID:"=",
	                recordProcessButtonDisplayFlag:"=",
	            }
	            ]
	            */
	            /*Hierachy Expandable*/
	            parentPropertyName: "@?",
	            //booleans
	            expandable: "=?",
	            expandableOpenRoot: "=?",
	            /*Searching*/
	            searchText: "=?",
	            /*Sorting*/
	            sortProperty: "@?",
	            sortContextIDColumn: "@?",
	            sortContextIDValue: "@?",
	            /*Single Select*/
	            selectFiledName: "@?",
	            selectValue: "@?",
	            selectTitle: "@?",
	            /*Multiselect*/
	            multiselectFieldName: "@?",
	            multiselectPropertyIdentifier: "@?",
	            multiselectIdPaths: "@?",
	            multiselectValues: "@?",
	            /*Helper / Additional / Custom*/
	            tableattributes: "@?",
	            tableclass: "@?",
	            adminattributes: "@?",
	            /* Settings */
	            showheader: "=?",
	            showSearch: "=?",
	            showTopPagination: "=?",
	            /* Basic Action Caller Overrides*/
	            createModal: "=?",
	            createAction: "@?",
	            createQueryString: "@?",
	            exportAction: "@?",
	            getChildCount: "=?",
	            hasSearch: "=?"
	        };
	        this.controller = SWListingDisplayController;
	        this.controllerAs = "swListingDisplay";
	        this.corePartialsPath = corePartialsPath;
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.corePartialsPath) + 'listingdisplay.html';
	    }
	    SWListingDisplay.Factory = function () {
	        var directive = function (corePartialsPath, hibachiPathBuilder) {
	            return new SWListingDisplay(corePartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            'corePartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWListingDisplay;
	})();
	exports.SWListingDisplay = SWListingDisplay;


/***/ },
/* 41 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWListingAggregateController = (function () {
	    function SWListingAggregateController() {
	        var _this = this;
	        this.init = function () {
	            _this.editable = _this.editable || false;
	        };
	        this.init();
	    }
	    return SWListingAggregateController;
	})();
	var SWListingAggregate = (function () {
	    function SWListingAggregate() {
	        this.restrict = 'EA';
	        this.scope = true;
	        this.bindToController = {
	            propertyIdentifier: "@",
	            aggregateFunction: "@",
	            aggregateAlias: "@?"
	        };
	        this.controller = SWListingAggregateController;
	        this.controllerAs = "swListingAggregate";
	        this.link = function (scope, element, attrs) {
	            var aggregate = {
	                propertyIdentifier: scope.swListingAggregate.propertyIdentifier,
	                aggregateFunction: scope.swListingAggregate.aggregateFunction,
	                aggregateAlias: scope.swListingAggregate.aggregateAlias,
	            };
	            scope.$parent.swListingDisplay.aggregates.push(aggregate);
	        };
	    }
	    SWListingAggregate.Factory = function () {
	        var directive = function () {
	            return new SWListingAggregate();
	        };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWListingAggregate;
	})();
	exports.SWListingAggregate = SWListingAggregate;


/***/ },
/* 42 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWListingColorFilterController = (function () {
	    function SWListingColorFilterController() {
	        this.init = function () {
	        };
	        this.init();
	    }
	    return SWListingColorFilterController;
	})();
	var SWListingColorFilter = (function () {
	    function SWListingColorFilter(utilityService) {
	        var _this = this;
	        this.utilityService = utilityService;
	        this.restrict = 'EA';
	        this.scope = true;
	        this.bindToController = {
	            propertyToCompare: "@",
	            comparisonOperator: "@",
	            comparisonValue: "@",
	            comparisonProperty: "@",
	            colorClass: "@",
	            color: "@"
	        };
	        this.controller = SWListingColorFilterController;
	        this.controllerAs = "swListingColorFilter";
	        this.link = function (scope, element, attrs) {
	            var colorFilter = {
	                propertyToCompare: scope.swListingColorFilter.propertyToCompare,
	                comparisonOperator: scope.swListingColorFilter.comparisonOperator,
	                comparisonValue: scope.swListingColorFilter.comparisonValue,
	                comparisonProperty: scope.swListingColorFilter.comparisonProperty,
	                colorClass: scope.swListingColorFilter.colorClass,
	                color: scope.swListingColorFilter.color
	            };
	            if (_this.utilityService.ArrayFindByPropertyValue(scope.$parent.swListingDisplay.colorFilters, 'propertyToCompare', colorFilter.propertyToCompare) === -1) {
	                scope.$parent.swListingDisplay.colorFilters.push(colorFilter);
	            }
	        };
	    }
	    SWListingColorFilter.Factory = function () {
	        var directive = function (utilityService) {
	            return new SWListingColorFilter(utilityService);
	        };
	        directive.$inject = [
	            'utilityService'
	        ];
	        return directive;
	    };
	    return SWListingColorFilter;
	})();
	exports.SWListingColorFilter = SWListingColorFilter;


/***/ },
/* 43 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWListingColumnController = (function () {
	    function SWListingColumnController() {
	        var _this = this;
	        this.init = function () {
	            _this.editable = _this.editable || false;
	        };
	        this.init();
	    }
	    return SWListingColumnController;
	})();
	var SWListingColumn = (function () {
	    function SWListingColumn(utilityService) {
	        var _this = this;
	        this.utilityService = utilityService;
	        this.restrict = 'EA';
	        this.scope = true;
	        this.bindToController = {
	            propertyIdentifier: "@",
	            processObjectProperty: "@?",
	            title: "@?",
	            tdclass: "@?",
	            search: "=?",
	            sort: "=?",
	            filter: "=?",
	            range: "=?",
	            editable: "=?",
	            buttonGroup: "=?"
	        };
	        this.controller = SWListingColumnController;
	        this.controllerAs = "swListingColumn";
	        this.link = function (scope, element, attrs) {
	            var column = {
	                propertyIdentifier: scope.swListingColumn.propertyIdentifier,
	                processObjectProperty: scope.swListingColumn.processObjectProperty,
	                title: scope.swListingColumn.title,
	                tdclass: scope.swListingColumn.tdclass,
	                search: scope.swListingColumn.search,
	                sort: scope.swListingColumn.sort,
	                filter: scope.swListingColumn.filter,
	                range: scope.swListingColumn.range,
	                editable: scope.swListingColumn.editable,
	                buttonGroup: scope.swListingColumn.buttonGroup
	            };
	            if (_this.utilityService.ArrayFindByPropertyValue(scope.$parent.swListingDisplay.columns, 'propertyIdentifier', column.propertyIdentifier) === -1) {
	                scope.$parent.swListingDisplay.columns.push(column);
	            }
	        };
	    }
	    SWListingColumn.Factory = function () {
	        var directive = function (utilityService) {
	            return new SWListingColumn(utilityService);
	        };
	        directive.$inject = [
	            'utilityService'
	        ];
	        return directive;
	    };
	    SWListingColumn.$inject = ['utilityService'];
	    return SWListingColumn;
	})();
	exports.SWListingColumn = SWListingColumn;


/***/ },
/* 44 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWListingFilterController = (function () {
	    function SWListingFilterController() {
	        this.init = function () {
	        };
	        this.init();
	    }
	    return SWListingFilterController;
	})();
	var SWListingFilter = (function () {
	    function SWListingFilter() {
	        this.restrict = 'EA';
	        this.scope = true;
	        this.bindToController = {
	            propertyIdentifier: "@",
	            comparisonOperator: "@",
	            comparisonValue: "@",
	            logicalOperator: "@",
	        };
	        this.controller = SWListingFilterController;
	        this.controllerAs = "swListingFilter";
	        this.link = function (scope, element, attrs) {
	            var filter = {
	                propertyIdentifier: scope.swListingFilter.propertyIdentifier,
	                comparisonOperator: scope.swListingFilter.comparisonOperator,
	                comparisonValue: scope.swListingFilter.comparisonValue,
	                logicalOperator: scope.swListingFilter.logicalOperator,
	            };
	            scope.$parent.swListingDisplay.filters.push(filter);
	        };
	    }
	    SWListingFilter.Factory = function () {
	        var directive = function () {
	            return new SWListingFilter();
	        };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWListingFilter;
	})();
	exports.SWListingFilter = SWListingFilter;


/***/ },
/* 45 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWListingOrderByController = (function () {
	    //@ngInject
	    function SWListingOrderByController() {
	        this.init = function () {
	        };
	        this.init();
	    }
	    return SWListingOrderByController;
	})();
	var SWListingOrderBy = (function () {
	    //@ngInject
	    function SWListingOrderBy(utilityService) {
	        this.utilityService = utilityService;
	        this.restrict = 'EA';
	        this.scope = true;
	        this.bindToController = {
	            orderBy: "@",
	        };
	        this.controller = SWListingOrderByController;
	        this.controllerAs = "swListingOrderBy";
	        this.link = function (scope, element, attrs) {
	            var orderBy = {
	                orderBy: scope.swListingOrderBy.orderBy,
	            };
	            scope.$parent.swListingDisplay.orderBys.push(orderBy);
	        };
	    }
	    SWListingOrderBy.Factory = function () {
	        var directive = function (utilityService) {
	            return new SWListingOrderBy(utilityService);
	        };
	        directive.$inject = [
	            'utilityService'
	        ];
	        return directive;
	    };
	    return SWListingOrderBy;
	})();
	exports.SWListingOrderBy = SWListingOrderBy;


/***/ },
/* 46 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWLoginController = (function () {
	    function SWLoginController($route, $log, $window, corePartialsPath, $hibachi, dialogService) {
	        var _this = this;
	        this.$route = $route;
	        this.$log = $log;
	        this.$window = $window;
	        this.corePartialsPath = corePartialsPath;
	        this.$hibachi = $hibachi;
	        this.dialogService = dialogService;
	        this.login = function () {
	            var loginPromise = _this.$hibachi.login(_this.account_login.data.emailAddress, _this.account_login.data.password);
	            loginPromise.then(function (loginResponse) {
	                if (loginResponse && loginResponse.data && loginResponse.data.token) {
	                    _this.$window.localStorage.setItem('token', loginResponse.data.token);
	                    _this.$route.reload();
	                    _this.dialogService.removeCurrentDialog();
	                }
	            });
	        };
	        this.$hibachi = $hibachi;
	        this.$window = $window;
	        this.$route = $route;
	        this.account_login = $hibachi.newEntity('Account_Login');
	    }
	    return SWLoginController;
	})();
	var SWLogin = (function () {
	    function SWLogin($route, $log, $window, corePartialsPath, $hibachi, dialogService, hibachiPathBuilder) {
	        this.$route = $route;
	        this.$log = $log;
	        this.$window = $window;
	        this.corePartialsPath = corePartialsPath;
	        this.$hibachi = $hibachi;
	        this.dialogService = dialogService;
	        this.restrict = 'E';
	        this.scope = {};
	        this.bindToController = {};
	        this.controller = SWLoginController;
	        this.controllerAs = "SwLogin";
	        this.link = function (scope, element, attrs) {
	        };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this).corePartialsPath + '/login.html';
	    }
	    SWLogin.Factory = function () {
	        var directive = function ($route, $log, $window, corePartialsPath, $hibachi, dialogService, hibachiPathBuilder) {
	            return new SWLogin($route, $log, $window, corePartialsPath, $hibachi, dialogService, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$route',
	            '$log',
	            '$window',
	            'corePartialsPath',
	            '$hibachi',
	            'dialogService',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWLogin;
	})();
	exports.SWLogin = SWLogin;


/***/ },
/* 47 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWNumbersOnly = (function () {
	    function SWNumbersOnly() {
	        this.restrict = "A";
	        this.require = "ngModel";
	        this.scope = {
	            ngModel: '=',
	            minNumber: '=?',
	            maxNumber: '=?'
	        };
	        this.link = function ($scope, element, attrs, modelCtrl) {
	            modelCtrl.$parsers.unshift(function (inputValue) {
	                var modelValue = modelCtrl.$modelValue;
	                if (inputValue != "" && !isNaN(Number(inputValue))) {
	                    if (angular.isDefined($scope.minNumber)) {
	                        if (Number(inputValue) >= $scope.minNumber || !angular.isDefined($scope.minNumber)) {
	                            modelCtrl.$setValidity("minNumber", true);
	                        }
	                        else if (angular.isDefined($scope.minNumber)) {
	                            modelCtrl.$setValidity("minNumber", false);
	                        }
	                    }
	                    if (angular.isDefined($scope.maxNumber)) {
	                        if (Number(inputValue) <= $scope.maxNumber || !angular.isDefined($scope.maxNumber)) {
	                            modelCtrl.$setValidity("maxNumber", true);
	                        }
	                        else if (angular.isDefined($scope.maxNumber)) {
	                            modelCtrl.$setValidity("maxNumber", false);
	                        }
	                    }
	                    if (modelCtrl.$valid) {
	                        modelValue = Number(inputValue);
	                    }
	                    else {
	                        modelValue = $scope.minNumber;
	                    }
	                }
	                return modelValue;
	            });
	        };
	    }
	    SWNumbersOnly.Factory = function () {
	        var directive = function () { return new SWNumbersOnly(); };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWNumbersOnly;
	})();
	exports.SWNumbersOnly = SWNumbersOnly;


/***/ },
/* 48 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWLoading = (function () {
	    function SWLoading($log, corePartialsPath, hibachiPathBuilder) {
	        return {
	            restrict: 'A',
	            transclude: true,
	            templateUrl: hibachiPathBuilder.buildPartialsPath(corePartialsPath) + 'loading.html',
	            scope: {
	                swLoading: '='
	            },
	            link: function (scope, attrs, element) {
	            }
	        };
	    }
	    SWLoading.Factory = function () {
	        var directive = function ($log, corePartialsPath, hibachiPathBuilder) {
	            return new SWLoading($log, corePartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            'corePartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWLoading;
	})();
	exports.SWLoading = SWLoading;


/***/ },
/* 49 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWScrollTrigger = (function () {
	    function SWScrollTrigger($rootScope, $window, $timeout) {
	        return {
	            link: function (scope, elem, attrs) {
	                var checkWhenEnabled, handler, scrollDistance, scrollEnabled;
	                $window = angular.element($window);
	                scrollDistance = 0;
	                if (attrs.infiniteScrollDistance != null) {
	                    scope
	                        .$watch(attrs.infiniteScrollDistance, function (value) {
	                        return scrollDistance = parseInt(value, 10);
	                    });
	                }
	                scrollEnabled = true;
	                checkWhenEnabled = false;
	                if (attrs.infiniteScrollDisabled != null) {
	                    scope
	                        .$watch(attrs.infiniteScrollDisabled, function (value) {
	                        scrollEnabled = !value;
	                        if (scrollEnabled
	                            && checkWhenEnabled) {
	                            checkWhenEnabled = false;
	                            return handler();
	                        }
	                    });
	                }
	                handler = function () {
	                    var elementBottom, remaining, shouldScroll, windowBottom;
	                    windowBottom = $window.height()
	                        + $window.scrollTop();
	                    elementBottom = elem.offset().top
	                        + elem.height();
	                    remaining = elementBottom
	                        - windowBottom;
	                    shouldScroll = remaining <= $window
	                        .height()
	                        * scrollDistance;
	                    if (shouldScroll && scrollEnabled) {
	                        if ($rootScope.$$phase) {
	                            return scope
	                                .$eval(attrs.infiniteScroll);
	                        }
	                        else {
	                            return scope
	                                .$apply(attrs.infiniteScroll);
	                        }
	                    }
	                    else if (shouldScroll) {
	                        return checkWhenEnabled = true;
	                    }
	                };
	                $window.on('scroll', handler);
	                scope.$on('$destroy', function () {
	                    return $window.off('scroll', handler);
	                });
	                return $timeout((function () {
	                    if (attrs.infiniteScrollImmediateCheck) {
	                        if (scope
	                            .$eval(attrs.infiniteScrollImmediateCheck)) {
	                            return handler();
	                        }
	                    }
	                    else {
	                        return handler();
	                    }
	                }), 0);
	            }
	        };
	    }
	    SWScrollTrigger.Factory = function () {
	        var directive = function ($rootScope, $window, $timeout) {
	            return new SWScrollTrigger($rootScope, $window, $timeout);
	        };
	        directive.$inject = [
	            '$rootScope',
	            '$window',
	            '$timeout'
	        ];
	        return directive;
	    };
	    return SWScrollTrigger;
	})();
	exports.SWScrollTrigger = SWScrollTrigger;


/***/ },
/* 50 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWTooltipController = (function () {
	    // @ngInject
	    function SWTooltipController(rbkeyService) {
	        var _this = this;
	        this.rbkeyService = rbkeyService;
	        this.showTooltip = false;
	        this.show = function () {
	            _this.showTooltip = true;
	        };
	        this.hide = function () {
	            _this.showTooltip = false;
	        };
	        if (angular.isDefined(this.rbKey)) {
	            this.text = rbkeyService.getRBKey(this.rbKey);
	        }
	        if (angular.isUndefined(this.position)) {
	            this.position = "top";
	        }
	    }
	    return SWTooltipController;
	})();
	exports.SWTooltipController = SWTooltipController;
	var SWTooltip = (function () {
	    // @ngInject
	    function SWTooltip($document, corePartialsPath, hibachiPathBuilder) {
	        this.$document = $document;
	        this.corePartialsPath = corePartialsPath;
	        this.transclude = true;
	        this.restrict = "EA";
	        this.scope = {};
	        this.bindToController = {
	            rbKey: "@?",
	            text: "@?",
	            position: "@?",
	            showTooltip: "=?"
	        };
	        this.controller = SWTooltipController;
	        this.controllerAs = "swTooltip";
	        this.link = function (scope, element, attrs, controller, transclude) {
	            var tooltip = element.find(".tooltip");
	            var elementPosition = element.position();
	            var tooltipStyle = tooltip[0].style;
	            if (attrs && attrs.position) {
	                switch (attrs.position.toLowerCase()) {
	                    case 'top':
	                        tooltipStyle.top = "0px";
	                        tooltipStyle.left = "0px";
	                        break;
	                    case 'bottom':
	                        //where the element is rendered to begin with
	                        break;
	                    case 'left':
	                        tooltipStyle.top = (elementPosition.top + element[0].offsetHeight - 5) + "px";
	                        tooltipStyle.left = (-1 * (elementPosition.left + element[0].offsetLeft - 5)) + "px";
	                        element.find(".tooltip-inner")[0].style.maxWidth = "none";
	                        break;
	                    default:
	                        //right is the default
	                        tooltipStyle.top = (elementPosition.top + element[0].offsetHeight - 5) + "px";
	                        tooltipStyle.left = (elementPosition.left + element[0].offsetWidth - 5) + "px";
	                }
	            }
	        };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "tooltip.html";
	    }
	    SWTooltip.Factory = function () {
	        var directive = function ($document, corePartialsPath, hibachiPathBuilder) { return new SWTooltip($document, corePartialsPath, hibachiPathBuilder); };
	        directive.$inject = ["$document", "corePartialsPath", "hibachiPathBuilder"];
	        return directive;
	    };
	    return SWTooltip;
	})();
	exports.SWTooltip = SWTooltip;


/***/ },
/* 51 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWRbKey = (function () {
	    function SWRbKey($hibachi, observerService, utilityService, $rootScope, $log, rbkeyService) {
	        return {
	            restrict: 'A',
	            scope: {
	                swRbkey: "="
	            },
	            link: function (scope, element, attrs) {
	                var rbKeyValue = scope.swRbkey;
	                var bindRBKey = function () {
	                    if (angular.isDefined(rbKeyValue) && angular.isString(rbKeyValue)) {
	                        element.text(rbkeyService.getRBKey(rbKeyValue));
	                    }
	                };
	                bindRBKey();
	            }
	        };
	    }
	    SWRbKey.Factory = function () {
	        var directive = function ($hibachi, observerService, utilityService, $rootScope, $log, rbkeyService) {
	            return new SWRbKey($hibachi, observerService, utilityService, $rootScope, $log, rbkeyService);
	        };
	        directive.$inject = [
	            '$hibachi',
	            'observerService',
	            'utilityService',
	            '$rootScope',
	            '$log',
	            'rbkeyService'
	        ];
	        return directive;
	    };
	    return SWRbKey;
	})();
	exports.SWRbKey = SWRbKey;


/***/ },
/* 52 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWOptions = (function () {
	    function SWOptions($log, $hibachi, observerService, corePartialsPath, hibachiPathBuilder) {
	        return {
	            restrict: 'AE',
	            scope: {
	                objectName: '@'
	            },
	            templateUrl: hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "options.html",
	            link: function (scope, element, attrs) {
	                scope.swOptions = {};
	                scope.swOptions.objectName = scope.objectName;
	                //sets up drop down options via collections
	                scope.getOptions = function () {
	                    scope.swOptions.object = $hibachi['new' + scope.swOptions.objectName]();
	                    var columnsConfig = [
	                        {
	                            "propertyIdentifier": scope.swOptions.objectName.charAt(0).toLowerCase() + scope.swOptions.objectName.slice(1) + 'Name'
	                        },
	                        {
	                            "propertyIdentifier": scope.swOptions.object.$$getIDName()
	                        }
	                    ];
	                    $hibachi.getEntity(scope.swOptions.objectName, { allRecords: true, columnsConfig: angular.toJson(columnsConfig) })
	                        .then(function (value) {
	                        scope.swOptions.options = value.records;
	                        observerService.notify('optionsLoaded');
	                    });
	                };
	                scope.getOptions();
	                var selectFirstOption = function () {
	                    scope.swOptions.selectOption(scope.swOptions.options[0]);
	                };
	                observerService.attach(selectFirstOption, 'selectFirstOption', 'selectFirstOption');
	                //use by ng-change to record changes
	                scope.swOptions.selectOption = function (selectedOption) {
	                    scope.swOptions.selectedOption = selectedOption;
	                    observerService.notify('optionsChanged', selectedOption);
	                };
	            }
	        };
	    }
	    SWOptions.Factory = function () {
	        var directive = function ($log, $hibachi, observerService, corePartialsPath, hibachiPathBuilder) {
	            return new SWOptions($log, $hibachi, observerService, corePartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            '$hibachi',
	            'observerService',
	            'corePartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWOptions;
	})();
	exports.SWOptions = SWOptions;


/***/ },
/* 53 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWSelection = (function () {
	    function SWSelection($log, selectionService, observerService, corePartialsPath, hibachiPathBuilder) {
	        return {
	            restrict: 'E',
	            templateUrl: hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "selection.html",
	            scope: {
	                selection: "=",
	                selectionid: "@",
	                id: "=",
	                isRadio: "=",
	                name: "@",
	                disabled: "="
	            },
	            link: function (scope, $element, $attrs) {
	                if (!scope.name) {
	                    scope.name = 'selection';
	                }
	                if (selectionService.hasSelection(scope.selectionid, scope.selection)) {
	                    scope.toggleValue = true;
	                }
	                scope.toggleSelection = function (toggleValue, selectionid, selection) {
	                    console.log('selected!');
	                    console.log(toggleValue);
	                    console.log(selectionid);
	                    console.log(selection);
	                    if (scope.isRadio) {
	                        selectionService.radioSelection(selectionid, selection);
	                    }
	                    else {
	                        if (toggleValue) {
	                            selectionService.addSelection(selectionid, selection);
	                        }
	                        else {
	                            selectionService.removeSelection(selectionid, selection);
	                        }
	                    }
	                    observerService.notify('swSelectionToggleSelection', { selectionid: selectionid, selection: selection });
	                };
	            }
	        };
	    }
	    SWSelection.Factory = function () {
	        var directive = function ($log, selectionService, observerService, corePartialsPath, hibachiPathBuilder) {
	            return new SWSelection($log, selectionService, observerService, corePartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            'selectionService',
	            'observerService',
	            'corePartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWSelection;
	})();
	exports.SWSelection = SWSelection;


/***/ },
/* 54 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWClickOutside = (function () {
	    //@ngInject
	    function SWClickOutside($document, $timeout, utilityService) {
	        this.$document = $document;
	        this.$timeout = $timeout;
	        this.utilityService = utilityService;
	        this.restrict = 'A';
	        this.scope = {
	            swClickOutside: '&'
	        };
	        this.link = function (scope, elem, attr) {
	            $document.on('click', function (e) {
	                if (!e || !e.target)
	                    return;
	                //check if our element already hiden
	                if (angular.element(elem).hasClass("ng-hide")) {
	                    return;
	                }
	                if (e.target !== elem && !utilityService.isDescendantElement(elem, e.target)) {
	                    $timeout(function () {
	                        scope.swClickOutside();
	                    });
	                }
	            });
	        };
	        this.$document = $document;
	        this.$timeout = $timeout;
	        this.utilityService = utilityService;
	    }
	    SWClickOutside.Factory = function () {
	        var directive = function ($document, $timeout, utilityService) {
	            return new SWClickOutside($document, $timeout, utilityService);
	        };
	        directive.$inject = [
	            '$document', '$timeout', 'utilityService'
	        ];
	        return directive;
	    };
	    return SWClickOutside;
	})();
	exports.SWClickOutside = SWClickOutside;


/***/ },
/* 55 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWDirective = (function () {
	    //@ngInject
	    function SWDirective($compile) {
	        return {
	            restrict: 'A',
	            replace: true,
	            scope: {
	                variables: "=",
	                directive: "="
	            },
	            link: function (scope, element, attrs) {
	                var template = '<span ' + scope.directive + ' ';
	                if (angular.isDefined(scope.variables)) {
	                    angular.forEach(scope.variables, function (value, key) {
	                        template += ' ' + key + '=' + value + ' ';
	                    });
	                }
	                template += +'>';
	                template += '</span>';
	                // Render the template.
	                element.html('').append($compile(template)(scope));
	            }
	        };
	    }
	    SWDirective.Factory = function () {
	        var directive = function ($compile) {
	            return new SWDirective($compile);
	        };
	        directive.$inject = [
	            '$compile'
	        ];
	        return directive;
	    };
	    return SWDirective;
	})();
	exports.SWDirective = SWDirective;


/***/ },
/* 56 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWExportAction = (function () {
	    //@ngInject
	    function SWExportAction($log, corePartialsPath, hibachiPathBuilder) {
	        return {
	            restrict: 'A',
	            templateUrl: hibachiPathBuilder.buildPartialsPath(corePartialsPath) + 'exportaction.html',
	            scope: {},
	            link: function (scope, element, attrs) {
	            }
	        };
	    }
	    SWExportAction.Factory = function () {
	        var directive = function ($log, corePartialsPath, hibachiPathBuilder) {
	            return new SWExportAction($log, corePartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            'corePartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWExportAction;
	})();
	exports.SWExportAction = SWExportAction;


/***/ },
/* 57 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWHref = (function () {
	    function SWHref() {
	        return {
	            restrict: 'A',
	            scope: {
	                swHref: "@"
	            },
	            link: function (scope, element, attrs) {
	                /*convert link to use hashbang*/
	                var hrefValue = attrs.swHref;
	                hrefValue = '?ng#!' + hrefValue;
	                element.attr('href', hrefValue);
	            }
	        };
	    }
	    SWHref.Factory = function () {
	        var directive = function () {
	            return new SWHref();
	        };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWHref;
	})();
	exports.SWHref = SWHref;


/***/ },
/* 58 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWProcessCallerController = (function () {
	    function SWProcessCallerController($templateRequest, $compile, corePartialsPath, $scope, $element, $transclude, utilityService, hibachiPathBuilder) {
	        var _this = this;
	        this.$templateRequest = $templateRequest;
	        this.$compile = $compile;
	        this.corePartialsPath = corePartialsPath;
	        this.$scope = $scope;
	        this.$element = $element;
	        this.$transclude = $transclude;
	        this.$templateRequest = $templateRequest;
	        this.$compile = $compile;
	        this.corePartialsPath = corePartialsPath;
	        this.utilityService = utilityService;
	        this.type = this.type || 'link';
	        this.queryString = this.queryString || '';
	        this.$scope = $scope;
	        this.$element = $element;
	        this.$transclude = this.$transclude;
	        this.$templateRequest(hibachiPathBuilder.buildPartialsPath(this.corePartialsPath) + "processcaller.html").then(function (html) {
	            var template = angular.element(html);
	            _this.$element.parent().append(template);
	            $compile(template)(_this.$scope);
	        });
	    }
	    SWProcessCallerController.$inject = ['$templateRequest', '$compile', 'corePartialsPath', '$scope', '$element', '$transclude', 'utilityService',
	        'hibachiPathBuilder'];
	    return SWProcessCallerController;
	})();
	var SWProcessCaller = (function () {
	    function SWProcessCaller(corePartialsPath, utilityService) {
	        this.corePartialsPath = corePartialsPath;
	        this.utilityService = utilityService;
	        this.restrict = 'E';
	        this.scope = {};
	        this.bindToController = {
	            action: "@",
	            entity: "@",
	            processContext: "@",
	            hideDisabled: "=",
	            type: "@",
	            queryString: "@",
	            text: "@",
	            title: "@",
	            'class': "@",
	            icon: "=",
	            iconOnly: "=",
	            submit: "=",
	            confirm: "=",
	            disabled: "=",
	            disabledText: "@",
	            modal: "="
	        };
	        this.controller = SWProcessCallerController;
	        this.controllerAs = "swProcessCaller";
	        this.link = function (scope, element, attrs) {
	        };
	        this.corePartialsPath = corePartialsPath;
	        this.utilityService = utilityService;
	    }
	    SWProcessCaller.Factory = function () {
	        var directive = function (corePartialsPath, utilityService) {
	            return new SWProcessCaller(corePartialsPath, utilityService);
	        };
	        directive.$inject = [
	            'corePartialsPath', 'utilityService'
	        ];
	        return directive;
	    };
	    SWProcessCaller.$inject = ['corePartialsPath', 'utilityService'];
	    return SWProcessCaller;
	})();
	exports.SWProcessCaller = SWProcessCaller;


/***/ },
/* 59 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWSortable = (function () {
	    function SWSortable(expression, compiledElement) {
	        return function (linkElement) {
	            var scope = this;
	            linkElement.sortable({
	                placeholder: "placeholder",
	                opacity: 0.8,
	                axis: "y",
	                update: function (event, ui) {
	                    // get model
	                    var model = scope.$apply(expression);
	                    // remember its length
	                    var modelLength = model.length;
	                    // rember html nodes
	                    var items = [];
	                    // loop through items in new order
	                    linkElement.children().each(function (index) {
	                        var item = $(this);
	                        // get old item index
	                        var oldIndex = parseInt(item.attr("sw:sortable-index"), 10);
	                        // add item to the end of model
	                        model.push(model[oldIndex]);
	                        if (item.attr("sw:sortable-index")) {
	                            // items in original order to restore dom
	                            items[oldIndex] = item;
	                            // and remove item from dom
	                            item.detach();
	                        }
	                    });
	                    model.splice(0, modelLength);
	                    // restore original dom order, so angular does not get confused
	                    linkElement.append.apply(linkElement, items);
	                    // notify angular of the change
	                    scope.$digest();
	                }
	            });
	        };
	    }
	    SWSortable.Factory = function () {
	        var directive = function (expression, compiledElement) { return new SWSortable(expression, compiledElement); };
	        directive.$inject = ['expression', 'compiledElement'];
	        return directive;
	    };
	    return SWSortable;
	})();
	exports.SWSortable = SWSortable;


/***/ },
/* 60 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWListingGlobalSearchController = (function () {
	    //@ngInject
	    function SWListingGlobalSearchController($timeout) {
	        var _this = this;
	        this.$timeout = $timeout;
	        this.init = function () {
	            _this.searching = false;
	        };
	        this.search = function () {
	            _this.searching = true;
	            if (_this._timeoutPromise) {
	                _this.$timeout.cancel(_this._timeoutPromise);
	            }
	            _this._timeoutPromise = _this.$timeout(function () {
	                _this.getCollection();
	            }, 500);
	        };
	        this.init();
	    }
	    return SWListingGlobalSearchController;
	})();
	var SWListingGlobalSearch = (function () {
	    //@ngInject
	    function SWListingGlobalSearch(utilityService, corePartialsPath, hibachiPathBuilder) {
	        this.utilityService = utilityService;
	        this.restrict = 'EA';
	        this.scope = {};
	        this.bindToController = {
	            searching: "=",
	            searchText: "=",
	            getCollection: "="
	        };
	        this.controller = SWListingGlobalSearchController;
	        this.controllerAs = "swListingGlobalSearch";
	        this.link = function (scope, element, attrs) {
	        };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "listingglobalsearch.html";
	    }
	    SWListingGlobalSearch.Factory = function () {
	        var directive = function (utilityService, corePartialsPath, hibachiPathBuilder) { return new SWListingGlobalSearch(utilityService, corePartialsPath, hibachiPathBuilder); };
	        directive.$inject = ['utilityService', 'corePartialsPath', 'hibachiPathBuilder'];
	        return directive;
	    };
	    return SWListingGlobalSearch;
	})();
	exports.SWListingGlobalSearch = SWListingGlobalSearch;


/***/ },
/* 61 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path="../../typings/tsd.d.ts" />
	/// <reference path="../../typings/hibachiTypescript.d.ts" />
	//modules
	var hibachi_module_1 = __webpack_require__(62);
	//controllers
	var frontend_1 = __webpack_require__(130);
	//directives
	var swfdirective_1 = __webpack_require__(131);
	//need to inject the public service into the rootscope for use in the directives.
	//Also, we set the initial value for account and cart.
	var frontendmodule = angular.module('frontend', [hibachi_module_1.hibachimodule.name])
	    .config(['hibachiPathBuilder', function (hibachiPathBuilder) {
	        /** set the baseURL */
	        hibachiPathBuilder.setBaseURL('/');
	        hibachiPathBuilder.setBasePartialsPath('custom/assets/');
	    }])
	    .run(['$rootScope', '$hibachi', 'publicService', 'hibachiPathBuilder', function ($rootScope, $hibachi, publicService, hibachiPathBuilder) {
	        $rootScope.hibachiScope = publicService;
	        $rootScope.hibachiScope.getAccount();
	        $rootScope.hibachiScope.getCart();
	        $rootScope.hibachiScope.getCountries();
	        $rootScope.hibachiScope.getStates();
	        $rootScope.slatwall = $rootScope.hibachiScope;
	        $rootScope.slatwall.getProcessObject = $hibachi.newEntity;
	    }])
	    .constant('frontendPartialsPath', 'frontend/components/')
	    .controller('frontendController', frontend_1.FrontendController)
	    .directive('swfDirective', swfdirective_1.SWFDirective.Factory());
	exports.frontendmodule = frontendmodule;


/***/ },
/* 62 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path='../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../typings/tsd.d.ts' />
	//import alertmodule = require('./alert/alert.module');
	var alert_module_1 = __webpack_require__(63);
	var collection_module_1 = __webpack_require__(67);
	var core_module_1 = __webpack_require__(11);
	var dialog_module_1 = __webpack_require__(92);
	var pagination_module_1 = __webpack_require__(95);
	var form_module_1 = __webpack_require__(98);
	var validation_module_1 = __webpack_require__(113);
	//directives
	var swsaveandfinish_1 = __webpack_require__(129);
	var hibachimodule = angular.module('hibachi', [
	    alert_module_1.alertmodule.name,
	    core_module_1.coremodule.name,
	    collection_module_1.collectionmodule.name,
	    dialog_module_1.dialogmodule.name,
	    pagination_module_1.paginationmodule.name,
	    form_module_1.formmodule.name,
	    validation_module_1.validationmodule.name
	])
	    .constant('hibachiPartialsPath', 'hibachi/components/')
	    .directive('swSaveAndFinish', swsaveandfinish_1.SWSaveAndFinish.Factory());
	exports.hibachimodule = hibachimodule;


/***/ },
/* 63 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path='../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../typings/tsd.d.ts' />
	//controllers
	var alertcontroller_1 = __webpack_require__(64);
	//services
	var alertService_1 = __webpack_require__(65);
	var alertmodule = angular.module('hibachi.alert', [])
	    .controller('alertController', alertcontroller_1.AlertController)
	    .service('alertService', alertService_1.AlertService);
	exports.alertmodule = alertmodule;


/***/ },
/* 64 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var AlertController = (function () {
	    //@ngInject
	    function AlertController($scope, alertService) {
	        $scope.$id = "alertController";
	        $scope.alerts = alertService.getAlerts();
	    }
	    return AlertController;
	})();
	exports.AlertController = AlertController;


/***/ },
/* 65 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	//import Alert = require('../model/alert');
	var alert_1 = __webpack_require__(66);
	var AlertService = (function () {
	    function AlertService($timeout, alerts) {
	        var _this = this;
	        this.$timeout = $timeout;
	        this.alerts = alerts;
	        this.newAlert = function () {
	            return new alert_1.Alert();
	        };
	        this.get = function () {
	            return _this.alerts || [];
	        };
	        this.addAlert = function (alert) {
	            _this.alerts.push(alert);
	            _this.$timeout(function (alert) {
	                _this.removeAlert(alert);
	            }, 3500);
	        };
	        this.addAlerts = function (alerts) {
	            alerts.forEach(function (alert) {
	                _this.addAlert(alert);
	            });
	        };
	        this.removeAlert = function (alert) {
	            var index = _this.alerts.indexOf(alert, 0);
	            if (index != undefined) {
	                _this.alerts.splice(index, 1);
	            }
	        };
	        this.getAlerts = function () {
	            return _this.alerts;
	        };
	        this.formatMessagesToAlerts = function (messages) {
	            var alerts = [];
	            if (messages) {
	                for (var message in messages) {
	                    var alert = new alert_1.Alert();
	                    alert.msg = messages[message].message;
	                    alert.type = messages[message].messageType;
	                    alerts.push(alert);
	                    if (alert.type === 'success' || alert.type === 'error') {
	                        _this.$timeout(function () {
	                            alert.fade = true;
	                        }, 3500);
	                        alert.dismissable = false;
	                    }
	                    else {
	                        alert.fade = false;
	                        alert.dismissable = true;
	                    }
	                }
	            }
	            return alerts;
	        };
	        this.removeOldestAlert = function () {
	            _this.alerts.splice(0, 1);
	        };
	        this.alerts = [];
	    }
	    AlertService.$inject = [
	        '$timeout'
	    ];
	    return AlertService;
	})();
	exports.AlertService = AlertService;


/***/ },
/* 66 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	//model
	var Alert = (function () {
	    function Alert(msg, type, fade, dismissable) {
	        this.fade = false;
	        this.dismissable = false;
	        this.msg = msg;
	        this.type = type;
	        this.fade = fade;
	        this.dismissable = dismissable;
	    }
	    return Alert;
	})();
	exports.Alert = Alert;


/***/ },
/* 67 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path='../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../typings/tsd.d.ts' />
	//modules
	var core_module_1 = __webpack_require__(11);
	//services
	var collectionconfigservice_1 = __webpack_require__(68);
	var collectionservice_1 = __webpack_require__(69);
	//controllers
	var collections_1 = __webpack_require__(70);
	var createcollection_1 = __webpack_require__(71);
	var confirmationcontroller_1 = __webpack_require__(72);
	//directives
	var swcollection_1 = __webpack_require__(73);
	var swaddfilterbuttons_1 = __webpack_require__(74);
	var swdisplayoptions_1 = __webpack_require__(75);
	var swdisplayitem_1 = __webpack_require__(76);
	var swcollectiontable_1 = __webpack_require__(77);
	var swcolumnitem_1 = __webpack_require__(78);
	var swconditioncriteria_1 = __webpack_require__(79);
	var swcriteria_1 = __webpack_require__(80);
	var swcriteriaboolean_1 = __webpack_require__(81);
	var swcriteriadate_1 = __webpack_require__(82);
	var swcriteriamanytomany_1 = __webpack_require__(83);
	var swcriteriamanytoone_1 = __webpack_require__(84);
	var swcriterianumber_1 = __webpack_require__(85);
	var swcriteriaonetomany_1 = __webpack_require__(86);
	var swcriteriastring_1 = __webpack_require__(87);
	var sweditfilteritem_1 = __webpack_require__(88);
	var swfiltergroups_1 = __webpack_require__(89);
	var swfilteritem_1 = __webpack_require__(90);
	var swfiltergroupitem_1 = __webpack_require__(91);
	var collectionmodule = angular.module('hibachi.collection', [core_module_1.coremodule.name])
	    .config([function () {
	    }]).run([function () {
	    }])
	    .constant('collectionPartialsPath', 'collection/components/')
	    .controller('collections', collections_1.CollectionController)
	    .controller('confirmationController', confirmationcontroller_1.ConfirmationController)
	    .controller('createCollection', createcollection_1.CreateCollection)
	    .factory('collectionConfigService', ['rbkeyService', '$hibachi', 'utilityService', function (rbkeyService, $hibachi, utilityService) { return new collectionconfigservice_1.CollectionConfig(rbkeyService, $hibachi, utilityService); }])
	    .service('collectionService', collectionservice_1.CollectionService)
	    .directive('swCollection', swcollection_1.SWCollection.Factory())
	    .directive('swAddFilterButtons', swaddfilterbuttons_1.SWAddFilterButtons.Factory())
	    .directive('swDisplayOptions', swdisplayoptions_1.SWDisplayOptions.Factory())
	    .directive('swDisplayItem', swdisplayitem_1.SWDisplayItem.Factory())
	    .directive('swCollectionTable', swcollectiontable_1.SWCollectionTable.Factory())
	    .directive('swColumnItem', swcolumnitem_1.SWColumnItem.Factory())
	    .directive('swConditionCriteria', swconditioncriteria_1.SWConditionCriteria.Factory())
	    .directive('swCriteria', swcriteria_1.SWCriteria.Factory())
	    .directive('swCriteriaBoolean', swcriteriaboolean_1.SWCriteriaBoolean.Factory())
	    .directive('swCriteriaDate', swcriteriadate_1.SWCriteriaDate.Factory())
	    .directive('swCriteriaManyToMany', swcriteriamanytomany_1.SWCriteriaManyToMany.Factory())
	    .directive('swCriteriaManyToOne', swcriteriamanytoone_1.SWCriteriaManyToOne.Factory())
	    .directive('swCriteriaNumber', swcriterianumber_1.SWCriteriaNumber.Factory())
	    .directive('swCriteriaOneToMany', swcriteriaonetomany_1.SWCriteriaOneToMany.Factory())
	    .directive('swCriteriaString', swcriteriastring_1.SWCriteriaString.Factory())
	    .directive('swEditFilterItem', sweditfilteritem_1.SWEditFilterItem.Factory())
	    .directive('swFilterGroups', swfiltergroups_1.SWFilterGroups.Factory())
	    .directive('swFilterItem', swfilteritem_1.SWFilterItem.Factory())
	    .directive('swFilterGroupItem', swfiltergroupitem_1.SWFilterGroupItem.Factory());
	exports.collectionmodule = collectionmodule;


/***/ },
/* 68 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var Column = (function () {
	    function Column(propertyIdentifier, title, isVisible, isDeletable, isSearchable, isExportable, persistent, ormtype, attributeID, attributeSetObject) {
	        if (isVisible === void 0) { isVisible = true; }
	        if (isDeletable === void 0) { isDeletable = true; }
	        if (isSearchable === void 0) { isSearchable = true; }
	        if (isExportable === void 0) { isExportable = true; }
	        this.propertyIdentifier = propertyIdentifier;
	        this.title = title;
	        this.isVisible = isVisible;
	        this.isDeletable = isDeletable;
	        this.isSearchable = isSearchable;
	        this.isExportable = isExportable;
	        this.persistent = persistent;
	        this.ormtype = ormtype;
	        this.attributeID = attributeID;
	        this.attributeSetObject = attributeSetObject;
	    }
	    return Column;
	})();
	exports.Column = Column;
	var Filter = (function () {
	    function Filter(propertyIdentifier, value, comparisonOperator, logicalOperator, displayPropertyIdentifier, displayValue) {
	        this.propertyIdentifier = propertyIdentifier;
	        this.value = value;
	        this.comparisonOperator = comparisonOperator;
	        this.logicalOperator = logicalOperator;
	        this.displayPropertyIdentifier = displayPropertyIdentifier;
	        this.displayValue = displayValue;
	    }
	    return Filter;
	})();
	exports.Filter = Filter;
	var CollectionFilter = (function () {
	    function CollectionFilter(propertyIdentifier, displayPropertyIdentifier, displayValue, collectionID, criteria, fieldtype, readOnly) {
	        if (readOnly === void 0) { readOnly = false; }
	        this.propertyIdentifier = propertyIdentifier;
	        this.displayPropertyIdentifier = displayPropertyIdentifier;
	        this.displayValue = displayValue;
	        this.collectionID = collectionID;
	        this.criteria = criteria;
	        this.fieldtype = fieldtype;
	        this.readOnly = readOnly;
	    }
	    return CollectionFilter;
	})();
	exports.CollectionFilter = CollectionFilter;
	var Join = (function () {
	    function Join(associationName, alias) {
	        this.associationName = associationName;
	        this.alias = alias;
	    }
	    return Join;
	})();
	exports.Join = Join;
	var OrderBy = (function () {
	    function OrderBy(propertyIdentifier, direction) {
	        this.propertyIdentifier = propertyIdentifier;
	        this.direction = direction;
	    }
	    return OrderBy;
	})();
	exports.OrderBy = OrderBy;
	var CollectionConfig = (function () {
	    // @ngInject
	    function CollectionConfig(rbkeyService, $hibachi, utilityService, baseEntityName, baseEntityAlias, columns, filterGroups, joins, orderBy, groupBys, id, currentPage, pageShow, keywords, allRecords, isDistinct) {
	        var _this = this;
	        if (filterGroups === void 0) { filterGroups = [{ filterGroup: [] }]; }
	        if (currentPage === void 0) { currentPage = 1; }
	        if (pageShow === void 0) { pageShow = 10; }
	        if (keywords === void 0) { keywords = ''; }
	        if (allRecords === void 0) { allRecords = false; }
	        if (isDistinct === void 0) { isDistinct = false; }
	        this.rbkeyService = rbkeyService;
	        this.$hibachi = $hibachi;
	        this.utilityService = utilityService;
	        this.baseEntityName = baseEntityName;
	        this.baseEntityAlias = baseEntityAlias;
	        this.columns = columns;
	        this.filterGroups = filterGroups;
	        this.joins = joins;
	        this.orderBy = orderBy;
	        this.groupBys = groupBys;
	        this.id = id;
	        this.currentPage = currentPage;
	        this.pageShow = pageShow;
	        this.keywords = keywords;
	        this.allRecords = allRecords;
	        this.isDistinct = isDistinct;
	        this.clearFilterGroups = function () {
	            _this.filterGroups = [{ filterGroup: [] }];
	            return _this;
	        };
	        this.newCollectionConfig = function (baseEntityName, baseEntityAlias) {
	            return new CollectionConfig(_this.rbkeyService, _this.$hibachi, _this.utilityService, baseEntityName, baseEntityAlias);
	        };
	        this.loadJson = function (jsonCollection) {
	            //if json then make a javascript object else use the javascript object
	            if (angular.isString(jsonCollection)) {
	                jsonCollection = angular.fromJson(jsonCollection);
	            }
	            _this.baseEntityAlias = jsonCollection.baseEntityAlias;
	            _this.baseEntityName = jsonCollection.baseEntityName;
	            if (angular.isDefined(jsonCollection.filterGroups)) {
	                _this.filterGroups = jsonCollection.filterGroups;
	            }
	            _this.columns = jsonCollection.columns;
	            _this.joins = jsonCollection.joins;
	            _this.keywords = jsonCollection.keywords;
	            _this.orderBy = jsonCollection.orderBy;
	            _this.groupBys = jsonCollection.groupBys;
	            _this.pageShow = jsonCollection.pageShow;
	            _this.allRecords = jsonCollection.allRecords;
	            _this.isDistinct = jsonCollection.isDistinct;
	            return _this;
	        };
	        this.loadFilterGroups = function (filterGroupsConfig) {
	            if (filterGroupsConfig === void 0) { filterGroupsConfig = [{ filterGroup: [] }]; }
	            _this.filterGroups = filterGroupsConfig;
	            return _this;
	        };
	        this.loadColumns = function (columns) {
	            _this.columns = columns;
	            return _this;
	        };
	        this.getCollectionConfig = function () {
	            return {
	                baseEntityAlias: _this.baseEntityAlias,
	                baseEntityName: _this.baseEntityName,
	                columns: _this.columns,
	                filterGroups: _this.filterGroups,
	                joins: _this.joins,
	                groupBys: _this.groupBys,
	                currentPage: _this.currentPage,
	                pageShow: _this.pageShow,
	                keywords: _this.keywords,
	                defaultColumns: (!_this.columns || !_this.columns.length),
	                allRecords: _this.allRecords,
	                isDistinct: _this.isDistinct
	            };
	        };
	        this.getEntityName = function () {
	            return _this.baseEntityName.charAt(0).toUpperCase() + _this.baseEntityName.slice(1);
	        };
	        this.getOptions = function () {
	            var options = {
	                columnsConfig: angular.toJson(_this.columns),
	                filterGroupsConfig: angular.toJson(_this.filterGroups),
	                joinsConfig: angular.toJson(_this.joins),
	                orderByConfig: angular.toJson(_this.orderBy),
	                groupBysConfig: angular.toJson(_this.groupBys),
	                currentPage: _this.currentPage,
	                pageShow: _this.pageShow,
	                keywords: _this.keywords,
	                defaultColumns: (!_this.columns || !_this.columns.length),
	                allRecords: _this.allRecords,
	                isDistinct: _this.isDistinct
	            };
	            if (angular.isDefined(_this.id)) {
	                options['id'] = _this.id;
	            }
	            return options;
	        };
	        this.debug = function () {
	            return _this;
	        };
	        this.formatPropertyIdentifier = function (propertyIdentifier, addJoin) {
	            if (addJoin === void 0) { addJoin = false; }
	            var _propertyIdentifier = _this.baseEntityAlias;
	            if (addJoin === true) {
	                _propertyIdentifier += _this.processJoin(propertyIdentifier);
	            }
	            else {
	                _propertyIdentifier += '.' + propertyIdentifier;
	            }
	            return _propertyIdentifier;
	        };
	        this.processJoin = function (propertyIdentifier) {
	            var _propertyIdentifier = '', propertyIdentifierParts = propertyIdentifier.split('.'), current_collection = _this.collection;
	            for (var i = 0; i < propertyIdentifierParts.length; i++) {
	                if (current_collection.metaData[propertyIdentifierParts[i]].cfc) {
	                    current_collection = _this.$hibachi.getEntityExample(current_collection.metaData[propertyIdentifierParts[i]].cfc);
	                    _propertyIdentifier += '_' + propertyIdentifierParts[i];
	                    _this.addJoin(new Join(_propertyIdentifier.replace(/_/g, '.').substring(1), _this.baseEntityAlias + _propertyIdentifier));
	                }
	                else {
	                    _propertyIdentifier += '.' + propertyIdentifierParts[i];
	                }
	            }
	            return _propertyIdentifier;
	        };
	        this.addJoin = function (join) {
	            if (!_this.joins) {
	                _this.joins = [];
	            }
	            var joinFound = false;
	            angular.forEach(_this.joins, function (configJoin) {
	                if (configJoin.alias === join.alias) {
	                    joinFound = true;
	                }
	            });
	            if (!joinFound) {
	                _this.joins.push(join);
	            }
	            return _this;
	        };
	        this.addAlias = function (propertyIdentifier) {
	            var parts = propertyIdentifier.split('.');
	            if (parts.length > 1 && parts[0] !== _this.baseEntityAlias) {
	                return _this.baseEntityAlias + '.' + propertyIdentifier;
	            }
	            return propertyIdentifier;
	        };
	        this.addColumn = function (column, title, options) {
	            if (title === void 0) { title = ''; }
	            if (options === void 0) { options = {}; }
	            if (!_this.columns || _this.utilityService.ArrayFindByPropertyValue(_this.columns, 'propertyIdentifier', column) === -1) {
	                var isVisible = true, isDeletable = true, isSearchable = true, isExportable = true, persistent, ormtype = 'string', lastProperty = column.split('.').pop();
	                var lastEntity = _this.$hibachi.getEntityExample(_this.$hibachi.getLastEntityNameInPropertyIdentifier(_this.baseEntityName, column));
	                if (angular.isUndefined(_this.columns)) {
	                    _this.columns = [];
	                }
	                if (!angular.isUndefined(options['isVisible'])) {
	                    isVisible = options['isVisible'];
	                }
	                if (!angular.isUndefined(options['isDeletable'])) {
	                    isDeletable = options['isDeletable'];
	                }
	                if (!angular.isUndefined(options['isSearchable'])) {
	                    isSearchable = options['isSearchable'];
	                }
	                if (!angular.isUndefined(options['isExportable'])) {
	                    isExportable = options['isExportable'];
	                }
	                if (angular.isUndefined(options['isExportable']) && !isVisible) {
	                    isExportable = false;
	                }
	                if (!angular.isUndefined(options['ormtype'])) {
	                    ormtype = options['ormtype'];
	                }
	                else if (lastEntity.metaData[lastProperty] && lastEntity.metaData[lastProperty].ormtype) {
	                    ormtype = lastEntity.metaData[lastProperty].ormtype;
	                }
	                if (angular.isDefined(lastEntity.metaData[lastProperty])) {
	                    persistent = lastEntity.metaData[lastProperty].persistent;
	                }
	                var columnObject = new Column(column, title, isVisible, isDeletable, isSearchable, isExportable, persistent, ormtype, options['attributeID'], options['attributeSetObject']);
	                if (options['aggregate']) {
	                    columnObject['aggregate'] = options['aggregate'],
	                        columnObject['aggregateAlias'] = title;
	                }
	                //add any non-conventional options
	                for (var key in options) {
	                    if (!columnObject[key]) {
	                        columnObject[key] = options[key];
	                    }
	                }
	                _this.columns.push(columnObject);
	            }
	            return _this;
	        };
	        this.setDisplayProperties = function (propertyIdentifier, title, options) {
	            if (title === void 0) { title = ''; }
	            if (options === void 0) { options = {}; }
	            _this.addDisplayProperty(propertyIdentifier, title, options);
	            return _this;
	        };
	        this.addDisplayAggregate = function (propertyIdentifier, aggregateFunction, aggregateAlias, options) {
	            var column = {
	                propertyIdentifier: _this.formatPropertyIdentifier(propertyIdentifier, true),
	                title: _this.rbkeyService.getRBKey("entity." + _this.baseEntityName + "." + propertyIdentifier),
	                aggregate: {
	                    aggregateFunction: aggregateFunction,
	                    aggregateAlias: aggregateAlias
	                }
	            };
	            angular.extend(column, options);
	            //Add columns
	            _this.addColumn(column.propertyIdentifier, undefined, column);
	            return _this;
	        };
	        this.addGroupBy = function (groupByAlias) {
	            if (!_this.groupBys) {
	                _this.groupBys = '';
	            }
	            _this.groupBys = _this.utilityService.listAppend(_this.groupBys, groupByAlias);
	            return _this;
	        };
	        this.addDisplayProperty = function (propertyIdentifier, title, options) {
	            if (title === void 0) { title = ''; }
	            if (options === void 0) { options = {}; }
	            var _DividedColumns = propertyIdentifier.trim().split(',');
	            var _DividedTitles = title.trim().split(',');
	            _DividedColumns.forEach(function (column, index) {
	                column = column.trim();
	                if (angular.isDefined(_DividedTitles[index]) && _DividedTitles[index].trim() != '') {
	                    title = _DividedTitles[index].trim();
	                }
	                else {
	                    title = _this.rbkeyService.getRBKey("entity." + _this.baseEntityName + "." + column);
	                }
	                _this.addColumn(_this.formatPropertyIdentifier(column), title, options);
	            });
	            return _this;
	        };
	        this.addFilter = function (propertyIdentifier, value, comparisonOperator, logicalOperator) {
	            if (comparisonOperator === void 0) { comparisonOperator = '='; }
	            //if filterGroups does not exists then set a default
	            if (!_this.filterGroups) {
	                _this.filterGroups = [{ filterGroup: [] }];
	            }
	            //if filterGroups is longer than 0 then we at least need to default the logical Operator to AND
	            if (_this.filterGroups[0].filterGroup.length && !logicalOperator)
	                logicalOperator = 'AND';
	            if (propertyIdentifier.split('.').length < 2) {
	                var join = false;
	            }
	            else {
	                var join = true;
	            }
	            //create filter group
	            var filter = new Filter(_this.formatPropertyIdentifier(propertyIdentifier, join), value, comparisonOperator, logicalOperator, propertyIdentifier.split('.').pop(), value);
	            _this.filterGroups[0].filterGroup.push(filter);
	            return _this;
	        };
	        this.removeFilter = function (propertyIdentifier, value, comparisonOperator) {
	            if (comparisonOperator === void 0) { comparisonOperator = '='; }
	            _this.removeFilterHelper(_this.filterGroups, propertyIdentifier, value, comparisonOperator);
	            return _this;
	        };
	        this.removeFilterHelper = function (filter, propertyIdentifier, value, comparisonOperator, currentGroup) {
	            if (angular.isUndefined(currentGroup)) {
	                currentGroup = filter;
	            }
	            if (angular.isArray(filter)) {
	                angular.forEach(filter, function (key) {
	                    _this.removeFilterHelper(key, propertyIdentifier, value, comparisonOperator, filter);
	                });
	            }
	            else if (angular.isArray(filter.filterGroup)) {
	                _this.removeFilterHelper(filter.filterGroup, propertyIdentifier, value, comparisonOperator, filter.filterGroup);
	            }
	            else {
	                if (filter.propertyIdentifier == propertyIdentifier && filter.value == value && filter.comparisonOperator == comparisonOperator) {
	                    currentGroup.splice(currentGroup.indexOf(filter), 1);
	                }
	            }
	        };
	        this.addCollectionFilter = function (propertyIdentifier, displayPropertyIdentifier, displayValue, collectionID, criteria, fieldtype, readOnly) {
	            if (criteria === void 0) { criteria = 'One'; }
	            if (readOnly === void 0) { readOnly = false; }
	            _this.filterGroups[0].filterGroup.push(new CollectionFilter(_this.formatPropertyIdentifier(propertyIdentifier), displayPropertyIdentifier, displayValue, collectionID, criteria, fieldtype, readOnly));
	            return _this;
	        };
	        //orderByList in this form: "property|direction" concrete: "skuName|ASC"
	        this.setOrderBy = function (orderByList) {
	            var orderBys = orderByList.split(',');
	            angular.forEach(orderBys, function (orderBy) {
	                _this.addOrderBy(orderBy);
	            });
	            return _this;
	        };
	        this.addOrderBy = function (orderByString) {
	            if (!_this.orderBy) {
	                _this.orderBy = [];
	            }
	            var propertyIdentifier = _this.utilityService.listFirst(orderByString, '|');
	            var direction = _this.utilityService.listLast(orderByString, '|');
	            var orderBy = {
	                propertyIdentifier: _this.formatPropertyIdentifier(propertyIdentifier),
	                direction: direction
	            };
	            _this.orderBy.push(orderBy);
	        };
	        this.setCurrentPage = function (pageNumber) {
	            _this.currentPage = pageNumber;
	            return _this;
	        };
	        this.setPageShow = function (NumberOfPages) {
	            _this.pageShow = NumberOfPages;
	            return _this;
	        };
	        this.getPageShow = function () {
	            return _this.pageShow;
	        };
	        this.setAllRecords = function (allFlag) {
	            if (allFlag === void 0) { allFlag = false; }
	            _this.allRecords = allFlag;
	            return _this;
	        };
	        this.setKeywords = function (keyword) {
	            _this.keywords = keyword;
	            return _this;
	        };
	        this.setId = function (id) {
	            _this.id = id;
	            return _this;
	        };
	        this.hasFilters = function () {
	            return (_this.filterGroups.length && _this.filterGroups[0].filterGroup.length);
	        };
	        this.clearFilters = function () {
	            _this.filterGroups = [{ filterGroup: [] }];
	            return _this;
	        };
	        this.getEntity = function (id) {
	            if (angular.isDefined(id)) {
	                _this.setId(id);
	            }
	            return _this.$hibachi.getEntity(_this.baseEntityName, _this.getOptions());
	        };
	        console.log('abc');
	        console.log(rbkeyService);
	        console.log($hibachi);
	        this.$hibachi = $hibachi;
	        this.rbkeyService = rbkeyService;
	        if (angular.isDefined(this.baseEntityName)) {
	            this.collection = this.$hibachi.getEntityExample(this.baseEntityName);
	            if (angular.isUndefined(this.baseEntityAlias)) {
	                this.baseEntityAlias = '_' + this.baseEntityName.toLowerCase();
	            }
	        }
	    }
	    return CollectionConfig;
	})();
	exports.CollectionConfig = CollectionConfig;


/***/ },
/* 69 */
/***/ function(module, exports) {

	var CollectionService = (function () {
	    function CollectionService($filter, $log) {
	        var _this = this;
	        this.$filter = $filter;
	        this.$log = $log;
	        this.get = function () {
	            return _this._pageDialogs || [];
	        };
	        //test
	        this.setFilterCount = function (count) {
	            _this.$log.debug('incrementFilterCount');
	            _this._filterCount = count;
	        };
	        this.getFilterCount = function () {
	            return _this._filterCount;
	        };
	        this.getColumns = function () {
	            return _this._collection.collectionConfig.columns;
	        };
	        this.getFilterPropertiesList = function () {
	            return _this._filterPropertiesList;
	        };
	        this.getFilterPropertiesListByBaseEntityAlias = function (baseEntityAlias) {
	            return _this._filterPropertiesList[baseEntityAlias];
	        };
	        this.setFilterPropertiesList = function (value, key) {
	            if (angular.isUndefined(_this._filterPropertiesList[key])) {
	                _this._filterPropertiesList[key] = value;
	            }
	        };
	        this.stringifyJSON = function (jsonObject) {
	            var jsonString = angular.toJson(jsonObject);
	            return jsonString;
	        };
	        this.removeFilterItem = function (filterItem, filterGroup) {
	            filterGroup.pop(filterGroup.indexOf(filterItem));
	        };
	        this.selectFilterItem = function (filterItem) {
	            if (filterItem.$$isClosed) {
	                for (var i in filterItem.$$siblingItems) {
	                    filterItem.$$siblingItems[i].$$isClosed = true;
	                    filterItem.$$siblingItems[i].$$disabled = true;
	                }
	                filterItem.$$isClosed = false;
	                filterItem.$$disabled = false;
	                filterItem.setItemInUse(true);
	            }
	            else {
	                for (var i in filterItem.$$siblingItems) {
	                    filterItem.$$siblingItems[i].$$disabled = false;
	                }
	                filterItem.$$isClosed = true;
	                filterItem.setItemInUse(false);
	            }
	        };
	        this.selectFilterGroupItem = function (filterGroupItem) {
	            if (filterGroupItem.$$isClosed) {
	                for (var i in filterGroupItem.$$siblingItems) {
	                    filterGroupItem.$$siblingItems[i].$$disabled = true;
	                }
	                filterGroupItem.$$isClosed = false;
	                filterGroupItem.$$disabled = false;
	            }
	            else {
	                for (var i in filterGroupItem.$$siblingItems) {
	                    filterGroupItem.$$siblingItems[i].$$disabled = false;
	                }
	                filterGroupItem.$$isClosed = true;
	            }
	            filterGroupItem.setItemInUse(!filterGroupItem.$$isClosed);
	        };
	        this.newFilterItem = function (filterItemGroup, setItemInUse, prepareForFilterGroup) {
	            if (angular.isUndefined(prepareForFilterGroup)) {
	                prepareForFilterGroup = false;
	            }
	            var filterItem = {
	                displayPropertyIdentifier: "",
	                propertyIdentifier: "",
	                comparisonOperator: "",
	                value: "",
	                $$disabled: false,
	                $$isClosed: true,
	                $$isNew: true,
	                $$siblingItems: filterItemGroup,
	                setItemInUse: setItemInUse
	            };
	            if (filterItemGroup.length !== 0) {
	                filterItem.logicalOperator = "AND";
	            }
	            if (prepareForFilterGroup === true) {
	                filterItem.$$prepareForFilterGroup = true;
	            }
	            filterItemGroup.push(filterItem);
	            _this.selectFilterItem(filterItem);
	        };
	        this.newFilterGroupItem = function (filterItemGroup, setItemInUse) {
	            var filterGroupItem = {
	                filterGroup: [],
	                $$disabled: "false",
	                $$isClosed: "true",
	                $$siblingItems: filterItemGroup,
	                $$isNew: "true",
	                setItemInUse: setItemInUse
	            };
	            if (filterItemGroup.length !== 0) {
	                filterGroupItem.logicalOperator = "AND";
	            }
	            filterItemGroup.push(filterGroupItem);
	            _this.selectFilterGroupItem(filterGroupItem);
	            _this.newFilterItem(filterGroupItem.filterGroup, setItemInUse, undefined);
	        };
	        this.transplantFilterItemIntoFilterGroup = function (filterGroup, filterItem) {
	            var filterGroupItem = {
	                filterGroup: [],
	                $$disabled: "false",
	                $$isClosed: "true",
	                $$isNew: "true"
	            };
	            if (angular.isDefined(filterItem.logicalOperator)) {
	                filterGroupItem.logicalOperator = filterItem.logicalOperator;
	                delete filterItem.logicalOperator;
	            }
	            filterGroupItem.setItemInUse = filterItem.setItemInUse;
	            filterGroupItem.$$siblingItems = filterItem.$$siblingItems;
	            filterItem.$$siblingItems = [];
	            filterGroup.pop(filterGroup.indexOf(filterItem));
	            filterItem.$$prepareForFilterGroup = false;
	            filterGroupItem.filterGroup.push(filterItem);
	            filterGroup.push(filterGroupItem);
	        };
	        this.formatFilterPropertiesList = function (filterPropertiesList, propertyIdentifier) {
	            _this.$log.debug('format Filter Properties List arguments 2');
	            _this.$log.debug(filterPropertiesList);
	            _this.$log.debug(propertyIdentifier);
	            var simpleGroup = {
	                $$group: 'simple',
	                displayPropertyIdentifier: '-----------------'
	            };
	            filterPropertiesList.data.push(simpleGroup);
	            var drillDownGroup = {
	                $$group: 'drilldown',
	                displayPropertyIdentifier: '-----------------'
	            };
	            filterPropertiesList.data.push(drillDownGroup);
	            var compareCollections = {
	                $$group: 'compareCollections',
	                displayPropertyIdentifier: '-----------------'
	            };
	            filterPropertiesList.data.push(compareCollections);
	            var attributeCollections = {
	                $$group: 'attribute',
	                displayPropertyIdentifier: '-----------------'
	            };
	            filterPropertiesList.data.push(attributeCollections);
	            for (var i in filterPropertiesList.data) {
	                if (angular.isDefined(filterPropertiesList.data[i].ormtype)) {
	                    if (angular.isDefined(filterPropertiesList.data[i].attributeID)) {
	                        filterPropertiesList.data[i].$$group = 'attribute';
	                    }
	                    else {
	                        filterPropertiesList.data[i].$$group = 'simple';
	                    }
	                }
	                if (angular.isDefined(filterPropertiesList.data[i].fieldtype)) {
	                    if (filterPropertiesList.data[i].fieldtype === 'id') {
	                        filterPropertiesList.data[i].$$group = 'simple';
	                    }
	                    if (filterPropertiesList.data[i].fieldtype === 'many-to-one') {
	                        filterPropertiesList.data[i].$$group = 'drilldown';
	                    }
	                    if (filterPropertiesList.data[i].fieldtype === 'many-to-many' || filterPropertiesList.data[i].fieldtype === 'one-to-many') {
	                        filterPropertiesList.data[i].$$group = 'compareCollections';
	                    }
	                }
	                filterPropertiesList.data[i].propertyIdentifier = propertyIdentifier + '.' + filterPropertiesList.data[i].name;
	            }
	            filterPropertiesList.data = _this._orderBy(filterPropertiesList.data, ['-$$group', 'propertyIdentifier'], false);
	        };
	        this.orderBy = function (propertiesList, predicate, reverse) {
	            return _this._orderBy(propertiesList, predicate, reverse);
	        };
	        this.$filter = $filter;
	        this.$log = $log;
	        this._collection = null;
	        this._collectionConfig = null;
	        this._filterPropertiesList = {};
	        this._filterCount = 0;
	        this._orderBy = $filter('orderBy');
	    }
	    CollectionService.$inject = [
	        '$filter', '$log'
	    ];
	    return CollectionService;
	})();
	exports.CollectionService = CollectionService;


/***/ },
/* 70 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var CollectionController = (function () {
	    //@ngInject
	    function CollectionController($scope, $location, $log, $timeout, $hibachi, collectionService, metadataService, selectionService, paginationService, collectionConfigService, appConfig) {
	        //init values
	        //$scope.collectionTabs =[{tabTitle:'PROPERTIES',isActive:true},{tabTitle:'FILTERS ('+filterCount+')',isActive:false},{tabTitle:'DISPLAY OPTIONS',isActive:false}];
	        $scope.$id = "collectionsController";
	        /*used til we convert to use route params*/
	        var QueryString = function () {
	            // This function is anonymous, is executed immediately and
	            // the return value is assigned to QueryString!
	            var query_string = {};
	            var query = window.location.search.substring(1);
	            var vars = query.split("&");
	            for (var i = 0; i < vars.length; i++) {
	                var pair = vars[i].split("=");
	                // If first entry with this name
	                if (typeof query_string[pair[0]] === "undefined") {
	                    query_string[pair[0]] = pair[1];
	                }
	                else if (typeof query_string[pair[0]] === "string") {
	                    var arr = [query_string[pair[0]], pair[1]];
	                    query_string[pair[0]] = arr;
	                }
	                else {
	                    query_string[pair[0]].push(pair[1]);
	                }
	            }
	            return query_string;
	        }();
	        //get url param to retrieve collection listing
	        $scope.collectionID = QueryString.collectionID;
	        $scope.paginator = paginationService.createPagination();
	        $scope.appendToCollection = function () {
	            if ($scope.paginator.getPageShow() === 'Auto') {
	                $log.debug('AppendToCollection');
	                if ($scope.autoScrollPage < $scope.collection.totalPages) {
	                    $scope.autoScrollDisabled = true;
	                    $scope.autoScrollPage++;
	                    var collectionListingPromise = $hibachi.getEntity('collection', { id: $scope.collectionID, currentPage: $scope.paginator.autoScrollPage, pageShow: 50 });
	                    collectionListingPromise.then(function (value) {
	                        $scope.collection.pageRecords = $scope.collection.pageRecords.concat(value.pageRecords);
	                        $scope.autoScrollDisabled = false;
	                    }, function (reason) {
	                    });
	                }
	            }
	        };
	        $scope.keywords = "";
	        $scope.loadingCollection = false;
	        var searchPromise;
	        $scope.searchCollection = function () {
	            if (searchPromise) {
	                $timeout.cancel(searchPromise);
	            }
	            searchPromise = $timeout(function () {
	                $log.debug('search with keywords');
	                $log.debug($scope.keywords);
	                //Set current page here so that the pagination does not break when getting collection
	                $scope.paginator.setCurrentPage(1);
	                $scope.loadingCollection = true;
	            }, 500);
	        };
	        $scope.getCollection = function () {
	            var pageShow = 50;
	            if ($scope.paginator.getPageShow() !== 'Auto') {
	                pageShow = $scope.paginator.getPageShow();
	            }
	            //			$scope.currentPage = $scope.pagination.getCurrentPage();
	            var collectionListingPromise = $hibachi.getEntity('collection', { id: $scope.collectionID, currentPage: $scope.paginator.getCurrentPage(), pageShow: pageShow, keywords: $scope.keywords });
	            collectionListingPromise.then(function (value) {
	                $scope.collection = value;
	                $scope.paginator.setPageRecordsInfo($scope.collection);
	                $scope.collectionInitial = angular.copy($scope.collection);
	                if (angular.isUndefined($scope.collectionConfig)) {
	                    var test = collectionConfigService.newCollectionConfig();
	                    test.loadJson(value.collectionConfig);
	                    $scope.collectionConfig = test.getCollectionConfig();
	                }
	                //check if we have any filter Groups
	                if (angular.isUndefined($scope.collectionConfig.filterGroups)) {
	                    $scope.collectionConfig.filterGroups = [
	                        {
	                            filterGroup: []
	                        }
	                    ];
	                }
	                collectionService.setFilterCount(filterItemCounter());
	                $scope.loadingCollection = false;
	            }, function (reason) {
	            });
	            return collectionListingPromise;
	        };
	        $scope.paginator.getCollection = $scope.getCollection;
	        $scope.getCollection();
	        var unbindCollectionObserver = $scope.$watch('collection', function (newValue, oldValue) {
	            if (newValue !== oldValue) {
	                if (angular.isUndefined($scope.filterPropertiesList)) {
	                    $scope.filterPropertiesList = {};
	                    var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName($scope.collectionConfig.baseEntityAlias);
	                    filterPropertiesPromise.then(function (value) {
	                        metadataService.setPropertiesList(value, $scope.collectionConfig.baseEntityAlias);
	                        $scope.filterPropertiesList[$scope.collectionConfig.baseEntityAlias] = metadataService.getPropertiesListByBaseEntityAlias($scope.collectionConfig.baseEntityAlias);
	                        metadataService.formatPropertiesList($scope.filterPropertiesList[$scope.collectionConfig.baseEntityAlias], $scope.collectionConfig.baseEntityAlias);
	                    });
	                }
	                unbindCollectionObserver();
	            }
	        });
	        $scope.setCollectionForm = function (form) {
	            $scope.collectionForm = form;
	        };
	        $scope.collectionDetails = {
	            isOpen: false,
	            openCollectionDetails: function () {
	                $scope.collectionDetails.isOpen = true;
	            }
	        };
	        $scope.errorMessage = {};
	        var filterItemCounter = function (filterGroupArray) {
	            var filterItemCount = 0;
	            if (!angular.isDefined(filterGroupArray)) {
	                filterGroupArray = $scope.collectionConfig.filterGroups[0].filterGroup;
	            }
	            //Start out loop
	            for (var index in filterGroupArray) {
	                //If filter isn't new then increment the count
	                if (!filterGroupArray[index].$$isNew
	                    && !angular.isDefined(filterGroupArray[index].filterGroup)) {
	                    filterItemCount++;
	                }
	                else if (angular.isDefined(filterGroupArray[index].filterGroup)) {
	                    //Call function recursively
	                    filterItemCount += filterItemCounter(filterGroupArray[index].filterGroup);
	                }
	                else {
	                    break;
	                }
	            }
	            return filterItemCount;
	        };
	        $scope.saveCollection = function () {
	            $timeout(function () {
	                $log.debug('saving Collection');
	                var entityName = 'collection';
	                var collection = $scope.collection;
	                $log.debug($scope.collectionConfig);
	                if (isFormValid($scope.collectionForm)) {
	                    var collectionConfigString = collectionService.stringifyJSON($scope.collectionConfig);
	                    $log.debug(collectionConfigString);
	                    var data = angular.copy(collection);
	                    data.collectionConfig = collectionConfigString;
	                    //has to be removed in order to save transient correctly
	                    delete data.pageRecords;
	                    var saveCollectionPromise = $hibachi.saveEntity(entityName, collection.collectionID, data, 'save');
	                    saveCollectionPromise.then(function (value) {
	                        $scope.errorMessage = {};
	                        //Set current page here so that the pagination does not break when getting collection
	                        $scope.paginator.setCurrentPage(1);
	                        $scope.collectionDetails.isOpen = false;
	                    }, function (reason) {
	                        //revert to original
	                        angular.forEach(reason.errors, function (value, key) {
	                            $scope.collectionForm[key].$invalid = true;
	                            $scope.errorMessage[key] = value[0];
	                        });
	                        //$scope.collection = angular.copy($scope.collectionInitial);
	                    });
	                }
	                collectionService.setFilterCount(filterItemCounter());
	            });
	        };
	        var isFormValid = function (angularForm) {
	            $log.debug('validateForm');
	            var formValid = true;
	            for (var field in angularForm) {
	                // look at each form input with a name attribute set
	                // checking if it is pristine and not a '$' special field
	                if (field[0] != '$') {
	                    // need to use formValid variable instead of formController.$valid because checkbox dropdown is not an input
	                    // and somehow formController didn't invalid if checkbox dropdown is invalid
	                    if (angularForm[field].$invalid) {
	                        formValid = false;
	                        for (var error in angularForm[field].$error) {
	                            if (error == 'required') {
	                                $scope.errorMessage[field] = 'This field is required';
	                            }
	                        }
	                    }
	                    if (angularForm[field].$pristine) {
	                        if (angular.isUndefined(angularForm[field].$viewValue)) {
	                            angularForm[field].$setViewValue("");
	                        }
	                        else {
	                            angularForm[field].$setViewValue(angularForm[field].$viewValue);
	                        }
	                    }
	                }
	            }
	            return formValid;
	        };
	        $scope.copyExistingCollection = function () {
	            $scope.collection.collectionConfig = $scope.selectedExistingCollection;
	        };
	        $scope.setSelectedExistingCollection = function (selectedExistingCollection) {
	            $scope.selectedExistingCollection = selectedExistingCollection;
	        };
	        $scope.setSelectedFilterProperty = function (selectedFilterProperty) {
	            $scope.selectedFilterProperty = selectedFilterProperty;
	        };
	        $scope.filterCount = collectionService.getFilterCount;
	        //export action
	        $scope.exportCollection = function () {
	            var url = '/?' + appConfig.action + '=main.collectionExport&collectionExportID=' + $scope.collectionID + '&downloadReport=1';
	            var data = { "ids": selectionService.getSelections('collectionSelection') };
	            var target = "downloadCollection";
	            $('body').append('<form action="' + url + '" method="post" target="' + target + '" id="postToIframe"></form>');
	            $.each(data, function (n, v) {
	                $('#postToIframe').append('<input type="hidden" name="' + n + '" value="' + v + '" />');
	            });
	            $('#postToIframe').submit().remove();
	        };
	    }
	    return CollectionController;
	})();
	exports.CollectionController = CollectionController;
	// 'use strict';
	// angular.module('slatwalladmin')
	// //using $location to get url params, this will probably change to using routes eventually
	// .controller('collections', [
	// 	'$scope',
	// '$location',
	// '$log',
	// '$timeout',
	// '$hibachi',
	// 'collectionService',
	// 'metadataService',
	// 'selectionService',
	// 'paginationService',
	// 	function(
	// 		$scope,
	// $location,
	// $log,
	// $timeout,
	// $hibachi,
	// collectionService,
	// metadataService,
	// selectionService,
	// paginationService
	// 	){
	//
	// 	}
	// ]);


/***/ },
/* 71 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var CreateCollection = (function () {
	    //@ngInject
	    function CreateCollection($scope, $log, $timeout, $hibachi, collectionService, formService, metadataService, paginationService, dialogService, observerService, selectionService, collectionConfigService, rbkeyService) {
	        $scope.params = dialogService.getCurrentDialog().params;
	        $scope.myCollection = collectionConfigService.newCollectionConfig($scope.params.entityName);
	        $scope.params.parentEntity = $scope.params.parentEntity.replace(new RegExp('^' + hibachiConfig.applicationKey, 'i'), '');
	        if ($scope.params.entityName == 'Type' && !angular.isDefined($scope.params.entityId)) {
	            var systemCode = $scope.params.parentEntity.charAt(0).toLowerCase() + $scope.params.parentEntity.slice(1) + 'Type';
	            $scope.myCollection.addFilter('parentType.systemCode', systemCode);
	        }
	        $scope.keywords = '';
	        $scope.paginator = paginationService.createPagination();
	        //$scope.isRadio = true;
	        $scope.hideEditView = true;
	        //$scope.closeSaving = true;
	        $scope.hasSelection = selectionService.getSelectionCount;
	        $scope.idsSelected = selectionService.getSelections;
	        $scope.unselectAll = function () {
	            selectionService.clearSelections('collectionSelection');
	            $scope.getCollection();
	        };
	        $scope.newCollection = $hibachi.newCollection();
	        $scope.newCollection.data.collectionCode = $scope.params.entityName + "-" + new Date().valueOf();
	        $scope.newCollection.data.collectionObject = $scope.params.entityName;
	        if (angular.isDefined($scope.params.entityId)) {
	            $scope.newCollection.data.collectionID = $scope.params.entityId;
	            $timeout(function () {
	                $scope.newCollection.forms['form.createCollection'].$setDirty();
	            });
	        }
	        if (angular.isDefined($scope.params.collectionName)) {
	            $scope.newCollection.data.collectionName = $scope.params.collectionName;
	            $timeout(function () {
	                $scope.newCollection.forms['form.createCollection'].$setDirty();
	            });
	        }
	        if (typeof String.prototype.startsWith != 'function') {
	            String.prototype.startsWith = function (str) {
	                return this.slice(0, str.length) == str;
	            };
	        }
	        $scope.saveCollection = function () {
	            $scope.myCollection.loadJson($scope.collectionConfig);
	            $scope.getCollection();
	        };
	        $scope.getCollection = function () {
	            $scope.closeSaving = true;
	            $scope.myCollection.setPageShow($scope.paginator.getPageShow());
	            $scope.myCollection.setCurrentPage($scope.paginator.getCurrentPage());
	            $scope.myCollection.setKeywords($scope.keywords);
	            var collectionOptions;
	            if (angular.isDefined($scope.params.entityId)) {
	                collectionOptions = {
	                    id: $scope.params.entityId,
	                    currentPage: $scope.paginator.getCurrentPage(),
	                    pageShow: $scope.paginator.getPageShow(),
	                    keywords: $scope.keywords
	                };
	            }
	            else {
	                collectionOptions = $scope.myCollection.getOptions();
	            }
	            $log.debug($scope.myCollection.getOptions());
	            var collectionListingPromise = $hibachi.getEntity($scope.myCollection.getEntityName(), collectionOptions);
	            collectionListingPromise.then(function (value) {
	                if (angular.isDefined($scope.params.entityId)) {
	                    $scope.newCollection.data.collectionName = value.collectionName;
	                }
	                $scope.collection = value;
	                $scope.collection.collectionObject = $scope.myCollection.baseEntityName;
	                $scope.collectionInitial = angular.copy($scope.collection);
	                $scope.paginator.setRecordsCount($scope.collection.recordsCount);
	                $scope.paginator.setPageRecordsInfo($scope.collection);
	                if (angular.isUndefined($scope.myCollection.columns)) {
	                    var colConfig = angular.fromJson(value.collectionConfig);
	                    colConfig.baseEntityName = colConfig.baseEntityName.replace(new RegExp('^' + hibachiConfig.applicationKey, 'i'), '');
	                    $scope.myCollection.loadJson(colConfig);
	                }
	                if (angular.isUndefined($scope.collectionConfig)) {
	                    var tempCollectionConfig = collectionConfigService.newCollectionConfig();
	                    tempCollectionConfig.loadJson(value.collectionConfig);
	                    $scope.collectionConfig = tempCollectionConfig.getCollectionConfig();
	                }
	                if (angular.isUndefined($scope.collectionConfig.filterGroups) || !$scope.collectionConfig.filterGroups.length) {
	                    $scope.collectionConfig.filterGroups = [
	                        {
	                            filterGroup: []
	                        }
	                    ];
	                }
	                collectionService.setFilterCount(filterItemCounter());
	                $scope.loadingCollection = false;
	                $scope.closeSaving = false;
	            }, function (reason) {
	            });
	            return collectionListingPromise;
	        };
	        $scope.paginator.collection = $scope.newCollection;
	        $scope.paginator.getCollection = $scope.getCollection;
	        var unbindCollectionObserver = $scope.$watch('collection', function (newValue, oldValue) {
	            if (newValue !== oldValue) {
	                if (angular.isUndefined($scope.filterPropertiesList)) {
	                    $scope.filterPropertiesList = {};
	                    var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName($scope.collectionConfig.baseEntityAlias);
	                    filterPropertiesPromise.then(function (value) {
	                        metadataService.setPropertiesList(value, $scope.collectionConfig.baseEntityAlias);
	                        $scope.filterPropertiesList[$scope.collectionConfig.baseEntityAlias] = metadataService.getPropertiesListByBaseEntityAlias($scope.collectionConfig.baseEntityAlias);
	                        metadataService.formatPropertiesList($scope.filterPropertiesList[$scope.collectionConfig.baseEntityAlias], $scope.collectionConfig.baseEntityAlias);
	                    });
	                }
	                unbindCollectionObserver();
	            }
	        });
	        var filterItemCounter = function (filterGroupArray) {
	            var filterItemCount = 0;
	            if (!angular.isDefined(filterGroupArray)) {
	                filterGroupArray = $scope.collectionConfig.filterGroups[0].filterGroup;
	            }
	            //Start out loop
	            for (var index in filterGroupArray) {
	                //If filter isn't new then increment the count
	                if (!filterGroupArray[index].$$isNew && !angular.isDefined(filterGroupArray[index].filterGroup)) {
	                    filterItemCount++;
	                }
	                else if (angular.isDefined(filterGroupArray[index].filterGroup)) {
	                    //Call function recursively
	                    filterItemCount += filterItemCounter(filterGroupArray[index].filterGroup);
	                }
	                else {
	                    break;
	                }
	            }
	            return filterItemCount;
	        };
	        $scope.getCollection();
	        $scope.copyExistingCollection = function () {
	            $scope.collection.collectionConfig = $scope.selectedExistingCollection;
	        };
	        $scope.setSelectedExistingCollection = function (selectedExistingCollection) {
	            $scope.selectedExistingCollection = selectedExistingCollection;
	        };
	        $scope.setSelectedFilterProperty = function (selectedFilterProperty) {
	            $scope.selectedFilterProperty = selectedFilterProperty;
	        };
	        $scope.loadingCollection = false;
	        var searchPromise;
	        $scope.searchCollection = function () {
	            if (searchPromise) {
	                $timeout.cancel(searchPromise);
	            }
	            searchPromise = $timeout(function () {
	                //$log.debug('search with keywords');
	                //$log.debug($scope.keywords);
	                //Set current page here so that the pagination does not break when getting collection
	                $scope.paginator.setCurrentPage(1);
	                $scope.loadingCollection = true;
	                $scope.getCollection();
	            }, 500);
	        };
	        $scope.filterCount = collectionService.getFilterCount;
	        //
	        $scope.hideExport = true;
	        $scope.saveNewCollection = function ($index) {
	            if ($scope.closeSaving)
	                return;
	            $scope.closeSaving = true;
	            if (!angular.isUndefined(selectionService.getSelections('collectionSelection'))
	                && (selectionService.getSelections('collectionSelection').length > 0)) {
	                $scope.collectionConfig.filterGroups[0].filterGroup = [
	                    {
	                        "displayPropertyIdentifier": rbkeyService.getRBKey("entity." + $scope.myCollection.baseEntityName.toLowerCase() + "." + $scope.myCollection.collection.$$getIDName().toLowerCase()),
	                        "propertyIdentifier": $scope.myCollection.baseEntityAlias + "." + $scope.myCollection.collection.$$getIDName(),
	                        "comparisonOperator": "in",
	                        "value": selectionService.getSelections('collectionSelection').join(),
	                        "displayValue": selectionService.getSelections('collectionSelection').join(),
	                        "ormtype": "string",
	                        "fieldtype": "id",
	                        "conditionDisplay": "In List"
	                    }
	                ];
	            }
	            $scope.newCollection.data.collectionConfig = $scope.collectionConfig;
	            if (!$scope.newCollection.data.collectionConfig.baseEntityName.startsWith(hibachiConfig.applicationKey))
	                $scope.newCollection.data.collectionConfig.baseEntityName = hibachiConfig.applicationKey + $scope.newCollection.data.collectionConfig.baseEntityName;
	            $scope.newCollection.$$save().then(function () {
	                observerService.notify('addCollection', $scope.newCollection.data);
	                selectionService.clearSelection('collectionSelection');
	                dialogService.removePageDialog($index);
	                $scope.closeSaving = false;
	            }, function () {
	                $scope.closeSaving = false;
	            });
	        };
	    }
	    return CreateCollection;
	})();
	exports.CreateCollection = CreateCollection;


/***/ },
/* 72 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var ConfirmationController = (function () {
	    //@ngInject
	    function ConfirmationController($scope, $log, $modalInstance) {
	        $scope.deleteEntity = function (entity) {
	            $log.debug("Deleting an entity.");
	            $log.debug($scope.entity);
	            this.close();
	        };
	        $scope.fireCallback = function (callbackFunction) {
	            callbackFunction();
	            this.close();
	        };
	        /**
	        * Closes the modal window
	        */
	        $scope.close = function () {
	            $modalInstance.close();
	        };
	        /**
	        * Cancels the modal window
	        */
	        $scope.cancel = function () {
	            $modalInstance.dismiss("cancel");
	        };
	    }
	    return ConfirmationController;
	})();
	exports.ConfirmationController = ConfirmationController;


/***/ },
/* 73 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWCollection = (function () {
	    //@ngInject
	    function SWCollection($http, $compile, $log, hibachiPathBuilder, collectionPartialsPath, collectionService) {
	        return {
	            restrict: 'A',
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "collection.html",
	            link: function (scope, $element, $attrs) {
	                scope.tabsUniqueID = Math.floor(Math.random() * 999);
	                scope.toggleCogOpen = $attrs.toggleoption;
	                //Toggles open/close of filters and display options
	                scope.toggleFiltersAndOptions = function () {
	                    if (scope.toggleCogOpen === false) {
	                        scope.toggleCogOpen = true;
	                    }
	                    else {
	                        scope.toggleCogOpen = false;
	                    }
	                };
	            }
	        };
	    }
	    SWCollection.Factory = function () {
	        var directive = function ($http, $compile, $log, hibachiPathBuilder, collectionPartialsPath, collectionService) {
	            return new SWCollection($http, $compile, $log, hibachiPathBuilder, collectionPartialsPath, collectionService);
	        };
	        directive.$inject = [
	            '$http',
	            '$compile',
	            '$log',
	            'hibachiPathBuilder',
	            'collectionPartialsPath',
	            'collectionService'
	        ];
	        return directive;
	    };
	    return SWCollection;
	})();
	exports.SWCollection = SWCollection;


/***/ },
/* 74 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWAddFilterButtons = (function () {
	    //@ngInject
	    function SWAddFilterButtons($http, $compile, $templateCache, collectionService, collectionPartialsPath, hibachiPathBuilder) {
	        return {
	            require: '^swFilterGroups',
	            restrict: 'E',
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "addfilterbuttons.html",
	            scope: {
	                itemInUse: "="
	            },
	            link: function (scope, element, attrs, filterGroupsController) {
	                scope.filterGroupItem = filterGroupsController.getFilterGroupItem();
	                scope.addFilterItem = function () {
	                    collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(), filterGroupsController.setItemInUse);
	                };
	                scope.addFilterGroupItem = function () {
	                    collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(), filterGroupsController.setItemInUse, true);
	                };
	            }
	        };
	    }
	    SWAddFilterButtons.Factory = function () {
	        var directive = function ($http, $compile, $templateCache, collectionService, collectionPartialsPath, hibachiPathBuilder) {
	            return new SWAddFilterButtons($http, $compile, $templateCache, collectionService, collectionPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$http',
	            '$compile',
	            '$templateCache',
	            'collectionService',
	            'collectionPartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWAddFilterButtons;
	})();
	exports.SWAddFilterButtons = SWAddFilterButtons;


/***/ },
/* 75 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWDisplayOptions = (function () {
	    //@ngInject
	    function SWDisplayOptions($http, $compile, $templateCache, $log, $hibachi, collectionService, hibachiPathBuilder, collectionPartialsPath, rbkeyService) {
	        return {
	            restrict: 'E',
	            transclude: true,
	            scope: {
	                orderBy: "=",
	                columns: '=',
	                propertiesList: "=",
	                saveCollection: "&",
	                baseEntityAlias: "=",
	                baseEntityName: "="
	            },
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "displayoptions.html",
	            controller: ['$scope', '$element', '$attrs', function ($scope, $element, $attrs) {
	                    $log.debug('display options initialize');
	                    this.removeColumn = function (columnIndex) {
	                        $log.debug('parent remove column');
	                        $log.debug($scope.columns);
	                        if ($scope.columns.length) {
	                            $scope.columns.splice(columnIndex, 1);
	                        }
	                    };
	                    this.getPropertiesList = function () {
	                        return $scope.propertiesList;
	                    };
	                    $scope.addDisplayDialog = {
	                        isOpen: false,
	                        toggleDisplayDialog: function () {
	                            $scope.addDisplayDialog.isOpen = !$scope.addDisplayDialog.isOpen;
	                        }
	                    };
	                    var getTitleFromProperty = function (selectedProperty) {
	                        var baseEntityCfcName = $scope.baseEntityName.replace('Slatwall', '').charAt(0).toLowerCase() + $scope.baseEntityName.replace('Slatwall', '').slice(1);
	                        var propertyIdentifier = selectedProperty.propertyIdentifier;
	                        var title = '';
	                        var propertyIdentifierArray = propertyIdentifier.split('.');
	                        var currentEntity;
	                        var currentEntityInstance;
	                        var prefix = 'entity.';
	                        if (selectedProperty.$$group == "attribute") {
	                            return selectedProperty.displayPropertyIdentifier;
	                        }
	                        angular.forEach(propertyIdentifierArray, function (propertyIdentifierItem, key) {
	                            //pass over the initial item
	                            if (key !== 0) {
	                                if (key === 1) {
	                                    currentEntityInstance = $hibachi['new' + $scope.baseEntityName.replace('Slatwall', '')]();
	                                    currentEntity = currentEntityInstance.metaData[propertyIdentifierArray[key]];
	                                    title += rbkeyService.getRBKey(prefix + baseEntityCfcName + '.' + propertyIdentifierItem);
	                                }
	                                else {
	                                    var currentEntityInstance = $hibachi['new' + currentEntity.cfc.charAt(0).toUpperCase() + currentEntity.cfc.slice(1)]();
	                                    currentEntity = currentEntityInstance.metaData[propertyIdentifierArray[key]];
	                                    title += rbkeyService.getRBKey(prefix + currentEntityInstance.metaData.className + '.' + currentEntity.name);
	                                }
	                                if (key < propertyIdentifierArray.length - 1) {
	                                    title += ' | ';
	                                }
	                            }
	                        });
	                        return title;
	                    };
	                    $scope.addColumn = function (selectedProperty, closeDialog) {
	                        $log.debug('add Column');
	                        $log.debug(selectedProperty);
	                        if (selectedProperty.$$group === 'simple' || 'attribute') {
	                            $log.debug($scope.columns);
	                            if (angular.isDefined(selectedProperty)) {
	                                var column = {
	                                    title: getTitleFromProperty(selectedProperty),
	                                    propertyIdentifier: selectedProperty.propertyIdentifier,
	                                    isVisible: true,
	                                    isDeletable: true,
	                                    isSearchable: true,
	                                    isExportable: true
	                                };
	                                //only add attributeid if the selectedProperty is attributeid
	                                if (angular.isDefined(selectedProperty.attributeID)) {
	                                    column['attributeID'] = selectedProperty.attributeID;
	                                    column['attributeSetObject'] = selectedProperty.attributeSetObject;
	                                }
	                                if (angular.isDefined(selectedProperty.ormtype)) {
	                                    column['ormtype'] = selectedProperty.ormtype;
	                                }
	                                $scope.columns.push(column);
	                                $scope.saveCollection();
	                                if (angular.isDefined(closeDialog) && closeDialog === true) {
	                                    $scope.addDisplayDialog.toggleDisplayDialog();
	                                }
	                            }
	                        }
	                    };
	                    $scope.selectBreadCrumb = function (breadCrumbIndex) {
	                        //splice out array items above index
	                        var removeCount = $scope.breadCrumbs.length - 1 - breadCrumbIndex;
	                        $scope.breadCrumbs.splice(breadCrumbIndex + 1, removeCount);
	                        $scope.selectedPropertyChanged(null);
	                    };
	                    var unbindBaseEntityAlias = $scope.$watch('baseEntityAlias', function (newValue, oldValue) {
	                        if (newValue !== oldValue) {
	                            $scope.breadCrumbs = [{
	                                    entityAlias: $scope.baseEntityAlias,
	                                    cfc: $scope.baseEntityAlias,
	                                    propertyIdentifier: $scope.baseEntityAlias
	                                }];
	                            unbindBaseEntityAlias();
	                        }
	                    });
	                    $scope.selectedPropertyChanged = function (selectedProperty) {
	                        // drill down or select field?
	                        $log.debug('selectedPropertyChanged');
	                        $log.debug(selectedProperty);
	                        $scope.selectedProperty = selectedProperty;
	                    };
	                    jQuery(function ($) {
	                        var panelList = angular.element($element).children('ul');
	                        panelList.sortable({
	                            // Only make the .panel-heading child elements support dragging.
	                            // Omit this to make then entire <li>...</li> draggable.
	                            handle: '.s-pannel-name',
	                            update: function (event, ui) {
	                                var tempColumnsArray = [];
	                                $('.s-pannel-name', panelList).each(function (index, elem) {
	                                    var newIndex = $(elem).attr('j-column-index');
	                                    var columnItem = $scope.columns[newIndex];
	                                    tempColumnsArray.push(columnItem);
	                                });
	                                $scope.$apply(function () {
	                                    $scope.columns = tempColumnsArray;
	                                });
	                                $scope.saveCollection();
	                            }
	                        });
	                    });
	                    /*var unbindBaseEntityAlaisWatchListener = scope.$watch('baseEntityAlias',function(){
	                         $("select").selectBoxIt();
	                         unbindBaseEntityAlaisWatchListener();
	                    });*/
	                }]
	        };
	    }
	    SWDisplayOptions.Factory = function () {
	        var directive = function ($http, $compile, $templateCache, $log, $hibachi, collectionService, hibachiPathBuilder, collectionPartialsPath, rbkeyService) {
	            return new SWDisplayOptions($http, $compile, $templateCache, $log, $hibachi, collectionService, hibachiPathBuilder, collectionPartialsPath, rbkeyService);
	        };
	        directive.$inject = [
	            '$http',
	            '$compile',
	            '$templateCache',
	            '$log',
	            '$hibachi',
	            'collectionService',
	            'hibachiPathBuilder',
	            'collectionPartialsPath',
	            'rbkeyService'
	        ];
	        return directive;
	    };
	    return SWDisplayOptions;
	})();
	exports.SWDisplayOptions = SWDisplayOptions;


/***/ },
/* 76 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWDisplayItem = (function () {
	    //@ngInject
	    function SWDisplayItem($http, $compile, $templateCache, $log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	        return {
	            require: '^swDisplayOptions',
	            restrict: 'A',
	            scope: {
	                selectedProperty: "=",
	                propertiesList: "=",
	                breadCrumbs: "=",
	                selectedPropertyChanged: "&"
	            },
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "displayitem.html",
	            link: function (scope, element, attrs, displayOptionsController) {
	                scope.showDisplayItem = false;
	                scope.selectedDisplayOptionChanged = function (selectedDisplayOption) {
	                    var breadCrumb = {
	                        entityAlias: scope.selectedProperty.name,
	                        cfc: scope.selectedProperty.cfc,
	                        propertyIdentifier: scope.selectedProperty.propertyIdentifier
	                    };
	                    scope.breadCrumbs.push(breadCrumb);
	                    scope.selectedPropertyChanged({ selectedProperty: selectedDisplayOption });
	                };
	                scope.$watch('selectedProperty', function (selectedProperty) {
	                    if (angular.isDefined(selectedProperty)) {
	                        if (selectedProperty === null) {
	                            scope.showDisplayItem = false;
	                            return;
	                        }
	                        if (selectedProperty.$$group !== 'drilldown') {
	                            scope.showDisplayItem = false;
	                            return;
	                        }
	                        if (selectedProperty.$$group === 'drilldown') {
	                            if (angular.isUndefined(scope.propertiesList[selectedProperty.propertyIdentifier])) {
	                                var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName(selectedProperty.cfc);
	                                filterPropertiesPromise.then(function (value) {
	                                    metadataService.setPropertiesList(value, selectedProperty.propertyIdentifier);
	                                    scope.propertiesList[selectedProperty.propertyIdentifier] = metadataService.getPropertiesListByBaseEntityAlias(selectedProperty.propertyIdentifier);
	                                    metadataService.formatPropertiesList(scope.propertiesList[selectedProperty.propertyIdentifier], selectedProperty.propertyIdentifier);
	                                }, function (reason) {
	                                });
	                            }
	                        }
	                        scope.showDisplayItem = true;
	                    }
	                });
	            }
	        };
	    }
	    SWDisplayItem.Factory = function () {
	        var directive = function ($http, $compile, $templateCache, $log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	            return new SWDisplayItem($http, $compile, $templateCache, $log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$http',
	            '$compile',
	            '$templateCache',
	            '$log',
	            '$hibachi',
	            '$filter',
	            'collectionPartialsPath',
	            'collectionService',
	            'metadataService',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWDisplayItem;
	})();
	exports.SWDisplayItem = SWDisplayItem;


/***/ },
/* 77 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWCollectionTable = (function () {
	    //@ngInject
	    function SWCollectionTable($http, $compile, $log, hibachiPathBuilder, collectionPartialsPath, paginationService, selectionService, $hibachi) {
	        return {
	            restrict: 'E',
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "collectiontable.html",
	            scope: {
	                collection: "=",
	                collectionConfig: "=",
	                isRadio: "=?",
	                //angularLink:true || false
	                angularLinks: "=?"
	            },
	            link: function (scope, element, attrs) {
	                if (angular.isUndefined(scope.angularLinks)) {
	                    scope.angularLinks = false;
	                }
	                console.log('here');
	                console.log(scope.collection);
	                console.log($hibachi);
	                scope.collectionObject = $hibachi['new' + scope.collection.collectionObject]();
	                var escapeRegExp = function (str) {
	                    return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
	                };
	                scope.replaceAll = function (str, find, replace) {
	                    return str.replace(new RegExp(escapeRegExp(find), 'g'), replace);
	                };
	                /*
	                 * Handles setting the key on the data.
	                 * */
	                angular.forEach(scope.collectionConfig.columns, function (column) {
	                    $log.debug("Config Key : " + column);
	                    column.key = column.propertyIdentifier.replace(/\./g, '_').replace(scope.collectionConfig.baseEntityAlias + '_', '');
	                });
	                scope.addSelection = function (selectionid, selection) {
	                    selectionService.addSelection(selectionid, selection);
	                };
	            }
	        };
	    }
	    SWCollectionTable.Factory = function () {
	        var directive = function ($http, $compile, $log, hibachiPathBuilder, collectionPartialsPath, paginationService, selectionService, $hibachi) {
	            return new SWCollectionTable($http, $compile, $log, hibachiPathBuilder, collectionPartialsPath, paginationService, selectionService, $hibachi);
	        };
	        directive.$inject = [
	            '$http',
	            '$compile',
	            '$log',
	            'hibachiPathBuilder',
	            'collectionPartialsPath',
	            'paginationService',
	            'selectionService',
	            '$hibachi'
	        ];
	        return directive;
	    };
	    return SWCollectionTable;
	})();
	exports.SWCollectionTable = SWCollectionTable;


/***/ },
/* 78 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWColumnItem = (function () {
	    function SWColumnItem($compile, $templateCache, $log, $timeout, hibachiPathBuilder, collectionService, collectionPartialsPath) {
	        return {
	            restrict: 'A',
	            require: "^swDisplayOptions",
	            scope: {
	                column: "=",
	                columns: "=",
	                columnIndex: "=",
	                saveCollection: "&",
	                propertiesList: "=",
	                orderBy: "="
	            },
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "columnitem.html",
	            link: function (scope, element, attrs, displayOptionsController) {
	                scope.editingDisplayTitle = false;
	                scope.editDisplayTitle = function () {
	                    if (angular.isUndefined(scope.column.displayTitle)) {
	                        scope.column.displayTitle = scope.column.title;
	                    }
	                    if (!scope.column.displayTitle.length) {
	                        scope.column.displayTitle = scope.column.title;
	                    }
	                    scope.previousDisplayTitle = scope.column.displayTitle;
	                    scope.editingDisplayTitle = true;
	                };
	                scope.saveDisplayTitle = function () {
	                    var savePromise = scope.saveCollection();
	                    scope.editingDisplayTitle = false;
	                };
	                scope.cancelDisplayTitle = function () {
	                    scope.column.displayTitle = scope.previousDisplayTitle;
	                    scope.editingDisplayTitle = false;
	                };
	                $log.debug('displayOptionsController');
	                if (angular.isUndefined(scope.column.sorting)) {
	                    scope.column.sorting = {
	                        active: false,
	                        sortOrder: 'asc',
	                        priority: 0
	                    };
	                }
	                scope.toggleVisible = function (column) {
	                    $log.debug('toggle visible');
	                    if (angular.isUndefined(column.isVisible)) {
	                        column.isVisible = false;
	                    }
	                    column.isVisible = !column.isVisible;
	                    scope.saveCollection();
	                };
	                scope.toggleSearchable = function (column) {
	                    $log.debug('toggle searchable');
	                    if (angular.isUndefined(column.isSearchable)) {
	                        column.isSearchable = false;
	                    }
	                    column.isSearchable = !column.isSearchable;
	                    scope.saveCollection();
	                };
	                scope.toggleExportable = function (column) {
	                    $log.debug('toggle exporable');
	                    if (angular.isUndefined(column.isExportable)) {
	                        column.isExportable = false;
	                    }
	                    column.isExportable = !column.isExportable;
	                    scope.saveCollection();
	                };
	                var compareByPriority = function (a, b) {
	                    if (angular.isDefined(a.sorting) && angular.isDefined(a.sorting.priority)) {
	                        if (a.sorting.priority < b.sorting.priority) {
	                            return -1;
	                        }
	                        if (a.sorting.priority > b.sorting.priority) {
	                            return 1;
	                        }
	                    }
	                    return 0;
	                };
	                var updateOrderBy = function () {
	                    if (angular.isDefined(scope.columns)) {
	                        var columnsCopy = angular.copy(scope.columns);
	                        columnsCopy.sort(compareByPriority);
	                        scope.orderBy = [];
	                        angular.forEach(columnsCopy, function (column) {
	                            if (angular.isDefined(column.sorting) && column.sorting.active === true) {
	                                var orderBy = {
	                                    propertyIdentifier: column.propertyIdentifier,
	                                    direction: column.sorting.sortOrder
	                                };
	                                scope.orderBy.push(orderBy);
	                            }
	                        });
	                    }
	                };
	                scope.toggleSortable = function (column) {
	                    $log.debug('toggle sortable');
	                    if (angular.isUndefined(column.sorting)) {
	                        column.sorting = {
	                            active: true,
	                            sortOrder: 'asc',
	                            priority: 0
	                        };
	                    }
	                    if (column.sorting.active === true) {
	                        if (column.sorting.sortOrder === 'asc') {
	                            column.sorting.sortOrder = 'desc';
	                        }
	                        else {
	                            removeSorting(column);
	                            column.sorting.active = false;
	                        }
	                    }
	                    else {
	                        column.sorting.active = true;
	                        column.sorting.sortOrder = 'asc';
	                        column.sorting.priority = getActivelySorting().length;
	                    }
	                    updateOrderBy();
	                    scope.saveCollection();
	                };
	                var removeSorting = function (column, saving) {
	                    if (column.sorting.active === true) {
	                        for (var i in scope.columns) {
	                            if (scope.columns[i].sorting.active === true && scope.columns[i].sorting.priority > column.sorting.priority) {
	                                scope.columns[i].sorting.priority = scope.columns[i].sorting.priority - 1;
	                            }
	                        }
	                        column.sorting.priority = 0;
	                    }
	                    if (!saving) {
	                        updateOrderBy();
	                        scope.saveCollection();
	                    }
	                };
	                scope.prioritize = function (column) {
	                    if (column.sorting.priority === 1) {
	                        var activelySorting = getActivelySorting();
	                        for (var i in scope.columns) {
	                            if (scope.columns[i].sorting.active === true) {
	                                scope.columns[i].sorting.priority = scope.columns[i].sorting.priority - 1;
	                            }
	                        }
	                        column.sorting.priority = activelySorting.length;
	                    }
	                    else {
	                        for (var i in scope.columns) {
	                            if (scope.columns[i].sorting.active === true && scope.columns[i].sorting.priority === column.sorting.priority - 1) {
	                                scope.columns[i].sorting.priority = scope.columns[i].sorting.priority + 1;
	                            }
	                        }
	                        column.sorting.priority -= 1;
	                    }
	                    updateOrderBy();
	                    scope.saveCollection();
	                };
	                var getActivelySorting = function () {
	                    var activelySorting = [];
	                    for (var i in scope.columns) {
	                        if (scope.columns[i].sorting.active === true) {
	                            activelySorting.push(scope.columns[i]);
	                        }
	                    }
	                    return activelySorting;
	                };
	                scope.removeColumn = function (columnIndex) {
	                    $log.debug('remove column');
	                    $log.debug(columnIndex);
	                    removeSorting(scope.columns[columnIndex], true);
	                    displayOptionsController.removeColumn(columnIndex);
	                    updateOrderBy();
	                    scope.saveCollection();
	                };
	            }
	        };
	    }
	    SWColumnItem.Factory = function () {
	        var directive = function ($compile, $templateCache, $log, $timeout, hibachiPathBuilder, collectionService, collectionPartialsPath) {
	            return new SWColumnItem($compile, $templateCache, $log, $timeout, hibachiPathBuilder, collectionService, collectionPartialsPath);
	        };
	        directive.$inject = [
	            '$compile',
	            '$templateCache',
	            '$log',
	            '$timeout',
	            'hibachiPathBuilder',
	            'collectionService',
	            'collectionPartialsPath'
	        ];
	        return directive;
	    };
	    return SWColumnItem;
	})();
	exports.SWColumnItem = SWColumnItem;


/***/ },
/* 79 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWConditionCriteria = (function () {
	    function SWConditionCriteria($http, $compile, $templateCache, $log, $hibachi, $filter, workflowPartialsPath, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	        /* Template info begin*/
	        var getTemplate = function (selectedFilterProperty) {
	            var template = '';
	            var templatePath = '';
	            if (angular.isUndefined(selectedFilterProperty.ormtype) && angular.isUndefined(selectedFilterProperty.fieldtype)) {
	                templatePath = hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "criteria.html";
	            }
	            else {
	                var criteriaormtype = selectedFilterProperty.ormtype;
	                var criteriafieldtype = selectedFilterProperty.fieldtype;
	                /*TODO: convert all switches to object literals*/
	                switch (criteriaormtype) {
	                    case 'boolean':
	                        templatePath = hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "criteriaboolean.html";
	                        break;
	                    case 'string':
	                        templatePath = hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "criteriastring.html";
	                        break;
	                    case 'timestamp':
	                        templatePath = hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "criteriadate.html";
	                        break;
	                    case 'big_decimal':
	                    case 'integer':
	                    case 'float':
	                        templatePath = hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "criterianumber.html";
	                        break;
	                }
	                switch (criteriafieldtype) {
	                    case "many-to-one":
	                        templatePath = hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "criteriamanytoone.html";
	                        break;
	                    case "many-to-many":
	                        templatePath = hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "criteriamanytomany.html";
	                        break;
	                    case "one-to-many":
	                        templatePath = hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "criteriaonetomany.html";
	                        break;
	                }
	            }
	            var templateLoader = $http.get(templatePath, { cache: $templateCache });
	            return templateLoader;
	        };
	        /* Template info end*/
	        /* Options info begin */
	        var getStringOptions = function (type) {
	            var stringOptions = [];
	            if (angular.isUndefined(type)) {
	                type = 'filter';
	            }
	            if (type == 'filter') {
	                stringOptions = [
	                    {
	                        display: "Equals",
	                        comparisonOperator: "="
	                    },
	                    {
	                        display: "Doesn't Equal",
	                        comparisonOperator: "<>"
	                    },
	                    {
	                        display: "Contains",
	                        comparisonOperator: "like",
	                        pattern: "%w%"
	                    },
	                    {
	                        display: "Doesn't Contain",
	                        comparisonOperator: "not like",
	                        pattern: "%w%"
	                    },
	                    {
	                        display: "Starts With",
	                        comparisonOperator: "like",
	                        pattern: "w%"
	                    },
	                    {
	                        display: "Doesn't Start With",
	                        comparisonOperator: "not like",
	                        pattern: "w%"
	                    },
	                    {
	                        display: "Ends With",
	                        comparisonOperator: "like",
	                        pattern: "%w"
	                    },
	                    {
	                        display: "Doesn't End With",
	                        comparisonOperator: "not like",
	                        pattern: "%w"
	                    },
	                    {
	                        display: "In List",
	                        comparisonOperator: "in"
	                    },
	                    {
	                        display: "Not In List",
	                        comparisonOperator: "not in"
	                    },
	                    {
	                        display: "Defined",
	                        comparisonOperator: "is not",
	                        value: "null"
	                    },
	                    {
	                        display: "Not Defined",
	                        comparisonOperator: "is",
	                        value: "null"
	                    }
	                ];
	                if (type === 'condition') {
	                    stringOptions = [
	                        {
	                            display: "Equals",
	                            comparisonOperator: "="
	                        },
	                        {
	                            display: "In List",
	                            comparisonOperator: "in"
	                        },
	                        {
	                            display: "Defined",
	                            comparisonOperator: "is not",
	                            value: "null"
	                        },
	                        {
	                            display: "Not Defined",
	                            comparisonOperator: "is",
	                            value: "null"
	                        }
	                    ];
	                }
	            }
	            return stringOptions;
	        };
	        var getBooleanOptions = function (type) {
	            var booleanOptions = [];
	            if (angular.isUndefined(type)) {
	                type = 'filter';
	            }
	            if (type === 'filter' || type === 'condition') {
	                booleanOptions = [
	                    {
	                        display: "True",
	                        comparisonOperator: "=",
	                        value: "True"
	                    },
	                    {
	                        display: "False",
	                        comparisonOperator: "=",
	                        value: "False"
	                    },
	                    {
	                        display: "Defined",
	                        comparisonOperator: "is not",
	                        value: "null"
	                    },
	                    {
	                        display: "Not Defined",
	                        comparisonOperator: "is",
	                        value: "null"
	                    }
	                ];
	            }
	            return booleanOptions;
	        };
	        var getDateOptions = function (type) {
	            var dateOptions = [];
	            if (angular.isUndefined(type)) {
	                type = 'filter';
	            }
	            if (type === 'filter') {
	                dateOptions = [
	                    {
	                        display: "Date",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'exactDate',
	                        }
	                    },
	                    {
	                        display: "In Range",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'range'
	                        }
	                    },
	                    {
	                        display: "Not In Range",
	                        comparisonOperator: "not between",
	                        dateInfo: {
	                            type: 'range'
	                        }
	                    },
	                    {
	                        display: "Today",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'calculation',
	                            measureType: 'd',
	                            measureCount: 0,
	                            behavior: 'toDate'
	                        }
	                    },
	                    {
	                        display: "Yesterday",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'calculation',
	                            measureType: 'd',
	                            measureCount: -1,
	                            behavior: 'toDate'
	                        }
	                    },
	                    {
	                        display: "This Week",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'calculation',
	                            measureType: 'w',
	                            behavior: 'toDate'
	                        }
	                    },
	                    {
	                        display: "This Month",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'calculation',
	                            measureType: 'm',
	                            behavior: 'toDate'
	                        }
	                    },
	                    {
	                        display: "This Quarter",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'calculation',
	                            measureType: 'q',
	                            behavior: 'toDate'
	                        }
	                    },
	                    {
	                        display: "This Year",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'calculation',
	                            measureType: 'y',
	                            behavior: 'toDate'
	                        }
	                    },
	                    {
	                        display: "Last N Hour(s)",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'calculation',
	                            measureType: 'h',
	                            measureTypeDisplay: 'Hours'
	                        }
	                    },
	                    {
	                        display: "Last N Day(s)",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'calculation',
	                            measureType: 'd',
	                            measureTypeDisplay: 'Days'
	                        }
	                    },
	                    {
	                        display: "Last N Week(s)",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'calculation',
	                            measureType: 'w',
	                            measureTypeDisplay: 'Weeks'
	                        }
	                    },
	                    {
	                        display: "Last N Month(s)",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'calculation',
	                            measureType: 'm',
	                            measureTypeDisplay: 'Months'
	                        }
	                    },
	                    {
	                        display: "Last N Quarter(s)",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'calculation',
	                            measureType: 'q',
	                            measureTypeDisplay: 'Quarters'
	                        }
	                    },
	                    {
	                        display: "Last N Year(s)",
	                        comparisonOperator: "between",
	                        dateInfo: {
	                            type: 'calculation',
	                            measureType: 'y',
	                            measureTypeDisplay: 'Years'
	                        }
	                    },
	                    {
	                        display: "Defined",
	                        comparisonOperator: "is not",
	                        value: "null"
	                    },
	                    {
	                        display: "Not Defined",
	                        comparisonOperator: "is",
	                        value: "null"
	                    }
	                ];
	            }
	            if (type === 'condition') {
	                dateOptions = [
	                    {
	                        display: "Defined",
	                        comparisonOperator: "is not",
	                        value: "null"
	                    },
	                    {
	                        display: "Not Defined",
	                        comparisonOperator: "is",
	                        value: "null"
	                    }
	                ];
	            }
	            return dateOptions;
	        };
	        var getNumberOptions = function (type) {
	            var numberOptions = [];
	            if (angular.isUndefined(type)) {
	                type = 'filter';
	            }
	            if (type == 'filter') {
	                numberOptions = [
	                    {
	                        display: "Equals",
	                        comparisonOperator: "="
	                    },
	                    {
	                        display: "Doesn't Equal",
	                        comparisonOperator: "<>"
	                    },
	                    {
	                        display: "In Range",
	                        comparisonOperator: "between",
	                        type: "range"
	                    },
	                    {
	                        display: "Not In Range",
	                        comparisonOperator: "not between",
	                        type: "range"
	                    },
	                    {
	                        display: "Greater Than",
	                        comparisonOperator: ">"
	                    },
	                    {
	                        display: "Greater Than Or Equal",
	                        comparisonOperator: ">="
	                    },
	                    {
	                        display: "Less Than",
	                        comparisonOperator: "<"
	                    },
	                    {
	                        display: "Less Than Or Equal",
	                        comparisonOperator: "<="
	                    },
	                    {
	                        display: "In List",
	                        comparisonOperator: "in"
	                    },
	                    {
	                        display: "Not In List",
	                        comparisonOperator: "not in"
	                    },
	                    {
	                        display: "Defined",
	                        comparisonOperator: "is not",
	                        value: "null"
	                    },
	                    {
	                        display: "Not Defined",
	                        comparisonOperator: "is",
	                        value: "null"
	                    }
	                ];
	            }
	            if (type === 'condition') {
	                numberOptions = [
	                    {
	                        display: "Equals",
	                        comparisonOperator: "="
	                    },
	                    {
	                        display: "Doesn't Equal",
	                        comparisonOperator: "<>"
	                    },
	                    {
	                        display: "Greater Than",
	                        comparisonOperator: ">"
	                    },
	                    {
	                        display: "Greater Than Or Equal",
	                        comparisonOperator: ">="
	                    },
	                    {
	                        display: "Less Than",
	                        comparisonOperator: "<"
	                    },
	                    {
	                        display: "Less Than Or Equal",
	                        comparisonOperator: "<="
	                    },
	                    {
	                        display: "In List",
	                        comparisonOperator: "in"
	                    },
	                    {
	                        display: "Defined",
	                        comparisonOperator: "is not",
	                        value: "null"
	                    },
	                    {
	                        display: "Not Defined",
	                        comparisonOperator: "is",
	                        value: "null"
	                    }
	                ];
	            }
	            return numberOptions;
	        };
	        var getOneToManyOptions = function (type) {
	            var oneToManyOptions = [];
	            if (angular.isUndefined(type)) {
	                type = 'filter';
	            }
	            if (type == 'filter') {
	                oneToManyOptions = [
	                    {
	                        display: "All Exist In Collection",
	                        comparisonOperator: "All"
	                    },
	                    {
	                        display: "None Exist In Collection",
	                        comparisonOperator: "None"
	                    },
	                    {
	                        display: "Some Exist In Collection",
	                        comparisonOperator: "One"
	                    }
	                ];
	            }
	            if (type === 'condition') {
	                oneToManyOptions = [];
	            }
	            return oneToManyOptions;
	        };
	        var getManyToManyOptions = function (type) {
	            var manyToManyOptions = [];
	            if (angular.isUndefined(type)) {
	                type = 'filter';
	            }
	            if (type == 'filter') {
	                manyToManyOptions = [
	                    {
	                        display: "All Exist In Collection",
	                        comparisonOperator: "All"
	                    },
	                    {
	                        display: "None Exist In Collection",
	                        comparisonOperator: "None"
	                    },
	                    {
	                        display: "Some Exist In Collection",
	                        comparisonOperator: "One"
	                    },
	                    {
	                        display: "Empty",
	                        comparisonOperator: "is",
	                        value: "null"
	                    },
	                    {
	                        display: "Not Empty",
	                        comparisonOperator: "is not",
	                        value: "null"
	                    }
	                ];
	            }
	            if (type === 'condition') {
	                manyToManyOptions = [
	                    {
	                        display: "Empty",
	                        comparisonOperator: "is",
	                        value: "null"
	                    },
	                    {
	                        display: "Not Empty",
	                        comparisonOperator: "is not",
	                        value: "null"
	                    }
	                ];
	            }
	            return manyToManyOptions;
	        };
	        var getManyToOneOptions = function (type) {
	            var manyToOneOptions = [];
	            if (angular.isUndefined(type)) {
	                type = 'filter';
	            }
	            if (type == 'filter') {
	                manyToOneOptions = {
	                    drillEntity: {},
	                    hasEntity: {
	                        display: "Defined",
	                        comparisonOperator: "is not",
	                        value: "null"
	                    },
	                    notHasEntity: {
	                        display: "Not Defined",
	                        comparisonOperator: "is",
	                        value: "null"
	                    }
	                };
	            }
	            return manyToOneOptions;
	        };
	        /* Options info end */
	        var linker = function (scope, element, attrs) {
	            /*show the user the value without % symbols as these are reserved*/
	            scope.$watch('selectedFilterProperty.criteriaValue', function (criteriaValue) {
	                if (angular.isDefined(criteriaValue)) {
	                    scope.selectedFilterProperty.criteriaValue = $filter('likeFilter')(criteriaValue);
	                }
	            });
	            scope.$watch('selectedFilterProperty', function (selectedFilterProperty) {
	                if (angular.isDefined(selectedFilterProperty)) {
	                    $log.debug('watchSelectedFilterProperty');
	                    $log.debug(scope.selectedFilterProperty);
	                    /*prepopulate if we have a comparison operator and value*/
	                    if (selectedFilterProperty === null) {
	                        return;
	                    }
	                    if (angular.isDefined(selectedFilterProperty.ormtype)) {
	                        switch (scope.selectedFilterProperty.ormtype) {
	                            case "boolean":
	                                scope.conditionOptions = getBooleanOptions();
	                                break;
	                            case "string":
	                                scope.conditionOptions = getStringOptions();
	                                scope.selectedConditionChanged = function (selectedFilterProperty) {
	                                    //scope.selectedFilterProperty.criteriaValue = '';
	                                    if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
	                                        selectedFilterProperty.showCriteriaValue = false;
	                                    }
	                                    else {
	                                        selectedFilterProperty.showCriteriaValue = true;
	                                    }
	                                };
	                                break;
	                            case "timestamp":
	                                scope.conditionOptions = getDateOptions();
	                                scope.today = function () {
	                                    if (angular.isDefined(scope.selectedFilterProperty)) {
	                                        scope.selectedFilterProperty.criteriaRangeStart = new Date();
	                                        scope.selectedFilterProperty.criteriaRangeEnd = new Date();
	                                    }
	                                };
	                                scope.clear = function () {
	                                    scope.selectedFilterProperty.criteriaRangeStart = null;
	                                    scope.selectedFilterProperty.criteriaRangeEnd = null;
	                                };
	                                scope.openCalendarStart = function ($event) {
	                                    $event.preventDefault();
	                                    $event.stopPropagation();
	                                    scope.openedCalendarStart = true;
	                                };
	                                scope.openCalendarEnd = function ($event) {
	                                    $event.preventDefault();
	                                    $event.stopPropagation();
	                                    scope.openedCalendarEnd = true;
	                                };
	                                scope.formats = [
	                                    'dd-MMMM-yyyy',
	                                    'yyyy/MM/dd',
	                                    'dd.MM.yyyy',
	                                    'shortDate'];
	                                scope.format = scope.formats[1];
	                                scope.selectedConditionChanged = function (selectedFilterProperty) {
	                                    $log.debug('selectedConditionChanged Begin');
	                                    var selectedCondition = selectedFilterProperty.selectedCriteriaType;
	                                    //check whether condition is checking for null values in date
	                                    if (angular.isDefined(selectedCondition.dateInfo)) {
	                                        //is condition a calculation
	                                        if (selectedCondition.dateInfo.type === 'calculation') {
	                                            selectedCondition.showCriteriaStart = true;
	                                            selectedCondition.showCriteriaEnd = true;
	                                            selectedCondition.disableCriteriaStart = true;
	                                            selectedCondition.disableCriteriaEnd = true;
	                                            //if item is a calculation of an N number of measure display the measure and number input
	                                            if (angular.isUndefined(selectedCondition.dateInfo.behavior)) {
	                                                $log.debug('Not toDate');
	                                                selectedCondition.showNumberOf = true;
	                                                selectedCondition.conditionDisplay = 'Number of ' + selectedCondition.dateInfo.measureTypeDisplay + ' :';
	                                            }
	                                            else {
	                                                $log.debug('toDate');
	                                                var today = Date.parse('today');
	                                                var todayEOD = today.setHours(23, 59, 59, 999);
	                                                selectedFilterProperty.criteriaRangeEnd = todayEOD;
	                                                //get this Measure to date
	                                                switch (selectedCondition.dateInfo.measureType) {
	                                                    case 'd':
	                                                        var dateBOD = Date.parse('today').add(selectedCondition.dateInfo.measureCount).days();
	                                                        dateBOD.setHours(0, 0, 0, 0);
	                                                        selectedFilterProperty.criteriaRangeStart = dateBOD.getTime();
	                                                        break;
	                                                    case 'w':
	                                                        var firstDayOfWeek = Date.today().last().monday();
	                                                        selectedFilterProperty.criteriaRangeStart = firstDayOfWeek.getTime();
	                                                        break;
	                                                    case 'm':
	                                                        var firstDayOfMonth = Date.today().moveToFirstDayOfMonth();
	                                                        selectedFilterProperty.criteriaRangeStart = firstDayOfMonth.getTime();
	                                                        break;
	                                                    case 'q':
	                                                        var month = Date.parse('today').toString('MM');
	                                                        var year = Date.parse('today').toString('yyyy');
	                                                        var quarterMonth = (Math.floor(month / 3) * 3);
	                                                        var firstDayOfQuarter = new Date(year, quarterMonth, 1);
	                                                        selectedFilterProperty.criteriaRangeStart = firstDayOfQuarter.getTime();
	                                                        break;
	                                                    case 'y':
	                                                        var year = Date.parse('today').toString('yyyy');
	                                                        var firstDayOfYear = new Date(year, 0, 1);
	                                                        selectedFilterProperty.criteriaRangeStart = firstDayOfYear.getTime();
	                                                        break;
	                                                }
	                                            }
	                                        }
	                                        if (selectedCondition.dateInfo.type === 'range') {
	                                            selectedCondition.showCriteriaStart = true;
	                                            selectedCondition.showCriteriaEnd = true;
	                                            selectedCondition.disableCriteriaStart = false;
	                                            selectedCondition.disableCriteriaEnd = false;
	                                            selectedCondition.showNumberOf = false;
	                                        }
	                                        if (selectedCondition.dateInfo.type === 'exactDate') {
	                                            selectedCondition.showCriteriaStart = true;
	                                            selectedCondition.showCriteriaEnd = false;
	                                            selectedCondition.disableCriteriaStart = false;
	                                            selectedCondition.disableCriteriaEnd = true;
	                                            selectedCondition.showNumberOf = false;
	                                            selectedCondition.conditionDisplay = '';
	                                            selectedFilterProperty.criteriaRangeStart = new Date(selectedFilterProperty.criteriaRangeStart).setHours(0, 0, 0, 0);
	                                            selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeStart).setHours(23, 59, 59, 999);
	                                        }
	                                    }
	                                    else {
	                                        selectedCondition.showCriteriaStart = false;
	                                        selectedCondition.showCriteriaEnd = false;
	                                        selectedCondition.showNumberOf = false;
	                                        selectedCondition.conditionDisplay = '';
	                                    }
	                                    $log.debug('selectedConditionChanged End');
	                                    $log.debug('selectedConditionChanged Result');
	                                    $log.debug(selectedCondition);
	                                    $log.debug(selectedFilterProperty);
	                                };
	                                scope.criteriaRangeChanged = function (selectedFilterProperty) {
	                                    var selectedCondition = selectedFilterProperty.selectedCriteriaType;
	                                    if (selectedCondition.dateInfo.type === 'calculation') {
	                                        var measureCount = selectedFilterProperty.criteriaNumberOf;
	                                        switch (selectedCondition.dateInfo.measureType) {
	                                            case 'h':
	                                                var today = Date.parse('today');
	                                                selectedFilterProperty.criteriaRangeEnd = today.getTime();
	                                                var todayXHoursAgo = Date.parse('today').add(-(measureCount)).hours();
	                                                selectedFilterProperty.criteriaRangeStart = todayXHoursAgo.getTime();
	                                                break;
	                                            case 'd':
	                                                var lastFullDay = Date.parse('today').add(-1).days();
	                                                lastFullDay.setHours(23, 59, 59, 999);
	                                                selectedFilterProperty.criteriaRangeEnd = lastFullDay.getTime();
	                                                var lastXDaysAgo = Date.parse('today').add(-(measureCount)).days();
	                                                selectedFilterProperty.criteriaRangeStart = lastXDaysAgo.getTime();
	                                                break;
	                                            case 'w':
	                                                var lastFullWeekEnd = Date.today().last().sunday();
	                                                lastFullWeekEnd.setHours(23, 59, 59, 999);
	                                                selectedFilterProperty.criteriaRangeEnd = lastFullWeekEnd.getTime();
	                                                var lastXWeeksAgo = Date.today().last().sunday().add(-(measureCount)).weeks();
	                                                selectedFilterProperty.criteriaRangeStart = lastXWeeksAgo.getTime();
	                                                break;
	                                            case 'm':
	                                                var lastFullMonthEnd = Date.today().add(-1).months().moveToLastDayOfMonth();
	                                                lastFullMonthEnd.setHours(23, 59, 59, 999);
	                                                selectedFilterProperty.criteriaRangeEnd = lastFullMonthEnd.getTime();
	                                                var lastXMonthsAgo = Date.today().add(-1).months().moveToLastDayOfMonth().add(-(measureCount)).months();
	                                                selectedFilterProperty.criteriaRangeStart = lastXMonthsAgo.getTime();
	                                                break;
	                                            case 'q':
	                                                var currentQuarter = Math.floor((Date.parse('today').getMonth() / 3));
	                                                var firstDayOfCurrentQuarter = new Date(Date.parse('today').getFullYear(), currentQuarter * 3, 1);
	                                                var lastDayOfPreviousQuarter = firstDayOfCurrentQuarter.add(-1).days();
	                                                lastDayOfPreviousQuarter.setHours(23, 59, 59, 999);
	                                                selectedFilterProperty.criteriaRangeEnd = lastDayOfPreviousQuarter.getTime();
	                                                var lastXQuartersAgo = new Date(Date.parse('today').getFullYear(), currentQuarter * 3, 1);
	                                                lastXQuartersAgo.add(-(measureCount * 3)).months();
	                                                selectedFilterProperty.criteriaRangeStart = lastXQuartersAgo.getTime();
	                                                break;
	                                            case 'y':
	                                                var lastFullYearEnd = new Date(new Date().getFullYear(), 11, 31).add(-1).years();
	                                                lastFullYearEnd.setHours(23, 59, 59, 999);
	                                                selectedFilterProperty.criteriaRangeEnd = lastFullYearEnd.getTime();
	                                                var lastXYearsAgo = new Date(new Date().getFullYear(), 11, 31).add(-(measureCount) - 1).years();
	                                                selectedFilterProperty.criteriaRangeStart = lastXYearsAgo.getTime();
	                                                break;
	                                        }
	                                    }
	                                    if (selectedCondition.dateInfo.type === 'exactDate') {
	                                        selectedFilterProperty.criteriaRangeStart = selectedFilterProperty.criteriaRangeStart.setHours(0, 0, 0, 0);
	                                        selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeStart).setHours(23, 59, 59, 999);
	                                    }
	                                    if (selectedCondition.dateInfo.type === 'range') {
	                                        if (angular.isDefined(selectedFilterProperty.criteriaRangeStart)) {
	                                            selectedFilterProperty.criteriaRangeStart = new Date(selectedFilterProperty.criteriaRangeStart).setHours(0, 0, 0, 0);
	                                        }
	                                        if (angular.isDefined(selectedFilterProperty.criteriaRangeEnd)) {
	                                            selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeEnd).setHours(23, 59, 59, 999);
	                                        }
	                                    }
	                                    $log.debug('criteriaRangeChanged');
	                                    $log.debug(selectedCondition);
	                                    $log.debug(selectedFilterProperty);
	                                };
	                                break;
	                            case "big_decimal":
	                            case "integer":
	                            case "float":
	                                scope.conditionOptions = getNumberOptions();
	                                scope.criteriaRangeChanged = function (selectedFilterProperty) {
	                                    var selectedCondition = selectedFilterProperty.selectedCriteriaType;
	                                };
	                                scope.selectedConditionChanged = function (selectedFilterProperty) {
	                                    selectedFilterProperty.showCriteriaValue = true;
	                                    //check whether the type is a range
	                                    if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.type)) {
	                                        selectedFilterProperty.showCriteriaValue = false;
	                                        selectedFilterProperty.selectedCriteriaType.showCriteriaStart = true;
	                                        selectedFilterProperty.selectedCriteriaType.showCriteriaEnd = true;
	                                    }
	                                    //is null or is not null
	                                    if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
	                                        selectedFilterProperty.showCriteriaValue = false;
	                                    }
	                                };
	                                break;
	                        }
	                    }
	                    if (angular.isDefined(scope.selectedFilterProperty.fieldtype)) {
	                        switch (scope.selectedFilterProperty.fieldtype) {
	                            case "many-to-one":
	                                scope.conditionOptions = getManyToOneOptions(scope.comparisonType);
	                                $log.debug('many-to-one');
	                                $log.debug(scope.selectedFilterProperty);
	                                $log.debug(scope.filterPropertiesList);
	                                if (angular.isUndefined(scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier])) {
	                                    var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName(scope.selectedFilterProperty.cfc);
	                                    filterPropertiesPromise.then(function (value) {
	                                        scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier] = value;
	                                        metadataService.formatPropertiesList(scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier], scope.selectedFilterProperty.propertyIdentifier);
	                                    }, function (reason) {
	                                    });
	                                }
	                                break;
	                            case "many-to-many":
	                            case "one-to-many":
	                                scope.manyToManyOptions = getManyToManyOptions();
	                                scope.oneToManyOptions = getOneToManyOptions();
	                                var existingCollectionsPromise = $hibachi.getExistingCollectionsByBaseEntity(selectedFilterProperty.cfc);
	                                existingCollectionsPromise.then(function (value) {
	                                    scope.collectionOptions = value.data;
	                                    if (angular.isDefined(scope.workflowCondition.collectionID)) {
	                                        for (var i in scope.collectionOptions) {
	                                            if (scope.collectionOptions[i].collectionID === scope.workflowCondition.collectionID) {
	                                                scope.selectedFilterProperty.selectedCollection = scope.collectionOptions[i];
	                                            }
	                                        }
	                                        for (var i in scope.oneToManyOptions) {
	                                            if (scope.oneToManyOptions[i].comparisonOperator === scope.workflowCondition.criteria) {
	                                                scope.selectedFilterProperty.selectedCriteriaType = scope.oneToManyOptions[i];
	                                            }
	                                        }
	                                    }
	                                });
	                                break;
	                        }
	                    }
	                    $log.debug('workflowCondition');
	                    $log.debug(scope.workflowCondition);
	                    angular.forEach(scope.conditionOptions, function (conditionOption) {
	                        if (conditionOption.display == scope.workflowCondition.conditionDisplay) {
	                            scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
	                            scope.selectedFilterProperty.criteriaValue = scope.workflowCondition.value;
	                            if (angular.isDefined(scope.selectedFilterProperty.selectedCriteriaType.dateInfo)
	                                && angular.isDefined(scope.workflowCondition.value)
	                                && scope.workflowCondition.value.length) {
	                                var dateRangeArray = scope.workflowCondition.value.split("-");
	                                scope.selectedFilterProperty.criteriaRangeStart = new Date(parseInt(dateRangeArray[0]));
	                                scope.selectedFilterProperty.criteriaRangeEnd = new Date(parseInt(dateRangeArray[1]));
	                            }
	                            if (angular.isDefined(scope.workflowCondition.criteriaNumberOf)) {
	                                scope.selectedFilterProperty.criteriaNumberOf = scope.workflowCondition.criteriaNumberOf;
	                            }
	                            if (angular.isDefined(scope.selectedConditionChanged)) {
	                                scope.selectedConditionChanged(scope.selectedFilterProperty);
	                            }
	                        }
	                    });
	                    $log.debug('templateLoader');
	                    $log.debug(selectedFilterProperty);
	                    var templateLoader = getTemplate(selectedFilterProperty);
	                    var promise = templateLoader.success(function (html) {
	                        element.html(html);
	                        $compile(element.contents())(scope);
	                    });
	                }
	            });
	            scope.selectedCriteriaChanged = function (selectedCriteria) {
	                $log.debug(selectedCriteria);
	                //update breadcrumbs as array of filterpropertylist keys
	                $log.debug(scope.selectedFilterProperty);
	                var breadCrumb = {
	                    entityAlias: scope.selectedFilterProperty.name,
	                    cfc: scope.selectedFilterProperty.cfc,
	                    propertyIdentifier: scope.selectedFilterProperty.propertyIdentifier
	                };
	                scope.workflowCondition.breadCrumbs.push(breadCrumb);
	                //populate editfilterinfo with the current level of the filter property we are inspecting by pointing to the new scope key
	                scope.selectedFilterPropertyChanged({ selectedFilterProperty: scope.selectedFilterProperty.selectedCriteriaType });
	                //update criteria to display the condition of the new critera we have selected
	            };
	        };
	        return {
	            restrict: 'A',
	            scope: {
	                workflowCondition: "=",
	                selectedFilterProperty: "=",
	                filterPropertiesList: "=",
	                selectedFilterPropertyChanged: "&"
	            },
	            link: linker
	        };
	    }
	    SWConditionCriteria.Factory = function () {
	        var directive = function ($http, $compile, $templateCache, $log, $hibachi, $filter, workflowPartialsPath, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	            return new SWConditionCriteria($http, $compile, $templateCache, $log, $hibachi, $filter, workflowPartialsPath, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$http',
	            '$compile',
	            '$templateCache',
	            '$log',
	            '$hibachi',
	            '$filter',
	            'workflowPartialsPath',
	            'collectionPartialsPath',
	            'collectionService',
	            'metadataService',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWConditionCriteria;
	})();
	exports.SWConditionCriteria = SWConditionCriteria;


/***/ },
/* 80 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWCriteria = (function () {
	    function SWCriteria($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	        return {
	            restrict: 'E',
	            scope: {
	                filterItem: "=",
	                selectedFilterProperty: "=",
	                filterPropertiesList: "=",
	                selectedFilterPropertyChanged: "&",
	                comparisonType: "=",
	                collectionConfig: "="
	            },
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + 'criteria.html',
	            link: function (scope, element, attrs) {
	            }
	        };
	    }
	    SWCriteria.Factory = function () {
	        var directive = function ($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	            return new SWCriteria($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            '$hibachi',
	            '$filter',
	            'collectionPartialsPath',
	            'collectionService',
	            'metadataService',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWCriteria;
	})();
	exports.SWCriteria = SWCriteria;


/***/ },
/* 81 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWCriteriaBoolean = (function () {
	    function SWCriteriaBoolean($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	        return {
	            restrict: 'E',
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + 'criteriaboolean.html',
	            link: function (scope, element, attrs) {
	                var getBooleanOptions = function (type) {
	                    if (angular.isUndefined(type)) {
	                        type = 'filter';
	                    }
	                    var booleanOptions = [];
	                    if (type === 'filter') {
	                        booleanOptions = [
	                            {
	                                display: "True",
	                                comparisonOperator: "=",
	                                value: "True"
	                            },
	                            {
	                                display: "False",
	                                comparisonOperator: "=",
	                                value: "False"
	                            },
	                            {
	                                display: "Defined",
	                                comparisonOperator: "is not",
	                                value: "null"
	                            },
	                            {
	                                display: "Not Defined",
	                                comparisonOperator: "is",
	                                value: "null"
	                            }
	                        ];
	                    }
	                    else if (type === 'condition') {
	                        booleanOptions = [
	                            {
	                                display: "True",
	                                comparisonOperator: "eq",
	                                value: "True"
	                            },
	                            {
	                                display: "False",
	                                comparisonOperator: "eq",
	                                value: "False"
	                            },
	                            {
	                                display: "Defined",
	                                comparisonOperator: "null",
	                                value: "False"
	                            },
	                            {
	                                display: "Not Defined",
	                                comparisonOperator: "null",
	                                value: "True"
	                            }
	                        ];
	                    }
	                    return booleanOptions;
	                };
	                scope.conditionOptions = getBooleanOptions(scope.comparisonType);
	                angular.forEach(scope.conditionOptions, function (conditionOption) {
	                    if (conditionOption.display == scope.filterItem.conditionDisplay) {
	                        scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
	                        scope.selectedFilterProperty.criteriaValue = scope.filterItem.value;
	                        if (angular.isDefined(scope.selectedConditionChanged)) {
	                            scope.selectedConditionChanged(scope.selectedFilterProperty);
	                        }
	                    }
	                });
	            }
	        };
	    }
	    SWCriteriaBoolean.Factory = function () {
	        var directive = function ($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	            return new SWCriteriaBoolean($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            '$hibachi',
	            '$filter',
	            'collectionPartialsPath',
	            'collectionService',
	            'metadataService',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWCriteriaBoolean;
	})();
	exports.SWCriteriaBoolean = SWCriteriaBoolean;


/***/ },
/* 82 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWCriteriaDate = (function () {
	    function SWCriteriaDate($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	        return {
	            restrict: 'E',
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + 'criteriadate.html',
	            link: function (scope, element, attrs) {
	                var getDateOptions = function (type) {
	                    if (angular.isUndefined(type)) {
	                        type = 'filter';
	                    }
	                    var dateOptions = [];
	                    if (type === 'filter') {
	                        dateOptions = [
	                            {
	                                display: "Date",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'exactDate',
	                                }
	                            },
	                            {
	                                display: "In Range",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'range'
	                                }
	                            },
	                            {
	                                display: "Not In Range",
	                                comparisonOperator: "not between",
	                                dateInfo: {
	                                    type: 'range'
	                                }
	                            },
	                            {
	                                display: "Today",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'calculation',
	                                    measureType: 'd',
	                                    measureCount: 0,
	                                    behavior: 'toDate'
	                                }
	                            },
	                            {
	                                display: "Yesterday",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'calculation',
	                                    measureType: 'd',
	                                    measureCount: -1,
	                                    behavior: 'toDate'
	                                }
	                            },
	                            {
	                                display: "This Week",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'calculation',
	                                    measureType: 'w',
	                                    behavior: 'toDate'
	                                }
	                            },
	                            {
	                                display: "This Month",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'calculation',
	                                    measureType: 'm',
	                                    behavior: 'toDate'
	                                }
	                            },
	                            {
	                                display: "This Quarter",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'calculation',
	                                    measureType: 'q',
	                                    behavior: 'toDate'
	                                }
	                            },
	                            {
	                                display: "This Year",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'calculation',
	                                    measureType: 'y',
	                                    behavior: 'toDate'
	                                }
	                            },
	                            {
	                                display: "Last N Hour(s)",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'calculation',
	                                    measureType: 'h',
	                                    measureTypeDisplay: 'Hours'
	                                }
	                            },
	                            {
	                                display: "Last N Day(s)",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'calculation',
	                                    measureType: 'd',
	                                    measureTypeDisplay: 'Days'
	                                }
	                            },
	                            {
	                                display: "Last N Week(s)",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'calculation',
	                                    measureType: 'w',
	                                    measureTypeDisplay: 'Weeks'
	                                }
	                            },
	                            {
	                                display: "Last N Month(s)",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'calculation',
	                                    measureType: 'm',
	                                    measureTypeDisplay: 'Months'
	                                }
	                            },
	                            {
	                                display: "Last N Quarter(s)",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'calculation',
	                                    measureType: 'q',
	                                    measureTypeDisplay: 'Quarters'
	                                }
	                            },
	                            {
	                                display: "Last N Year(s)",
	                                comparisonOperator: "between",
	                                dateInfo: {
	                                    type: 'calculation',
	                                    measureType: 'y',
	                                    measureTypeDisplay: 'Years'
	                                }
	                            },
	                            {
	                                display: "Defined",
	                                comparisonOperator: "is not",
	                                value: "null"
	                            },
	                            {
	                                display: "Not Defined",
	                                comparisonOperator: "is",
	                                value: "null"
	                            }
	                        ];
	                    }
	                    else if (type === 'condition') {
	                        dateOptions = [
	                            {
	                                display: "Equals",
	                                comparisonOperator: "eq"
	                            },
	                            {
	                                display: "Doesn't Equal",
	                                comparisonOperator: "neq"
	                            },
	                            {
	                                display: "Defined",
	                                comparisonOperator: "null",
	                                value: "False"
	                            },
	                            {
	                                display: "Not Defined",
	                                comparisonOperator: "null",
	                                value: "True"
	                            }
	                        ];
	                    }
	                    return dateOptions;
	                };
	                scope.conditionOptions = getDateOptions(scope.comparisonType);
	                scope.today = function () {
	                    if (angular.isDefined(scope.selectedFilterProperty)) {
	                        scope.selectedFilterProperty.criteriaRangeStart = new Date();
	                        scope.selectedFilterProperty.criteriaRangeEnd = new Date();
	                    }
	                };
	                scope.clear = function () {
	                    scope.selectedFilterProperty.criteriaRangeStart = null;
	                    scope.selectedFilterProperty.criteriaRangeEnd = null;
	                };
	                scope.openCalendarStart = function ($event) {
	                    $event.preventDefault();
	                    $event.stopPropagation();
	                    scope.openedCalendarStart = true;
	                };
	                scope.openCalendarEnd = function ($event) {
	                    $event.preventDefault();
	                    $event.stopPropagation();
	                    scope.openedCalendarEnd = true;
	                };
	                scope.formats = [
	                    'dd-MMMM-yyyy',
	                    'yyyy/MM/dd',
	                    'dd.MM.yyyy',
	                    'shortDate'];
	                scope.format = scope.formats[1];
	                scope.selectedConditionChanged = function (selectedFilterProperty) {
	                    $log.debug('selectedConditionChanged Begin');
	                    var selectedCondition = selectedFilterProperty.selectedCriteriaType;
	                    //check whether condition is checking for null values in date
	                    if (angular.isDefined(selectedCondition.dateInfo)) {
	                        //is condition a calculation
	                        if (selectedCondition.dateInfo.type === 'calculation') {
	                            selectedCondition.showCriteriaStart = true;
	                            selectedCondition.showCriteriaEnd = true;
	                            selectedCondition.disableCriteriaStart = true;
	                            selectedCondition.disableCriteriaEnd = true;
	                            //if item is a calculation of an N number of measure display the measure and number input
	                            if (angular.isUndefined(selectedCondition.dateInfo.behavior)) {
	                                $log.debug('Not toDate');
	                                selectedCondition.showNumberOf = true;
	                                selectedCondition.conditionDisplay = 'Number of ' + selectedCondition.dateInfo.measureTypeDisplay + ' :';
	                            }
	                            else {
	                                $log.debug('toDate');
	                                var today = Date.parse('today');
	                                var todayEOD = today.setHours(23, 59, 59, 999);
	                                selectedFilterProperty.criteriaRangeEnd = todayEOD;
	                                //get this Measure to date
	                                switch (selectedCondition.dateInfo.measureType) {
	                                    case 'd':
	                                        var dateBOD = Date.parse('today').add(selectedCondition.dateInfo.measureCount).days();
	                                        dateBOD.setHours(0, 0, 0, 0);
	                                        selectedFilterProperty.criteriaRangeStart = dateBOD.getTime();
	                                        break;
	                                    case 'w':
	                                        var firstDayOfWeek = Date.today().last().monday();
	                                        selectedFilterProperty.criteriaRangeStart = firstDayOfWeek.getTime();
	                                        break;
	                                    case 'm':
	                                        var firstDayOfMonth = Date.today().moveToFirstDayOfMonth();
	                                        selectedFilterProperty.criteriaRangeStart = firstDayOfMonth.getTime();
	                                        break;
	                                    case 'q':
	                                        var month = Date.parse('today').toString('MM');
	                                        var year = Date.parse('today').toString('yyyy');
	                                        var quarterMonth = (Math.floor(month / 3) * 3);
	                                        var firstDayOfQuarter = new Date(year, quarterMonth, 1);
	                                        selectedFilterProperty.criteriaRangeStart = firstDayOfQuarter.getTime();
	                                        break;
	                                    case 'y':
	                                        var year = Date.parse('today').toString('yyyy');
	                                        var firstDayOfYear = new Date(year, 0, 1);
	                                        selectedFilterProperty.criteriaRangeStart = firstDayOfYear.getTime();
	                                        break;
	                                }
	                            }
	                        }
	                        if (selectedCondition.dateInfo.type === 'range') {
	                            selectedCondition.showCriteriaStart = true;
	                            selectedCondition.showCriteriaEnd = true;
	                            selectedCondition.disableCriteriaStart = false;
	                            selectedCondition.disableCriteriaEnd = false;
	                            selectedCondition.showNumberOf = false;
	                        }
	                        if (selectedCondition.dateInfo.type === 'exactDate') {
	                            selectedCondition.showCriteriaStart = true;
	                            selectedCondition.showCriteriaEnd = false;
	                            selectedCondition.disableCriteriaStart = false;
	                            selectedCondition.disableCriteriaEnd = true;
	                            selectedCondition.showNumberOf = false;
	                            selectedCondition.conditionDisplay = '';
	                            selectedFilterProperty.criteriaRangeStart = new Date(selectedFilterProperty.criteriaRangeStart).setHours(0, 0, 0, 0);
	                            selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeStart).setHours(23, 59, 59, 999);
	                        }
	                    }
	                    else {
	                        selectedCondition.showCriteriaStart = false;
	                        selectedCondition.showCriteriaEnd = false;
	                        selectedCondition.showNumberOf = false;
	                        selectedCondition.conditionDisplay = '';
	                    }
	                    $log.debug('selectedConditionChanged End');
	                    $log.debug('selectedConditionChanged Result');
	                    $log.debug(selectedCondition);
	                    $log.debug(selectedFilterProperty);
	                };
	                scope.criteriaRangeChanged = function (selectedFilterProperty) {
	                    $log.debug('criteriaRangeChanged');
	                    $log.debug(selectedFilterProperty);
	                    var selectedCondition = selectedFilterProperty.selectedCriteriaType;
	                    if (selectedCondition.dateInfo.type === 'calculation') {
	                        var measureCount = selectedFilterProperty.criteriaNumberOf;
	                        switch (selectedCondition.dateInfo.measureType) {
	                            case 'h':
	                                var today = Date.parse('today');
	                                selectedFilterProperty.criteriaRangeEnd = today.getTime();
	                                var todayXHoursAgo = Date.parse('today').add(-(measureCount)).hours();
	                                selectedFilterProperty.criteriaRangeStart = todayXHoursAgo.getTime();
	                                break;
	                            case 'd':
	                                var lastFullDay = Date.parse('today').add(-1).days();
	                                lastFullDay.setHours(23, 59, 59, 999);
	                                selectedFilterProperty.criteriaRangeEnd = lastFullDay.getTime();
	                                var lastXDaysAgo = Date.parse('today').add(-(measureCount)).days();
	                                selectedFilterProperty.criteriaRangeStart = lastXDaysAgo.getTime();
	                                break;
	                            case 'w':
	                                var lastFullWeekEnd = Date.today().last().sunday();
	                                lastFullWeekEnd.setHours(23, 59, 59, 999);
	                                selectedFilterProperty.criteriaRangeEnd = lastFullWeekEnd.getTime();
	                                var lastXWeeksAgo = Date.today().last().sunday().add(-(measureCount)).weeks();
	                                selectedFilterProperty.criteriaRangeStart = lastXWeeksAgo.getTime();
	                                break;
	                            case 'm':
	                                var lastFullMonthEnd = Date.today().add(-1).months().moveToLastDayOfMonth();
	                                lastFullMonthEnd.setHours(23, 59, 59, 999);
	                                selectedFilterProperty.criteriaRangeEnd = lastFullMonthEnd.getTime();
	                                var lastXMonthsAgo = Date.today().add(-1).months().moveToLastDayOfMonth().add(-(measureCount)).months();
	                                selectedFilterProperty.criteriaRangeStart = lastXMonthsAgo.getTime();
	                                break;
	                            case 'q':
	                                var currentQuarter = Math.floor((Date.parse('today').getMonth() / 3));
	                                var firstDayOfCurrentQuarter = new Date(Date.parse('today').getFullYear(), currentQuarter * 3, 1);
	                                var lastDayOfPreviousQuarter = firstDayOfCurrentQuarter.add(-1).days();
	                                lastDayOfPreviousQuarter.setHours(23, 59, 59, 999);
	                                selectedFilterProperty.criteriaRangeEnd = lastDayOfPreviousQuarter.getTime();
	                                var lastXQuartersAgo = new Date(Date.parse('today').getFullYear(), currentQuarter * 3, 1);
	                                lastXQuartersAgo.add(-(measureCount * 3)).months();
	                                selectedFilterProperty.criteriaRangeStart = lastXQuartersAgo.getTime();
	                                break;
	                            case 'y':
	                                var lastFullYearEnd = new Date(new Date().getFullYear(), 11, 31).add(-1).years();
	                                lastFullYearEnd.setHours(23, 59, 59, 999);
	                                selectedFilterProperty.criteriaRangeEnd = lastFullYearEnd.getTime();
	                                var lastXYearsAgo = new Date(new Date().getFullYear(), 11, 31).add(-(measureCount) - 1).years();
	                                selectedFilterProperty.criteriaRangeStart = lastXYearsAgo.getTime();
	                                break;
	                        }
	                    }
	                    if (selectedCondition.dateInfo.type === 'exactDate' && angular.isDefined(selectedFilterProperty.criteriaRangeStart) && angular.isDefined(selectedFilterProperty.criteriaRangeStart.setHours)) {
	                        selectedFilterProperty.criteriaRangeStart = selectedFilterProperty.criteriaRangeStart.setHours(0, 0, 0, 0);
	                        selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeStart).setHours(23, 59, 59, 999);
	                    }
	                    if (selectedCondition.dateInfo.type === 'range') {
	                        if (angular.isDefined(selectedFilterProperty.criteriaRangeStart) && angular.isDefined(selectedFilterProperty.criteriaRangeStart)) {
	                            selectedFilterProperty.criteriaRangeStart = new Date(selectedFilterProperty.criteriaRangeStart).setHours(0, 0, 0, 0);
	                        }
	                        if (angular.isDefined(selectedFilterProperty.criteriaRangeEnd) && angular.isDefined(selectedFilterProperty.criteriaRangeStart)) {
	                            selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeEnd).setHours(23, 59, 59, 999);
	                        }
	                    }
	                    $log.debug('criteriaRangeChanged');
	                    $log.debug(selectedCondition);
	                    $log.debug(selectedFilterProperty);
	                };
	                if (angular.isUndefined(scope.filterItem.$$isNew) || scope.filterItem.$$isNew === false) {
	                    angular.forEach(scope.conditionOptions, function (conditionOption) {
	                        if (conditionOption.display == scope.filterItem.conditionDisplay) {
	                            scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
	                            scope.selectedFilterProperty.criteriaValue = scope.filterItem.value;
	                            if (angular.isDefined(scope.selectedFilterProperty.selectedCriteriaType.dateInfo)
	                                && angular.isDefined(scope.filterItem.value)
	                                && scope.filterItem.value.length) {
	                                var dateRangeArray = scope.filterItem.value.split("-");
	                                scope.selectedFilterProperty.criteriaRangeStart = new Date(parseInt(dateRangeArray[0]));
	                                scope.selectedFilterProperty.criteriaRangeEnd = new Date(parseInt(dateRangeArray[1]));
	                            }
	                            if (angular.isDefined(scope.selectedConditionChanged)) {
	                                scope.selectedConditionChanged(scope.selectedFilterProperty);
	                            }
	                        }
	                    });
	                }
	                else {
	                    scope.selectedFilterProperty.criteriaValue = '';
	                    scope.selectedFilterProperty.criteriaRangeStart = '';
	                    scope.selectedFilterProperty.criteriaRangeEnd = '';
	                }
	            }
	        };
	    }
	    SWCriteriaDate.Factory = function () {
	        var directive = function ($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	            return new SWCriteriaDate($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            '$hibachi',
	            '$filter',
	            'collectionPartialsPath',
	            'collectionService',
	            'metadataService',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWCriteriaDate;
	})();
	exports.SWCriteriaDate = SWCriteriaDate;


/***/ },
/* 83 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWCriteriaManyToMany = (function () {
	    function SWCriteriaManyToMany($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, dialogService, observerService, hibachiPathBuilder, rbkeyService) {
	        return {
	            restrict: 'E',
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + 'criteriamanytomany.html',
	            link: function (scope, element, attrs) {
	                scope.data = {};
	                scope.collectionOptionsOpen = false;
	                scope.toggleCollectionOptions = function (flag) {
	                    scope.collectionOptionsOpen = (!angular.isUndefined(flag)) ? flag : !scope.collectionOptionsOpen;
	                };
	                scope.selectCollection = function (collection) {
	                    scope.toggleCollectionOptions();
	                    scope.selectedFilterProperty.selectedCollection = collection;
	                    scope.selectedFilterProperty.selectedCriteriaType = scope.manyToManyOptions[2];
	                };
	                scope.cleanSelection = function () {
	                    scope.toggleCollectionOptions(false);
	                    scope.data.collectionName = "";
	                    scope.selectedFilterProperty.selectedCollection = null;
	                };
	                var getManyToManyOptions = function (type) {
	                    if (angular.isUndefined(type)) {
	                        type = 'filter';
	                    }
	                    $log.debug('type', type);
	                    var manyToManyOptions = [];
	                    if (type == 'filter') {
	                        manyToManyOptions = [
	                            {
	                                display: "All Exist In Collection",
	                                comparisonOperator: "All"
	                            },
	                            {
	                                display: "None Exist In Collection",
	                                comparisonOperator: "None"
	                            },
	                            {
	                                display: "Some Exist In Collection",
	                                comparisonOperator: "One"
	                            },
	                            {
	                                display: "Empty",
	                                comparisonOperator: "is",
	                                value: "null"
	                            },
	                            {
	                                display: "Not Empty",
	                                comparisonOperator: "is not",
	                                value: "null"
	                            }
	                        ];
	                    }
	                    else if (type === 'condition') {
	                        manyToManyOptions = [];
	                    }
	                    return manyToManyOptions;
	                };
	                scope.manyToManyOptions = getManyToManyOptions(scope.comparisonType);
	                var existingCollectionsPromise = $hibachi.getExistingCollectionsByBaseEntity(scope.selectedFilterProperty.cfc);
	                existingCollectionsPromise.then(function (value) {
	                    scope.collectionOptions = value.data;
	                    if (angular.isDefined(scope.filterItem.collectionID)) {
	                        for (var i in scope.collectionOptions) {
	                            if (scope.collectionOptions[i].collectionID === scope.filterItem.collectionID) {
	                                scope.selectedFilterProperty.selectedCollection = scope.collectionOptions[i];
	                            }
	                        }
	                        for (var i in scope.manyToManyOptions) {
	                            if (scope.manyToManyOptions[i].comparisonOperator === scope.filterItem.criteria) {
	                                scope.selectedFilterProperty.selectedCriteriaType = scope.manyToManyOptions[i];
	                            }
	                        }
	                    }
	                });
	                function populateUI(collection) {
	                    scope.collectionOptions.push(collection);
	                    scope.selectedFilterProperty.selectedCollection = collection;
	                    scope.selectedFilterProperty.selectedCriteriaType = scope.manyToManyOptions[2];
	                }
	                observerService.attach(populateUI, 'addCollection', 'addCollection');
	                scope.selectedCriteriaChanged = function (selectedCriteria) {
	                    $log.debug(selectedCriteria);
	                    //update breadcrumbs as array of filterpropertylist keys
	                    $log.debug(scope.selectedFilterProperty);
	                    var breadCrumb = {
	                        entityAlias: scope.selectedFilterProperty.name,
	                        cfc: scope.selectedFilterProperty.cfc,
	                        propertyIdentifier: scope.selectedFilterProperty.propertyIdentifier,
	                        rbKey: rbkeyService.getRBKey('entity.' + scope.selectedFilterProperty.cfc.replace('_', ''))
	                    };
	                    scope.filterItem.breadCrumbs.push(breadCrumb);
	                    //populate editfilterinfo with the current level of the filter property we are inspecting by pointing to the new scope key
	                    scope.selectedFilterPropertyChanged({ selectedFilterProperty: scope.selectedFilterProperty.selectedCriteriaType });
	                    //update criteria to display the condition of the new critera we have selected
	                };
	                scope.addNewCollection = function () {
	                    dialogService.addPageDialog('org/Hibachi/client/src/collection/components/criteriacreatecollection', {
	                        entityName: scope.selectedFilterProperty.cfc,
	                        collectionName: scope.data.collectionName,
	                        parentEntity: scope.collectionConfig.baseEntityName
	                    });
	                    scope.cleanSelection();
	                };
	                scope.viewSelectedCollection = function () {
	                    dialogService.addPageDialog('org/Hibachi/client/src/collection/components//criteriacreatecollection', {
	                        entityName: 'collection',
	                        entityId: scope.selectedFilterProperty.selectedCollection.collectionID,
	                        parentEntity: scope.collectionConfig.baseEntityName
	                    });
	                };
	            }
	        };
	    }
	    SWCriteriaManyToMany.Factory = function () {
	        var directive = function ($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, dialogService, observerService, hibachiPathBuilder, rbkeyService) {
	            return new SWCriteriaManyToMany($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, dialogService, observerService, hibachiPathBuilder, rbkeyService);
	        };
	        directive.$inject = [
	            '$log',
	            '$hibachi',
	            '$filter',
	            'collectionPartialsPath',
	            'collectionService',
	            'metadataService',
	            'dialogService',
	            'observerService',
	            'hibachiPathBuilder',
	            'rbkeyService',
	        ];
	        return directive;
	    };
	    return SWCriteriaManyToMany;
	})();
	exports.SWCriteriaManyToMany = SWCriteriaManyToMany;


/***/ },
/* 84 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWCriteriaManyToOne = (function () {
	    function SWCriteriaManyToOne($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder, rbkeyService) {
	        return {
	            restrict: 'E',
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + 'criteriamanytoone.html',
	            link: function (scope, element, attrs) {
	                var getManyToOneOptions = function () {
	                    var manyToOneOptions = {
	                        drillEntity: {},
	                        hasEntity: {
	                            display: "Defined",
	                            comparisonOperator: "is not",
	                            value: "null"
	                        },
	                        notHasEntity: {
	                            display: "Not Defined",
	                            comparisonOperator: "is",
	                            value: "null"
	                        }
	                    };
	                    return manyToOneOptions;
	                };
	                scope.manyToOneOptions = getManyToOneOptions();
	                scope.conditionOptions = getManyToOneOptions();
	                $log.debug('many-to-one');
	                $log.debug(scope.selectedFilterProperty);
	                $log.debug(scope.filterPropertiesList);
	                scope.$watch('selectedFilterProperty', function (selectedFilterProperty) {
	                    if (angular.isUndefined(scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier])) {
	                        var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName(selectedFilterProperty.cfc);
	                        filterPropertiesPromise.then(function (value) {
	                            scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier] = value;
	                            metadataService.formatPropertiesList(scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier], scope.selectedFilterProperty.propertyIdentifier);
	                        }, function (reason) {
	                        });
	                    }
	                    scope.selectedCriteriaChanged = function (selectedCriteria) {
	                        $log.debug(selectedCriteria);
	                        $log.debug('changed');
	                        //update breadcrumbs as array of filterpropertylist keys
	                        $log.debug(scope.selectedFilterProperty);
	                        var breadCrumb = {
	                            entityAlias: scope.selectedFilterProperty.name,
	                            cfc: scope.selectedFilterProperty.cfc,
	                            propertyIdentifier: scope.selectedFilterProperty.propertyIdentifier,
	                            rbKey: rbkeyService.getRBKey('entity.' + scope.selectedFilterProperty.cfc.replace('_', ''))
	                        };
	                        $log.debug('breadcrumb');
	                        $log.debug(breadCrumb);
	                        $log.debug(scope.filterItem.breadCrumbs);
	                        scope.filterItem.breadCrumbs.push(breadCrumb);
	                        //populate editfilterinfo with the current level of the filter property we are inspecting by pointing to the new scope key
	                        scope.selectedFilterPropertyChanged({ selectedFilterProperty: scope.selectedFilterProperty.selectedCriteriaType });
	                        //update criteria to display the condition of the new critera we have selected
	                        $log.debug(scope.selectedFilterProperty);
	                    };
	                });
	            }
	        };
	    }
	    SWCriteriaManyToOne.Factory = function () {
	        var directive = function ($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder, rbkeyService) {
	            return new SWCriteriaManyToOne($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder, rbkeyService);
	        };
	        directive.$inject = [
	            '$log',
	            '$hibachi',
	            '$filter',
	            'collectionPartialsPath',
	            'collectionService',
	            'metadataService',
	            'hibachiPathBuilder',
	            'rbkeyService'
	        ];
	        return directive;
	    };
	    return SWCriteriaManyToOne;
	})();
	exports.SWCriteriaManyToOne = SWCriteriaManyToOne;
	// 'use strict';
	// angular.module('slatwalladmin')
	// .directive('swCriteriaManyToOne', [
	// 	'$log',
	// 	'$hibachi',
	// 	'$filter',
	// 	'collectionPartialsPath',
	// 	'collectionService',
	// 	'metadataService',
	// 	function(
	// 		$log,
	// 		$hibachi,
	// 		$filter,
	// 		collectionPartialsPath,
	// 		collectionService,
	// 		metadataService
	// 	){
	// 		return {
	// 			restrict: 'E',
	// 			templateUrl:collectionPartialsPath+'criteriamanytoone.html',
	// 			link: function(scope, element, attrs){
	// 				var getManyToOneOptions = function(){
	// 			    	var manyToOneOptions = {
	// 			            drillEntity:{},
	// 						hasEntity:{
	// 							display:"Defined",
	// 							comparisonOperator:"is not",
	// 							value:"null"
	// 						},
	// 						notHasEntity:{
	// 							display:"Not Defined",
	// 							comparisonOperator:"is",
	// 							value:"null"
	// 						}
	// 			    	};
	// 			    	return manyToOneOptions;
	// 			    };
	// 			    scope.manyToOneOptions = getManyToOneOptions();
	// 			    scope.conditionOptions = getManyToOneOptions();
	// 				$log.debug('many-to-one');
	// 				$log.debug(scope.selectedFilterProperty);
	// 				$log.debug(scope.filterPropertiesList);
	// 				scope.$watch('selectedFilterProperty',function(selectedFilterProperty){
	// 					if(angular.isUndefined(scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier])){
	// 						var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName(selectedFilterProperty.cfc);
	// 						filterPropertiesPromise.then(function(value){
	// 							scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier] = value;
	// 							metadataService.formatPropertiesList(scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier],scope.selectedFilterProperty.propertyIdentifier);
	// 						}, function(reason){
	// 						});
	// 					}
	// 					scope.selectedCriteriaChanged = function(selectedCriteria){
	// 						$log.debug(selectedCriteria);
	// 						$log.debug('changed');
	// 						//update breadcrumbs as array of filterpropertylist keys
	// 						$log.debug(scope.selectedFilterProperty);
	// 						var breadCrumb = {
	// 								entityAlias:scope.selectedFilterProperty.name,
	// 								cfc:scope.selectedFilterProperty.cfc,
	// 								propertyIdentifier:scope.selectedFilterProperty.propertyIdentifier,
	// 								rbKey:rbkeyService.getRBKey('entity.'+scope.selectedFilterProperty.cfc.replace('_',''))
	// 						};
	// 						$log.debug('breadcrumb');
	// 						$log.debug(breadCrumb);
	// 						$log.debug(scope.filterItem.breadCrumbs);
	// 						scope.filterItem.breadCrumbs.push(breadCrumb);
	// 						//populate editfilterinfo with the current level of the filter property we are inspecting by pointing to the new scope key
	// 						scope.selectedFilterPropertyChanged({selectedFilterProperty:scope.selectedFilterProperty.selectedCriteriaType});
	// 						//update criteria to display the condition of the new critera we have selected
	// 						$log.debug(scope.selectedFilterProperty);
	// 					};
	// 				});
	// 			}
	// 		};
	// 	}
	// ]);


/***/ },
/* 85 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWCriteriaNumber = (function () {
	    function SWCriteriaNumber($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	        return {
	            restrict: 'E',
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + 'criterianumber.html',
	            link: function (scope, element, attrs) {
	                var getNumberOptions = function (type) {
	                    if (angular.isUndefined(type)) {
	                        type = 'filter';
	                    }
	                    var numberOptions = [];
	                    if (type === 'filter') {
	                        numberOptions = [
	                            {
	                                display: "Equals",
	                                comparisonOperator: "="
	                            },
	                            {
	                                display: "Doesn't Equal",
	                                comparisonOperator: "<>"
	                            },
	                            {
	                                display: "In Range",
	                                comparisonOperator: "between",
	                                type: "range"
	                            },
	                            {
	                                display: "Not In Range",
	                                comparisonOperator: "not between",
	                                type: "range"
	                            },
	                            {
	                                display: "Greater Than",
	                                comparisonOperator: ">"
	                            },
	                            {
	                                display: "Greater Than Or Equal",
	                                comparisonOperator: ">="
	                            },
	                            {
	                                display: "Less Than",
	                                comparisonOperator: "<"
	                            },
	                            {
	                                display: "Less Than Or Equal",
	                                comparisonOperator: "<="
	                            },
	                            {
	                                display: "In List",
	                                comparisonOperator: "in"
	                            },
	                            {
	                                display: "Not In List",
	                                comparisonOperator: "not in"
	                            },
	                            {
	                                display: "Defined",
	                                comparisonOperator: "is not",
	                                value: "null"
	                            },
	                            {
	                                display: "Not Defined",
	                                comparisonOperator: "is",
	                                value: "null"
	                            }
	                        ];
	                    }
	                    else if (type === 'condition') {
	                        numberOptions = [
	                            {
	                                display: "Equals",
	                                comparisonOperator: "eq"
	                            },
	                            {
	                                display: "Doesn't Equal",
	                                comparisonOperator: "neq"
	                            },
	                            {
	                                display: "Defined",
	                                comparisonOperator: "null",
	                                value: "False"
	                            },
	                            {
	                                display: "Not Defined",
	                                comparisonOperator: "null",
	                                value: "True"
	                            }
	                        ];
	                    }
	                    return numberOptions;
	                };
	                scope.$watch('selectedFilterProperty.criteriaValue', function (criteriaValue) {
	                    if (angular.isDefined(criteriaValue)) {
	                        scope.selectedFilterProperty.criteriaValue = criteriaValue;
	                        $log.debug(scope.selectedFilterProperty);
	                    }
	                });
	                scope.conditionOptions = getNumberOptions(scope.comparisonType);
	                scope.criteriaRangeChanged = function (selectedFilterProperty) {
	                    var selectedCondition = selectedFilterProperty.selectedCriteriaType;
	                };
	                scope.selectedConditionChanged = function (selectedFilterProperty) {
	                    selectedFilterProperty.showCriteriaValue = true;
	                    //check whether the type is a range
	                    if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.type)) {
	                        selectedFilterProperty.showCriteriaValue = false;
	                        selectedFilterProperty.selectedCriteriaType.showCriteriaStart = true;
	                        selectedFilterProperty.selectedCriteriaType.showCriteriaEnd = true;
	                    }
	                    //is null or is not null
	                    if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
	                        selectedFilterProperty.showCriteriaValue = false;
	                    }
	                };
	                angular.forEach(scope.conditionOptions, function (conditionOption) {
	                    $log.debug('populate');
	                    if (conditionOption.display == scope.filterItem.conditionDisplay) {
	                        scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
	                        $log.debug(scope.filterItem);
	                        if (scope.filterItem.comparisonOperator === 'between' || scope.filterItem.comparisonOperator === 'not between') {
	                            var criteriaRangeArray = scope.filterItem.value.split('-');
	                            $log.debug(criteriaRangeArray);
	                            scope.selectedFilterProperty.criteriaRangeStart = parseInt(criteriaRangeArray[0]);
	                            scope.selectedFilterProperty.criteriaRangeEnd = parseInt(criteriaRangeArray[1]);
	                        }
	                        else {
	                            scope.selectedFilterProperty.criteriaValue = scope.filterItem.value;
	                        }
	                        if (angular.isDefined(scope.filterItem.criteriaNumberOf)) {
	                            scope.selectedFilterProperty.criteriaNumberOf = scope.filterItem.criteriaNumberOf;
	                        }
	                        if (angular.isDefined(scope.selectedConditionChanged)) {
	                            scope.selectedConditionChanged(scope.selectedFilterProperty);
	                        }
	                    }
	                });
	            }
	        };
	    }
	    SWCriteriaNumber.Factory = function () {
	        var directive = function ($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	            return new SWCriteriaNumber($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            '$hibachi',
	            '$filter',
	            'collectionPartialsPath',
	            'collectionService',
	            'metadataService',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWCriteriaNumber;
	})();
	exports.SWCriteriaNumber = SWCriteriaNumber;


/***/ },
/* 86 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWCriteriaOneToMany = (function () {
	    function SWCriteriaOneToMany($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, dialogService, observerService, hibachiPathBuilder, rbkeyService) {
	        return {
	            restrict: 'E',
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + 'criteriaonetomany.html',
	            link: function (scope, element, attrs) {
	                scope.data = {};
	                scope.collectionOptionsOpen = false;
	                scope.toggleCollectionOptions = function (flag) {
	                    scope.collectionOptionsOpen = (!angular.isUndefined(flag)) ? flag : !scope.collectionOptionsOpen;
	                };
	                scope.selectCollection = function (collection) {
	                    scope.toggleCollectionOptions();
	                    scope.selectedFilterProperty.selectedCollection = collection;
	                    scope.selectedFilterProperty.selectedCriteriaType = scope.oneToManyOptions[2];
	                };
	                scope.cleanSelection = function () {
	                    scope.toggleCollectionOptions(false);
	                    scope.data.collectionName = "";
	                    scope.selectedFilterProperty.selectedCollection = null;
	                };
	                var getOneToManyOptions = function (type) {
	                    if (angular.isUndefined(type)) {
	                        type = 'filter';
	                    }
	                    var oneToManyOptions = [];
	                    if (type == 'filter') {
	                        oneToManyOptions = [
	                            {
	                                display: "All Exist In Collection",
	                                comparisonOperator: "All"
	                            },
	                            {
	                                display: "None Exist In Collection",
	                                comparisonOperator: "None"
	                            },
	                            {
	                                display: "Some Exist In Collection",
	                                comparisonOperator: "One"
	                            }
	                        ];
	                    }
	                    else if (type === 'condition') {
	                        oneToManyOptions = [];
	                    }
	                    return oneToManyOptions;
	                };
	                $log.debug('onetomany');
	                $log.debug(scope.selectedFilterProperty);
	                scope.oneToManyOptions = getOneToManyOptions(scope.comparisonType);
	                var existingCollectionsPromise = $hibachi.getExistingCollectionsByBaseEntity(scope.selectedFilterProperty.cfc);
	                existingCollectionsPromise.then(function (value) {
	                    scope.collectionOptions = value.data;
	                    if (angular.isDefined(scope.filterItem.collectionID)) {
	                        for (var i in scope.collectionOptions) {
	                            if (scope.collectionOptions[i].collectionID === scope.filterItem.collectionID) {
	                                scope.selectedFilterProperty.selectedCollection = scope.collectionOptions[i];
	                            }
	                        }
	                        for (var i in scope.oneToManyOptions) {
	                            if (scope.oneToManyOptions[i].comparisonOperator === scope.filterItem.criteria) {
	                                scope.selectedFilterProperty.selectedCriteriaType = scope.oneToManyOptions[i];
	                            }
	                        }
	                    }
	                });
	                function populateUI(collection) {
	                    scope.collectionOptions.push(collection);
	                    scope.selectedFilterProperty.selectedCollection = collection;
	                    scope.selectedFilterProperty.selectedCriteriaType = scope.oneToManyOptions[2];
	                }
	                observerService.attach(populateUI, 'addCollection', 'addCollection');
	                scope.selectedCriteriaChanged = function (selectedCriteria) {
	                    $log.debug(selectedCriteria);
	                    //update breadcrumbs as array of filterpropertylist keys
	                    $log.debug(scope.selectedFilterProperty);
	                    var breadCrumb = {
	                        entityAlias: scope.selectedFilterProperty.name,
	                        cfc: scope.selectedFilterProperty.cfc,
	                        propertyIdentifier: scope.selectedFilterProperty.propertyIdentifier,
	                        rbKey: rbkeyService.getRBKey('entity.' + scope.selectedFilterProperty.cfc.replace('_', '')),
	                        filterProperty: scope.selectedFilterProperty
	                    };
	                    scope.filterItem.breadCrumbs.push(breadCrumb);
	                    $log.debug('criteriaChanged');
	                    //$log.debug(selectedFilterPropertyChanged);
	                    $log.debug(scope.selectedFilterProperty);
	                    //populate editfilterinfo with the current level of the filter property we are inspecting by pointing to the new scope key
	                    scope.selectedFilterPropertyChanged({ selectedFilterProperty: scope.selectedFilterProperty.selectedCriteriaType });
	                    //update criteria to display the condition of the new critera we have selected
	                };
	                scope.addNewCollection = function () {
	                    dialogService.addPageDialog('org/Hibachi/client/src/collection/components/criteriacreatecollection', {
	                        entityName: scope.selectedFilterProperty.cfc,
	                        collectionName: scope.data.collectionName,
	                        parentEntity: scope.collectionConfig.baseEntityName
	                    });
	                    scope.cleanSelection();
	                };
	                scope.viewSelectedCollection = function () {
	                    scope.toggleCollectionOptions();
	                    dialogService.addPageDialog('org/Hibachi/client/src/collection/components/criteriacreatecollection', {
	                        entityName: 'collection',
	                        entityId: scope.selectedFilterProperty.selectedCollection.collectionID,
	                        parentEntity: scope.collectionConfig.baseEntityName
	                    });
	                };
	            }
	        };
	    }
	    SWCriteriaOneToMany.Factory = function () {
	        var directive = function ($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, dialogService, observerService, hibachiPathBuilder, rbkeyService) {
	            return new SWCriteriaOneToMany($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, dialogService, observerService, hibachiPathBuilder, rbkeyService);
	        };
	        directive.$inject = [
	            '$log',
	            '$hibachi',
	            '$filter',
	            'collectionPartialsPath',
	            'collectionService',
	            'metadataService',
	            'dialogService',
	            'observerService',
	            'hibachiPathBuilder',
	            'rbkeyService'
	        ];
	        return directive;
	    };
	    return SWCriteriaOneToMany;
	})();
	exports.SWCriteriaOneToMany = SWCriteriaOneToMany;


/***/ },
/* 87 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWCriteriaString = (function () {
	    function SWCriteriaString($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	        return {
	            restrict: 'E',
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + 'criteriastring.html',
	            link: function (scope, element, attrs) {
	                var getStringOptions = function (type) {
	                    if (angular.isUndefined(type)) {
	                        type = 'filter';
	                    }
	                    var stringOptions = [];
	                    if (type === 'filter') {
	                        stringOptions = [
	                            {
	                                display: "Equals",
	                                comparisonOperator: "="
	                            },
	                            {
	                                display: "Doesn't Equal",
	                                comparisonOperator: "<>"
	                            },
	                            {
	                                display: "Contains",
	                                comparisonOperator: "like",
	                                pattern: "%w%"
	                            },
	                            {
	                                display: "Doesn't Contain",
	                                comparisonOperator: "not like",
	                                pattern: "%w%"
	                            },
	                            {
	                                display: "Starts With",
	                                comparisonOperator: "like",
	                                pattern: "w%"
	                            },
	                            {
	                                display: "Doesn't Start With",
	                                comparisonOperator: "not like",
	                                pattern: "w%"
	                            },
	                            {
	                                display: "Ends With",
	                                comparisonOperator: "like",
	                                pattern: "%w"
	                            },
	                            {
	                                display: "Doesn't End With",
	                                comparisonOperator: "not like",
	                                pattern: "%w"
	                            },
	                            {
	                                display: "In List",
	                                comparisonOperator: "in"
	                            },
	                            {
	                                display: "Not In List",
	                                comparisonOperator: "not in"
	                            },
	                            {
	                                display: "Defined",
	                                comparisonOperator: "is not",
	                                value: "null"
	                            },
	                            {
	                                display: "Not Defined",
	                                comparisonOperator: "is",
	                                value: "null"
	                            }
	                        ];
	                    }
	                    else if (type === 'condition') {
	                        stringOptions = [
	                            {
	                                display: "Equals",
	                                comparisonOperator: "eq"
	                            },
	                            {
	                                display: "Doesn't Equal",
	                                comparisonOperator: "neq"
	                            },
	                            {
	                                display: "Defined",
	                                comparisonOperator: "null",
	                                value: "False"
	                            },
	                            {
	                                display: "Not Defined",
	                                comparisonOperator: "null",
	                                value: "True"
	                            }
	                        ];
	                    }
	                    return stringOptions;
	                };
	                //initialize values
	                scope.conditionOptions = getStringOptions(scope.comparisonType);
	                scope.inListArray = [];
	                if (angular.isDefined(scope.filterItem.value)) {
	                    scope.inListArray = scope.filterItem.value.split(',');
	                }
	                scope.newListItem = '';
	                //declare functions
	                scope.addToValueInListFormat = function (inListItem) {
	                    // Adds item into array
	                    scope.inListArray.push(inListItem);
	                    //set value field to the user generated list
	                    scope.filterItem.value = scope.inListArray.toString();
	                    scope.filterItem.displayValue = scope.inListArray.toString().replace(/,/g, ', ');
	                    scope.newListItem = '';
	                };
	                scope.removelistItem = function (argListIndex) {
	                    scope.inListArray.splice(argListIndex, 1);
	                    scope.filterItem.value = scope.inListArray.toString();
	                    scope.filterItem.displayValue = scope.inListArray.toString().replace(/,/g, ', ');
	                };
	                scope.clearField = function () {
	                    scope.newListItem = '';
	                };
	                scope.selectedConditionChanged = function (selectedFilterProperty) {
	                    //scope.selectedFilterProperty.criteriaValue = '';
	                    if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
	                        selectedFilterProperty.showCriteriaValue = false;
	                    }
	                    else {
	                        if (selectedFilterProperty.selectedCriteriaType.comparisonOperator === 'in' || selectedFilterProperty.selectedCriteriaType.comparisonOperator === 'not in') {
	                            selectedFilterProperty.showCriteriaValue = false;
	                            scope.comparisonOperatorInAndNotInFlag = true;
	                        }
	                        else {
	                            selectedFilterProperty.showCriteriaValue = true;
	                        }
	                    }
	                };
	                scope.$watch('filterItem.value', function (criteriaValue) {
	                    //remove percents for like values
	                    if (angular.isDefined(scope.filterItem) && angular.isDefined(scope.filterItem.value)) {
	                        scope.filterItem.value = scope.filterItem.value.replace('%', '');
	                    }
	                });
	                scope.$watch('selectedFilterProperty', function (selectedFilterProperty) {
	                    if (angular.isDefined(selectedFilterProperty)) {
	                        angular.forEach(scope.conditionOptions, function (conditionOption) {
	                            if (conditionOption.display == scope.filterItem.conditionDisplay) {
	                                scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
	                                scope.selectedFilterProperty.criteriaValue = scope.filterItem.value;
	                                if (angular.isDefined(scope.selectedConditionChanged)) {
	                                    scope.selectedConditionChanged(scope.selectedFilterProperty);
	                                }
	                            }
	                        });
	                    }
	                });
	            }
	        };
	    }
	    SWCriteriaString.Factory = function () {
	        var directive = function ($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder) {
	            return new SWCriteriaString($log, $hibachi, $filter, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            '$hibachi',
	            '$filter',
	            'collectionPartialsPath',
	            'collectionService',
	            'metadataService',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWCriteriaString;
	})();
	exports.SWCriteriaString = SWCriteriaString;


/***/ },
/* 88 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWEditFilterItem = (function () {
	    function SWEditFilterItem($http, $compile, $templateCache, $log, $filter, $timeout, $hibachi, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder, rbkeyService) {
	        return {
	            require: '^swFilterGroups',
	            restrict: 'E',
	            scope: {
	                collectionConfig: "=",
	                filterItem: "=",
	                filterPropertiesList: "=",
	                saveCollection: "&",
	                removeFilterItem: "&",
	                filterItemIndex: "=",
	                comparisonType: "="
	            },
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "editfilteritem.html",
	            link: function (scope, element, attrs, filterGroupsController) {
	                function daysBetween(first, second) {
	                    // Copy date parts of the timestamps, discarding the time parts.
	                    var one = new Date(first.getFullYear(), first.getMonth(), first.getDate());
	                    var two = new Date(second.getFullYear(), second.getMonth(), second.getDate());
	                    // Do the math.
	                    var millisecondsPerDay = 1000 * 60 * 60 * 24;
	                    var millisBetween = two.getTime() - one.getTime();
	                    var days = millisBetween / millisecondsPerDay;
	                    // Round down.
	                    return Math.floor(days);
	                }
	                if (angular.isUndefined(scope.filterItem.breadCrumbs)) {
	                    scope.filterItem.breadCrumbs = [];
	                    if (scope.filterItem.propertyIdentifier === "") {
	                        scope.filterItem.breadCrumbs = [
	                            {
	                                rbKey: rbkeyService.getRBKey('entity.' + scope.collectionConfig.baseEntityAlias.replace('_', '')),
	                                entityAlias: scope.collectionConfig.baseEntityAlias,
	                                cfc: scope.collectionConfig.baseEntityAlias,
	                                propertyIdentifier: scope.collectionConfig.baseEntityAlias
	                            }
	                        ];
	                    }
	                    else {
	                        var entityAliasArrayFromString = scope.filterItem.propertyIdentifier.split('.');
	                        entityAliasArrayFromString.pop();
	                        for (var i in entityAliasArrayFromString) {
	                            var breadCrumb = {
	                                rbKey: rbkeyService.getRBKey('entity.' + scope.collectionConfig.baseEntityAlias.replace('_', '')),
	                                entityAlias: entityAliasArrayFromString[i],
	                                cfc: entityAliasArrayFromString[i],
	                                propertyIdentifier: entityAliasArrayFromString[i]
	                            };
	                            scope.filterItem.breadCrumbs.push(breadCrumb);
	                        }
	                    }
	                }
	                else {
	                    angular.forEach(scope.filterItem.breadCrumbs, function (breadCrumb, key) {
	                        if (angular.isUndefined(scope.filterPropertiesList[breadCrumb.propertyIdentifier])) {
	                            var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName(breadCrumb.cfc);
	                            filterPropertiesPromise.then(function (value) {
	                                metadataService.setPropertiesList(value, breadCrumb.propertyIdentifier);
	                                scope.filterPropertiesList[breadCrumb.propertyIdentifier] = metadataService.getPropertiesListByBaseEntityAlias(breadCrumb.propertyIdentifier);
	                                metadataService.formatPropertiesList(scope.filterPropertiesList[breadCrumb.propertyIdentifier], breadCrumb.propertyIdentifier);
	                                var entityAliasArrayFromString = scope.filterItem.propertyIdentifier.split('.');
	                                entityAliasArrayFromString.pop();
	                                entityAliasArrayFromString = entityAliasArrayFromString.join('.').trim();
	                                if (angular.isDefined(scope.filterPropertiesList[entityAliasArrayFromString])) {
	                                    for (var i in scope.filterPropertiesList[entityAliasArrayFromString].data) {
	                                        var filterProperty = scope.filterPropertiesList[entityAliasArrayFromString].data[i];
	                                        if (filterProperty.propertyIdentifier === scope.filterItem.propertyIdentifier) {
	                                            //selectItem from drop down
	                                            scope.selectedFilterProperty = filterProperty;
	                                            //decorate with value and comparison Operator so we can use it in the Condition section
	                                            scope.selectedFilterProperty.value = scope.filterItem.value;
	                                            scope.selectedFilterProperty.comparisonOperator = scope.filterItem.comparisonOperator;
	                                        }
	                                    }
	                                }
	                            });
	                        }
	                        else {
	                            var entityAliasArrayFromString = scope.filterItem.propertyIdentifier.split('.');
	                            entityAliasArrayFromString.pop();
	                            entityAliasArrayFromString = entityAliasArrayFromString.join('.').trim();
	                            if (angular.isDefined(scope.filterPropertiesList[entityAliasArrayFromString])) {
	                                for (var i in scope.filterPropertiesList[entityAliasArrayFromString].data) {
	                                    var filterProperty = scope.filterPropertiesList[entityAliasArrayFromString].data[i];
	                                    if (filterProperty.propertyIdentifier === scope.filterItem.propertyIdentifier) {
	                                        //selectItem from drop down
	                                        scope.selectedFilterProperty = filterProperty;
	                                        //decorate with value and comparison Operator so we can use it in the Condition section
	                                        scope.selectedFilterProperty.value = scope.filterItem.value;
	                                        scope.selectedFilterProperty.comparisonOperator = scope.filterItem.comparisonOperator;
	                                    }
	                                }
	                            }
	                        }
	                    });
	                }
	                if (angular.isUndefined(scope.filterItem.$$isClosed)) {
	                    scope.filterItem.$$isClosed = true;
	                }
	                scope.filterGroupItem = filterGroupsController.getFilterGroupItem();
	                scope.togglePrepareForFilterGroup = function () {
	                    scope.filterItem.$$prepareForFilterGroup = !scope.filterItem.$$prepareForFilterGroup;
	                };
	                //public functions
	                scope.selectBreadCrumb = function (breadCrumbIndex) {
	                    //splice out array items above index
	                    var removeCount = scope.filterItem.breadCrumbs.length - 1 - breadCrumbIndex;
	                    scope.filterItem.breadCrumbs.splice(breadCrumbIndex + 1, removeCount);
	                    $log.debug('selectBreadCrumb');
	                    $log.debug(scope.selectedFilterProperty);
	                    //scope.selectedFilterPropertyChanged(scope.filterItem.breadCrumbs[scope.filterItem.breadCrumbs.length -1].filterProperty);
	                    scope.selectedFilterPropertyChanged(null);
	                };
	                scope.selectedFilterPropertyChanged = function (selectedFilterProperty) {
	                    $log.debug('selectedFilterProperty');
	                    $log.debug(selectedFilterProperty);
	                    if (angular.isDefined(scope.selectedFilterProperty) && scope.selectedFilterProperty === null) {
	                        scope.selectedFilterProperty = {};
	                    }
	                    if (angular.isDefined(scope.selectedFilterProperty) && angular.isDefined(scope.selectedFilterProperty.selectedCriteriaType)) {
	                        delete scope.selectedFilterProperty.selectedCriteriaType;
	                    }
	                    if (angular.isDefined(scope.filterItem.value)) {
	                        delete scope.filterItem.value;
	                    }
	                    scope.selectedFilterProperty.showCriteriaValue = false;
	                    scope.selectedFilterProperty = selectedFilterProperty;
	                };
	                scope.addFilterItem = function () {
	                    collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(), filterGroupsController.setItemInUse);
	                };
	                scope.cancelFilterItem = function () {
	                    $log.debug('cancelFilterItem');
	                    $log.debug(scope.filterItemIndex);
	                    //scope.deselectItems(scope.filterGroupItem[filterItemIndex]);
	                    scope.filterItem.setItemInUse(false);
	                    scope.filterItem.$$isClosed = true;
	                    for (var siblingIndex in scope.filterItem.$$siblingItems) {
	                        scope.filterItem.$$siblingItems[siblingIndex].$$disabled = false;
	                    }
	                    if (scope.filterItem.$$isNew === true) {
	                        scope.removeFilterItem({ filterItemIndex: scope.filterItemIndex });
	                    }
	                };
	                scope.saveFilter = function (selectedFilterProperty, filterItem, callback) {
	                    $log.debug('saveFilter begin');
	                    if (angular.isDefined(selectedFilterProperty.selectedCriteriaType) && angular.equals({}, selectedFilterProperty.selectedCriteriaType)) {
	                        return;
	                    }
	                    if (angular.isDefined(selectedFilterProperty) && angular.isDefined(selectedFilterProperty.selectedCriteriaType)) {
	                        //populate filterItem with selectedFilterProperty values
	                        filterItem.$$isNew = false;
	                        filterItem.propertyIdentifier = selectedFilterProperty.propertyIdentifier;
	                        filterItem.displayPropertyIdentifier = selectedFilterProperty.displayPropertyIdentifier;
	                        switch (selectedFilterProperty.ormtype) {
	                            case 'boolean':
	                                filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
	                                filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
	                                filterItem.displayValue = filterItem.value;
	                                break;
	                            case 'string':
	                                if (angular.isDefined(selectedFilterProperty.attributeID)) {
	                                    filterItem.attributeID = selectedFilterProperty.attributeID;
	                                    filterItem.attributeSetObject = selectedFilterProperty.attributeSetObject;
	                                }
	                                filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
	                                //retrieving implied value or user input | ex. implied:prop is null, user input:prop = "Name"
	                                if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
	                                    filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
	                                }
	                                else if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.pattern)) {
	                                    filterItem.pattern = selectedFilterProperty.selectedCriteriaType.pattern;
	                                }
	                                filterItem.displayValue = filterItem.value;
	                                break;
	                            //TODO:simplify timestamp and big decimal to leverage reusable function for null, range, and value
	                            case 'timestamp':
	                                //retrieving implied value or user input | ex. implied:prop is null, user input:prop = "Name"
	                                filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
	                                //is it null or a range
	                                if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
	                                    filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
	                                    filterItem.displayValue = filterItem.value;
	                                }
	                                else {
	                                    if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.dateInfo.type) && selectedFilterProperty.selectedCriteriaType.dateInfo.type === 'calculation') {
	                                        var _daysBetween = daysBetween(new Date(selectedFilterProperty.criteriaRangeStart), new Date(selectedFilterProperty.criteriaRangeEnd));
	                                        filterItem.value = _daysBetween;
	                                        filterItem.displayValue = selectedFilterProperty.selectedCriteriaType.display;
	                                        if (angular.isDefined(selectedFilterProperty.criteriaNumberOf)) {
	                                            filterItem.criteriaNumberOf = selectedFilterProperty.criteriaNumberOf;
	                                        }
	                                    }
	                                    else {
	                                        var dateValueString = selectedFilterProperty.criteriaRangeStart + '-' + selectedFilterProperty.criteriaRangeEnd;
	                                        filterItem.value = dateValueString;
	                                        var formattedDateValueString = $filter('date')(angular.copy(selectedFilterProperty.criteriaRangeStart), 'MM/dd/yyyy @ h:mma') + '-' + $filter('date')(angular.copy(selectedFilterProperty.criteriaRangeEnd), 'MM/dd/yyyy @ h:mma');
	                                        filterItem.displayValue = formattedDateValueString;
	                                        if (angular.isDefined(selectedFilterProperty.criteriaNumberOf)) {
	                                            filterItem.criteriaNumberOf = selectedFilterProperty.criteriaNumberOf;
	                                        }
	                                    }
	                                }
	                                break;
	                            case 'big_decimal':
	                            case 'integer':
	                            case 'float':
	                                filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
	                                //is null, is not null
	                                if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
	                                    filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
	                                }
	                                else {
	                                    if (angular.isUndefined(selectedFilterProperty.selectedCriteriaType.type)) {
	                                        filterItem.value = selectedFilterProperty.criteriaValue;
	                                    }
	                                    else {
	                                        var decimalValueString = selectedFilterProperty.criteriaRangeStart + '-' + selectedFilterProperty.criteriaRangeEnd;
	                                        filterItem.value = decimalValueString;
	                                    }
	                                }
	                                filterItem.displayValue = filterItem.value;
	                                break;
	                        }
	                        switch (selectedFilterProperty.fieldtype) {
	                            case 'many-to-one':
	                                filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
	                                //is null, is not null
	                                if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
	                                    filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
	                                }
	                                filterItem.displayValue = filterItem.value;
	                                break;
	                            case 'one-to-many':
	                            case 'many-to-many':
	                                filterItem.collectionID = selectedFilterProperty.selectedCollection.collectionID;
	                                filterItem.displayValue = selectedFilterProperty.selectedCollection.collectionName;
	                                filterItem.criteria = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
	                                break;
	                        }
	                        if (angular.isUndefined(filterItem.displayValue)) {
	                            filterItem.displayValue = filterItem.value;
	                        }
	                        if (angular.isDefined(selectedFilterProperty.ormtype)) {
	                            filterItem.ormtype = selectedFilterProperty.ormtype;
	                        }
	                        if (angular.isDefined(selectedFilterProperty.fieldtype)) {
	                            filterItem.fieldtype = selectedFilterProperty.fieldtype;
	                        }
	                        for (var siblingIndex in filterItem.$$siblingItems) {
	                            filterItem.$$siblingItems[siblingIndex].$$disabled = false;
	                        }
	                        filterItem.conditionDisplay = selectedFilterProperty.selectedCriteriaType.display;
	                        //if the add to New group checkbox has been checked then we need to transplant the filter item into a filter group
	                        if (filterItem.$$prepareForFilterGroup === true) {
	                            collectionService.transplantFilterItemIntoFilterGroup(filterGroupsController.getFilterGroupItem(), filterItem);
	                        }
	                        //persist Config and 
	                        scope.saveCollection();
	                        $log.debug(selectedFilterProperty);
	                        $log.debug(filterItem);
	                        $timeout(function () {
	                            callback();
	                        });
	                        $log.debug('saveFilter end');
	                    }
	                };
	            }
	        };
	    }
	    SWEditFilterItem.Factory = function () {
	        var directive = function ($http, $compile, $templateCache, $log, $filter, $timeout, $hibachi, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder, rbkeyService) {
	            return new SWEditFilterItem($http, $compile, $templateCache, $log, $filter, $timeout, $hibachi, collectionPartialsPath, collectionService, metadataService, hibachiPathBuilder, rbkeyService);
	        };
	        directive.$inject = [
	            '$http',
	            '$compile',
	            '$templateCache',
	            '$log',
	            '$filter',
	            '$timeout',
	            '$hibachi',
	            'collectionPartialsPath',
	            'collectionService',
	            'metadataService',
	            'hibachiPathBuilder',
	            'rbkeyService'
	        ];
	        return directive;
	    };
	    return SWEditFilterItem;
	})();
	exports.SWEditFilterItem = SWEditFilterItem;


/***/ },
/* 89 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWFilterGroups = (function () {
	    function SWFilterGroups($http, $compile, $templateCache, $log, collectionPartialsPath, hibachiPathBuilder) {
	        return {
	            restrict: 'EA',
	            scope: {
	                collectionConfig: "=?",
	                filterGroupItem: "=?",
	                filterPropertiesList: "=?",
	                saveCollection: "&",
	                filterGroup: "=?",
	                comparisonType: "=?"
	            },
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "filtergroups.html",
	            controller: ['$scope', '$element', '$attrs', function ($scope, $element, $attrs) {
	                    //if the filter group comparisontype is not specified, then assume we are doing filters
	                    if (!angular.isDefined($scope.comparisonType)) {
	                        $scope.comparisonType = 'filter';
	                    }
	                    $scope.itemInUse = false;
	                    $log.debug('collectionConfig');
	                    $log.debug($scope.collectionConfig);
	                    this.getFilterGroup = function () {
	                        return $scope.filterGroup;
	                    };
	                    this.getFilterGroupItem = function () {
	                        return $scope.filterGroupItem;
	                    };
	                    this.setItemInUse = function (booleanValue) {
	                        $scope.itemInUse = booleanValue;
	                    };
	                    this.getItemInUse = function () {
	                        return $scope.itemInUse;
	                    };
	                    this.saveCollection = function () {
	                        $scope.saveCollection();
	                    };
	                    $scope.deselectItems = function (filterItem) {
	                        for (var i in filterItem.$$siblingItems) {
	                            filterItem.$$siblingItems[i].$$disabled = false;
	                        }
	                    };
	                    this.removeFilterItem = function (filterItemIndex) {
	                        if (angular.isDefined(filterItemIndex)) {
	                            $scope.deselectItems($scope.filterGroupItem[filterItemIndex]);
	                            $scope.filterGroupItem[filterItemIndex].setItemInUse(false);
	                            //remove item
	                            $log.debug('removeFilterItem');
	                            $log.debug(filterItemIndex);
	                            $scope.filterGroupItem.splice(filterItemIndex, 1);
	                            //make sure first item has no logical operator if it exists
	                            if ($scope.filterGroupItem.length) {
	                                delete $scope.filterGroupItem[0].logicalOperator;
	                            }
	                            $log.debug('removeFilterItem');
	                            $log.debug(filterItemIndex);
	                            $scope.saveCollection();
	                        }
	                    };
	                    this.removeFilterGroupItem = function (filterGroupItemIndex) {
	                        //remove Item
	                        $scope.deselectItems($scope.filterGroupItem[filterGroupItemIndex]);
	                        $scope.filterGroupItem[filterGroupItemIndex].setItemInUse(false);
	                        $scope.filterGroupItem.splice(filterGroupItemIndex, 1);
	                        //make sure first item has no logical operator if it exists
	                        if ($scope.filterGroupItem.length) {
	                            delete $scope.filterGroupItem[0].logicalOperator;
	                        }
	                        $log.debug('removeFilterGroupItem');
	                        $log.debug(filterGroupItemIndex);
	                        $scope.saveCollection();
	                    };
	                }]
	        };
	    }
	    SWFilterGroups.Factory = function () {
	        var directive = function ($http, $compile, $templateCache, $log, collectionPartialsPath, hibachiPathBuilder) {
	            return new SWFilterGroups($http, $compile, $templateCache, $log, collectionPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$http',
	            '$compile',
	            '$templateCache',
	            '$log',
	            'collectionPartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWFilterGroups;
	})();
	exports.SWFilterGroups = SWFilterGroups;


/***/ },
/* 90 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWFilterItem = (function () {
	    function SWFilterItem($log, collectionService, collectionPartialsPath, hibachiPathBuilder) {
	        return {
	            restrict: 'A',
	            require: '^swFilterGroups',
	            scope: {
	                collectionConfig: "=",
	                filterItem: "=",
	                siblingItems: "=",
	                filterPropertiesList: "=",
	                filterItemIndex: "=",
	                saveCollection: "&",
	                comparisonType: "="
	            },
	            templateUrl: hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "filteritem.html",
	            link: function (scope, element, attrs, filterGroupsController) {
	                scope.baseEntityAlias = scope.collectionConfig.baseEntityAlias;
	                if (angular.isUndefined(scope.filterItem.$$isClosed)) {
	                    scope.filterItem.$$isClosed = true;
	                }
	                if (angular.isUndefined(scope.filterItem.$$disabled)) {
	                    scope.filterItem.$$disabled = false;
	                }
	                if (angular.isUndefined(scope.filterItem.siblingItems)) {
	                    scope.filterItem.$$siblingItems = scope.siblingItems;
	                }
	                scope.filterItem.setItemInUse = filterGroupsController.setItemInUse;
	                scope.selectFilterItem = function (filterItem) {
	                    collectionService.selectFilterItem(filterItem);
	                };
	                scope.removeFilterItem = function () {
	                    filterGroupsController.removeFilterItem(scope.filterItemIndex, filterGroupsController.getFilterGroupItem());
	                };
	                scope.filterGroupItem = filterGroupsController.getFilterGroupItem();
	                scope.logicalOperatorChanged = function (logicalOperatorValue) {
	                    $log.debug('logicalOperatorChanged');
	                    $log.debug(logicalOperatorValue);
	                    scope.filterItem.logicalOperator = logicalOperatorValue;
	                    filterGroupsController.saveCollection();
	                };
	            }
	        };
	    }
	    SWFilterItem.Factory = function () {
	        var directive = function ($log, collectionService, collectionPartialsPath, hibachiPathBuilder) {
	            return new SWFilterItem($log, collectionService, collectionPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            'collectionService',
	            'collectionPartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWFilterItem;
	})();
	exports.SWFilterItem = SWFilterItem;


/***/ },
/* 91 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWFilterGroupItem = (function () {
	    function SWFilterGroupItem($http, $compile, $templateCache, $log, collectionService, collectionPartialsPath, hibachiPathBuilder) {
	        return {
	            restrict: 'A',
	            require: "^swFilterGroups",
	            scope: {
	                collectionConfig: "=",
	                filterGroupItem: "=",
	                siblingItems: "=",
	                filterPropertiesList: "=",
	                filterGroupItemIndex: "=",
	                saveCollection: "&",
	                comparisonType: "="
	            },
	            link: function (scope, element, attrs, filterGroupsController) {
	                var Partial = hibachiPathBuilder.buildPartialsPath(collectionPartialsPath) + "filtergroupitem.html";
	                var templateLoader = $http.get(Partial, { cache: $templateCache });
	                var promise = templateLoader.success(function (html) {
	                    element.html(html);
	                }).then(function (response) {
	                    element.replaceWith($compile(element.html())(scope));
	                });
	                //for(item in filterGroupItem){}
	                scope.filterGroupItem.setItemInUse = filterGroupsController.setItemInUse;
	                scope.filterGroupItem.$$index = scope.filterGroupItemIndex;
	                scope.removeFilterGroupItem = function () {
	                    filterGroupsController.removeFilterGroupItem(scope.filterGroupItemIndex);
	                };
	                scope.filterGroupItem.removeFilterGroupItem = scope.removeFilterGroupItem;
	                scope.filterGroupItem.$$disabled = false;
	                if (angular.isUndefined(scope.filterGroupItem.$$isClosed)) {
	                    scope.filterGroupItem.$$isClosed = true;
	                }
	                scope.filterGroupItem.$$siblingItems = scope.siblingItems;
	                scope.selectFilterGroupItem = function (filterGroupItem) {
	                    collectionService.selectFilterGroupItem(filterGroupItem);
	                };
	                scope.logicalOperatorChanged = function (logicalOperatorValue) {
	                    $log.debug('logicalOperatorChanged');
	                    $log.debug(logicalOperatorValue);
	                    scope.filterGroupItem.logicalOperator = logicalOperatorValue;
	                    filterGroupsController.saveCollection();
	                };
	            }
	        };
	    }
	    SWFilterGroupItem.Factory = function () {
	        var directive = function ($http, $compile, $templateCache, $log, collectionService, collectionPartialsPath, hibachiPathBuilder) {
	            return new SWFilterGroupItem($http, $compile, $templateCache, $log, collectionService, collectionPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$http',
	            '$compile',
	            '$templateCache',
	            '$log',
	            'collectionService',
	            'collectionPartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWFilterGroupItem;
	})();
	exports.SWFilterGroupItem = SWFilterGroupItem;


/***/ },
/* 92 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path='../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../typings/tsd.d.ts' />
	//services
	var dialogservice_1 = __webpack_require__(93);
	//controllers
	var pagedialog_1 = __webpack_require__(94);
	var dialogmodule = angular.module('hibachi.dialog', []).config(function () {
	})
	    .service('dialogService', dialogservice_1.DialogService)
	    .controller('pageDialog', pagedialog_1.PageDialogController)
	    .constant('dialogPartials', 'dialog/components/');
	exports.dialogmodule = dialogmodule;


/***/ },
/* 93 */
/***/ function(module, exports) {

	var DialogService = (function () {
	    function DialogService(hibachiPathBuilder) {
	        var _this = this;
	        this.hibachiPathBuilder = hibachiPathBuilder;
	        this.get = function () {
	            return _this._pageDialogs || [];
	        };
	        this.addPageDialog = function (name, params) {
	            var newDialog = {
	                'path': name + '.html',
	                'params': params
	            };
	            _this._pageDialogs.push(newDialog);
	        };
	        this.removePageDialog = function (index) {
	            _this._pageDialogs.splice(index, 1);
	        };
	        this.getPageDialogs = function () {
	            return _this._pageDialogs;
	        };
	        this.removeCurrentDialog = function () {
	            _this._pageDialogs.splice(_this._pageDialogs.length - 1, 1);
	        };
	        this.getCurrentDialog = function () {
	            return _this._pageDialogs[_this._pageDialogs.length - 1];
	        };
	        this._pageDialogs = [];
	        this.hibachiPathBuilder = hibachiPathBuilder;
	    }
	    DialogService.$inject = [
	        'hibachiPathBuilder'
	    ];
	    return DialogService;
	})();
	exports.DialogService = DialogService;


/***/ },
/* 94 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var PageDialogController = (function () {
	    //@ngInject
	    function PageDialogController($scope, $location, $log, $anchorScroll, $hibachi, dialogService) {
	        $scope.$id = 'pageDialogController';
	        //get url param to retrieve collection listing
	        $scope.pageDialogs = dialogService.getPageDialogs();
	        $scope.scrollToTopOfDialog = function () {
	            $location.hash('/#topOfPageDialog');
	            $anchorScroll();
	        };
	        $scope.pageDialogStyle = { "z-index": 3000 };
	    }
	    return PageDialogController;
	})();
	exports.PageDialogController = PageDialogController;


/***/ },
/* 95 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path="../../typings/tsd.d.ts" />
	/// <reference path="../../typings/hibachiTypescript.d.ts" />
	//services
	var paginationservice_1 = __webpack_require__(96);
	var swpaginationbar_1 = __webpack_require__(97);
	var core_module_1 = __webpack_require__(11);
	var paginationmodule = angular.module('hibachi.pagination', [core_module_1.coremodule.name])
	    .run([function () {
	    }])
	    .service('paginationService', paginationservice_1.PaginationService)
	    .directive('swPaginationBar', swpaginationbar_1.SWPaginationBar.Factory())
	    .constant('partialsPath', 'pagination/components/');
	exports.paginationmodule = paginationmodule;


/***/ },
/* 96 */
/***/ function(module, exports) {

	/// <reference path="../../../typings/tsd.d.ts" />
	/// <reference path="../../../typings/hibachiTypescript.d.ts" />
	/*collection service is used to maintain the state of the ui*/
	var Pagination = (function () {
	    //@ngInject
	    function Pagination(uuid) {
	        var _this = this;
	        this.uuid = uuid;
	        this.pageShow = 10;
	        this.currentPage = 1;
	        this.pageStart = 0;
	        this.pageEnd = 0;
	        this.recordsCount = 0;
	        this.totalPages = 0;
	        this.pageShowOptions = [
	            { display: 10, value: 10 },
	            { display: 20, value: 20 },
	            { display: 50, value: 50 },
	            { display: 250, value: 250 },
	            { display: "Auto", value: "Auto" }
	        ];
	        this.autoScrollPage = 1;
	        this.autoScrollDisabled = false;
	        this.getSelectedPageShowOption = function () {
	            return _this.selectedPageShowOption;
	        };
	        this.pageShowOptionChanged = function (pageShowOption) {
	            _this.setPageShow(pageShowOption.value);
	            _this.setCurrentPage(1);
	            _this.getCollection();
	        };
	        this.getTotalPages = function () {
	            return _this.totalPages;
	        };
	        this.setTotalPages = function (totalPages) {
	            _this.totalPages = totalPages;
	        };
	        this.getPageStart = function () {
	            return _this.pageStart;
	        };
	        this.setPageStart = function (pageStart) {
	            _this.pageStart = pageStart;
	        };
	        this.getPageEnd = function () {
	            return _this.pageEnd;
	        };
	        this.setPageEnd = function (pageEnd) {
	            _this.pageEnd = pageEnd;
	        };
	        this.getRecordsCount = function () {
	            return _this.recordsCount;
	        };
	        this.setRecordsCount = function (recordsCount) {
	            _this.recordsCount = recordsCount;
	        };
	        this.getPageShowOptions = function () {
	            return _this.pageShowOptions;
	        };
	        this.setPageShowOptions = function (pageShowOptions) {
	            _this.pageShowOptions = pageShowOptions;
	        };
	        this.getPageShow = function () {
	            return _this.pageShow;
	        };
	        this.setPageShow = function (pageShow) {
	            _this.pageShow = pageShow;
	        };
	        this.getCurrentPage = function () {
	            return _this.currentPage;
	        };
	        this.setCurrentPage = function (currentPage) {
	            _this.currentPage = currentPage;
	            _this.getCollection();
	        };
	        this.previousPage = function () {
	            if (_this.getCurrentPage() == 1)
	                return;
	            _this.setCurrentPage(_this.getCurrentPage() - 1);
	        };
	        this.nextPage = function () {
	            if (_this.getCurrentPage() < _this.getTotalPages()) {
	                _this.currentPage = _this.getCurrentPage() + 1;
	                _this.getCollection();
	            }
	        };
	        this.hasPrevious = function () {
	            return (_this.getPageStart() <= 1);
	        };
	        this.hasNext = function () {
	            return (_this.getPageEnd() === _this.getRecordsCount());
	        };
	        this.showPreviousJump = function () {
	            return (angular.isDefined(_this.getCurrentPage()) && _this.getCurrentPage() > 3);
	        };
	        this.showNextJump = function () {
	            return !!(_this.getCurrentPage() < _this.getTotalPages() - 3 && _this.getTotalPages() > 6);
	        };
	        this.previousJump = function () {
	            _this.setCurrentPage(_this.currentPage - 3);
	        };
	        this.nextJump = function () {
	            _this.setCurrentPage(_this.getCurrentPage() + 3);
	        };
	        this.showPageNumber = function (pageNumber) {
	            if (_this.getCurrentPage() >= _this.getTotalPages() - 3) {
	                if (pageNumber > _this.getTotalPages() - 6) {
	                    return true;
	                }
	            }
	            if (_this.getCurrentPage() <= 3) {
	                if (pageNumber < 6) {
	                    return true;
	                }
	            }
	            else {
	                var bottomRange = _this.getCurrentPage() - 2;
	                var topRange = _this.getCurrentPage() + 2;
	                if (pageNumber > bottomRange && pageNumber < topRange) {
	                    return true;
	                }
	            }
	            return false;
	        };
	        this.setPageRecordsInfo = function (collection) {
	            _this.setRecordsCount(collection.recordsCount);
	            if (_this.getRecordsCount() === 0) {
	                _this.setPageStart(0);
	            }
	            else {
	                _this.setPageStart(collection.pageRecordsStart);
	            }
	            _this.setPageEnd(collection.pageRecordsEnd);
	            _this.setTotalPages(collection.totalPages);
	            _this.totalPagesArray = [];
	            if (angular.isUndefined(_this.getCurrentPage()) || _this.getCurrentPage() < 5) {
	                var start = 1;
	                var end = (_this.getTotalPages() <= 10) ? _this.getTotalPages() + 1 : 10;
	            }
	            else {
	                var start = (!_this.showNextJump()) ? _this.getTotalPages() - 4 : _this.getCurrentPage() - 3;
	                var end = (_this.showNextJump()) ? _this.getCurrentPage() + 5 : _this.getTotalPages() + 1;
	            }
	            for (var i = start; i < end; i++) {
	                _this.totalPagesArray.push(i);
	            }
	        };
	        this.uuid = uuid;
	        this.selectedPageShowOption = this.pageShowOptions[0];
	    }
	    return Pagination;
	})();
	exports.Pagination = Pagination;
	var PaginationService = (function () {
	    //@ngInject
	    function PaginationService(utilityService) {
	        var _this = this;
	        this.utilityService = utilityService;
	        this.paginations = {};
	        this.createPagination = function () {
	            var uuid = _this.utilityService.createID(10);
	            _this.paginations[uuid] = new Pagination(uuid);
	            return _this.paginations[uuid];
	        };
	        this.getPagination = function (uuid) {
	            if (!uuid)
	                return;
	            return _this.paginations[uuid];
	        };
	    }
	    return PaginationService;
	})();
	exports.PaginationService = PaginationService;


/***/ },
/* 97 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	//import pagination = require('../services/paginationservice');
	//var PaginationService = pagination.PaginationService;
	//'use strict';
	var SWPaginationBarController = (function () {
	    //@ngInject
	    function SWPaginationBarController(paginationService) {
	        if (angular.isUndefined(this.paginator)) {
	            this.paginator = paginationService.createPagination();
	        }
	    }
	    return SWPaginationBarController;
	})();
	exports.SWPaginationBarController = SWPaginationBarController;
	var SWPaginationBar = (function () {
	    //@ngInject
	    function SWPaginationBar(hibachiPathBuilder, partialsPath) {
	        this.restrict = 'E';
	        this.scope = {};
	        this.bindToController = {
	            paginator: "="
	        };
	        this.controller = SWPaginationBarController;
	        this.controllerAs = "swPaginationBar";
	        this.link = function (scope, element, attrs) {
	        };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(partialsPath) + 'paginationbar.html';
	    }
	    SWPaginationBar.Factory = function () {
	        var directive = function (hibachiPathBuilder, partialsPath) { return new SWPaginationBar(hibachiPathBuilder, partialsPath); };
	        directive.$inject = ['hibachiPathBuilder', 'partialsPath'];
	        return directive;
	    };
	    return SWPaginationBar;
	})();
	exports.SWPaginationBar = SWPaginationBar;
	//class SWPaginationBarFactory{
	//    public static getFactoryFor<T extends SWPaginationBar>(classType:Function):ng.IDirectiveFactory {
	//        var factory = (...args:any[]):T=>{
	//            var directive = <any>classType;
	//            return new directive(args);
	//        }
	//
	//        factory.$inject = classType.$inject;
	//        return factory;
	//        // var directive: ng.IDirectiveFactory =
	//        //                ($log:ng.ILogService, $timeout:ng.ITimeoutService, partialsPath, paginationService) => new SWPaginationBar( $log,  $timeout, partialsPath,  paginationService);
	//        // directive.$inject = ['$log','$timeout','partialsPath','paginationService'];
	//        // return directive;
	//    }
	//}
	//angular.module('hibachi.pagination').directive('swPaginationBar',['$log','$timeout','partialsPath','paginationService',($log,$timeout,partialsPath,paginationService) => new SWPaginationBar($log,$timeout,partialsPath,paginationService)]);


/***/ },
/* 98 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path='../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../typings/tsd.d.ts' />
	//services
	// import {AccountService} from "./services/accountservice";
	// import {CartService} from "./services/cartservice";
	// import {UtilityService} from "./services/utilityservice";
	// import {SelectionService} from "./services/selectionservice";
	// import {ObserverService} from "./services/observerservice";
	// import {FormService} from "./services/formservice";
	// import {MetaDataService} from "./services/metadataservice";
	//directives
	//  components
	//form
	var swinput_1 = __webpack_require__(99);
	var swfformfield_1 = __webpack_require__(100);
	var swform_1 = __webpack_require__(101);
	var swformfield_1 = __webpack_require__(102);
	var swformfieldjson_1 = __webpack_require__(103);
	var swformfieldnumber_1 = __webpack_require__(104);
	var swformfieldpassword_1 = __webpack_require__(105);
	var swformfieldradio_1 = __webpack_require__(106);
	var swformfieldsearchselect_1 = __webpack_require__(107);
	var swformfieldselect_1 = __webpack_require__(108);
	var swformfieldtext_1 = __webpack_require__(109);
	var swformregistrar_1 = __webpack_require__(110);
	var swfpropertydisplay_1 = __webpack_require__(111);
	var swpropertydisplay_1 = __webpack_require__(112);
	var formmodule = angular.module('hibachi.form', []).config(function () {
	})
	    .constant('coreFormPartialsPath', 'form/components/')
	    .directive('swInput', swinput_1.SWInput.Factory())
	    .directive('swfFormField', swfformfield_1.SWFFormField.Factory())
	    .directive('swForm', swform_1.SWForm.Factory())
	    .directive('swFormField', swformfield_1.SWFormField.Factory())
	    .directive('swFormFieldJson', swformfieldjson_1.SWFormFieldJson.Factory())
	    .directive('swFormFieldNumber', swformfieldnumber_1.SWFormFieldNumber.Factory())
	    .directive('swFormFieldPassword', swformfieldpassword_1.SWFormFieldPassword.Factory())
	    .directive('swFormFieldRadio', swformfieldradio_1.SWFormFieldRadio.Factory())
	    .directive('swFormFieldSearchSelect', swformfieldsearchselect_1.SWFormFieldSearchSelect.Factory())
	    .directive('swFormFieldSelect', swformfieldselect_1.SWFormFieldSelect.Factory())
	    .directive('swFormFieldText', swformfieldtext_1.SWFormFieldText.Factory())
	    .directive('swFormRegistrar', swformregistrar_1.SWFormRegistrar.Factory())
	    .directive('swfPropertyDisplay', swfpropertydisplay_1.SWFPropertyDisplay.Factory())
	    .directive('swPropertyDisplay', swpropertydisplay_1.SWPropertyDisplay.Factory());
	exports.formmodule = formmodule;


/***/ },
/* 99 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * This validate directive will look at the current element, figure out the context (save, edit, delete) and
	 * validate based on that context as defined in the validation properties object.
	 */
	var SWInput = (function () {
	    function SWInput($log, $compile, utilityService) {
	        var getValidationDirectives = function (propertyDisplay) {
	            var spaceDelimitedList = '';
	            var name = propertyDisplay.property;
	            var form = propertyDisplay.form.$$swFormInfo;
	            $log.debug("Name is:" + name + " and form is: " + form);
	            var validations = propertyDisplay.object.validations.properties[propertyDisplay.property];
	            $log.debug("Validations: ", validations);
	            $log.debug(propertyDisplay.form.$$swFormInfo);
	            var validationsForContext = [];
	            //get the form context and the form name.
	            var formContext = propertyDisplay.form.$$swFormInfo.context;
	            var formName = propertyDisplay.form.$$swFormInfo.name;
	            $log.debug("Form context is: ");
	            $log.debug(formContext);
	            $log.debug("Form Name: ");
	            $log.debug(formName);
	            //get the validations for the current element.
	            var propertyValidations = propertyDisplay.object.validations.properties[name];
	            /*
	            * Investigating why number inputs are not working.
	            * */
	            //check if the contexts match.
	            if (angular.isObject(propertyValidations)) {
	                //if this is a procesobject validation then the context is implied
	                if (angular.isUndefined(propertyValidations[0].contexts) && propertyDisplay.object.metaData.isProcessObject) {
	                    propertyValidations[0].contexts = propertyDisplay.object.metaData.className.split('_')[1];
	                }
	                if (propertyValidations[0].contexts === formContext) {
	                    $log.debug("Matched");
	                    for (var prop in propertyValidations[0]) {
	                        if (prop != "contexts" && prop !== "conditions") {
	                            spaceDelimitedList += (" swvalidation" + prop.toLowerCase() + "='" + propertyValidations[0][prop] + "'");
	                        }
	                    }
	                }
	                $log.debug(spaceDelimitedList);
	            }
	            //loop over validations that are required and create the space delimited list
	            $log.debug(validations);
	            //get all validations related to the form context;
	            $log.debug(form);
	            $log.debug(propertyDisplay);
	            angular.forEach(validations, function (validation, key) {
	                if (utilityService.listFind(validation.contexts.toLowerCase(), form.context.toLowerCase()) !== -1) {
	                    $log.debug("Validations for context");
	                    $log.debug(validation);
	                    validationsForContext.push(validation);
	                }
	            });
	            //now that we have all related validations for the specific form context that we are working with collection the directives we need
	            //getValidationDirectiveByType();
	            return spaceDelimitedList;
	        };
	        var getTemplate = function (propertyDisplay) {
	            var template = '';
	            var validations = '';
	            var currency = '';
	            if (!propertyDisplay.noValidate) {
	                validations = getValidationDirectives(propertyDisplay);
	            }
	            if (propertyDisplay.object.metaData.$$getPropertyFormatType(propertyDisplay.property) == "currency") {
	                currency = 'sw-currency-formatter ';
	                if (angular.isDefined(propertyDisplay.object.data.currencyCode)) {
	                    currency = currency + 'data-currency-code="' + propertyDisplay.object.data.currencyCode + '" ';
	                }
	            }
	            if (propertyDisplay.fieldType === 'text') {
	                template = '<input type="text" class="form-control" ' +
	                    'ng-model="propertyDisplay.object.data[propertyDisplay.property]" ' +
	                    'ng-disabled="!propertyDisplay.editable" ' +
	                    'ng-show="propertyDisplay.editing" ' +
	                    'name="' + propertyDisplay.property + '" ' +
	                    validations + currency +
	                    'id="swinput' + utilityService.createID(26) + '"' +
	                    ' />';
	            }
	            else if (propertyDisplay.fieldType === 'password') {
	                template = '<input type="password" class="form-control" ' +
	                    'ng-model="propertyDisplay.object.data[propertyDisplay.property]" ' +
	                    'ng-disabled="!propertyDisplay.editable" ' +
	                    'ng-show="propertyDisplay.editing" ' +
	                    'name="' + propertyDisplay.property + '" ' +
	                    validations +
	                    'id="swinput' + utilityService.createID(26) + '"' +
	                    ' />';
	            }
	            else if (propertyDisplay.fieldType === 'number') {
	                template = '<input type="number" class="form-control" ' +
	                    'ng-model="propertyDisplay.object.data[propertyDisplay.property]" ' +
	                    'ng-disabled="!propertyDisplay.editable" ' +
	                    'ng-show="propertyDisplay.editing" ' +
	                    'name="' + propertyDisplay.property + '" ' +
	                    validations +
	                    'id="swinput' + utilityService.createID(26) + '"' +
	                    ' />';
	            }
	            return template;
	        };
	        return {
	            require: '^form',
	            scope: {
	                propertyDisplay: "=",
	                type: "@?"
	            },
	            restrict: "E",
	            //adding model and form controller
	            link: function (scope, element, attr, formController) {
	                //renders the template and compiles it
	                element.html(getTemplate(scope.propertyDisplay));
	                $compile(element.contents())(scope);
	            }
	        };
	    }
	    SWInput.Factory = function () {
	        var directive = function ($log, $compile, utilityService) {
	            return new SWInput($log, $compile, utilityService);
	        };
	        directive.$inject = [
	            '$log',
	            '$compile',
	            'utilityService'
	        ];
	        return directive;
	    };
	    return SWInput;
	})();
	exports.SWInput = SWInput;


/***/ },
/* 100 */
/***/ function(module, exports) {

	/**********************************************************************************************
	 **********************************************************************************************
	 **********************************************************************************************
	 **		___________________________________________
	 ** 	Form Field - type have the following options (This is for the frontend so it can be modified):
	 **
	 **		checkbox			|	As a single checkbox this doesn't require any options, but it will create a hidden field for you so that the key gets submitted even when not checked.  The value of the checkbox will be 1
	 **		checkboxgroup		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
	 **		file				|	No value can be passed in
	 **		multiselect			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
	 **		password			|	No Value can be passed in
	 **		radiogroup			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
	 **		select      		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
	 **		text				|	Simple Text Field
	 **		textarea			|	Simple Textarea
	 **		yesno				|	This is used by booleans and flags to create a radio group of Yes and No
	 **		submit				|	submit button to post these properties back to the server.
	 **		------------------------------------------------------------------------------------------------------
	 **
	 **		attr.valueObject" type="any" default="" />
	 **		attr.valueObjectProperty" type="string" default="" />
	 **
	 **		General Settings that end up getting applied to the value object
	 **		attr.type" type="string" default="text"
	 **		attr.name" type="string" default=""
	 **		attr.class" type="string" default=""
	 **		attr.value" type="any" default=""
	 **		attr.valueOptions" type="array" default="#arrayNew(1)#"		<!--- Used for select, checkbox group, multiselect --->
	 **		attr.fieldAttributes" type="string" default=""
	 **
	 *********************************************************************************************
	 *********************************************************************************************
	 *********************************************************************************************
	 */
	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	    * Property Display Controller handles the logic for this directive.
	    */
	var SWFFormFieldController = (function () {
	    function SWFFormFieldController($scope) {
	        this.$scope = $scope;
	        var vm = this;
	        if (this.propertyDisplay) {
	            vm.propertyDisplay = this.propertyDisplay;
	        }
	        else {
	            vm.propertyDisplay = {
	                name: vm.name,
	                class: vm.class,
	                errorClass: vm.errorClass,
	                type: vm.type,
	                object: vm.object,
	                propertyIdentifier: vm.propertyIdentifier
	            };
	        }
	    }
	    /**
	        * Handles the logic for the frontend version of the property display.
	        */
	    SWFFormFieldController.$inject = ['$scope'];
	    return SWFFormFieldController;
	})();
	/**
	    * This class handles configuring formFields for use in process forms on the front end.
	    */
	var SWFFormField = (function () {
	    function SWFFormField(coreFormPartialsPath, hibachiPathBuilder) {
	        this.restrict = "E";
	        this.require = "^?swfPropertyDisplay";
	        this.controller = SWFFormFieldController;
	        this.controllerAs = "swfFormField";
	        this.scope = true;
	        this.bindToController = {
	            propertyDisplay: "=?",
	            propertyIdentifier: "@?",
	            name: "@?",
	            class: "@?",
	            errorClass: "@?",
	            type: "@?"
	        };
	        this.link = function (scope, element, attrs, formController, transcludeFn) {
	        };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + 'swfformfield.html';
	    }
	    /**
	        * Handles injecting the partials path into this class
	        */
	    SWFFormField.Factory = function () {
	        var directive = function (coreFormPartialsPath, hibachiPathBuilder) {
	            return new SWFFormField(coreFormPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            'coreFormPartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWFFormField;
	})();
	exports.SWFFormField = SWFFormField;


/***/ },
/* 101 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * Form Controller handles the logic for this directive.
	 */
	var SWFormController = (function () {
	    /**
	     * This controller handles most of the logic for the swFormDirective when more complicated self inspection is needed.
	     */
	    // @ngInject
	    function SWFormController($scope, $element, $hibachi, $http, $timeout, observerService, $rootScope) {
	        this.$scope = $scope;
	        this.$element = $element;
	        this.$hibachi = $hibachi;
	        this.$http = $http;
	        this.$timeout = $timeout;
	        this.observerService = observerService;
	        this.$rootScope = $rootScope;
	        /** only use if the developer has specified these features with isProcessForm */
	        if (angular.isUndefined(this.isDirty)) {
	            this.isDirty = false;
	        }
	        this.isProcessForm = this.isProcessForm || "false";
	        if (this.isProcessForm == "true") {
	            this.handleForm(this, $scope);
	        }
	    }
	    /**
	     * Iterates through the form elements and checks if the names of any of them match
	     * the meta data that comes back from the processObject call. Supplies a generic submit
	     * method that can be called by any subclasses that inject formCtrl. On submit,
	     * this class will attach any errors to the correspnding form element.
	     */
	    SWFormController.prototype.handleForm = function (context, $scope) {
	        var _this = this;
	        //console.log("Context", context);
	        /** local variables */
	        this.processObject = this.name || "";
	        var vm = context;
	        vm.hiddenFields = this.hiddenFields;
	        vm.entityName = this.entityName;
	        vm.processObject = this.processObject;
	        vm.action = this.action;
	        vm.actions = this.actions;
	        vm.$timeout = this.$timeout;
	        vm.postOnly = false;
	        vm.hibachiScope = this.$rootScope.hibachiScope;
	        var observerService = this.observerService;
	        /** parse the name */
	        vm.entityName = this.processObject.split("_")[0];
	        var processObject = this.processObject.split("_")[1];
	        /** try to grab the meta data from the process entity in slatwall in a process exists
	         *  otherwise, just use the service method to access it.
	         */
	        /** Cart is an alias for an Order */
	        if (vm.entityName == "Order") {
	            vm.entityName = "Cart";
	        }
	        ;
	        /** find the form scope */
	        this.$scope.$on('anchor', function (event, data) {
	            if (data.anchorType == "form" && data.scope !== undefined) {
	                vm["formCtrl"] = data.scope;
	            }
	        });
	        /** make sure we have our data using new logic and $hibachi*/
	        if (this.processObject == undefined || vm.entityName == undefined) {
	            throw ("ProcessObject Undefined Exception");
	        }
	        if (angular.isDefined(this.object) && this.object.name) {
	            vm.actionFn = this.object;
	        }
	        else {
	            vm.postOnly = true;
	        }
	        /** We use these for our models */
	        vm.formData = {};
	        /** returns all the data from the form by iterating the form elements */
	        vm.getFormData = function () {
	            var _this = this;
	            //console.log("Form Data:", this.object);
	            angular.forEach(this.object, function (val, key) {
	                /** Check for form elements that have a name that doesn't start with $ */
	                if (angular.isString(val)) {
	                    _this.formData[key] = val;
	                }
	            });
	            return vm.formData || "";
	        };
	        /****
	          * Handle parsing through the server errors and injecting the error text for that field
	          * If the form only has a submit, then simply call that function and set errors.
	          ***/
	        vm.parseErrors = function (result) {
	            var _this = this;
	            //console.log("Resultant Errors: ", result);
	            if (angular.isDefined(result.errors) && result.errors) {
	                angular.forEach(result.errors, function (val, key) {
	                    //console.log("Parsing Rule: ", result.errors[key]);
	                    //console.log(this.object, key, this.object[key]);
	                    //console.log("Yes, is defined...");
	                    var primaryElement = _this.$element.find("[error-for='" + key + "']");
	                    //console.log("Primary Element: ", primaryElement);
	                    vm.$timeout(function () {
	                        //console.log("Appending");
	                        primaryElement.append("<span name='" + key + "Error'>" + result.errors[key] + "</span>");
	                    }, 0);
	                    //vm["formCtrl"][vm.processObject][key].$setValidity(key, false);//set field invalid
	                    //vm["formCtrl"][vm.processObject][key].$setPristine(key, false);
	                }, this);
	            }
	        };
	        vm.eventsObj = [];
	        /** looks at the onSuccess, onError, and onLoading and parses the string into useful subcategories */
	        vm.parseEventString = function (evntStr, evntType) {
	            vm.events = vm.parseEvents(evntStr, evntType); //onSuccess : [hide:this, show:someOtherForm, refresh:Account]
	        };
	        vm.eventsHandler = function (params) {
	            for (var e in params.events) {
	                if (angular.isDefined(params.events[e].value) && params.events[e].value == vm.processObject.toLowerCase()) {
	                    if (params.events[e].name == "hide") {
	                        vm.hide(params.events[e].value);
	                    }
	                    if (params.events[e].name == "show") {
	                        vm.show(params.events[e].value);
	                    }
	                    if (params.events[e].name == "update") {
	                        vm.update(params.events[e].value);
	                    }
	                    if (params.events[e].name == "refresh") {
	                        vm.refresh(params.events[e].value);
	                    }
	                    ;
	                }
	            }
	        };
	        /** hides this directive on event */
	        vm.hide = function (param) {
	            if (vm.processObject.toLowerCase() == param) {
	                _this.$element.hide();
	            }
	        };
	        /** shows this directive on event */
	        vm.show = function (param) {
	            if (vm.processObject.toLowerCase() == param) {
	                _this.$element.show();
	            }
	        };
	        /** refreshes this directive on event */
	        vm.refresh = function (params) {
	            //stub
	        };
	        /** updates this directive on event */
	        vm.update = function (params) {
	            //stub
	        };
	        /** clears this directive on event */
	        vm.clear = function (params) {
	            //stub
	        };
	        vm.parseEvents = function (str, evntType) {
	            if (str == undefined)
	                return;
	            var strTokens = str.split(","); //this gives the format [hide:this, show:Account_Logout, update:Account or Cart]
	            var eventsObj = {
	                "events": []
	            }; //will hold events
	            for (var token in strTokens) {
	                var t = strTokens[token].split(":")[0].toLowerCase().replace(' ', '');
	                var u = strTokens[token].split(":")[1].toLowerCase().replace(' ', '');
	                if (t == "show" || t == "hide" || t == "refresh" || t == "update") {
	                    if (u == "this") {
	                        u == vm.processObject.toLowerCase();
	                    } //<--replaces the alias this with the name of this form.
	                    var event_1 = { "name": t, "value": u };
	                    eventsObj.events.push(event_1);
	                }
	            }
	            if (eventsObj.events.length) {
	                observerService.attach(vm.eventsHandler, "onSuccess");
	            }
	            return eventsObj;
	        };
	        /** find and clear all errors on form */
	        vm.clearErrors = function () {
	            /** clear all form errors on submit. */
	            _this.$timeout(function () {
	                var errorElements = _this.$element.find("[error-for]");
	                errorElements.empty();
	                //vm["formCtrl"][vm.processObject].$setPristine(true);
	            }, 0);
	        };
	        /** iterates through the factory submitting data */
	        vm.iterateFactory = function (submitFunction) {
	            if (!submitFunction) {
	                throw "Action not defined on form";
	            }
	            var submitFn = vm.hibachiScope.doAction;
	            vm.formData = vm.formData || {};
	            //console.log("Calling Final Submit");
	            submitFn(submitFunction, vm.formData).then(function (result) {
	                if (vm.hibachiScope.hasErrors) {
	                    vm.parseErrors(result.data);
	                    //trigger an onError event
	                    observerService.notify("onError", { "caller": _this.processObject, "events": vm.events.events || "" });
	                }
	                else {
	                    //trigger a on success event
	                    observerService.notify("onSuccess", { "caller": _this.processObject, "events": vm.events.events || "" });
	                }
	            }, angular.noop);
	            //console.log("Leaving iterateFactory.");
	        };
	        /** does either a single or multiple actions */
	        vm.doAction = function (actionObject) {
	            if (angular.isArray(actionObject)) {
	                for (var _i = 0; _i < actionObject.length; _i++) {
	                    var submitFunction = actionObject[_i];
	                    vm.iterateFactory(submitFunction);
	                }
	            }
	            else if (angular.isString(actionObject)) {
	                vm.iterateFactory(actionObject);
	            }
	            else {
	                throw ("Unknown type of action exception");
	            }
	        };
	        /** create the generic submit function */
	        vm.submit = function (Action) {
	            var action = Action || _this.action;
	            vm.clearErrors();
	            vm.formData = vm.getFormData() || "";
	            vm.doAction(action);
	        };
	        this.submit = vm.submit;
	        /* give children access to the process
	        */
	        vm.getProcessObject = function () {
	            return vm.processEntity;
	        };
	        /* handle events
	        */
	        if (this.onSuccess) {
	            vm.parseEventString(this.onSuccess, "onSuccess");
	            observerService.attach(vm.eventsHandler, "onSuccess");
	        }
	        else if (this.onError) {
	            vm.parseEventString(this.onError, "onError");
	            observerService.attach(vm.eventsHandler, "onError"); //stub
	        }
	    };
	    return SWFormController;
	})();
	var SWForm = (function () {
	    // @ngInject
	    function SWForm(coreFormPartialsPath, hibachiPathBuilder) {
	        this.coreFormPartialsPath = coreFormPartialsPath;
	        this.hibachiPathBuilder = hibachiPathBuilder;
	        this.templateUrl = "";
	        this.transclude = true;
	        this.restrict = "E";
	        this.controller = SWFormController;
	        this.controllerAs = "swForm";
	        this.scope = {};
	        /**
	         * Binds all of our variables to the controller so we can access using this
	         */
	        this.bindToController = {
	            name: "@?",
	            context: "@?",
	            entityName: "@?",
	            processObject: "@?",
	            hiddenFields: "=?",
	            action: "@?",
	            actions: "@?",
	            formClass: "@?",
	            formData: "=?",
	            object: "=?",
	            onSuccess: "@?",
	            onError: "@?",
	            hideUntil: "@?",
	            isProcessForm: "@?",
	            isDirty: "=?"
	        };
	        /**
	            * Sets the context of this form
	            */
	        this.link = function (scope, element, attrs, controller) {
	            scope.context = scope.context || 'save';
	        };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + "formPartial.html";
	    }
	    /**
	     * Handles injecting the partials path into this class
	     */
	    SWForm.Factory = function () {
	        var directive = function (coreFormPartialsPath, hibachiPathBuilder) {
	            return new SWForm(coreFormPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
	        return directive;
	    };
	    return SWForm;
	})();
	exports.SWForm = SWForm;


/***/ },
/* 102 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWFormField = (function () {
	    function SWFormField($log, $templateCache, $window, $hibachi, formService, coreFormPartialsPath, hibachiPathBuilder) {
	        return {
	            require: "^form",
	            restrict: 'AE',
	            scope: {
	                propertyDisplay: "="
	            },
	            templateUrl: hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + 'formfield.html',
	            link: function (scope, element, attrs, formController) {
	                if (angular.isUndefined(scope.propertyDisplay.object.$$getID) || scope.propertyDisplay.object.$$getID() === '') {
	                    scope.propertyDisplay.isDirty = true;
	                }
	                if (angular.isDefined(formController[scope.propertyDisplay.property])) {
	                    scope.propertyDisplay.errors = formController[scope.propertyDisplay.property].$error;
	                    formController[scope.propertyDisplay.property].formType = scope.propertyDisplay.fieldType;
	                }
	            }
	        };
	    }
	    SWFormField.Factory = function () {
	        var directive = function ($log, $templateCache, $window, $hibachi, formService, coreFormPartialsPath, hibachiPathBuilder) {
	            return new SWFormField($log, $templateCache, $window, $hibachi, formService, coreFormPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            '$templateCache',
	            '$window',
	            '$hibachi',
	            'formService',
	            'coreFormPartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWFormField;
	})();
	exports.SWFormField = SWFormField;
	//	angular.module('slatwalladmin').directive('swFormField',['$log','$templateCache', '$window', '$hibachi', 'formService', 'coreFormPartialsPath',($log, $templateCache, $window, $hibachi, formService, coreFormPartialsPath) => new swFormField($log, $templateCache, $window, $hibachi, formService, coreFormPartialsPath)]);


/***/ },
/* 103 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWFormFieldJsonController = (function () {
	    //@ngInject
	    function SWFormFieldJsonController(formService) {
	        this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
	    }
	    return SWFormFieldJsonController;
	})();
	var SWFormFieldJson = (function () {
	    function SWFormFieldJson(coreFormPartialsPath, hibachiPathBuilder) {
	        this.restrict = 'E';
	        this.require = "^form";
	        this.scope = true;
	        this.controller = SWFormFieldJsonController;
	        this.bindToController = {
	            propertyDisplay: "=?"
	        };
	        this.controllerAs = "ctrl";
	        this.templateUrl = "";
	        this.link = function (scope, element, attrs, formController) { };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "json.html";
	    }
	    SWFormFieldJson.Factory = function () {
	        var directive = function (coreFormPartialsPath, hibachiPathBuilder) {
	            return new SWFormFieldJson(coreFormPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            'coreFormPartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWFormFieldJson;
	})();
	exports.SWFormFieldJson = SWFormFieldJson;


/***/ },
/* 104 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWFormFieldNumberController = (function () {
	    function SWFormFieldNumberController() {
	        if (this.propertyDisplay.isDirty == undefined)
	            this.propertyDisplay.isDirty = false;
	        this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
	    }
	    return SWFormFieldNumberController;
	})();
	var SWFormFieldNumber = (function () {
	    function SWFormFieldNumber(coreFormPartialsPath, hibachiPathBuilder) {
	        this.restrict = 'E';
	        this.require = "^form";
	        this.scope = true;
	        this.bindToController = {
	            propertyDisplay: "=?"
	        };
	        this.templateUrl = "";
	        this.controller = SWFormFieldNumberController;
	        this.controllerAs = "ctrl";
	        this.link = function (scope, element, attrs, formController) { };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "number.html";
	    }
	    SWFormFieldNumber.Factory = function () {
	        var directive = function (coreFormPartialsPath, hibachiPathBuilder) {
	            return new SWFormFieldNumber(coreFormPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
	        return directive;
	    };
	    return SWFormFieldNumber;
	})();
	exports.SWFormFieldNumber = SWFormFieldNumber;


/***/ },
/* 105 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var swFormFieldPasswordController = (function () {
	    //@ngInject
	    function swFormFieldPasswordController() {
	        this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
	    }
	    return swFormFieldPasswordController;
	})();
	var SWFormFieldPassword = (function () {
	    //@ngInject
	    function SWFormFieldPassword(coreFormPartialsPath, hibachiPathBuilder) {
	        this.restrict = 'E';
	        this.require = "^form";
	        this.scope = true;
	        this.bindToController = {
	            propertyDisplay: "=?"
	        };
	        this.controller = swFormFieldPasswordController;
	        this.controllerAs = "ctrl";
	        this.link = function (scope, element, attrs, formController) { };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "password.html";
	    }
	    SWFormFieldPassword.Factory = function () {
	        var directive = function (coreFormPartialsPath, hibachiPathBuilder) {
	            return new SWFormFieldPassword(coreFormPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
	        return directive;
	    };
	    return SWFormFieldPassword;
	})();
	exports.SWFormFieldPassword = SWFormFieldPassword;


/***/ },
/* 106 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWFormFieldRadio = (function () {
	    //@ngInject
	    function SWFormFieldRadio($log, $timeout, coreFormPartialsPath, hibachiPathBuilder) {
	        return {
	            templateUrl: hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + 'radio.html',
	            require: "^form",
	            restrict: 'E',
	            scope: {
	                propertyDisplay: "="
	            },
	            link: function (scope, element, attr, formController) {
	                console.log('radio');
	                var makeRandomID = function makeid(count) {
	                    var text = "";
	                    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	                    for (var i = 0; i < count; i++)
	                        text += possible.charAt(Math.floor(Math.random() * possible.length));
	                    return text;
	                };
	                if (scope.propertyDisplay.fieldType === 'yesno') {
	                    //format value
	                    scope.selectedRadioFormName = makeRandomID(26);
	                    scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.object.data[scope.propertyDisplay.property] === 'YES ' || scope.propertyDisplay.object.data[scope.propertyDisplay.property] == 1 ? 1 : 0;
	                    scope.formFieldChanged = function (option) {
	                        scope.propertyDisplay.object.data[scope.propertyDisplay.property] = option.value;
	                        scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = true;
	                        scope.propertyDisplay.form['selected' + scope.propertyDisplay.object.metaData.className + scope.propertyDisplay.property + scope.selectedRadioFormName].$dirty = false;
	                    };
	                    scope.propertyDisplay.options = [
	                        {
	                            name: 'Yes',
	                            value: 1
	                        },
	                        {
	                            name: 'No',
	                            value: 0
	                        }
	                    ];
	                    if (angular.isDefined(scope.propertyDisplay.object.data[scope.propertyDisplay.property])) {
	                        for (var i in scope.propertyDisplay.options) {
	                            if (scope.propertyDisplay.options[i].value === scope.propertyDisplay.object.data[scope.propertyDisplay.property]) {
	                                scope.selected = scope.propertyDisplay.options[i];
	                                scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.options[i].value;
	                            }
	                        }
	                    }
	                    else {
	                        scope.selected = scope.propertyDisplay.options[0];
	                        scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.options[0].value;
	                    }
	                    $timeout(function () {
	                        scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = scope.propertyDisplay.isDirty;
	                    });
	                }
	            }
	        };
	    }
	    SWFormFieldRadio.Factory = function () {
	        var directive = function ($log, $timeout, coreFormPartialsPath, hibachiPathBuilder) {
	            return new SWFormFieldRadio($log, $timeout, coreFormPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log', '$timeout', 'coreFormPartialsPath', 'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWFormFieldRadio;
	})();
	exports.SWFormFieldRadio = SWFormFieldRadio;


/***/ },
/* 107 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWFormFieldSearchSelect = (function () {
	    function SWFormFieldSearchSelect($http, $log, $hibachi, formService, coreFormPartialsPath, hibachiPathBuilder) {
	        return {
	            templateUrl: hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + 'search-select.html',
	            require: "^form",
	            restrict: 'E',
	            scope: {
	                propertyDisplay: "="
	            },
	            link: function (scope, element, attr, formController) {
	                //set up selectionOptions
	                scope.selectionOptions = {
	                    value: [],
	                    $$adding: false
	                };
	                //match in matches track by
	                //function to set state of adding new item
	                scope.setAdding = function (isAdding) {
	                    scope.isAdding = isAdding;
	                    scope.showAddBtn = false;
	                };
	                scope.selectedOption = {};
	                scope.showAddBtn = false;
	                var propertyMetaData = scope.propertyDisplay.object.$$getMetaData(scope.propertyDisplay.property);
	                //create basic
	                var object = $hibachi.newEntity(propertyMetaData.cfc);
	                //				scope.propertyDisplay.template = '';
	                //				//check for a template
	                //				//rules are tiered: check if an override is specified at scope.template, check if the cfc name .html exists, use
	                //				var templatePath = coreFormPartialsPath + 'formfields/searchselecttemplates/';
	                //				if(angular.isUndefined(scope.propertyDisplay.template)){
	                //					var templatePromise = $http.get(templatePath+propertyMetaData.cfcProperCase+'.html',function(){
	                //						$log.debug('template');
	                //						scope.propertyDisplay.template = templatePath+propertyMetaData.cfcProperCase+'.html';
	                //					},function(){
	                //						scope.propertyDisplay.template = templatePath+'index.html';
	                //						$log.debug('template');
	                //						$log.debug(scope.propertyDisplay.template);
	                //					});
	                //				}
	                //set up query function for finding related object
	                scope.cfcProperCase = propertyMetaData.cfcProperCase;
	                scope.selectionOptions.getOptionsByKeyword = function (keyword) {
	                    var filterGroupsConfig = '[' +
	                        ' {  ' +
	                        '"filterGroup":[  ' +
	                        '{' +
	                        ' "propertyIdentifier":"_' + scope.cfcProperCase.toLowerCase() + '.' + scope.cfcProperCase + 'Name",' +
	                        ' "comparisonOperator":"like",' +
	                        ' "ormtype":"string",' +
	                        ' "value":"%' + keyword + '%"' +
	                        '  }' +
	                        ' ]' +
	                        ' }' +
	                        ']';
	                    return $hibachi.getEntity(propertyMetaData.cfc, { filterGroupsConfig: filterGroupsConfig.trim() })
	                        .then(function (value) {
	                        $log.debug('typesByKeyword');
	                        $log.debug(value);
	                        scope.selectionOptions.value = value.pageRecords;
	                        var myLength = keyword.length;
	                        if (myLength > 0) {
	                            scope.showAddBtn = true;
	                        }
	                        else {
	                            scope.showAddBtn = false;
	                        }
	                        return scope.selectionOptions.value;
	                    });
	                };
	                var propertyPromise = scope.propertyDisplay.object['$$get' + propertyMetaData.nameCapitalCase]();
	                propertyPromise.then(function (data) {
	                });
	                //set up behavior when selecting an item
	                scope.selectItem = function ($item, $model, $label) {
	                    scope.$item = $item;
	                    scope.$model = $model;
	                    scope.$label = $label;
	                    scope.showAddBtn = false; //turns off the add btn on select
	                    //angular.extend(inflatedObject.data,$item);
	                    object.$$init($item);
	                    $log.debug('select item');
	                    $log.debug(object);
	                    scope.propertyDisplay.object['$$set' + propertyMetaData.nameCapitalCase](object);
	                };
	                //				if(angular.isUndefined(scope.propertyDipslay.object[scope.propertyDisplay.property])){
	                //					$log.debug('getmeta');
	                //					$log.debug(scope.propertyDisplay.object.metaData[scope.propertyDisplay.property]);
	                //
	                //					//scope.propertyDipslay.object['$$get'+]
	                //				}
	                //
	                //				scope.propertyDisplay.object.data[scope.propertyDisplay.property].$dirty = true;
	            }
	        };
	    }
	    SWFormFieldSearchSelect.Factory = function () {
	        var directive = function ($http, $log, $hibachi, formService, coreFormPartialsPath, hibachiPathBuilder) {
	            return new SWFormFieldSearchSelect($http, $log, $hibachi, formService, coreFormPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$http',
	            '$log',
	            '$hibachi',
	            'formService',
	            'coreFormPartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWFormFieldSearchSelect;
	})();
	exports.SWFormFieldSearchSelect = SWFormFieldSearchSelect;


/***/ },
/* 108 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWFormFieldSelect = (function () {
	    //@ngInject
	    function SWFormFieldSelect($log, $hibachi, formService, coreFormPartialsPath, utilityService, hibachiPathBuilder) {
	        return {
	            templateUrl: hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + 'select.html',
	            require: "^form",
	            restrict: 'E',
	            scope: {
	                propertyDisplay: "="
	            },
	            link: function (scope, element, attr, formController) {
	                var selectType;
	                if (angular.isDefined(scope.propertyDisplay.object.metaData[scope.propertyDisplay.property].fieldtype)) {
	                    selectType = 'object';
	                    $log.debug('selectType:object');
	                }
	                else {
	                    selectType = 'string';
	                    $log.debug('selectType:string');
	                }
	                scope.formFieldChanged = function (option) {
	                    $log.debug('formfieldchanged');
	                    $log.debug(option);
	                    if (selectType === 'object' && typeof scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName == "function") {
	                        scope.propertyDisplay.object.data[scope.propertyDisplay.property]['data'][scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()] = option.value;
	                        if (angular.isDefined(scope.propertyDisplay.form[scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()])) {
	                            scope.propertyDisplay.form[scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()].$dirty = true;
	                        }
	                    }
	                    else if (selectType === 'string') {
	                        scope.propertyDisplay.object.data[scope.propertyDisplay.property] = option.value;
	                        scope.propertyDisplay.form[scope.propertyDisplay.property].$dirty = true;
	                    }
	                };
	                scope.getOptions = function () {
	                    if (angular.isUndefined(scope.propertyDisplay.options)) {
	                        var optionsPromise = $hibachi.getPropertyDisplayOptions(scope.propertyDisplay.object.metaData.className, scope.propertyDisplay.optionsArguments);
	                        optionsPromise.then(function (value) {
	                            scope.propertyDisplay.options = value.data;
	                            if (selectType === 'object') {
	                                if (angular.isUndefined(scope.propertyDisplay.object.data[scope.propertyDisplay.property])) {
	                                    scope.propertyDisplay.object.data[scope.propertyDisplay.property] = $hibachi['new' + scope.propertyDisplay.object.metaData[scope.propertyDisplay.property].cfc]();
	                                }
	                                if (scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getID() === '') {
	                                    $log.debug('no ID');
	                                    $log.debug(scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName());
	                                    scope.propertyDisplay.object.data['selected' + scope.propertyDisplay.property] = scope.propertyDisplay.options[0];
	                                    scope.propertyDisplay.object.data[scope.propertyDisplay.property] = $hibachi['new' + scope.propertyDisplay.object.metaData[scope.propertyDisplay.property].cfc]();
	                                    scope.propertyDisplay.object.data[scope.propertyDisplay.property]['data'][scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()] = scope.propertyDisplay.options[0].value;
	                                }
	                                else {
	                                    var found = false;
	                                    for (var i in scope.propertyDisplay.options) {
	                                        if (angular.isObject(scope.propertyDisplay.options[i].value)) {
	                                            $log.debug('isObject');
	                                            $log.debug(scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName());
	                                            if (scope.propertyDisplay.options[i].value === scope.propertyDisplay.object.data[scope.propertyDisplay.property]) {
	                                                scope.propertyDisplay.object.data['selected' + scope.propertyDisplay.property] = scope.propertyDisplay.options[i];
	                                                scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.options[i].value;
	                                                found = true;
	                                                break;
	                                            }
	                                        }
	                                        else {
	                                            $log.debug('notisObject');
	                                            $log.debug(scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName());
	                                            if (scope.propertyDisplay.options[i].value === scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getID()) {
	                                                scope.propertyDisplay.object.data['selected' + scope.propertyDisplay.property] = scope.propertyDisplay.options[i];
	                                                scope.propertyDisplay.object.data[scope.propertyDisplay.property]['data'][scope.propertyDisplay.object.data[scope.propertyDisplay.property].$$getIDName()] = scope.propertyDisplay.options[i].value;
	                                                found = true;
	                                                break;
	                                            }
	                                        }
	                                        if (!found) {
	                                            scope.propertyDisplay.object.data['selected' + scope.propertyDisplay.property] = scope.propertyDisplay.options[0];
	                                        }
	                                    }
	                                }
	                            }
	                            else if (selectType === 'string') {
	                                if (scope.propertyDisplay.object.data[scope.propertyDisplay.property] !== null) {
	                                    for (var i in scope.propertyDisplay.options) {
	                                        if (scope.propertyDisplay.options[i].value === scope.propertyDisplay.object.data[scope.propertyDisplay.property]) {
	                                            scope.propertyDisplay.object.data['selected' + scope.propertyDisplay.property] = scope.propertyDisplay.options[i];
	                                            scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.options[i].value;
	                                        }
	                                    }
	                                }
	                                else {
	                                    scope.propertyDisplay.object.data['selected' + scope.propertyDisplay.property] = scope.propertyDisplay.options[0];
	                                    scope.propertyDisplay.object.data[scope.propertyDisplay.property] = scope.propertyDisplay.options[0].value;
	                                }
	                            }
	                        });
	                    }
	                };
	                if (scope.propertyDisplay.eagerLoadOptions == true) {
	                    scope.getOptions();
	                }
	                //formService.setPristinePropertyValue(scope.propertyDisplay.property,scope.propertyDisplay.object[scope.propertyDisplay.valueOptions].value[0]);
	                if (selectType === 'object') {
	                    formController[scope.propertyDisplay.property + 'ID'].$dirty = scope.propertyDisplay.isDirty;
	                }
	                else if (selectType === 'string') {
	                    formController[scope.propertyDisplay.property].$dirty = scope.propertyDisplay.isDirty;
	                }
	            }
	        }; //<--end return
	    }
	    SWFormFieldSelect.Factory = function () {
	        var directive = function ($log, $hibachi, formService, coreFormPartialsPath, utilityService, hibachiPathBuilder) {
	            return new SWFormFieldSelect($log, $hibachi, formService, coreFormPartialsPath, utilityService, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            '$hibachi',
	            'formService',
	            'coreFormPartialsPath',
	            'utilityService',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWFormFieldSelect;
	})();
	exports.SWFormFieldSelect = SWFormFieldSelect;


/***/ },
/* 109 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWFormFieldTextController = (function () {
	    //@ngInject
	    function SWFormFieldTextController(formService) {
	        this.formService = formService;
	        if (this.propertyDisplay.isDirty == undefined)
	            this.propertyDisplay.isDirty = false;
	        this.propertyDisplay.form.$dirty = this.propertyDisplay.isDirty;
	        this.formService.setPristinePropertyValue(this.propertyDisplay.property, this.propertyDisplay.object.data[this.propertyDisplay.property]);
	    }
	    return SWFormFieldTextController;
	})();
	var SWFormFieldText = (function () {
	    function SWFormFieldText(coreFormPartialsPath, hibachiPathBuilder) {
	        this.restrict = 'E';
	        this.require = "^form";
	        this.controller = SWFormFieldTextController;
	        this.controllerAs = "ctrl";
	        this.scope = true;
	        this.bindToController = {
	            propertyDisplay: "="
	        };
	        //@ngInject
	        this.link = function (scope, element, attr, formController) {
	        };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "text.html";
	    }
	    SWFormFieldText.Factory = function () {
	        var directive = function (coreFormPartialsPath, hibachiPathBuilder) {
	            return new SWFormFieldText(coreFormPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            'coreFormPartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWFormFieldText;
	})();
	exports.SWFormFieldText = SWFormFieldText;
	//     angular.module('slatwalladmin').directive('swFormFieldText', ['$log','$hibachi','formService','partialsPath', ($log, $hibachi, formService, partialsPath) => new SWFormFieldText($log, $hibachi, formService, partialsPath)]);
	// }


/***/ },
/* 110 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWFormRegistrar = (function () {
	    //@ngInject
	    function SWFormRegistrar(formService, coreFormPartialsPath, hibachiPathBuilder) {
	        return {
	            restrict: 'E',
	            require: "^form",
	            scope: {
	                object: "=",
	                context: "@",
	                name: "@",
	                isDirty: "="
	            },
	            link: function (scope, element, attrs, formController) {
	                /*add form info at the form level*/
	                formController.$$swFormInfo = {
	                    object: scope.object,
	                    context: scope.context || 'save',
	                    name: scope.name
	                };
	                var makeRandomID = function makeid(count) {
	                    var text = "";
	                    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	                    for (var i = 0; i < count; i++)
	                        text += possible.charAt(Math.floor(Math.random() * possible.length));
	                    return text;
	                };
	                if (scope.isDirty) {
	                    formController.autoDirty = true;
	                }
	                scope.form = formController;
	                /*register form with service*/
	                formController.name = scope.name;
	                formController.$setDirty();
	                formService.setForm(formController);
	                /*register form at object level*/
	                if (!angular.isDefined(scope.object.forms)) {
	                    scope.object.forms = {};
	                }
	                scope.object.forms[scope.name] = formController;
	            }
	        };
	    }
	    SWFormRegistrar.Factory = function () {
	        var directive = function (formService, coreFormPartialsPath, hibachiPathBuilder) {
	            return new SWFormRegistrar(formService, coreFormPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            'formService',
	            'coreFormPartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWFormRegistrar;
	})();
	exports.SWFormRegistrar = SWFormRegistrar;
	// 	angular.module('slatwalladmin').directive('swFormRegistrar',[ 'formService', 'partialsPath', (formService, partialsPath) => new swFormRegistrar(formService, partialsPath)]);
	// }


/***/ },
/* 111 */
/***/ function(module, exports) {

	/**********************************************************************************************
	 **********************************************************************************************
	 **********************************************************************************************
	 **		Property Display (This one is specifically for the frontend so that it can be modified)
	 **		isHidden
	 **		requiredFlag
	 **		title
	 **		hint
	 **		editting
	 **		object
	 **		class
	 **		___________________________________________
	 ** 	attr.type have the following options:
	 **
	 **		checkbox			|	As a single checkbox this doesn't require any options, but it will create a hidden field for you so that the key gets submitted even when not checked.  The value of the checkbox will be 1
	 **		checkboxgroup		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
	 **		file				|	No value can be passed in
	 **		multiselect			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
	 **		password			|	No Value can be passed in
	 **		radiogroup			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
	 **		select      		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
	 **		text				|	Simple Text Field
	 **		textarea			|	Simple Textarea
	 **		yesno				|	This is used by booleans and flags to create a radio group of Yes and No
	 **		submit				|	submit button to post these properties back to the server.
	 **		------------------------------------------------------------------------------------------------------
	 **
	 **		attr.valueObject" type="any" default="" />
	 **		attr.valueObjectProperty" type="string" default="" />
	 **
	 **		General Settings that end up getting applied to the value object
	 **		attr.type" type="string" default="text"
	 **		attr.name" type="string" default=""
	 **		attr.class" type="string" default=""
	 **		attr.value" type="any" default=""
	 **		attr.valueOptions" type="array" default="#arrayNew(1)#"		<!--- Used for select, checkbox group, multiselect --->
	 **		attr.fieldAttributes" type="string" default=""
	 **
	 *********************************************************************************************
	 *********************************************************************************************
	 *********************************************************************************************
	 */
	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	    * Property Display Controller handles the logic for this directive.
	    */
	var SWFPropertyDisplayController = (function () {
	    /**
	        * Handles the logic for the frontend version of the property display.
	        */
	    //@ngInject
	    function SWFPropertyDisplayController($scope) {
	        this.$scope = $scope;
	        this.optionValues = [];
	        var vm = this;
	        vm.processObject = {};
	        vm.valueObjectProperty = this.valueObjectProperty;
	        vm.type = this.type || "text";
	        vm.class = this.class || "formControl";
	        vm.valueObject = this.valueObject;
	        vm.fieldAttributes = this.fieldAttributes || "";
	        vm.label = this.label || "true";
	        vm.labelText = this.labelText || "";
	        vm.labelClass = this.labelClass || "";
	        vm.name = this.name || "unnamed";
	        vm.options = this.options;
	        vm.valueOptions = this.valueOptions;
	        vm.errorClass = this.errorClass;
	        vm.errorText = this.errorText;
	        vm.object = this.object; //this is the process object
	        vm.propertyIdentifier = this.propertyIdentifier; //this is the property
	        vm.loader = this.loader;
	        vm.noValidate = this.noValidate;
	        /** in order to attach the correct controller to local vm, we need a watch to bind */
	        /** handle options */
	        if (vm.options && angular.isString(vm.options)) {
	            var optionsArray = [];
	            optionsArray = vm.options.toString().split(",");
	            angular.forEach(optionsArray, function (o) {
	                var newOption = {
	                    name: "",
	                    value: ""
	                };
	                newOption.name = o;
	                newOption.value = o;
	                this.optionValues.push(newOption);
	            }, vm);
	        }
	        if (angular.isDefined(vm.valueOptions) && angular.isObject(vm.valueOptions)) {
	            vm.optionsValues = [];
	            angular.forEach(vm.valueOptions, function (o) {
	                var newOption = {
	                    name: "",
	                    value: ""
	                };
	                if (angular.isDefined(o.name) && angular.isDefined(o.value)) {
	                    newOption.name = o.name;
	                    newOption.value = o.value;
	                    vm.optionValues.push(newOption);
	                }
	            });
	        }
	        /** handle turning the options into an array of objects */
	        /** handle setting the default value for the yes / no element  */
	        if (this.type == "yesno" && (this.value && angular.isString(this.value))) {
	            vm.selected == this.value;
	        }
	        this.propertyDisplay = {
	            type: vm.type,
	            name: vm.name,
	            class: vm.class,
	            loader: vm.loader,
	            errorClass: vm.errorClass,
	            option: vm.options,
	            valueObject: vm.valueObject,
	            object: vm.object,
	            label: vm.label,
	            labelText: vm.labelText,
	            labelClass: vm.labelClass,
	            optionValues: vm.optionValues,
	            edit: vm.editting,
	            title: vm.title,
	            value: vm.value || "",
	            errorText: vm.errorText,
	        };
	        //console.log("Property Display", this.propertyDisplay);
	    }
	    return SWFPropertyDisplayController;
	})();
	/**
	    * This class handles configuring formFields for use in process forms on the front end.
	    */
	var SWFPropertyDisplay = (function () {
	    //@ngInject
	    function SWFPropertyDisplay(coreFormPartialsPath, hibachiPathBuilder) {
	        this.restrict = "E";
	        this.require = "?^swForm";
	        this.transclude = true;
	        this.templateUrl = "";
	        this.controller = SWFPropertyDisplayController;
	        this.controllerAs = "swfPropertyDisplayController";
	        this.scope = {};
	        this.bindToController = {
	            type: "@?",
	            name: "@?",
	            class: "@?",
	            edit: "@?",
	            title: "@?",
	            hint: "@?",
	            valueObject: "=?",
	            valueObjectProperty: "=?",
	            propertyIdentifier: "@?",
	            options: "@?",
	            valueOptions: "=?",
	            fieldAttributes: "@?",
	            object: "=",
	            label: "@?",
	            labelText: "@?",
	            labelClass: "@?",
	            errorText: "@?",
	            errorClass: "@?",
	            formTemplate: "@?"
	        };
	        this.link = function (scope, element, attrs, formController, transcludeFn) {
	            scope.frmController = formController;
	        };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + 'swfpropertydisplaypartial.html';
	    }
	    SWFPropertyDisplay.Factory = function () {
	        var directive = function (coreFormPartialsPath, hibachiPathBuilder) {
	            return new SWFPropertyDisplay(coreFormPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
	        return directive;
	    };
	    return SWFPropertyDisplay;
	})();
	exports.SWFPropertyDisplay = SWFPropertyDisplay;


/***/ },
/* 112 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWPropertyDisplay = (function () {
	    function SWPropertyDisplay($log, $filter, coreFormPartialsPath, hibachiPathBuilder) {
	        return {
	            require: '^form',
	            restrict: 'AE',
	            scope: {
	                object: "=",
	                options: "=?",
	                property: "@",
	                editable: "=",
	                editing: "=",
	                isHidden: "=",
	                title: "=",
	                hint: "@",
	                optionsArguments: "=",
	                eagerLoadOptions: "=",
	                isDirty: "=",
	                onChange: "=",
	                fieldType: "@",
	                noValidate: "="
	            },
	            templateUrl: hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "propertydisplay.html",
	            link: function (scope, element, attrs, formController) {
	                //if the item is new, then all fields at the object level are dirty
	                $log.debug('editingproper');
	                $log.debug(scope.property);
	                $log.debug(scope.title);
	                if (!angular.isDefined(scope.object)) {
	                    scope.object = formController.$$swFormInfo.object;
	                }
	                /**
	                 * Configuration for property display object.
	                 */
	                scope.propertyDisplay = {
	                    object: scope.object,
	                    options: scope.options,
	                    property: scope.property,
	                    errors: {},
	                    editing: scope.editing,
	                    editable: scope.editable,
	                    isHidden: scope.isHidden,
	                    fieldType: scope.fieldType || scope.object.metaData.$$getPropertyFieldType(scope.property),
	                    title: scope.title,
	                    hint: scope.hint || scope.object.metaData.$$getPropertyHint(scope.property),
	                    optionsArguments: scope.optionsArguments || {},
	                    eagerLoadOptions: scope.eagerLoadOptions || true,
	                    isDirty: scope.isDirty,
	                    onChange: scope.onChange,
	                    noValidate: scope.noValidate
	                };
	                if (angular.isUndefined(scope.propertyDisplay.noValidate)) {
	                    scope.propertyDisplay.noValidate = false;
	                }
	                if (angular.isUndefined(scope.propertyDisplay.editable)) {
	                    scope.propertyDisplay.editable = true;
	                }
	                if (angular.isUndefined(scope.editing)) {
	                    scope.propertyDisplay.editing = false;
	                }
	                if (angular.isUndefined(scope.propertyDisplay.isHidden)) {
	                    scope.propertyDisplay.isHidden = false;
	                }
	                scope.applyFilter = function (model, filter) {
	                    try {
	                        return $filter(filter)(model);
	                    }
	                    catch (e) {
	                        return model;
	                    }
	                };
	                scope.$id = 'propertyDisplay:' + scope.property;
	                /* register form that the propertyDisplay belongs to*/
	                scope.propertyDisplay.form = formController;
	                $log.debug(scope.propertyDisplay);
	                $log.debug('propertyDisplay');
	                $log.debug(scope.propertyDisplay);
	            }
	        };
	    }
	    SWPropertyDisplay.Factory = function () {
	        var directive = function ($log, $filter, coreFormPartialsPath, hibachiPathBuilder) {
	            return new SWPropertyDisplay($log, $filter, coreFormPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = [
	            '$log',
	            '$filter',
	            'coreFormPartialsPath',
	            'hibachiPathBuilder'
	        ];
	        return directive;
	    };
	    return SWPropertyDisplay;
	})();
	exports.SWPropertyDisplay = SWPropertyDisplay;


/***/ },
/* 113 */
/***/ function(module, exports, __webpack_require__) {

	/// <reference path="../../typings/tsd.d.ts" />
	/// <reference path="../../typings/hibachiTypescript.d.ts" />
	var swvalidate_1 = __webpack_require__(114);
	var swvalidationminlength_1 = __webpack_require__(115);
	var swvalidationdatatype_1 = __webpack_require__(116);
	var swvalidationeq_1 = __webpack_require__(117);
	var swvalidationgte_1 = __webpack_require__(118);
	var swvalidationlte_1 = __webpack_require__(119);
	var swvalidationmaxlength_1 = __webpack_require__(120);
	var swvalidationmaxvalue_1 = __webpack_require__(121);
	var swvalidationminvalue_1 = __webpack_require__(122);
	var swvalidationneq_1 = __webpack_require__(123);
	var swvalidationnumeric_1 = __webpack_require__(124);
	var swvalidationregex_1 = __webpack_require__(125);
	var swvalidationrequired_1 = __webpack_require__(126);
	var swvalidationunique_1 = __webpack_require__(127);
	var swvalidationuniqueornull_1 = __webpack_require__(128);
	var validationmodule = angular.module('hibachi.validation', [])
	    .run([function () {
	    }])
	    .directive('swValidate', swvalidate_1.SWValidate.Factory())
	    .directive('swvalidationminlength', swvalidationminlength_1.SWValidationMinLength.Factory())
	    .directive('swvalidationdatatype', swvalidationdatatype_1.SWValidationDataType.Factory())
	    .directive('swvalidationeq', swvalidationeq_1.SWValidationEq.Factory())
	    .directive("swvalidationgte", swvalidationgte_1.SWValidationGte.Factory())
	    .directive("swvalidationlte", swvalidationlte_1.SWValidationLte.Factory())
	    .directive('swvalidationmaxlength', swvalidationmaxlength_1.SWValidationMaxLength.Factory())
	    .directive("swvalidationmaxvalue", swvalidationmaxvalue_1.SWValidationMaxValue.Factory())
	    .directive("swvalidationminvalue", swvalidationminvalue_1.SWValidationMinValue.Factory())
	    .directive("swvalidationneq", swvalidationneq_1.SWValidationNeq.Factory())
	    .directive("swvalidationnumeric", swvalidationnumeric_1.SWValidationNumeric.Factory())
	    .directive("swvalidationregex", swvalidationregex_1.SWValidationRegex.Factory())
	    .directive("swvalidationrequired", swvalidationrequired_1.SWValidationRequired.Factory())
	    .directive("swvalidationunique", swvalidationunique_1.SWValidationUnique.Factory())
	    .directive("swvalidationuniqueornull", swvalidationuniqueornull_1.SWValidationUniqueOrNull.Factory());
	exports.validationmodule = validationmodule;


/***/ },
/* 114 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * This validate directive will look at the current element, figure out the context (save, edit, delete) and
	 * validate based on that context as defined in the validation properties object.
	 */
	// 'use strict';
	// angular.module('slatwalladmin').directive('swValidate',
	// [ '$log','$hibachi', function($log, $hibachi) {
	var SWValidate = (function () {
	    function SWValidate($log, $hibachi) {
	        return {
	            restrict: "A",
	            require: '^ngModel',
	            link: function (scope, elem, attr, ngModel) {
	                //Define our contexts and validation property enums.
	                var ContextsEnum = {
	                    SAVE: { name: "save", value: 0 },
	                    DELETE: { name: "delete", value: 1 },
	                    EDIT: { name: "edit", value: 2 }
	                };
	                var ValidationPropertiesEnum = {
	                    REGEX: { name: "regex", value: 0 },
	                    MIN_VALUE: { name: "minValue", value: 1 },
	                    MAX_VALUE: { name: "maxValue", value: 2 },
	                    EQ: { name: "eq", value: 3 },
	                    NEQ: { name: "neq", value: 4 },
	                    UNIQUE: { name: "unique", value: 5 },
	                    LTE: { name: "lte", value: 6 },
	                    GTE: { name: "gte", value: 7 },
	                    MIN_LENGTH: { name: "minLength", value: 8 },
	                    MAX_LENGTH: { name: "maxLength", value: 9 },
	                    DATA_TYPE: { name: "dataType", value: 10 },
	                    REQUIRED: { name: "required", value: 11 }
	                };
	                scope.validationPropertiesEnum = ValidationPropertiesEnum;
	                scope.contextsEnum = ContextsEnum;
	                var myCurrentContext = scope.contextsEnum.SAVE; //We are only checking the save context right now.
	                var contextNamesArray = getNamesFromObject(ContextsEnum); //Convert for higher order functions.
	                var validationPropertiesArray = getNamesFromObject(ValidationPropertiesEnum); //Convert for higher order functions.
	                var validationObject = scope.propertyDisplay.object.validations.properties; //Get the scope validation object.
	                var errors = scope.propertyDisplay.errors;
	                var errorMessages = [];
	                var failFlag = 0;
	                /**
	                * Iterates over the validation object looking for the current elements validations, maps that to a validation function list
	                * and calls those validate functions. When a validation fails, an error is set, the elements border turns red.
	                */
	                function validate(name, context, elementValue) {
	                    var validationResults = {};
	                    validationResults = { "name": "name", "context": "context", "required": "required", "error": "none", "errorkey": "none" };
	                    for (var key in validationObject) {
	                        // Look for the current attribute in the
	                        // validation parameters.
	                        if (key === name || key === name + "Flag") {
	                            // Now that we have found the current
	                            // validation parameters, iterate
	                            // through them looking for
	                            // the required parameters that match
	                            // the current page context (save,
	                            // delete, etc.)
	                            for (var inner in validationObject[key]) {
	                                var required = validationObject[key][inner].required || "false"; // Get
	                                // the
	                                // required
	                                // value
	                                var context = validationObject[key][inner].contexts || "none"; // Get
	                                // the
	                                // element
	                                // context
	                                //Setup the validation results object to pass back to caller.
	                                validationResults = { "name": key, "context": context, "required": required, "error": "none", "errorkey": "none" };
	                                var elementValidationArr = map(checkHasValidationType, validationPropertiesArray, validationObject[key][inner]);
	                                //Iterate over the array and call the validate function if it has that property.
	                                for (var i = 0; i < elementValidationArr.length; i++) {
	                                    if (elementValidationArr[i] == true) {
	                                        if (validationPropertiesArray[i] === "regex" && elementValue !== "") {
	                                            //Get the regex string to match and send to validation function.
	                                            var re = validationObject[key][inner].regex;
	                                            var result = validate_RegExp(elementValue, re); //true if pattern match, fail otherwise.
	                                            if (result != true) {
	                                                errorMessages
	                                                    .push("Invalid input");
	                                                validationResults.error = errorMessages[errorMessages.length - 1];
	                                                validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["REGEX"].name;
	                                                validationResults.fail = true;
	                                            }
	                                            else {
	                                                errorMessages
	                                                    .push("Valid input");
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
	                                                errorMessages
	                                                    .push("Minimum value is: "
	                                                    + validationMinValue);
	                                                validationResults.error = errorMessages[errorMessages.length - 1];
	                                                validationResults.errorkey = "invalid-" + ValidationPropertiesEnum["MIN_VALUE"].name;
	                                                validationResults.fail = true;
	                                            }
	                                            else {
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
	                                                errorMessages
	                                                    .push("Maximum value is: "
	                                                    + validationMaxValue);
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
	                                                errorMessages
	                                                    .push("Minimum length must be: "
	                                                    + validationMinLength);
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
	                                                errorMessages
	                                                    .push("Maximum length is: "
	                                                    + validationMaxLength);
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
	                                                errorMessages
	                                                    .push("Must equal "
	                                                    + validationEq);
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
	                                                errorMessages
	                                                    .push("Must not equal: "
	                                                    + validationNeq);
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
	                                                errorMessages
	                                                    .push("Must be less than "
	                                                    + validationLte);
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
	                                                errorMessages
	                                                    .push("Must be greater than: "
	                                                    + validationGte);
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
	                                                errorMessages
	                                                    .push("Required");
	                                                validationResults.error = errorMessages[errorMessages.length - 1];
	                                                validationResults.errorkey = ValidationPropertiesEnum["REQUIRED"].name;
	                                                validationResults.fail = true;
	                                            }
	                                            else {
	                                                errorMessages
	                                                    .push("Required");
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
	                    } //<---end validate.			
	                }
	                /**
	                * Function to map if we need a validation on this element.
	                */
	                function checkHasValidationType(validationProp, validationType) {
	                    if (validationProp[validationType] != undefined) {
	                        return true;
	                    }
	                    else {
	                        return false;
	                    }
	                }
	                /**
	                * Iterates over the properties object finding which types of validation are needed.
	                */
	                function map(func, array, obj) {
	                    var result = [];
	                    forEach(array, function (element) {
	                        result.push(func(obj, element));
	                    });
	                    return result;
	                }
	                /**
	                * Array iteration helper.
	                */
	                function forEach(array, action) {
	                    for (var i = 0; i < array.length; i++)
	                        action(array[i]);
	                }
	                /**
	                * Helper function to read all the names in our enums into an array that the higher order functions can use.
	                */
	                function getNamesFromObject(obj) {
	                    var result = [];
	                    for (var i in obj) {
	                        var name = obj[i].name || "stub";
	                        result.push(name);
	                    }
	                    return result;
	                }
	                /**
	                * Tests the value for a RegExp match given by the pattern string.
	                * Validates true if pattern match, false otherwise.
	                */
	                function validate_RegExp(value, pattern) {
	                    var regex = new RegExp(pattern);
	                    if (regex.test(value)) {
	                        return true;
	                    }
	                    return false;
	                }
	                /**
	                * Validates true if userValue >= minValue (inclusive)
	                */
	                function validate_MinValue(userValue, minValue) {
	                    return (userValue >= minValue);
	                }
	                /**
	                * Validates true if userValue <= maxValue (inclusive)
	                */
	                function validate_MaxValue(userValue, maxValue) {
	                    return (userValue <= maxValue) ? true : false;
	                }
	                /**
	                * Validates true if length of the userValue >= minLength (inclusive)
	                */
	                function validate_MinLength(userValue, minLength) {
	                    return (userValue.length >= minLength) ? true : false;
	                }
	                /**
	                * Validates true if length of the userValue <= maxLength (inclusive)
	                */
	                function validate_MaxLength(userValue, maxLength) {
	                    return (userValue.length <= maxLength) ? true : false;
	                }
	                /**
	                * Validates true if the userValue == eqValue
	                */
	                function validate_Eq(userValue, eqValue) {
	                    return (userValue == eqValue) ? true : false;
	                }
	                /**
	                * Validates true if the userValue != neqValue
	                */
	                function validate_Neq(userValue, neqValue) {
	                    return (userValue != neqValue) ? true : false;
	                }
	                /**
	                * Validates true if the userValue < decisionValue (exclusive)
	                */
	                function validate_Lte(userValue, decisionValue) {
	                    return (userValue < decisionValue) ? true : false;
	                }
	                /**
	                * Validates true if the userValue > decisionValue (exclusive)
	                */
	                function validate_Gte(userValue, decisionValue) {
	                    return (userValue > decisionValue) ? true : false;
	                }
	                /**
	                * Validates true if the userValue === property
	                */
	                function validate_EqProperty(userValue, property) {
	                    return (userValue === property) ? true : false;
	                }
	                /**
	                * Validates true if the given value is !NaN (Negate, Not a Number).
	                */
	                function validate_IsNumeric(value) {
	                    return !isNaN(value) ? true : false;
	                }
	                /**
	                * Validates true if the given userValue is empty and the field is required.
	                */
	                function validate_Required(property, userValue) {
	                    return (userValue == "" && property == true) ? true : false;
	                }
	                /**
	                * Handles the 'eager' validation on every key press.
	                */
	                ngModel.$parsers.unshift(function (value) {
	                    var name = elem.context.name; //Get the element name for the validate function.
	                    var currentValue = elem.val(); //Get the current element value to check validations against.
	                    var val = validate(name, myCurrentContext, currentValue) || {};
	                    //Check if field is required.				
	                    $log.debug(scope);
	                    $log.debug(val);
	                    ngModel.$setValidity(val.errorkey, !val.fail);
	                    return true;
	                }); //<---end $parsers
	                /**
	                * This handles 'lazy' validation on blur.
	                */
	                elem.bind('blur', function (e) {
	                });
	            }
	        };
	    }
	    SWValidate.Factory = function () {
	        var directive = function ($log, $hibachi) { return new SWValidate($log, $hibachi); };
	        directive.$inject = ['$log', '$hibachi'];
	        return directive;
	    };
	    return SWValidate;
	})();
	exports.SWValidate = SWValidate;


/***/ },
/* 115 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * Returns true if the user value is greater than the min length.
	 */
	/**
	 * Returns true if the user value is greater than the minimum value.
	 */
	var SWValidationMinLength = (function () {
	    function SWValidationMinLength($log) {
	        return {
	            restrict: "A",
	            require: "^ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                ngModel.$validators.swvalidationminlength =
	                    function (modelValue, viewValue) {
	                        var constraintValue = attributes.swvalidationminlength;
	                        var userValue = viewValue || 0;
	                        if (parseInt(viewValue.length) >= parseInt(constraintValue)) {
	                            return true;
	                        }
	                        $log.debug('invalid min length');
	                        return false;
	                    };
	            }
	        };
	    }
	    SWValidationMinLength.Factory = function () {
	        var directive = function ($log) { return new SWValidationMinLength($log); };
	        directive.$inject = ['$log'];
	        return directive;
	    };
	    return SWValidationMinLength;
	})();
	exports.SWValidationMinLength = SWValidationMinLength;


/***/ },
/* 116 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * True if the data type matches the given data type.
	 */
	/**
	 * Validates true if the model value is a numeric value.
	 */
	var SWValidationDataType = (function () {
	    function SWValidationDataType() {
	        return {
	            restrict: "A",
	            require: "^ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                var MY_EMAIL_REGEXP = /^[a-zA-Z0-9_.]+@[a-zA-Z0-9_]+?\.[a-zA-Z]{2,3}$/;
	                ngModel.$validators.swvalidationdatatype =
	                    function (modelValue) {
	                        if (angular.isString(modelValue) && attributes.swvalidationdatatype === "string") {
	                            return true;
	                        }
	                        if (angular.isNumber(parseInt(modelValue)) && attributes.swvalidationdatatype === "numeric") {
	                            return true;
	                        }
	                        if (angular.isArray(modelValue) && attributes.swvalidationdatatype === "array") {
	                            return true;
	                        }
	                        if (angular.isDate(modelValue) && attributes.swvalidationdatatype === "date") {
	                            return true;
	                        }
	                        if (angular.isObject(modelValue) && attributes.swvalidationdatatype === "object") {
	                            return true;
	                        }
	                        if (attributes.swvalidationdatatype === 'email') {
	                            return MY_EMAIL_REGEXP.test(modelValue);
	                        }
	                        if (angular.isUndefined(modelValue && attributes.swvalidationdatatype === "undefined")) {
	                            return true;
	                        }
	                        return false;
	                    };
	            }
	        };
	    }
	    SWValidationDataType.Factory = function () {
	        var directive = function () {
	            return new SWValidationDataType();
	        };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWValidationDataType;
	})();
	exports.SWValidationDataType = SWValidationDataType;


/***/ },
/* 117 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * SwValidationEQ: Validates true if the user value == the constraint value.
	 * @usage <input type='text' swvalidationgte='5' /> will validate false if the user enters
	 * value other than 5.
	 */
	var SWValidationEq = (function () {
	    function SWValidationEq() {
	        return {
	            restrict: "A",
	            require: "^ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                ngModel.$validators.swvalidationeq =
	                    function (modelValue, viewValue) {
	                        var constraintValue = attributes.swvalidationeq;
	                        if (modelValue === constraintValue) {
	                            return true;
	                        }
	                        else {
	                            return false;
	                        }
	                    }; //<--end function
	            } //<--end link
	        };
	    }
	    SWValidationEq.Factory = function () {
	        var directive = function () {
	            return new SWValidationEq();
	        };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWValidationEq;
	})();
	exports.SWValidationEq = SWValidationEq;


/***/ },
/* 118 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * SwValidationGTE: Validates true if the user value >= to the constraint value.
	 * @usage <input type='text' swvalidationGte='5' /> will validate false if the user enters
	 * value less than OR equal to 5.
	 */
	var SWValidationGte = (function () {
	    function SWValidationGte() {
	        return {
	            restrict: "A",
	            require: "^ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                ngModel.$validators.swvalidationGte =
	                    function (modelValue, viewValue) {
	                        var constraintValue = attributes.swvalidationGte || 0;
	                        if (parseInt(modelValue) >= parseInt(constraintValue)) {
	                            return true; //Passes the validation
	                        }
	                        return false;
	                    }; //<--end function
	            } //<--end link
	        };
	    }
	    SWValidationGte.Factory = function () {
	        var directive = function () { return new SWValidationGte(); };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWValidationGte;
	})();
	exports.SWValidationGte = SWValidationGte;


/***/ },
/* 119 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * SwValidationLTE: Validates true if the user value <= to the constraint value.
	 * @usage <input type='number' swvalidationlte='5000' /> will validate false if the user enters
	 * value greater than OR equal to 5,000.
	 */
	var SWValidationLte = (function () {
	    function SWValidationLte() {
	        return {
	            restrict: "A",
	            require: "^ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                ngModel.$validators.swvalidationlte =
	                    function (modelValue, viewValue) {
	                        var constraintValue = attributes.swvalidationlte;
	                        var userValue = viewValue || 0;
	                        if (parseInt(viewValue) <= parseInt(constraintValue)) {
	                            return true;
	                        }
	                        return false;
	                    };
	            }
	        };
	    }
	    SWValidationLte.Factory = function () {
	        var directive = function () { return new SWValidationLte(); };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWValidationLte;
	})();
	exports.SWValidationLte = SWValidationLte;


/***/ },
/* 120 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * Returns true if the user value is greater than the max length.
	 */
	var SWValidationMaxLength = (function () {
	    function SWValidationMaxLength() {
	        return {
	            restrict: "A",
	            require: "^ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                ngModel.$validators.swvalidationmaxlength =
	                    function (modelValue, viewValue) {
	                        var constraintValue = attributes.swvalidationmaxlength;
	                        var userValue = viewValue || 0;
	                        if (parseInt(viewValue.length) >= parseInt(constraintValue)) {
	                            return true;
	                        }
	                        return false;
	                    };
	            }
	        };
	    }
	    SWValidationMaxLength.Factory = function () {
	        var directive = function () { return new SWValidationMaxLength(); };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWValidationMaxLength;
	})();
	exports.SWValidationMaxLength = SWValidationMaxLength;


/***/ },
/* 121 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * Returns true if the user value is greater than the min value.
	 */
	var SWValidationMaxValue = (function () {
	    function SWValidationMaxValue() {
	        return {
	            restrict: "A",
	            require: "^ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                ngModel.$validators.swvalidationmaxvalue =
	                    function (modelValue, viewValue) {
	                        var constraintValue = attributes.swvalidationmaxvalue;
	                        var userValue = viewValue || 0;
	                        if (parseInt(viewValue) <= parseInt(constraintValue)) {
	                            return true;
	                        }
	                        return false;
	                    };
	            }
	        };
	    }
	    SWValidationMaxValue.Factory = function () {
	        var directive = function () { return new SWValidationMaxValue(); };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWValidationMaxValue;
	})();
	exports.SWValidationMaxValue = SWValidationMaxValue;


/***/ },
/* 122 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * Returns true if the user value is greater than the minimum value.
	 */
	var SWValidationMinValue = (function () {
	    function SWValidationMinValue() {
	        return {
	            restrict: "A",
	            require: "^ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                ngModel.$validators.swvalidationminvalue =
	                    function (modelValue, viewValue) {
	                        var constraintValue = attributes.swvalidationminvalue;
	                        var userValue = viewValue || 0;
	                        if (parseInt(modelValue) >= parseInt(constraintValue)) {
	                            return true;
	                        }
	                        return false;
	                    };
	            }
	        };
	    }
	    SWValidationMinValue.Factory = function () {
	        var directive = function () { return new SWValidationMinValue(); };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWValidationMinValue;
	})();
	exports.SWValidationMinValue = SWValidationMinValue;


/***/ },
/* 123 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 *  Validates true if the user value != the property value.
	 */
	var SWValidationNeq = (function () {
	    function SWValidationNeq() {
	        return {
	            restrict: "A",
	            require: "^ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                ngModel.$validators.swvalidationneq =
	                    function (modelValue) {
	                        if (modelValue != attributes.swvalidationneq) {
	                            return true;
	                        }
	                        return false;
	                    };
	            }
	        };
	    }
	    SWValidationNeq.Factory = function () {
	        var directive = function () { return new SWValidationNeq(); };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWValidationNeq;
	})();
	exports.SWValidationNeq = SWValidationNeq;


/***/ },
/* 124 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * Validates true if the model value (user value) is a numeric value.
	 * @event This event fires on every change to an input.
	 */
	var SWValidationNumeric = (function () {
	    function SWValidationNumeric() {
	        return {
	            restrict: "A",
	            require: "^ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                ngModel.$validators.swvalidationnumeric =
	                    function (modelValue, viewValue) {
	                        //Returns true if this is not a number.
	                        if (!isNaN(viewValue)) {
	                            return true;
	                        }
	                        else {
	                            return false;
	                        }
	                    };
	            }
	        };
	    }
	    SWValidationNumeric.Factory = function () {
	        var directive = function () { return new SWValidationNumeric(); };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWValidationNumeric;
	})();
	exports.SWValidationNumeric = SWValidationNumeric;


/***/ },
/* 125 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * Validates true if the model value matches a regex string.
	 */
	var SWValidationRegex = (function () {
	    function SWValidationRegex() {
	        return {
	            restrict: "A",
	            require: "^ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                ngModel.$validators.swvalidationregex =
	                    function (modelValue) {
	                        //Returns true if this user value (model value) does match the pattern
	                        var pattern = attributes.swvalidationregex;
	                        var regex = new RegExp(pattern);
	                        if (regex.test(modelValue)) {
	                            return true;
	                        }
	                        else {
	                            return false;
	                        }
	                    };
	            }
	        };
	    }
	    SWValidationRegex.Factory = function () {
	        var directive = function () { return new SWValidationRegex(); };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWValidationRegex;
	})();
	exports.SWValidationRegex = SWValidationRegex;


/***/ },
/* 126 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * Returns true if the uservalue is empty and false otherwise
	 */
	var SWValidationRequired = (function () {
	    function SWValidationRequired() {
	        return {
	            restrict: "A",
	            require: "^ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                ngModel.$validators.swvalidationrequired =
	                    function (modelValue, viewValue) {
	                        var value = modelValue || viewValue;
	                        if (value) {
	                            return true;
	                        }
	                        return false;
	                    };
	            }
	        };
	    }
	    SWValidationRequired.Factory = function () {
	        var directive = function () { return new SWValidationRequired(); };
	        directive.$inject = [];
	        return directive;
	    };
	    return SWValidationRequired;
	})();
	exports.SWValidationRequired = SWValidationRequired;


/***/ },
/* 127 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * Validates true if the given object is 'unique' and false otherwise.
	 */
	var SWValidationUnique = (function () {
	    function SWValidationUnique($http, $q, $hibachi, $log) {
	        return {
	            restrict: "A",
	            require: "ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                ngModel.$asyncValidators.swvalidationunique = function (modelValue, viewValue) {
	                    $log.debug('asyc');
	                    var deferred = $q.defer(), currentValue = modelValue || viewValue, key = scope.propertyDisplay.object.metaData.className, property = scope.propertyDisplay.property;
	                    //First time the asyncValidators function is loaded the
	                    //key won't be set  so ensure that we have
	                    //key and propertyName before checking with the server
	                    if (key && property) {
	                        $hibachi.checkUniqueValue(key, property, currentValue)
	                            .then(function (unique) {
	                            $log.debug('uniquetest');
	                            $log.debug(unique);
	                            if (unique) {
	                                deferred.resolve(); //It's unique
	                            }
	                            else {
	                                deferred.reject(); //Add unique to $errors
	                            }
	                        });
	                    }
	                    else {
	                        deferred.resolve(); //Ensure promise is resolved if we hit this
	                    }
	                    return deferred.promise;
	                };
	            }
	        };
	    }
	    SWValidationUnique.Factory = function () {
	        var directive = function ($http, $q, $hibachi, $log) { return new SWValidationUnique($http, $q, $hibachi, $log); };
	        directive.$inject = ['$http', '$q', '$hibachi', '$log'];
	        return directive;
	    };
	    return SWValidationUnique;
	})();
	exports.SWValidationUnique = SWValidationUnique;


/***/ },
/* 128 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	/**
	 * Validates true if the given object is 'unique' and false otherwise.
	 */
	var SWValidationUniqueOrNull = (function () {
	    function SWValidationUniqueOrNull($http, $q, $hibachi, $log) {
	        return {
	            restrict: "A",
	            require: "ngModel",
	            link: function (scope, element, attributes, ngModel) {
	                ngModel.$asyncValidators.swvalidationuniqueornull = function (modelValue, viewValue) {
	                    $log.debug('async');
	                    var deferred = $q.defer(), currentValue = modelValue || viewValue, key = scope.propertyDisplay.object.metaData.className, property = scope.propertyDisplay.property;
	                    //First time the asyncValidators function is loaded the
	                    //key won't be set  so ensure that we have
	                    //key and propertyName before checking with the server
	                    if (key && property) {
	                        $hibachi.checkUniqueOrNullValue(key, property, currentValue)
	                            .then(function (unique) {
	                            $log.debug('uniquetest');
	                            $log.debug(unique);
	                            if (unique) {
	                                deferred.resolve(); //It's unique
	                            }
	                            else {
	                                deferred.reject(); //Add unique to $errors
	                            }
	                        });
	                    }
	                    else {
	                        deferred.resolve(); //Ensure promise is resolved if we hit this
	                    }
	                    return deferred.promise;
	                };
	            }
	        };
	    }
	    SWValidationUniqueOrNull.Factory = function () {
	        var directive = function ($http, $q, $hibachi, $log) { return new SWValidationUniqueOrNull($http, $q, $hibachi, $log); };
	        directive.$inject = ['$http', '$q', '$hibachi', '$log'];
	        return directive;
	    };
	    return SWValidationUniqueOrNull;
	})();
	exports.SWValidationUniqueOrNull = SWValidationUniqueOrNull;


/***/ },
/* 129 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWSaveAndFinishController = (function () {
	    //@ngInject
	    function SWSaveAndFinishController($hibachi, dialogService, $log) {
	        var _this = this;
	        this.$hibachi = $hibachi;
	        this.dialogService = dialogService;
	        this.$log = $log;
	        this.saving = false;
	        this.initialSetup = function () {
	            if (!angular.isDefined(_this.finish)) {
	                _this.openNewDialog = false;
	            }
	            else {
	                _this.openNewDialog = (_this.finish.toLowerCase() == 'true') ? false : true;
	            }
	            if (_this.openNewDialog) {
	                _this.rbKey = 'admin.define.saveandnew';
	            }
	            else {
	                _this.rbKey = 'admin.define.saveandfinish';
	            }
	        };
	        this.save = function () {
	            _this.saving = true;
	            _this.entity.$$save().then(function (data) {
	                _this.dialogService.removeCurrentDialog();
	            }).finally(function (data) {
	                _this.saving = false;
	                if (_this.openNewDialog && angular.isDefined(_this.partial)) {
	                    _this.dialogService.addPageDialog(_this.partial);
	                }
	                else {
	                    if (angular.isDefined(_this.redirectUrl)) {
	                        window.location = _this.redirectUrl;
	                    }
	                    else if (angular.isDefined(_this.redirectAction)) {
	                        if (angular.isUndefined(_this.redirectQueryString)) {
	                            _this.redirectQueryString = "";
	                        }
	                        window.location = _this.$hibachi.buildURL(_this.redirectAction, _this.redirectQueryString);
	                    }
	                    else {
	                        _this.$log.debug("You did not specify a redirect for swSaveAndFinish");
	                    }
	                }
	            });
	        };
	        if (!angular.isFunction(this.entity.$$save)) {
	            throw ("Your entity does not have the $$save function.");
	        }
	        this.initialSetup();
	    }
	    return SWSaveAndFinishController;
	})();
	exports.SWSaveAndFinishController = SWSaveAndFinishController;
	var SWSaveAndFinish = (function () {
	    //@ngInject
	    function SWSaveAndFinish(hibachiPartialsPath, hibachiPathBuilder) {
	        this.hibachiPartialsPath = hibachiPartialsPath;
	        this.restrict = "EA";
	        this.scope = {};
	        this.controller = SWSaveAndFinishController;
	        this.controllerAs = "swSaveAndFinish";
	        this.bindToController = {
	            entity: "=",
	            redirectUrl: "@?",
	            redirectAction: "@?",
	            redirectQueryString: "@?",
	            finish: "@?",
	            partial: "@?"
	        };
	        this.templateUrl = hibachiPathBuilder.buildPartialsPath(hibachiPartialsPath) + "saveandfinish.html";
	    }
	    SWSaveAndFinish.Factory = function () {
	        var directive = function (hibachiPartialsPath, hibachiPathBuilder) {
	            return new SWSaveAndFinish(hibachiPartialsPath, hibachiPathBuilder);
	        };
	        directive.$inject = ["hibachiPartialsPath", "hibachiPathBuilder"];
	        return directive;
	    };
	    return SWSaveAndFinish;
	})();
	exports.SWSaveAndFinish = SWSaveAndFinish;


/***/ },
/* 130 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var FrontendController = (function () {
	    function FrontendController($scope, $element, $log, $hibachi, collectionConfigService, selectionService) {
	        this.$scope = $scope;
	        this.$element = $element;
	        this.$log = $log;
	        this.$hibachi = $hibachi;
	        this.collectionConfigService = collectionConfigService;
	        this.selectionService = selectionService;
	    }
	    return FrontendController;
	})();
	exports.FrontendController = FrontendController;


/***/ },
/* 131 */
/***/ function(module, exports) {

	/// <reference path='../../../typings/hibachiTypescript.d.ts' />
	/// <reference path='../../../typings/tsd.d.ts' />
	var SWFDirectiveController = (function () {
	    //@ngInject
	    function SWFDirectiveController($log, frontendPartialsPath, $rootScope) {
	        this.$log = $log;
	        this.frontendPartialsPath = frontendPartialsPath;
	        this.$rootScope = $rootScope;
	        this.$rootScope = $rootScope;
	        this.hibachiScope = this.$rootScope.hibachiScope;
	    }
	    return SWFDirectiveController;
	})();
	exports.SWFDirectiveController = SWFDirectiveController;
	var SWFDirective = (function () {
	    // @ngInject
	    function SWFDirective(hibachiPathBuilder, frontendPartialsPath, $compile) {
	        var _this = this;
	        this.frontendPartialsPath = frontendPartialsPath;
	        this.restrict = 'E';
	        this.bindToController = {
	            variables: "=",
	            directive: "=",
	            templateUrl: "@"
	        };
	        this.controller = SWFDirectiveController;
	        this.controllerAs = "SWFDirective";
	        this.templatePath = "";
	        this.url = "";
	        /** allows you to build a directive without using another controller and directive config. */
	        // @ngInject
	        this.link = function (scope, element, attrs) {
	            _this.scope = scope;
	            _this.path = attrs.partialPath || _this.templatePath;
	            //Developer specifies the path and name of a partial for creating a custom directive.
	            if (attrs.partialName) {
	                //returns the attrs.path or the default if not configured.
	                var template = "<span ng-include = " + "'\"" + _this.path + attrs.partialName + ".html\"'" + "></span>";
	                element.html('').append(_this.$compile(template)(scope));
	            }
	            else {
	                //this.templateUrl = this.url;
	                if (!attrs.type) {
	                    attrs.type = "A";
	                }
	                if (attrs.type == "A" || !attrs.type) {
	                    var template = '<span ' + attrs.directive + ' ';
	                    if (angular.isDefined(_this.scope.variables)) {
	                        angular.forEach(_this.scope.variables, function (value, key) {
	                            template += ' ' + key + '=' + value + ' ';
	                        });
	                    }
	                    template += +'>';
	                    template += '</span>';
	                }
	                else {
	                    var template = '<' + attrs.directive + ' ';
	                    if (_this.scope.variables) {
	                        angular.forEach(_this.scope.variables, function (value, key) {
	                            template += ' ' + key + '=' + value + ' ';
	                        });
	                    }
	                    template += +'>';
	                    template += '</' + attrs.directive + '>';
	                }
	                // Render the template.
	                element.html('').append(_this.$compile(template)(scope));
	            }
	        };
	        this.templatePath = hibachiPathBuilder.buildPartialsPath(frontendPartialsPath);
	        this.url = hibachiPathBuilder.buildPartialsPath(frontendPartialsPath) + 'swfdirectivepartial.html';
	        this.$compile = $compile;
	    }
	    SWFDirective.Factory = function () {
	        var directive = function (hibachiPathBuilder, frontendPartialsPath, $compile) {
	            return new SWFDirective(hibachiPathBuilder, frontendPartialsPath, $compile);
	        };
	        directive.$inject = [
	            'hibachiPathBuilder',
	            'frontendPartialsPath',
	            '$compile'
	        ];
	        return directive;
	    };
	    return SWFDirective;
	})();
	exports.SWFDirective = SWFDirective;


/***/ }
/******/ ]);