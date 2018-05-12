

all: compile simulate

compile:
	vcs +v2k -full64 -debug_all \
	-timescale=1ns/\1ps \
	+warn=noCDNYI,noIPDW,noILLGO,noTMR,noPHNE,noIRIID-W \
	-Mupdate +notimingcheck +nospecify \
	${novas_args} \
	-f flist.f

simulate:
	./simv

verdi:
	verdi -f flist.f -ssf tb.fsdb -workMode hardwareDebug&

clean:
	-rm -rf simv csrc simv.daidir
	-rm novas.conf novas_dump.log novas.rc
	-rm tb.fsdb ucli.key
	-rm -rf verdiLog
