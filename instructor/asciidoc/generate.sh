#!/bin/sh
asciidoctor /documents/lab.adoc -o /output/lab.html
asciidoctor -b docbook /documents/lab.adoc -o /output/lab.xml
cp -r /documents/images /output
cd /output
fopub lab.xml

