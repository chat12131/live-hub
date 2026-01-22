document.addEventListener('turbolinks:load', function() {
  const $liveScheduleSelector = $('#good_live_schedule_id');
  const $dateField = $('#good_date');
  const $artistSelector = $('#good_artist_id');
  const $addMemberLink = $('#add_member_link');
  const $memberSelector = $('#good_member_id');

  function fetchLiveScheduleDetails(liveScheduleId) {
    if (liveScheduleId) {
      $.getJSON(`/live_records/${liveScheduleId}/details.json`, function(data) {
        if (data.date) {
          $dateField.val(data.date);
        } else {
          $dateField.val('');
        }

        if (data.artist && data.artist.id) {
          $artistSelector.val(data.artist.id).trigger('change');
        } else if (!$artistSelector.val()) {
          $artistSelector.val('').trigger('change');
          $addMemberLink.css('display', 'none');
          $memberSelector.html(`<option value=''>-アーティストを選択してください-</option>`).prop('disabled', true);
        }
      }).fail(function(jqxhr, textStatus, error) {
      });
    } else {
      $dateField.val('');
      if (!$artistSelector.val()) {
        $artistSelector.val('').trigger('change');
        $addMemberLink.css('display', 'none');
        $memberSelector.html(`<option value=''>-アーティストを選択してください-</option>`).prop('disabled', true);
      }
    }
  }

  $liveScheduleSelector.on('change', function() {
    const liveScheduleId = $(this).val();
    fetchLiveScheduleDetails(liveScheduleId);
  });

  const initialLiveScheduleId = $liveScheduleSelector.val();
  if (initialLiveScheduleId) {
    fetchLiveScheduleDetails(initialLiveScheduleId);
  }
});
