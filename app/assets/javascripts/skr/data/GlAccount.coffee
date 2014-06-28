class Skr.Data.GlAccount extends Skr.Data.Model
    name: 'Gl Account'
    @include Skr.Data.mixins.HasCodeField


class GlAccountListing extends Skr.Data.Collection
    model: Skr.Data.GlAccount

Skr.Data.GlAccounts = new GlAccountListing

Skr.Data.GlAccounts.bootstrap = (accounts)->
    Skr.Data.GlAccounts.reset(accounts)
