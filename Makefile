# Resolve bash through PATH so this also works on Termux
SHELL := bash

# Termux uses a PREFIX under its Android app directory
ifneq (,$(findstring /com.termux/,$(PREFIX)))
    MKFILENAME := termux
else
    OS := $(shell awk -F= '$$1=="ID" { gsub(/"/, "", $$2); print $$2; }' /etc/os-release 2>/dev/null)

    ifneq (,$(filter debian ubuntu linuxmint,$(OS)))
        MKFILENAME := ubuntu
    else ifneq (,$(filter arch manjaro endeavouros garuda cachyos,$(OS)))
        MKFILENAME := arch
    else
        $(error Unsupported operating system: $(if $(OS),$(OS),unknown))
    endif
endif

-include $(MKFILENAME).mk
