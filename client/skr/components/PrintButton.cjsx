class Skr.Components.PrintButton extends Lanes.React.BaseComponent

    propTypes:
        onPrint: React.PropTypes.func


    componentWillMount: ->   window.matchMedia('print')?.addListener(@onWindowPrint)
    componentWillUnmount: -> window.matchMedia('print')?.removeListener(@onWindowPrint)
    onWindowPrint: (mm) ->
        return if mm.matches # true == print is starting, false == complete
        _.delay( =>
            @props.onPrint?(false)
        , 1000)

    print: ->
        _.delay ->
            window.print()
        , 50 # a bit of time for all rendering to complete, and for the loading mask to hide

    onPrintClick: ->
        wait = @props.onPrint?(true)
        if _.isPromise(wait)
            wait.then @print
        else
            @print()

    render: ->
        if @props.iconOnly
            <LC.Icon type="print" onClick={@onPrintClick} />
        else
            <BS.Button className="print" onClick={@onPrintClick} bsSize='small'>
                <LC.Icon type="print" />Print
            </BS.Button>
