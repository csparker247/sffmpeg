sffmpeg:
	@mkdir -p build && \
	cd build && \
	cmake -DCMAKE_BUILD_TYPE=Release -GNinja .. && \
	ninja

distclean:
	@rm -rf build

clean:

deb:
	@debuild -i -us -uc -b

debclean:
	@debuild clean
