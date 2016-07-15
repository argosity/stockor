class Skr.Components.LatexSnippets extends Lanes.React.Component

    propTypes:
        settings: React.PropTypes.object.isRequired

    getInitialState: ->
        name: ''
        latex: ''

    componentWillMount: ->
        @props.settings['latex_snippets'] ||= {}

    saveSnippet: (ev) ->
        @setState(latex: ev.target.value)
        name = @refs.name.value
        if @state.name
            @props.settings['latex_snippets'][@state.name] = ev.target.value

    updateName: (ev) ->
        @setState(name: ev.target.value)


    setSnippet: (choice) ->
        @setState(name: choice.id, latex: @props.settings['latex_snippets'][choice.id])

    getSnippets: ->
        snippets = []
        for name, latex of @props.settings['latex_snippets']
            snippets.push {id: name}
        snippets

    onRemove: ->
        delete @props.settings['latex_snippets'][@state.name]
        @setState(name: '', latex: '')

    render: ->

        <div className="latex-snippets">
            <BS.FormGroup>
              <h3>Print Form Snippets</h3>
              <Lanes.Vendor.ReactWidgets.DropdownList
                  data={@getSnippets()}
                  valueField='id' textField='id'
                  value={@state.currentSnippet}
                  onChange={@setSnippet}
              />
            </BS.FormGroup>
            <BS.Row>
                <BS.FormGroup>
                    <BS.Col componentClass={BS.ControlLabel} sm={2}>
                        Snippet name
                    </BS.Col>
                    <BS.Col sm={9}>
                        <BS.FormControl type="text" ref='name'
                            value={@state.name} onChange={@updateName}/>
                    </BS.Col>
                    <BS.Col sm={1}>
                        <LC.Icon type="trash" onClick={@onRemove} />
                    </BS.Col>
                </BS.FormGroup>
            </BS.Row>
            <BS.FormGroup>
              <BS.ControlLabel>Latex</BS.ControlLabel>
              <BS.FormControl componentClass="textarea"
                  value={@state.latex} onChange={@saveSnippet} />
            </BS.FormGroup>

        </div>
