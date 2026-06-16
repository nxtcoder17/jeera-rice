function decrypt-file
  openssl enc -d -aes-256-cbc -a -salt -pbkdf2 -iter 100000 -pass env:ENC_PASS -in "$argv[1]"
end
