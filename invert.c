#include <stddef.h>

struct bt {
  unsigned value;
  struct bt *left;
  struct bt *right;
};

struct bt *reverse(struct bt *p) {
  struct bt *t;
  if (!p)
    return NULL;
  t = reverse(p->left);
  p->left = reverse(p->right);
  p->right = t;
  return p;
}

int main(void) { return 0; }
