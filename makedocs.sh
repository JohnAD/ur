cp README.rst docs/index.rst
nim doc src/ur.nim
pandoc --from=html --to=rst --output=docs/ur.rst ur.html
rm ur.html
nim doc src/urpkg/log.nim
pandoc --from=html --to=rst --output=docs/log.rst log.html
rm log.html
