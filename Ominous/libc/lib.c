void bzero(char *s, size_t n) //TODO: switch to void
{
	for (int i = 0; i < n; i++) {
		s[i] = 0;
	}
}

void *memset(void *str, int c, size_t n) {
    for (int i = 0; i < n; i++) {
        ((int*)str)[i] = c;
    }
    return str;
}


int strncmp (const char* str1, const char* str2, size_t num)
{
	for (int i = 0; i < num; i++) {
		if (str1[i] > str2[i]) {
			return 1;
		} else if (str1[i] < str2[i]) {
			return -1;
		}

		if (str1[i] == 0 || str2[i] == 0) {
			return 0;
		}
	}
	return 0;
}

size_t strlen (const char* str) 
{
	size_t len = 0;
	while (str[len])
		len++;
	return len;
}

void reverse(char arr[], int count)
{
   int temp;
   for (int i = 0; i < count/2; ++i)
   {
      temp = arr[i];
      arr[i] = arr[count-i-1];
      arr[count-i-1] = temp;
   }
}

void printint(int i) {
	char ch[10];
	bzero(ch, 10);
	itoa(i, ch, 16);
	terminal_writestring(ch);
}

char* itoa(int num, char* str, int base)
{
    int i = 0;
    bool isNegative = false;
 
    /* Handle 0 explicitely, otherwise empty string is printed for 0 */
    if (num == 0)
    {
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }
 
    // In standard itoa(), negative numbers are handled only with 
    // base 10. Otherwise numbers are considered unsigned.
    if (num < 0 && base == 10)
    {
        isNegative = true;
        num = -num;
    }
 
    // Process individual digits
    while (num != 0)
    {
        int rem = num % base;
        str[i++] = (rem > 9)? (rem-10) + 'a' : rem + '0';
        num = num/base;
    }
 
    // If number is negative, append '-'
    if (isNegative)
        str[i++] = '-';
 
    str[i] = '\0'; // Append string terminator
 
    // Reverse the string
    reverse(str, i);
 
    return str;
}