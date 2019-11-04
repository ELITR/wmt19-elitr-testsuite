# wmt19-elitr-testsuite
This repository contains the "SAO Test Suite" used in WMT19 for a detailed analysis of translation quality in the following translation directions: en-cs en-de de-en cs-de de-cs.

The test suite and the results were presented at WMT19:

* Tereza Vojtěchová, Michal Novák, Miloš Klouček, Ondřej Bojar (2019): SAO WMT19 Test Suite: Machine Translation of Audit Reports. In: Fourth Conference on Machine Translation - Proceedings of the Conference, pp. 680-692, Association for Computational Linguistics, Stroudsburg, PA, USA, ISBN 978-1-950737-27-7
```
@inproceedings{biblio-6791531936341737515,
  author    = {Tereza Vojtěchová and Michal Novák and Miloš Klouček and Ondřej Bojar},
  year      = 2019,
  title     = {SAO WMT19 Test Suite: Machine Translation of Audit Reports},
  booktitle = {Fourth Conference on Machine Translation - Proceedings of the Conference},
  pages     = {680--692},
  publisher = {Association for Computational Linguistics},
  address   = {Stroudsburg, PA, USA},
  isbn      = {978-1-950737-27-7},
}
```

## Contents of the directories:

references:
  The main part of the test suite, the texts in Czech, English and German, aligned across the three languages at the segment level.

translated:
  The outputs of WMT19 primary MT systems, in all the tested translation directions.
  The de<->cs systems are *unsupervised*, i.e. trained on monolingual data.

Makefile, scripts, resources:
  Scripts used to generate the manually evaluated document portions.

manual-annotation-by-auditors:
  The generated PDF files that were assessed by the annotators (auditors employed by the Supreme Audit Office of the Czech Republic)

annotation-web:
  A simple web-based user interface in which annotators recorder and submitted their annotation.

## Acknowledgement

The creation of this test set was supported by the grant H2020-ICT-2018-2-825460 (ELITR) of the European Union.
