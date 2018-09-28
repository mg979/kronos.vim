if exists('b:current_syntax')
  finish
endif

syntax match KronosInfoNoteHead  '^## Note:'
highlight default link KronosInfoNoteHead     Comment

let b:current_syntax = 'knote'


