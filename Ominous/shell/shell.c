void shell_prompt() {
	terminal_writestring("\n# ");
}

void shell_execute(const char* cmd) {
	terminal_writestring("\n");
	if (strncmp(cmd, "echo", 255) == 0) {
		terminal_writestring("not implemented yet\n");
	} else if (strncmp(cmd, "pcils", 255) == 0) {
		checkAllBuses();
	} else {
		terminal_writestring("command not found\n");
	}
	/* elf loader */
	shell_prompt();
}

void shell()
{
	shell_prompt();
	int len = 0;
	char cmd[256];
	bzero(cmd, 256);
	while (true) {
		char c = getChar();
		switch (c) {
			case 8:
				if (len > 0) {
					cmd[len] = 0;
					len--;
					terminal_delchar();
				}
				break;
			case '\n':
				if (len > 0) {
					shell_execute(cmd);
					len = 0;
					bzero(cmd, 256);
				}
				break;
			case 0:
				//nothing
				break;
			default:
				cmd[len] = c;
				len++;
				terminal_putchar(c);
		}
	}
}