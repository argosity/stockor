!function(e,n,t,o,c,a,r,s,i,l){n.Screens.GlAccounts=function(){function e(){}return e.prototype.displayName="Skr.Screens.GlAccounts",e.prototype.FILE=s,e.prototype.modelBindings={account:function(){return this.loadOrCreateModel({klass:n.Models.GlAccount,prop:"account",attribute:"number"})}},e.prototype.getInitialState=function(){return{commands:new n.Screens.Commands(this,{modelName:"account",print:!0})}},e.prototype.render=function(){return a.createElement(c.ScreenWrapper,{identifier:"gl-accounts"},a.createElement(o.ScreenControls,{commands:this.state.commands}),a.createElement(r.Row,null,a.createElement(o.GlAccountChooser,{sm:2,model:this.account,commands:this.state.commands,label:"Number",name:"number",editOnly:!0,finderField:!0}),a.createElement(c.ToggleField,{sm:2,align:"center",label:"Active?",name:"is_active",model:this.account}),a.createElement(c.Input,{sm:8,name:"name",model:this.account})),a.createElement(r.Row,null,a.createElement(c.TextArea,{sm:12,name:"description",model:this.account})))},e}(),n.Screens.GlAccounts=n.Screens.Base.extend(n.Screens.GlAccounts)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","gl-accounts","GlAccounts"]},window);