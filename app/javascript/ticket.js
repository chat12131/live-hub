document.addEventListener('turbolinks:load', function() {
  const ticketStatusRadios = document.querySelectorAll('input[name="live_schedule[ticket_status]"]');
  const ticketSaleDateField = document.querySelector('input[name="live_schedule[ticket_sale_date]"]');
  const ticketPriceField = document.querySelector('input[name="live_schedule[ticket_price]"]');
  const drinkPriceField = document.querySelector('input[name="live_schedule[drink_price]"]');

  function updateFormFields() {
    if (!ticketSaleDateField || !ticketPriceField || !drinkPriceField) {
      return;
    }

    let selectedValue;
    ticketStatusRadios.forEach(radio => {
      if (radio.checked) {
        selectedValue = radio.value;
      }
    });

    const visibleFields = [];

    if (selectedValue === '未購入') {
      ticketSaleDateField.closest('.ticket-field').classList.remove('is-hidden');
      visibleFields.push(ticketSaleDateField.closest('.ticket-field'));
    } else {
      ticketSaleDateField.closest('.ticket-field').classList.add('is-hidden');
    }

    if (selectedValue === 'チケ無し') {
      ticketPriceField.closest('.ticket-field').classList.add('is-hidden');
    } else {
      ticketPriceField.closest('.ticket-field').classList.remove('is-hidden');
      visibleFields.push(ticketPriceField.closest('.ticket-field'));
    }

    drinkPriceField.closest('.ticket-field').classList.remove('is-hidden');
    visibleFields.push(drinkPriceField.closest('.ticket-field'));

    flatpickr("[class='flatpickr']", {
      enableTime: true,
      dateFormat: 'Y-m-d H:i',
      disableMobile: true,
      'locale': 'ja'
    });
  }

  ticketStatusRadios.forEach(radio => {
    radio.addEventListener('change', updateFormFields);
  });

  const ticketStatusSpans = document.querySelectorAll('.btn-radio');
  ticketStatusSpans.forEach(span => {
    span.addEventListener('click', function() {
      const radio = span.querySelector('input[type="radio"]');
      radio.click();
    });
  });

  updateFormFields();
});
