class Skr.Screens.SkuMaint extends Lanes.React.Screen

    dataObjects:
        vendor: ->
            @props.sku || new Skr.Models.Sku
        query: ->
            new Lanes.Models.Query({
                modelClass: Skr.Models.Sku, fields: [
                    {id:'id', visible: false}
                    'code'
                    { id: 'description', flex: 2}
                ]
            })

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'vendor')

    modelForAccess: 'sku'

    render: ->
        <div className="sku-maint">
            <LC.Toolbar commands={@state.commands} />
            <LC.ErrorDisplay model={@vendor} />
            <BS.Row>
                <LC.RecordFinder ref="finder" sm=4 autoFocus
                    model={@vendor}
                    commands={@state.commands}
                    query={@query} />
                <LC.TextField sm=8 name="description" model={@vendor} />
            </BS.Row>
            <BS.Row>
                <LC.SelectField sm=4
                    label="Asset Account"
                    name="gl_asset_account"
                    labelField="combined_name"
                    model={@sku} />

                <LC.SelectField sm=4
                    label="Asset Account"
                    name="gl_asset_account"
                    labelField="combined_name"
                    model={@sku} />

        </div>
