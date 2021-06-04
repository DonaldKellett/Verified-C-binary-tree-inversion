#include <stddef.h>

struct bt {
  unsigned value;
  struct bt *left;
  struct bt *right;
};

struct bt *invert(struct bt *p) {
  struct bt *t;
  if (!p)
    return NULL;
  t = invert(p->left);
  p->left = invert(p->right);
  p->right = t;
  return p;
}

int main(void) { return 0; }
