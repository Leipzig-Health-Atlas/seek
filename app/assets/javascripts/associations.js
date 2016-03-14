function optionsFromArray(array) {
    var options = [];

    for(var i = 0; i < array.length; i++)
        options.push($j('<option/>').val(array[i][1]).text(array[i][0])[0]);

    return options;
}

var Associations = {};

// Object to control a list of existing associations
Associations.List = function (template, element) {
    this.template = template;
    this.element = element;
    this.element.data('associationList', this);
    this.listElement = $j('ul', this.element);
    this.items = [];
};

Associations.List.prototype.toggleEmptyListText = function () {
    var noText = $j('.no-item-text', this.element);

    if(this.items.length === 0)
        noText.show();
    else
        noText.hide();
};

Associations.List.prototype.add = function (association) {
    this.items.push(new Associations.ListItem(this, association));
    this.toggleEmptyListText();
};

Associations.List.prototype.remove = function (listItem) {
    var index = this.items.indexOf(listItem);
    if (index > -1)
        this.items.splice(index, 1);
    this.toggleEmptyListText();
};

Associations.List.prototype.removeAll = function () {
    this.items = [];
    this.listElement.html('');
    this.toggleEmptyListText();
};

// Object to control an element in the association list
Associations.ListItem = function (list, data) {
    this.list = list;
    this.data = data;

    // Create and append element to list
    this.element = $j(HandlebarsTemplates[this.list.template](data));
    this.list.listElement.append(this.element);

    // Bind remove event
    var listItem = this;
    this.element.on('click', '.remove-association', function () {
        listItem.remove();
    });
};

Associations.ListItem.prototype.remove = function () {
    this.element.remove();
    this.list.remove(this);
};


// Object to control the association selection form.
Associations.Form = function (list, element) {
    this.list = list;
    this.element = element;
    this.element.data('associationForm', this);
    this.selectedItems = [];
    this.commonFieldElements = [];
};

Associations.Form.prototype.reset = function () {
    this.selectedItems = [];
};

Associations.Form.prototype.submit = function () {
    var commonFields = {};
    this.commonFieldElements.forEach(function (element) {
        var name = element.data('attributeName');
        if(element.is('select')) {     //  <select> tags store both the value and the selected option's text
            commonFields[name] = { value: element.val(),
                text: $j('option:selected', element).text() };
        } else {
            commonFields[name] = element.val();
        }
    });

    var list = this.list;
    this.selectedItems.forEach(function (selectedItem) {
        // Merge the common fields with the selected item's attributes
        var associationObject = $j.extend({}, commonFields, selectedItem);
        list.add(associationObject);
    });

    if(this.afterSubmit)
        this.afterSubmit(this.selectedItems.length);

    this.reset();
};


$j(document).ready(function () {
    $j('[data-role="seek-association-form"]').each(function () {
        var element = this;
        var listId = $j(element).data('associationsListId');
        var list = $j('#' + listId).data('associationList'); // Get the List object from the DOM element
        var form = new Associations.Form(list, $j(this));

        // Strip the name of the element and store it as a data attribute, to stop it being submitted as a field in the
        //  main form
        $j(':input[data-role="seek-association-common-field"]', $j(element)).each(function () {
            $j(this).data('attributeName', this.name);
            this.name = '';
            form.commonFieldElements.push($j(this));
        });

        $j('[data-role="seek-association-confirm-button"]', $j(element)).click(function (e) {
            e.preventDefault();
            form.submit();
        });

        $j(element).on('click', '.selectable[data-role="seek-association-candidate"]', function () {
            $j(this).toggleClass('selected');
            if(!$j(this).parents('[data-role="seek-association-candidate-list"]').data('multiple')) {
                $j(this).siblings().removeClass('selected');
            }

            form.selectedItems = [];
            $j(this).parents('[data-role="seek-association-candidate-list"]').find('[data-role="seek-association-candidate"].selected').each(function () {
                // Merge common fields and association-specific fields into single object
                form.selectedItems.push({
                    id: $j(this).data('associationId'),
                    title: $j(this).data('associationTitle')
                });
            });

            return false;
        });
    });


    $j('[data-role="seek-associations-list"]').each(function () {
        var list = new Associations.List($j(this).data('templateName'), $j(this));
        var self = $j(this);
        var existingValues = JSON.parse($j('script[data-role="seek-existing-associations"]', self).html());

        existingValues.forEach(function (value) {
            list.add(value)
        });
    });

    $j('[data-role="seek-association-filter"]').keypress(function (e) {
        // If more than two characters were entered, or the input was cleared, or the ENTER key was pressed..
        var filter = this;
        if($j(this).val().length == 0 || $j(this).val().length >= 2 || e.keyCode == 13) {
            $j.ajax($j(this).data('filterUrl'), {
                    data: { filter: $j(this).val() },
                    success: function (data) { $j(filter).siblings('[data-role="seek-association-candidate-list"]').html(data); }
                }
            );
            if(e.keyCode == 13)
                e.preventDefault();
        }
    });
});
