#! /usr/bin/env sh

x=""
while read line
do
  x+="$line"
done < "${1:-/dev/stdin}"

[ -d /tmp/to-json ] && mkdir /tmp/to-json

fName=/tmp/to-json/${RANDOM}.js
cat > $fName <<EOF
  let x = \`$x\`;
  x = x.trim();
  eqIdx = x.indexOf('=')
  colIdx = x.indexOf(':')
  if (x.endsWith(';')) x = x.slice(0,-1)

  if ( eqIdx != -1 && eqIdx < colIdx) {
    const toStringify = x.split('=', 2)[1].trim()
    eval('const y = ' + x + '; console.log(JSON.stringify(y, null, 2))')
  } else {
    eval('const y = ' + x + '; console.log(JSON.stringify(y, null, 2))')
  }
EOF

node $fName
rm $fName
