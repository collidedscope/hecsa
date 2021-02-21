hecsa: hecsa.cr
	crystal build --release --no-debug hecsa.cr

dev: hecsa.cr
	crystal build hecsa.cr
