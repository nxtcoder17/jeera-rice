function edit-encrypted-file
  set file $argv[1]
  set tmp (mktemp -t enc_plain); or return 1
  set enc_tmp (mktemp -t enc_cipher); or begin
      rm -f "$tmp"
      return 1
  end

  function __cleanup --on-event edit_encrypted_cleanup
      rm -f "$tmp" "$enc_tmp"
      set -e ENC_PASS
  end

  read -x -s -P "Password: " ENC_PASS
  echo

  if not decrypt-file "$file" >"$tmp"
      echo "decrypt failed" >&2
      emit edit_encrypted_cleanup
      return 1
  end

  set editor (test -n "$EDITOR"; and echo "$EDITOR"; or echo "vi")
  $editor "$tmp"

  if not encrypt-file "$tmp" >"$enc_tmp"
      echo "encrypt failed" >&2
      emit edit_encrypted_cleanup
      return 1
  end

  mv "$enc_tmp" "$file"
  emit edit_encrypted_cleanup
end

