class Skr.Screens.SkuMaint extends Skr.Screens.Base

    mixins:[
        Lanes.Screens.Mixins.Editing
    ]
    useFormBindings: true

    finderOptions: ->
        modelClass: Skr.Models.Sku
        title: 'Find SKU',
        invalid_chars: Skr.Models.Mixins.CodeField.invalidChars
        withAssociations: []
        fields: ['code', 'description']
