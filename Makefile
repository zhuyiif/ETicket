PROD = ETicket
CONF = Release
CONFD = Debug
IPA = $(HOME)/Downloads
ARC = $(HOME)/Downloads/$(PROD)-$(CONF).xcarchive
ARCD = $(HOME)/Downloads/$(PROD)-$(CONFD).xcarchive
WORKSPACE = '$(PROD).xcworkspace'

.PHONY: build

devdebug:
	make devreplace devbuilddebug devrevert

release:
	make devreplace build devrevert

devbuilddebug:
	xcodebuild -workspace $(WORKSPACE) -scheme $(CONFD) -configuration Debug archive -archivePath $(ARCD)
	xcodebuild -exportArchive -archivePath $(ARCD) -exportPath $(IPA) -exportOptionsPlist exportOptions.plist
	# install FIR-CLI >= 1.1.5 first: gem install fir-cli
	time fir publish -T 2e7c719a47ec178f92ab032936016f53 $(IPA)/$(CONFD).ipa


build:
	xcodebuild -workspace $(WORKSPACE) -scheme $(CONF) archive -archivePath $(ARC)
	xcodebuild -exportArchive -archivePath $(ARC) -exportPath $(IPA) -exportOptionsPlist exportOptions.plist
	# install FIR-CLI >= 1.1.5 first: gem install fir-cli
	time fir publish -T 2e7c719a47ec178f92ab032936016f53 $(IPA)/$(CONF).ipa

devreplace:
	sed -i '' -e 's/ad-hoc/development/g' exportOptions.plist

devrevert:
	sed -i '' -e 's/development/ad-hoc/g' exportOptions.plist


