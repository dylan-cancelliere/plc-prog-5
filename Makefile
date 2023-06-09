all: timpcore tuscheme

PATH := /usr/local/pub/mtf/plc/bin:$(shell echo $$PATH)

#
# Choose SML compiler
#
SMLC			:=
ifeq ($(SMLC),)
ifeq (mosmlc, $(shell command -v mosmlc > /dev/null 2>&1 && echo mosmlc))
SMLC := mosmlc
else ifeq (mlton, $(shell command -v mlton > /dev/null 2>&1 && echo mlton))
SMLC := mlton
else
$(error "No SML compiler found.")
endif
endif

ifeq ($(SMLC),mosmlc)
SMLCFLAGS := -o
endif
ifeq ($(SMLC),mlton)
SMLCFLAGS := -output
endif

timpcore: timpcore.sml
	$(SMLC) $(SMLCFLAGS) timpcore timpcore.sml

timpcore-tests.out: timpcore
	./tests/run-timpcore-tests.sh 2>&1 | tee timpcore-tests.out

tuscheme: tuscheme.sml
	$(SMLC) $(SMLCFLAGS) tuscheme tuscheme.sml

tuscheme-tests.out: tuscheme
	./tests/run-tuscheme-tests.sh 2>&1 | tee tuscheme-tests.out

.PHONY: clean
clean:
	rm -rf *.ui *.uo timpcore timpcore-tests.out tuscheme tuscheme-tests.out
