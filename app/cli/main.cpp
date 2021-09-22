#include "../core/core.h"


int main()
{
  Core * core = new Core();
  core->print_ascii_art_logo();
  delete core;
  return 0;
}
