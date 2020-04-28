!function(e,n,t,r,o,i,c,a,s,l){n.Screens.ChartOfAccounts=function(){function t(){}return t.prototype.displayName="Skr.Screens.ChartOfAccounts",t.prototype.FILE=a,t.prototype.modelForAccess="gl-transaction",t.prototype.modelBindings={query:function(){return new e.Models.Query({title:"Lines",src:n.Models.GlAccount,syncOptions:{"with":"with_balances"},fields:[{id:"id",visible:!1},{id:"number",label:"Acct #",fixedWidth:120},"description",{id:"balance",fixedWidth:120,textAlign:"right",format:e.u.format.currency}]})}},t.prototype.reload=function(){return this.query.results.reload()},t.prototype.onRowClick=function(n){return e.Screens.Definitions.all.get("gl-transactions").display({props:{account:n}})},t.prototype.render=function(){return i.createElement(o.ScreenWrapper,{flexVertical:!0,identifier:"chart-of-accounts"},i.createElement("div",{className:"heading"},i.createElement("h3",null,"Chart of Accounts"),i.createElement("span",{className:"explain"},"Click row to review transactions"),i.createElement(c.Button,{onClick:this.reload},"Reload")),i.createElement(o.Grid,{onSelectionChange:this.onRowClick,query:this.query,ref:"grid",expandY:!0}))},t}(),n.Screens.ChartOfAccounts=n.Screens.Base.extend(n.Screens.ChartOfAccounts)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","chart-of-accounts","ChartOfAccounts"]},window);