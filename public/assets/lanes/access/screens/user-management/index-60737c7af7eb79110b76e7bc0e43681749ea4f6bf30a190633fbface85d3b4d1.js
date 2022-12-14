!function(e,n,t,r,s,o,a,i){e.Access.Screens.UserManagement=function(){function s(){}return s.prototype.displayName="Lanes.Access.Screens.UserManagement",s.prototype.FILE=o,s.prototype.getInitialState=function(){var n;return n=[{id:"id",visible:!1},"login","name","email",{id:"role_names",title:"Role Names"}],{query:new e.Models.Query({fields:n,src:e.Models.User})}},s.prototype.rolesForUser=function(e){return n.map(e.role_names,function(e){return{id:e,name:n.titleize(e)}})},s.prototype.setRolesForUser=function(e,t){return t.model.role_names=n.map(e,"id")},s.prototype.editors=function(n){return{role_names:function(n){return function(s){var o;return o=s.model,r.createElement(t.SelectField,{id:"role_names",key:"row-select",queryModel:e.Models.User,fieldOnly:!0,editOnly:!0,multiSelect:!0,writable:!0,model:o,labelField:"name",getSelection:n.rolesForUser,setSelection:n.setRolesForUser,choices:e.Models.Role.all.models,fetchOnSelect:!1,name:"role_names"})}}(this)}},s.prototype.render=function(){return r.createElement(t.ScreenWrapper,{identifier:"user-management",flexVertical:!0},r.createElement("h1",null,"Users Management"),r.createElement(t.Grid,{editorProps:{height:350,syncImmediatly:!0},query:this.state.query,allowCreate:!0,editor:e.Access.Screens.UserManagement.Editor,columEditors:this.editors(),ref:"grid"}))},s}(),e.Access.Screens.UserManagement=e.React.Screen.extend(e.Access.Screens.UserManagement)}(window.Lanes=window.Lanes||{},(window.Lanes.Vendor=window.Lanes.Vendor||{}).ld,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes,extension:{name:"Lanes",identifier:"lanes"},path:["lanes","access","screens","user-management","UserManagement"]},window),function(e,n,t,r,s,o,a,i){e.Access.Screens.UserManagement.Editor=function(){function n(){}return n.prototype.displayName="Lanes.Access.Screens.UserManagement.Editor",n.prototype.FILE=o,n.prototype.mixins=[e.Components.Grid.PopoverMixin],n.prototype.getInitialState=function(){return{link:t.Helpers.modelLinkFields(this.props.model),recordName:this.props.model.name||this.props.model.title}},n.prototype.renderBody=function(){return r.createElement("form",null,this.renderFields(),r.createElement("div",{className:"field"},r.createElement("label",null,"Password"),r.createElement("input",Object.assign({},this.state.link("password"),{type:"password"}))),this.renderControls())},n.prototype.render=function(){return this.renderPopover({height:380})},n}(),e.Access.Screens.UserManagement.Editor=e.React.Component.extend(e.Access.Screens.UserManagement.Editor)}(window.Lanes=window.Lanes||{},(window.Lanes.Vendor=window.Lanes.Vendor||{}).ld,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes,extension:{name:"Lanes",identifier:"lanes"},path:["lanes","access","screens","user-management","Editor"]},window);