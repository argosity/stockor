class Skr.Screens.SkuMaint extends Skr.Screens.Base

    syncOptions:
        {include: ['default_vendor', 'uoms']}

    modelBindings:
        sku: ->
            @loadOrCreateModel({
                syncOptions: @syncOptions, klass: Skr.Models.Sku, prop: 'sku', attribute: 'code'
            })

    getInitialState: ->
        commands: new Skr.Screens.Commands(this, modelName: 'sku')

    modelForAccess: 'sku'

    render: ->
        <LC.ScreenWrapper identifier="sku-maint">
            <SC.ScreenControls commands={@state.commands} />
            <BS.Row>
                <SC.SkuFinder model={@sku} sm=4 label='Code' editOnly autoFocus
                    syncOptions={@syncOptions}
                    model={@sku} name='code'
                    commands={@state.commands} />

                <LC.Input sm=8 name="description" model={@sku} />
            </BS.Row>
            <BS.Row>
                <SC.VendorFinder model={@sku} name="default_vendor" selectField />

                <SC.GlAccountChooser sm=3 label="Asset Account"
                    name="gl_asset_account" model={@sku} />

                <Skr.Screens.SkuMaint.SkuUomList label={"UOMs"} model={@sku} name='uoms' sm=4 />
            </BS.Row>
            <BS.Row>
                <LC.ToggleField sm=2
                    label="Is Public?"
                    name="is_public"
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

        </LC.ScreenWrapper>
