clean:
	@$(MAKE) -C iOS10 clean
	@$(MAKE) -C iOS11 clean
	rm -Rf iOS10/packages
	rm -Rf iOS11/packages
packages: clean
	@$(MAKE) -C iOS10 package FINALPACKAGE=1
	@$(MAKE) -C iOS11 package FINALPACKAGE=1
	rm -Rf packages
	mkdir packages
	mv iOS10/packages/* ./packages/
	mv iOS11/packages/* ./packages/
do:
	@$(MAKE) -C iOS11 do