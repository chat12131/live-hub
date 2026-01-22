document.addEventListener('turbolinks:load', () => {
  const timepickers = document.querySelectorAll('.timepicker');

  timepickers.forEach(timepicker => {
    const datetime = new Date(timepicker.value);
    timepicker.value = ('0' + datetime.getHours()).slice(-2) + ':' + ('0' + datetime.getMinutes()).slice(-2);
  });

  flatpickr('.timepicker', {
    noCalendar: true,
    enableTime: true,
    dateFormat: 'H:i',
    disableMobile: true,
    locale: 'ja'
  });

  flatpickr('.datepicker', {
    showMonths: 2,
    dateFormat: 'Y-m-d',
    disableMobile: true,
    locale: Object.assign({}, flatpickr.l10ns.ja, { firstDayOfWeek: 1 }),
    prevArrow: "<span aria-hidden='true'>&larr;</span>",
    nextArrow: "<span aria-hidden='true'>&rarr;</span>"
  });
});
