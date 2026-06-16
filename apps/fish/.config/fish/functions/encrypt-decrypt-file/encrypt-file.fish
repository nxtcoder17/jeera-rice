function encrypt-file
  test -e "$argv[1]"; or begin
    echo "$argv[1] does not exist" >&2
    return 1
  end
  openssl enc -aes-256-cbc -a -salt -pbkdf2 -iter 100000 -pass env:ENC_PASS -in "$argv[1]"
end
