document.addEventListener('turbolinks:load', function() {
  const addMemberButton = document.getElementById('add-member');
  const memberInput = document.getElementById('member-input');
  const artistForm = document.querySelector('.artist-form form');

  function addMemberAsHiddenField(memberName) {
    if (!artistForm) {
      return;
    }
    const hiddenInput = document.createElement('input');
    hiddenInput.type = 'hidden';
    hiddenInput.name = 'artist[members_attributes][][name]';
    hiddenInput.value = memberName;
    artistForm.appendChild(hiddenInput);
  }

  if (addMemberButton && memberInput) {
    addMemberButton.addEventListener('click', function() {
      const memberName = memberInput.value;
      if (memberName) {
        addMemberAsHiddenField(memberName);
        memberInput.value = '';
      }
    });
  }

  if (artistForm && memberInput) {
    artistForm.addEventListener('submit', function() {
      const memberName = memberInput.value;
      if (memberName) {
        addMemberAsHiddenField(memberName);
      }
    });
  }
});
