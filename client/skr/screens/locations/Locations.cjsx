class Skr.Screens.Locations extends Skr.Screens.Base

    dataObjects:
        location: ->
            @props.location || new Skr.Models.Location

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
                <SC.Address lg=6 model={@location.address}  />
            </BS.Row>

        </LC.ScreenWrapper>
