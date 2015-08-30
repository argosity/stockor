class Skr.Screens.SkuMaint extends Lanes.React.Screen

    dataObjects:
        sku: ->
            @props.sku || new Skr.Models.Sku
        query: ->
            new Lanes.Models.Query({
                syncOptions:
                    include: ['default_vendor']
                src: Skr.Models.Sku, fields: [
                    {id:'id', visible: false}
                    'code'
                    { id: 'description', flex: 2}
                ]
            })

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'sku')

    modelForAccess: 'sku'

    render: ->
        <div className="sku-maint">
            <LC.Toolbar commands={@state.commands} />
            <LC.ErrorDisplay model={@sku} />
            <BS.Row>
                <LC.RecordFinder ref="finder" sm=4 autoFocus
                    model={@sku}
                    commands={@state.commands}
                    query={@query} />
                <LC.Input sm=8 name="description" model={@sku} />
            </BS.Row>
            <BS.Row>
                <LC.SelectField sm=2
                    label="Vendor"
                    name="default_vendor"
                    labelField="name"
                    model={@sku} />

                <LC.SelectField sm=2
                    label="Asset Account"
                    name="gl_asset_account"
                    labelField="combined_name"
                    model={@sku} />

                <LC.ToggleField sm=2
                    label="Other Charge?"
                    name="is_other_charge"
                    model={@sku} />

                <LC.ToggleField sm=2
                    label="Track Inventory?"
                    name="does_track_inventory"
                    model={@sku} />

                <LC.ToggleField sm=2
                    label="Can Backorder?"
                    name="can_backorder"
                    model={@sku} />
            </BS.Row>
        </div>
