function benchmark_launch
  hyperfine --warmup 17 'fish -i -c "exit"'
end
