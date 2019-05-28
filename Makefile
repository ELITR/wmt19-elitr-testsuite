SHELL=/bin/bash

SCRIPT_DIR=scripts

TRANSL_PAIR=en-cs
SRC_LANG:=$(shell echo $(TRANSL_PAIR) | cut -f1 -d'-')
TRG_LANG:=$(shell echo $(TRANSL_PAIR) | cut -f2 -d'-')
NOT_EN_LANG:=$(shell if [ "$(SRC_LANG)" == en ]; then echo $(TRG_LANG); else echo $(SRC_LANG); fi)

SPLIT_DIR=splits/$(TRANSL_PAIR)
SEGMENT_LENGTH=380


en-cs_SYSTEMS=newstest2019.online-B.0.en-cs newstest2019.CUNI-DocTransformer-T2T.6751.en-cs newstest2019.CUNI-Transformer-T2T-2019.6851.en-cs newstest2019.TartuNLP-c.6633.en-cs
en-de_SYSTEMS=newstest2019.online-B.0.en-de newstest2019.eTranslation.6823.en-de newstest2019.MSRA.MADL.6926.en-de
de-en_SYSTEMS=newstest2019.online-B.0.de-en newstest2019.MSRA.MADL.6910.de-en

split2segments:
	for docpath in `ls -d translated/$(TRANSL_PAIR)/* | grep -v "SML"`; do \
		doc=`echo $$docpath | sed 's|^.*/||'`; \
		echo $$doc; \
		mkdir -p $(SPLIT_DIR)/$$doc; \
		$(SCRIPT_DIR)/suggest_splits.pl 380	< reference/$$doc.en > $(SPLIT_DIR)/$$doc/splits; \
		$(SCRIPT_DIR)/split_file.pl $(SPLIT_DIR)/$$doc/splits $(SPLIT_DIR)/$$doc/src_$(SRC_LANG) < reference/$$doc.$(SRC_LANG); \
		$(SCRIPT_DIR)/split_file.pl $(SPLIT_DIR)/$$doc/splits $(SPLIT_DIR)/$$doc/ref_$(TRG_LANG) < reference/$$doc.$(TRG_LANG); \
		for s in $($(SRC_LANG)-$(TRG_LANG)_SYSTEMS); do \
			$(SCRIPT_DIR)/split_file.pl $(SPLIT_DIR)/$$doc/splits $(SPLIT_DIR)/$$doc/$$s < translated/$(TRANSL_PAIR)/$$doc/$$s; \
		done; \
	done

ANNOTATORS=4
HOURS_PER_ANNOTATOR=2
OVERLAPPING_SEGM=2
ifeq ($(ANNOTATORS),1)
OVERLAPPING_SEGM=0
endif
ifndef ANNOT_TAG
ANNOT_TAG:=$(ANNOTATORS)x$(HOURS_PER_ANNOTATOR)-$(OVERLAPPING_SEGM)
endif

PACK_DIR=manual-annotation-by-auditors/$(TRANSL_PAIR).$(ANNOT_TAG)


GET_WORDS_cs=zcat /net/data/CNK/syn_v4/syn_v4.conll.gz | grep -P '^.*\t.*\tN.*$$' | cut -f2
GET_WORDS_en=cat /net/data/universal-dependencies-2.4/UD_English-EWT/en_ewt-ud-train.conllu | grep -v '^\#' | grep -v '^$$' | grep NOUN | cut -f3

SEGM_ID_LANG:=en
ifeq ($(TRG_LANG), cs)
SEGM_ID_LANG:=cs
endif

TEX_TEMPLATE=resources/annotate.$(SEGM_ID_LANG).tex.templ

resources/segm.%.ids :
	$(GET_WORDS_$*) | head -n50000 | \
		perl -ne 'chomp $$_; if (length $$_ > 5 && length $$_ < 8 && lc($$_) eq $$_ && $$_ =~ /^[a-z]*$$/) { print $$_."\n"; }' |\
		sort | uniq | shuffle --random_seed 42 > $@

segments2pack: resources/segm.$(SEGM_ID_LANG).ids
	$(SCRIPT_DIR)/collect_annot_package.pl $(TRANSL_PAIR) \
		$(ANNOT_TAG) \
		$< \
		$($(SRC_LANG)-$(TRG_LANG)_SYSTEMS) ref_$(TRG_LANG); \
	for src_txt in `find $(PACK_DIR) -name 'src.*.txt'`; do \
		trg_txt=`echo $$src_txt | sed 's|src|trg|g'`; \
		id=`echo $$src_txt | sed 's|^.*src\.[0-9]*-\([^.]*\)\.txt$$|\1|g'`; \
		tex=`echo $$src_txt | sed 's|src|annot|g' | sed 's|\.txt$$|.tex|'`; \
		cat $(TEX_TEMPLATE) | $(SCRIPT_DIR)/fill_in_tex.pl $$id $$src_txt $$trg_txt > $$tex; \
		xelatex -output-directory `dirname $$tex` $$tex; \
	done
