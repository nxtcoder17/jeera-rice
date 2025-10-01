function lsx --description "A better ls"
  set ls_command "exa --icons"

  for item in $argv
    if test -d "$item"
      # Input is a directory, behave like `ls`
      echo "--- Listing directory: $item ---"
      command ls -l "$item"
    else if test -f "$item"
      # Input is a file, check if it's an archive
      switch "$item"
        case '*.tar.gz' '*.tgz'
          echo "--- Listing compressed tar archive: $item ---"
          tar -ztf "$item"
        case '*.tar.bz2' '*.tbz2'
          echo "--- Listing compressed bzip2 archive: $item ---"
          tar -jtf "$item"
        case '*.tar.xz' '*.txz'
          echo "--- Listing compressed xz archive: $item ---"
          tar -Jtf "$item"
        case '*.tar'
          echo "--- Listing tar archive: $item ---"
          tar -tf "$item"
        case '*.zip'
          echo "--- Listing zip archive: $item ---"
          unzip -l "$item"
        case '*'
          # Input is a regular file, use `ls`
          echo "--- Listing regular file: $item ---"
          command ls -l "$item"
      end
    else
      # Input does not exist or is not a standard file/directory
      echo "--- Not found or unrecognized: $item ---"
      command ls -ld "$item" # Show error or file type
    end
  end
end
