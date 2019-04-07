configure:
	@mkdir -p build && \
	cd build && \
	cmake -DCMAKE_BUILD_TYPE=Release -GNinja ..

sffmpeg: | configure
	@cd build && \
	ninja

ffmpeg: | configure
	@cd build && \
	ninja ffmpeg

distclean:
	@rm -rf build

clean:

deb:
	@debuild -i -us -uc -b

debclean:
	@debuild clean
