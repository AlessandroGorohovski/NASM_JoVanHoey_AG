// inline2.c
// Пользование расширенного встроенного ассемблерного кода

#include <stdio.h>

// Глобальные переменные
int a = 12;
int b = 13;
int bsum;

int main(void) {
	printf("The global variables are %d and %d\n", a, b);

	__asm__(
		".intel_syntax noprefix\n"
		"mov rax, a \n"
		"add rax, b \n"
		"mov bsum, rax \n"	// Нет возвращаемого значения, а результат кладёт в глобальную bsum
		:::"rax" // Затираемый регистр
	);
	printf("The extended inline SUM of global variables is %d\n\n", bsum);

	int x = 14, y = 16, esum, eproduct, edif;	// Локальные переменные
	printf("The loсal variables are %d and %d\n", x, y);

	__asm__(
		".intel_syntax noprefix;"
		"mov rax, rdx;"
		"add rax, rcx;"
		:"=a"(esum)	// Возвращаем значение (вывод) в rax через esum
		:"d"(x), "c"(y)	// Передаваемые переменные (ввод) через соответствующие регистры rdx, rcx
	);
	printf("The extended inline SUM of local variables is %d\n", esum);

	__asm__(
		".intel_syntax noprefix;"
		"mov  rbx, rdx;"
		"imul rbx, rcx;"

		"mov  rax, rbx;"
		:"=a"(eproduct)	// Возвращаем значение (вывод) в rax через eproduct
		:"d"(x), "c"(y)	// Передаваемые переменные (ввод) через соответствующие регистры rdx, rcx
		:"rbx"	// затираемый регистр
	);
	printf("The extended inline PRODUCT of local variables is %d\n", eproduct);

	__asm__(
		".intel_syntax noprefix;"
		"mov rax, rdx;"
		"sub rax, rcx;"
		:"=a"(edif)	// Возвращаем значение (вывод) в rax через edif
		:"d"(x), "c"(y)	// Передаваемые переменные (ввод) через соответствующие регистры rdx, rcx
	);
	printf("The extended inline asm difference is %d\n", edif);

	return 0;
}
