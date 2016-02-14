class Skr.Screens.Locations extends Skr.Screens.Base

    syncOptions:
        include: [ 'address' ]

    dataObjects:
        location: ->
            @loadOrCreateModel({
                syncOptions: @syncOptions, klass: Skr.Models.Location
                prop: 'location', attribute: 'code'
            })

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'location')

    render: ->
        <LC.ScreenWrapper identifier="locations">
            <Lanes.Screens.CommonComponents commands={@state.commands} />
            <BS.Row>
                <SC.LocationChooser label='Code' editOnly displayFinder
                    commands={@state.commands} model={@location} name="code" />
                <LC.Input sm=6 name='name' model={@location} />
            </BS.Row>
            <BS.Row>
                <LC.ImageSaver label='Logo' sm=3 model={@location} name='logo' />
            </BS.Row>
            <BS.Row>
                <SC.Address lg=6 model={@location.address}  />
            </BS.Row>

        </LC.ScreenWrapper>
