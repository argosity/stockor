class Skr.Screens.SkuMaint extends Skr.Screens.Base

    mixins:[
        Lanes.Screens.Mixins.Editing
    ]

    subviews:
        glacct:
            component: 'SelectField'
            model: 'model'
            options: { association: 'gl_asset_account', mappings: { title: 'combined_name' } }

    finderOptions: ->
        modelClass: Skr.Models.Sku
        title: 'Find SKU',
        invalid_chars: Skr.Models.Mixins.CodeField.invalidChars
        withAssociations: []
        fields: ['code', 'description']
