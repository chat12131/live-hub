import 'bootstrap';
import flatpickr from 'flatpickr';
import '../stylesheets/application';
import '../../assets/stylesheets/user.scss';
import '../artists';
import '../member';
import '../venue';
import '../initialize_flatpickr';
import '../ticket';
import '../add_categories';
import '../menber_in_artist';
import '../goods_liverecord';
import '../weather';
import '../avatar_autosubmit';
import '../flash_close';
import '../charts';
import '../image_preview';
import '../memo_autogrow';
import '../mobile_nav';


import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'

Rails.start()
Turbolinks.start()
ActiveStorage.start()
