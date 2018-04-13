
#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <vector>
#include <string>
#include <climits>
#include <unistd.h>
#include "rlutil.h"
// #include <stdio.h>

#define PI 3.1415926
#define FRAME_WIDTH 80
#define FRAME_HEIGHT 23
#define FRAME_NUM 10

#define ID "0416045"
#define NAME "Chia-Yu Sun"
#define EMAIL "cysun0226@gmail.com"

using namespace std;

void clear_screen() {
  // CSI[2J clears screen, CSI[H moves the cursor to top-left corner
  std::cout << "\x1B[2J\x1B[H";
}

void showMenu() {
  // show a menu
  cout << endl << " === Options === " << endl << endl;
  cout << " 1. Show colorful frames" << endl;
  cout << " 2. Sum up signed integers" << endl;
  cout << " 3. Sum up unsigned integers" << endl;
  cout << " 4. Compute sin(x)" << endl;
  cout << " 5. Show student information" << endl;
  cout << " 6. Quit" << endl << endl;
  cout << " > Please select an option : ";
}

// overloading sum up function
template <class myType>
myType get_sum (std::vector<myType> v) {
  myType total = 0;
  for (size_t i = 0; i < v.size(); i++)
    total += v[i];
  return total;
}

/* background color */
void draw_bar(int h, int w){
  gotoxy(w+1, h+4);
  for (size_t i = 0; i < FRAME_WIDTH-2*w; i++) {
    cout << ' ';
  }
  cout << endl;
}

void draw_line(int width, int height, int length) {
  // rlutil::setBackgroundColor(color);
  for (size_t h = height; h < length; h++) {
    gotoxy(width, h+4);
    cout << "  " << endl;
  }
}

void show_color() {
  clear_screen();
  cout << "\n --- show color frames --- " << endl;

  std::vector<int> color_stack;
  int color = 0, prev_color = 0;
  // bar
  for (size_t i = 0; i < FRAME_NUM; i++) {
    while (color == prev_color)
      color = rand() % 7 + 1;
    prev_color = color;
    // color_stack.push_back(color);
  	rlutil::setBackgroundColor(color);
    draw_bar(i, i*2);
    draw_line(i*2+1, i, FRAME_HEIGHT-i);
    draw_line(FRAME_WIDTH-i*2-1, i, FRAME_HEIGHT-i);
    draw_bar(FRAME_HEIGHT-i, i*2);

    sleep(1);
  }

  rlutil::setBackgroundColor(rlutil::BLACK);
  gotoxy(0, FRAME_HEIGHT+6);
}

/* sum up */
void sum_up_int() {
  std::vector<int> stack;
  int num;
  cout << "\n\n --- Sum up signed integers ---" << endl << endl;
  cout << " > Please input the number of integers : ";
  cin >> num;
  cout << endl;

  cout << " > Please input integers : ";

  for (size_t i = 0; i < num; i++) {
    int tmp;
    cin >> tmp;
    stack.push_back(tmp);
    cout << " ";
  }

  cout<< endl;

  cout << " Sum = " << get_sum<int>(stack) << endl;
}

/*sin */
void print_vector(std::vector<double> v) {
  for (size_t i = 0; i < v.size(); i++) {
    cout << "s[" << i << "] = " << v[i] << endl;
  }
}

float to_radian(float x) {
	return x / 180.0 * PI;
}

double get_sin(float x, int n) {
  std::vector<double> sin_stack;
  double sum = 0;
  double taylor_series = x;
  for (size_t i = 0; i < n; i++) {
    // sin_stack.push_back(taylor_series);
    sum += taylor_series;
    taylor_series *= - (x*x) / (2*(i+1) * (2*(i+1)+1));
  }

  // return get_sum<double>(sin_stack);
  return sum;
}

void compute_sin() {
  float x; int n;
  cout << "\n\n --- Compute sin(x) ---" << endl << endl;
  cout << " > Please input x : ";
  cin >> x;
  cout << " > Please input n (number of terms) : ";
  cin >> n;
  cout << endl;

  cout << " sin(" << x << ") = " << get_sin(to_radian(x), n) << endl;
}

/* show information */
void show_inform(){
  cout << "\n\n --- Show student information ---" << endl << endl;
  cout << setw(22) << std::left << " student ID" << " : " <<  ID << endl;
  cout << setw(22) << std::left << " student name" << " : " <<  NAME << endl;
  cout << setw(22) << std::left << " student email address" << " : " <<  EMAIL << endl;
}

int main()
{
  char option = 's';
  while (option != 'q')
  {
    showMenu();
    cin >> option;

    if(option == '6' || option == 'q')
      break;

    switch (option) {
      case '1': show_color(); break;
      case '2': sum_up_int(); break;
      case '4': compute_sin(); break;
      case '5': show_inform(); break;

      default: break;
    }

    cout << "\n (Press any key to return to menu...) ";
    cin >> option;
    clear_screen();
  }

  return 0;
}
