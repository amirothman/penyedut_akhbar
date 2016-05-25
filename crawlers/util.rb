def remove_invalid_utf8 txt
  txt.encode('utf-8', invalid: :replace, undef: :replace, replace: '')
end
