function default
  for val in $argv
    if test "$val" != ""
      echo $val
      break
    end
  end
end

function as_table --description "Prints a table of data"
  set data_sep (default $argv[1] ':')
  set col_sep (default $argv[2] ' | ')
  column -s$data_sep -o $col_sep -t
end
