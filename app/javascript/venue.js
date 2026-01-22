window.initMap = function() {
    const input = document.getElementById('venue-name-display');

    if (!input || !(input instanceof HTMLInputElement)) {
        return;
    }

    const options = {
        componentRestrictions: { country: 'JP' },
    };
    const autocomplete = new google.maps.places.Autocomplete(input, options);

    autocomplete.setTypes(['establishment']);
    autocomplete.setFields(['name', 'place_id', 'address_components', 'geometry']);

    autocomplete.addListener('place_changed', function() {
        const place = autocomplete.getPlace();

        if (!place.geometry) {
            return;
        }
        input.value = place.name;

        let area = '';
        place.address_components.forEach(component => {
            if (component.types.includes('locality')) {
                area = component.long_name;
            }
        });

        if (area.endsWith('市') || area.endsWith('区') || area.endsWith('町') || area.endsWith('村')) {
            area = area.slice(0, -1);
        }

        const latitude = place.geometry.location.lat();
        const longitude = place.geometry.location.lng();

        document.getElementById('nameField').value = place.name;
        document.getElementById('google_place_idField').value = place.place_id;
        document.getElementById('areaField').value = area;
        document.getElementById('latitudeField').value = latitude;
        document.getElementById('longitudeField').value = longitude;
    });


    input.addEventListener('input', function() {
        document.getElementById('nameField').value = '';
        document.getElementById('google_place_idField').value = '';
        document.getElementById('areaField').value = '';
        document.getElementById('latitudeField').value = '';
        document.getElementById('longitudeField').value = '';
    });


    input.addEventListener('blur', function() {
        const nameField = document.getElementById('nameField');

        if (!nameField.value) {
            nameField.value = input.value;
        }
    });
}

document.addEventListener('turbolinks:load', initMap);
