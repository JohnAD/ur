pandoc README.md -f markdown -t html -s -o docs/index.html
nim doc src/ur.nim
mv ur.html docs/ur.html
nim doc src/urpkg/log.nim
mv log.html docs/log.html
