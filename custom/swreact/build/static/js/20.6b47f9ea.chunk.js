(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[20],{303:function(e,t,c){"use strict";var s=c(10),a=c(0);t.a=function(e){var t=e.customBody,c=void 0===t?"":t,n=e.contentTitle,r=void 0===n?"":n,o=Object(s.f)();return Object(a.jsxs)(a.Fragment,{children:[Object(a.jsx)("div",{className:"d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3",children:Object(a.jsx)("div",{className:"d-flex justify-content-between w-100",children:Object(a.jsx)("h2",{className:"h3",children:r})})}),Object(a.jsx)("div",{onClick:function(e){e.preventDefault(),e.target.getAttribute("href")&&o.push(e.target.getAttribute("href"))},dangerouslySetInnerHTML:{__html:c}})]})}},446:function(e,t,c){"use strict";c.r(t);var s=c(4),a=c(295),n=c(303),r=c(307),o=c(13),l=c(339),i=c.n(l),u=c(340),d=c.n(u),m=c(11),b=c(5),j=c(291),h=c(0);t.default=Object(s.b)((function(e){return{user:e.userReducer}}))((function(e){var t=e.crumbs,c=e.title,l=e.customBody,u=e.contentTitle,f=e.user,p=Object(s.c)(),O=d()(i.a),v=Object(j.a)(),x=v.t,N=(v.i18n,Object(r.a)({enableReinitialize:!0,initialValues:{accountFirstName:f.firstName,accountLastName:f.lastName,accountEmailAddress:f.primaryEmailAddress.emailAddress,accountCompany:f.company},onSubmit:function(e){p(Object(o.r)({firstName:e.accountFirstName,lastName:e.accountLastName,emailAddress:e.accountEmailAddress,company:e.accountCompany,returnJSONObjects:"account"}))}}));return Object(h.jsxs)(a.a,{crumbs:t,title:c,children:[Object(h.jsx)(n.a,{customBody:l,contentTitle:u}),Object(h.jsx)("form",{onSubmit:N.handleSubmit,children:Object(h.jsxs)("div",{className:"row",children:[Object(h.jsx)("div",{className:"col-sm-6",children:Object(h.jsxs)("div",{className:"form-group",children:[Object(h.jsx)("label",{htmlFor:"accountFirstName",children:x("frontend.account.first_name")}),Object(h.jsx)("input",{className:"form-control",type:"text",id:"accountFirstName",value:N.values.accountFirstName,onChange:N.handleChange})]})}),Object(h.jsx)("div",{className:"col-sm-6",children:Object(h.jsxs)("div",{className:"form-group",children:[Object(h.jsx)("label",{htmlFor:"accountLastName",children:x("frontend.account.last_name")}),Object(h.jsx)("input",{className:"form-control",type:"text",id:"accountLastName",value:N.values.accountLastName,onChange:N.handleChange})]})}),Object(h.jsx)("div",{className:"col-sm-6",children:Object(h.jsxs)("div",{className:"form-group",children:[Object(h.jsx)("label",{htmlFor:"accountEmailAddress",children:x("frontend.account.email")}),Object(h.jsx)("input",{className:"form-control",type:"accountEmailAddress",id:"accountEmailAddress",value:N.values.accountEmailAddress,onChange:N.handleChange,disabled:""})]})}),Object(h.jsx)("div",{className:"col-sm-6",children:Object(h.jsxs)("div",{className:"form-group",children:[Object(h.jsx)("label",{htmlFor:"accountCompany",children:x("frontend.account.company")}),Object(h.jsx)("input",{className:"form-control",value:N.values.accountCompany,type:"text",onChange:N.handleChange,id:"accountCompany"})]})}),Object(h.jsxs)("div",{className:"col-12",children:[Object(h.jsx)("hr",{className:"mt-2 mb-3"}),Object(h.jsxs)("div",{className:"d-flex flex-wrap justify-content-end",children:[Object(h.jsx)("button",{className:"btn btn-secondary mt-3 mt-sm-0 mr-3",onClick:function(e){e.preventDefault(),O.fire({title:"Update Password",html:'<input id="accountPassword" placeholder="Password" class="swal2-input"><input id="accountPasswordConfirm" placeholder="Confirm Password" class="swal2-input">',focusConfirm:!1,showCancelButton:!0,preConfirm:function(){return[document.getElementById("accountPassword").value,document.getElementById("accountPasswordConfirm").value]}}).then((function(e){e.isConfirmed&&(2===e.value.length&&e.value[0]===e.value[1]?b.a.account.changePassword({password:e.value[0],passwordConfirm:e.value[1]}).then((function(e){e.isSuccess()?e.success().successfulActions.length?m.b.success("Password Update Successful"):m.b.error(e.success().errors.password.join(" ")):m.b.error("Network Error")})):m.b.error("Password Mismatch"))}))},type:"submit",children:x("frontend.account.password_update")}),Object(h.jsx)("button",{type:"submit",className:"btn btn-primary mt-3 mt-sm-0",children:x("frontend.account.profile_update")})]})]})]})})]})}))}}]);
//# sourceMappingURL=20.6b47f9ea.chunk.js.map