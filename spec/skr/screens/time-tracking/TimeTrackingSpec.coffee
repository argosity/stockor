describe "Skr.Screens.TimeTracking", ->

    beforeEach (done) ->
        @screen = LT.renderComponent(Skr.Screens.TimeTracking)
        _.defer =>
            @screen.entries.entries.once 'sync', (te) -> done()
            Lanes.Models.Sync.restorePerform =>
                _.dom(@screen).qs('button[value=month]').click()


    it "renders monthly totals", ->
        _.dom(@screen).qs('button[value=month]').click()
        totals = _.pluck _.dom(@screen).qsa('.day.summary > div'), 'textContent'
        expect(totals).toEqual(["28.75", "14.50", "1.50", "2.00"])
