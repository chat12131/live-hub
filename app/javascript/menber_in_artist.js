document.addEventListener('turbolinks:load', function() {
  const $artistSelector = $('#good_artist_id');
  const $memberSelector = $('#good_member_id');
  const $addMemberLink = $('#add_member_link');

  function handleArtistSelection(artistId) {
    if (artistId) {
      const artistEditPath = `/artists/${artistId}/edit`;
      $addMemberLink.attr('href', `${artistEditPath}?from=${encodeURIComponent(window.location.pathname)}`);
      $addMemberLink.css('display', 'block');

      $.getJSON(`/artists/${artistId}/members.json`, function(data) {
        let options = [`<option value=''>-メンバーを選択-</option>`];

        const selectedMemberId = $memberSelector.data('selected-member-id');

        if (data && data.length > 0) {
            options = options.concat(data.map(member => {
                const selectedAttr = member.id === selectedMemberId ? 'selected' : '';
                return `<option value='${member.id}' ${selectedAttr}>${member.name}</option>`;
            }));
            $memberSelector.html(options).prop('disabled', false);
        } else {
            $memberSelector.html(`<option value=''>メンバーがいません</option>`).prop('disabled', true);
        }
      }).fail(function(jqxhr, textStatus, error) {
          const err = textStatus + ', ' + error;
      });
    } else {
      $memberSelector.html(`<option value=''>-アーティストを選択してください-</option>`).prop('disabled', true);
      $addMemberLink.css('display', 'none');
    }
  }

  if ($artistSelector.length) {
    const initialArtistId = $artistSelector.val();
    if (initialArtistId) {
      handleArtistSelection(initialArtistId);
    }

    $artistSelector.on('change', function() {
      const artistId = $(this).val();
      handleArtistSelection(artistId);
    });

  } else {
  }
});
