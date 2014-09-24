SCRIPT = install-debathena

default:
	@echo "Targets: production, beta"

confirm:
	@echo -n "Type 'yes' to move the beta installer to production: "
	@read confirm && [ "$$confirm" = "yes" ]

beta:
	@echo "Go run 'git pull' by hand, please."

production: $(SCRIPT).sh $(SCRIPT).sh.sha256sum.txt

$(SCRIPT).sh: $(SCRIPT).beta.sh confirm
	cp -f $< $@

%.sha256sum.txt: %
	sha256sum $* | cut -d\  -f 1 > $@

.PHONY: default confirm production beta
