renderLines = (props) ->
    new _.Promise (res, rej) ->
        lines = LT.renderComponent(Skr.Components.SkuLines, {props})
        _.delay -> res(lines)

LAST_ROW_SELECTOR = '.z-table .z-row:last-child'

startEdit = (props) ->
    props.screen.setState(isEditing: true)
    new Promise (res, rej) ->
        props.editor = true
        renderLines(props).then (lines) ->
            Lanes.Models.Sync.restorePerform ->
                _.dom(lines).qs(LAST_ROW_SELECTOR).click()
                remaining = 100
                checkRendered = ->
                    editors = LT.Utils.scryRenderedComponentsWithType(lines,
                        Lanes.Components.Grid.RowEditor)
                    if remaining and _.isEmpty(editors)
                        remaining -= 1
                        console.log remaining
                        _.defer(checkRendered)
                    else
                        res(editor: editors[0], lines: lines)
                checkRendered()

describe "Skr.Components.SkuLines", ->

    beforeEach (done) ->
        screen   = LT.makeScreen()
        commands = new Lanes.Screens.Commands(screen, modelName: 'sales_order')
        Lanes.Models.Sync.restorePerform =>
            Skr.Models.SalesOrder.where({visible_id: 1}, include: 'lines')
                .whenLoaded (orders) =>
                    @sales_order = orders.first()
                    lines = @sales_order.lines
                    @props = {lines, commands, screen}
                    done()

    it "renders lines", (done) ->
        renderLines(@props).then (lines) =>
            expect(_.dom(lines).qsa('.z-row').length).toEqual( @props.lines.length )
            done()

    it "displays the editor", (done) ->
        startEdit(@props).then ({lines, editor}) =>
            sol = @props.lines.last()
            expect(_.pluck( _.dom(editor).qsa('input'), 'value'))
                .toEqual([sol.sku_code, sol.description, sol.uom_code, "#{sol.qty}", sol.price.toString()])
            done()

    it "saves values when edited", (done) ->
        startEdit(@props).then ({lines, editor}) =>
            _.dom(editor).qs('input[name=price]').setValue('42.21')
            _.dom(editor).qs('input[name=qty]').setValue(12)
            _.dom(editor).qs('button.save').click()
            _.defer =>
                sol = @props.lines.last()
                expect(sol.qty).toEqual(12)
                expect(sol.price.toString()).toEqual('42.21')
                done()
