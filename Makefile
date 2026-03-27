SHELL := /bin/bash

OS := $(shell awk -F= '$$1=="ID" { print $$2 ;}' /etc/os-release)

ifneq (,$(filter ubuntu debian,$(OS)))
	MKFILENAME = ubuntu
else
	MKFILENAME = arch
endif

-include $(MKFILENAME).mk
