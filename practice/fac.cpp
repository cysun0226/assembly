
#include<iostream>

int factorial(int a[], int n)
{
    if ( n <=0 ) return a[0];
    int c = a[n]*factorial(a, n-1);
    return c;
 }

 int foo (int n, int *b, int *c, int sign) {
   if (b[n] == 0) return (*c);

   *c = (*c) + b[n] * sign;
   sign *= -1;
   std::cout << "c = " << *c << std::endl;
   return foo(n+1, b, c, sign);
 }

int main()
{
  int n;
  std::cout << "Input n: ";
  std::cin >> n;
  int arr[] = {1, 2, 3, 4, 5, 6, 7};

  std::cout << n << "! = " << factorial(arr, n-1) << std::endl << std::endl;

  int b[100];
  int c[100];
  for (size_t i = 1; i <= 30; i++) {
    b[i-1] = i;
    c[i-1] = i;
  }

  std::cout << "foo(n) = " << foo(0, b, &n, 1) << std::endl;


  return 0;
}
