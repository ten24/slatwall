(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[13],{537:function(e,t,a){"use strict";a.r(t);var i=a(2),r=a(5),n=a(28),c=a(0),s=function(e){var t=e.brandName,a=void 0===t?"":t,i=e.imageFile,r=e.brandDescription,s=e.subHeading;return Object(c.jsxs)("div",{className:"row align-items-center",children:[i&&i.length>5&&Object(c.jsx)(n.U,{style:{maxHeight:"150px"},customPath:"/custom/assets/images/brand/logo/",src:i,alt:a,type:"brand",className:"bg-white mr-2 ml-3"}),Object(c.jsxs)("div",{className:"col text-left",children:[Object(c.jsx)("h2",{className:"m-0 font-weight-normal",children:a}),!!s&&Object(c.jsx)("h3",{className:"h5 m-0",children:s})]}),Object(c.jsx)("div",{className:"col text-right ",children:Object(c.jsx)("span",{dangerouslySetInnerHTML:{__html:r}})})]})},d=a(140),l=a(15),o=a(32),u=a(3),b=a(19),m=a.n(b),p=a(1),j=a(141),h=a(49),g=a(26);t.default=function(e){var t,a,b,O=Object(u.d)(h.a),y=Object(u.d)((function(e){return e.configuration.filtering.productTypeBase})),v=e.location.pathname.split("/").reverse(),T=Object(l.h)(),f=m.a.parse(T.search,{arrayFormat:"separator",arrayFormatSeparator:","}),x=Object(l.g)(),N=Object(o.c)(),F=Object(r.a)(N,2),L=F[0],k=F[1],w=Object(o.c)(),P=Object(r.a)(w,2),D=P[0],H=P[1],S=f.key||y;if(Object(p.useEffect)((function(){D.isFetching||D.isLoaded||H(Object(i.a)(Object(i.a)({},D),{},{isFetching:!0,isLoaded:!1,entity:"ProductType",params:{brandUrlTitle:v[0],"p:show":250,includeSettingsInList:!0},makeRequest:!0})),L.isFetching||L.isLoaded||k(Object(i.a)(Object(i.a)({},L),{},{isFetching:!0,isLoaded:!1,entity:"brand",params:{"f:urlTitle":v[0]},makeRequest:!0}))}),[S,k,L,v,H,D]),!D.isFetching&&D.isLoaded&&0===Object.keys(D.data).length)return Object(c.jsx)(l.a,{to:"/404"});var I=Object(g.a)(S,D.data),_=0!==(null===I||void 0===I||null===(t=I.childProductTypes)||void 0===t?void 0:t.length)&&S!==y;return Object(c.jsxs)(n.w,{classNameList:"page-overlap-none",children:[L.isLoaded&&L.data.length>0&&Object(c.jsx)(j.a,{title:L.data[0].settings.brandHTMLTitleString}),L.isLoaded&&D.isLoaded&&Object(c.jsx)(n.D,{title:_&&(null===I||void 0===I?void 0:I.productTypeName),includeHome:!0,brand:f.key&&[{title:L.data[0].brandName,urlTitle:"/".concat(O,"/").concat(L.data[0].urlTitle)}],crumbs:D.data.filter((function(e){var t;return null===I||void 0===I||null===(t=I.productTypeIDPath)||void 0===t?void 0:t.includes(e.productTypeID)})).map((function(e){return{title:e.productTypeName,urlTitle:e.urlTitle}})).filter((function(e){return e.urlTitle!==y})).filter((function(e){return e.urlTitle!==S})).map((function(e){return Object(i.a)(Object(i.a)({},e),{},{urlTitle:"".concat(T.pathname,"?").concat(m.a.stringify({key:e.urlTitle},{arrayFormat:"comma"}))})})),children:Object(c.jsx)(s,{subHeading:null===I||void 0===I?void 0:I.productTypeName,brandName:L.data[0].brandName,imageFile:L.data[0].imageFile,brandDescription:L.data[0].brandDescription})}),L.isLoaded&&(null===(a=I.childProductTypes)||void 0===a?void 0:a.length)>0&&Object(c.jsx)(n.P,{data:I,onSelect:function(e){f.key=e,x.push("".concat(T.pathname,"?").concat(m.a.stringify(f,{arrayFormat:"comma"})))}}),0===(null===I||void 0===I||null===(b=I.childProductTypes)||void 0===b?void 0:b.length)&&Object(c.jsx)(d.a,{preFilter:{brand:L.data[0].brandName,productType_slug:I.urlTitle},hide:["productType","brands"]})]})}}}]);
//# sourceMappingURL=13.adb0929c.chunk.js.map