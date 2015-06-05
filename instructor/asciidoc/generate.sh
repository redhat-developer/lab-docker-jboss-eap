#!/bin/sh
asciidoctor /documents/lab.adoc -o /output/lab.html
asciidoctor -b docbook /documents/lab.adoc -o /output/lab.xml
cd /output
fopub lab.xml

