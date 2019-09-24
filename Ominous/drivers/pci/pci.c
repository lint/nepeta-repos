void checkDevice(uint8_t bus, uint8_t device);
void checkBus(uint8_t bus);
void checkFunction(uint8_t bus, uint8_t device, uint8_t function);
void checkAllBuses(void);

uint8_t ahci_bus = 0; //lets assume we can only have one AHCI controller rn
uint8_t ahci_slot = 0;

uint16_t pciConfigReadWord (uint8_t bus, uint8_t slot, uint8_t func, uint8_t offset)
{
	uint32_t address;
	uint32_t lbus  = (uint32_t)bus;
	uint32_t lslot = (uint32_t)slot;
	uint32_t lfunc = (uint32_t)func;
	uint16_t tmp = 0;

	/* create configuration address as per Figure 1 */
	address = (uint32_t)((lbus << 16) | (lslot << 11) |
	(lfunc << 8) | (offset & 0xfc) | ((uint32_t)0x80000000));

	/* write out the address */
	outl (0xCF8, address);
	/* read in the data */
	/* (offset & 2) * 8) = 0 will choose the first word of the 32 bits register */
	tmp = (uint16_t)((inl (0xCFC) >> ((offset & 2) * 8)) & 0xffff);
	return (tmp);
}

uint16_t getVendorID(uint8_t bus, uint8_t slot, uint8_t func)
{
	return pciConfigReadWord(bus,slot,func,0);
}

uint16_t getDeviceID(uint8_t bus, uint8_t slot, uint8_t func)
{
	return pciConfigReadWord(bus,slot,func,2);
}

uint8_t getHeaderType(uint8_t bus, uint8_t slot, uint8_t func)
{
	return pciConfigReadWord(bus,slot,func,13) >> 8;
}

void checkDevice(uint8_t bus, uint8_t device) {
	uint8_t function, headerType = 0;
	uint16_t vendorID, deviceID = 0;
	
	vendorID = getVendorID(bus, device, function);
	if(vendorID == 0xFFFF) return;        // Device doesn't exist
	deviceID = getDeviceID(bus, device, function);


	//terminal_writestring("[pci] ");
	printint(vendorID);
	terminal_writestring(":");
	printint(deviceID);

	checkFunction(bus, device, function);
	terminal_writestring("\n");

	headerType = getHeaderType(bus, device, function);

	/*if (headerType != 15) {
		terminal_writestring("[pci] headerType = ");
		printint(headerType);
		terminal_writestring("\n");
	}*/

	if( (headerType & 0x80) != 0) {
			
			/* It is a multi-function device, so check remaining functions */
			for(function = 1; function < 8; function++) {
					if(getVendorID(bus, device, function) != 0xFFFF) {
							checkFunction(bus, device, function);
					}
			}
	}
}

void checkBus(uint8_t bus) {
	uint8_t device;

	for(device = 0; device < 32; device++) {
			checkDevice(bus, device);
	}
}

void checkFunction(uint8_t bus, uint8_t slot, uint8_t func) {
	uint16_t class;
	uint8_t baseClass;
	uint8_t subClass;
	uint8_t secondaryBus;

	class = pciConfigReadWord(bus,slot,func,10);
	subClass = class & 0xFF;
	baseClass = class >> 8;

	if ((baseClass == 0x01) && (subClass == 0x06)) {
		ahci_bus = bus;
		ahci_slot = slot;
		terminal_writestring(" - AHCI");
	}

	/*terminal_writestring("[pci] class = ");
	printint(baseClass);
	terminal_writestring("; subClass = ");
	printint(subClass);
	terminal_writestring("\n");*/

	if( (baseClass == 0x06) && (subClass == 0x04) ) {
		secondaryBus = pciConfigReadWord(bus,slot,func,26);
		checkBus(secondaryBus);
	}
}

void checkAllBuses(void) {
	uint8_t function;
	uint8_t bus;
	uint8_t headerType;

	headerType = getHeaderType(0, 0, 0);
	if( (headerType & 0x80) == 0) {
		/* Single PCI host controller */
		checkBus(0);
	} else {
		/* Multiple PCI host controllers */
		for(function = 0; function < 8; function++) {
			if(getVendorID(0, 0, function) != 0xFFFF) break;
			bus = function;
			checkBus(bus);
		}
	}
}