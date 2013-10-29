#!/bin/sh

# Generate appledoc
appledoc --project-name "KiiToolkit-iOS" --project-company "Kii Corporation" --create-html --no-create-docset --company-id com.kii --output ./ --ignore "Documentation" --explicit-crossref --keep-intermediate-files ../

exit 0;
