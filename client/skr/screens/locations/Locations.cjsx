class Skr.Screens.Locations extends Skr.Screens.Base

    syncOptions:
        include: [ 'address', 'logo' ]

    modelBindings:
        location: ->
            @loadOrCreateModel({
                syncOptions: @syncOptions, klass: Skr.Models.Location
                prop: 'location', attribute: 'code'
            })

    getInitialState: ->
        commands: new Skr.Screens.Commands(this, modelName: 'location')

    render: ->
        <LC.ScreenWrapper identifier="locations">
            <SC.ScreenControls commands={@state.commands} />
            <BS.Row>
                <SC.LocationChooser label='Code' editOnly displayFinder
                    syncOptions={@syncOptions}
                    commands={@state.commands} model={@location} name="code" />
                <LC.Input sm=6 name='name' model={@location} />
            </BS.Row>
            <BS.Row>
                <LC.FieldSet title="Logos" sm=12>
                    <LC.ImageAsset sm=5 asset={@location.logo}
                        label='Primary' size='thumb' />
                    <LC.ImageAsset sm=5 smOffset=2 asset={@location.print_logo}
                        label='Print' size='thumb' />
                </LC.FieldSet>
            </BS.Row>
            <BS.Row>
                <SC.Address lg=6 model={@location.address}  />
            </BS.Row>

        </LC.ScreenWrapper>
