#define SIZE 32
#define HEIGHT 64
#define CUBE 1
#define PADDING 0.5

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <GL/glut.h>

float totalSpace = 0;
float center = 0;
float pullDown = 0;
float cameraAngle = 0;
unsigned int gen = 0;
unsigned char*** state;
float* hues;
GLfloat lColors[] = {0.3, 0.3, 0.3};
GLfloat lPos[] = {0.0, 90.0, 0.0, 0.0};

void pSetHSV(float h, float s, float v) {
  int i = (int)floor(h / 60.0f) % 6;
  float f = h / 60.0f - floor(h / 60.0f);
  float p = v * (float)(1 - s);
  float q = v * (float)(1 - s * f);
  float t = v * (float)(1 - (1 - f) * s);
  switch (i) {
    case 0: glColor3f(v, t, p);
      break;
    case 1: glColor3f(q, v, p);
      break;
    case 2: glColor3f(p, v, t);
      break;
    case 3: glColor3f(p, q, v);
      break;
    case 4: glColor3f(t, p, v);
      break;
    case 5: glColor3f(v, p, q);
  }
}

void reshape(int w, int h) {
  glViewport(0, 0, w, h);
}

void moveStateDown() {
  unsigned char** bottom = state[0];
  float bottomHue = hues[0];
  for (unsigned int y = 0; y < HEIGHT-1; y++) {
    state[y] = state[y+1];
    hues[y] = hues[y+1];
  }

  state[HEIGHT-1] = bottom;
  hues[HEIGHT-1] = bottomHue;
}

unsigned char nextState(unsigned int y, unsigned int x, unsigned int z) {
  unsigned char** current = state[y];
  int neighbors = current[(SIZE+x-1) % SIZE][(SIZE+z-1) % SIZE]
    + current[(SIZE+x-1) % SIZE][z]
    + current[(SIZE+x-1) % SIZE][(SIZE+z+1) % SIZE]
    + current[x][(SIZE+z-1) % SIZE]
    + current[x][(SIZE+z+1) % SIZE]
    + current[(SIZE+x+1) % SIZE][(SIZE+z-1) % SIZE]
    + current[(SIZE+x+1) % SIZE][z]
    + current[(SIZE+x+1) % SIZE][(SIZE+z+1) % SIZE];

  return (current[x][z] && (neighbors == 2 || neighbors == 3)) || (!current[x][y] && neighbors == 3);
}

void randomize(unsigned int y, unsigned int chance) {
  for (unsigned int x = 0; x < SIZE; x++)
    for (unsigned int z = 0; z < SIZE; z++)
      if (rand()%chance == 0) state[y][x][z] = 1;
}

void nextGeneration() {
  int y = HEIGHT - 1;

  for (unsigned int x = 0; x < SIZE; x++) {
    for (unsigned int z = 0; z < SIZE; z++) {
      state[y][x][z] = nextState(y-1, x, z);
    }
  }

  if (gen % 10 == 0) randomize(y, 100);
  if (gen % 100 == 0) {
    gen = 0;
    randomize(y, 10);
  }

  gen++;
}

void display() {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();

  GLint viewport[4];
  glGetIntegerv(GL_VIEWPORT, viewport);
  double aspect = (double)viewport[2] / (double)viewport[3];
  gluPerspective(90, aspect, 1, 100);

  glLightfv(GL_LIGHT0, GL_AMBIENT, lColors);
  glLightfv(GL_LIGHT0, GL_POSITION, lPos);

  gluLookAt(0.0, 90.0, 0.1, 10.0 * sin(cameraAngle), 0.0, 10.0 * cos(cameraAngle), 0.0, 1.0, 0.0);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  for (unsigned int y = 0; y < HEIGHT; y++) {
    pSetHSV(hues[y], 0.8, 0.3);
    for (unsigned int x = 0; x < SIZE; x++) {
      for (unsigned int z = 0; z < SIZE; z++) {
        if (x == SIZE/2 && z == SIZE/2) continue;
        if (!state[y][x][z]) continue;

        glPushMatrix();
        glTranslatef((x*totalSpace) - center, y*totalSpace - pullDown, -(z*totalSpace) + center);
        glutSolidCube(1);
        glPopMatrix();
      }
    }
  }

  glutSwapBuffers();
}

void timer(int extra) {
  if (cameraAngle >= 6.28) cameraAngle = 0;
  cameraAngle += 0.01;

  pullDown += totalSpace/10;
  if (pullDown > totalSpace) {
    pullDown = 0;
    moveStateDown();
    nextGeneration();
  }

  glutPostRedisplay();
  glutTimerFunc(16, timer, 0);
}

int main(int argc, char **argv) {
  time_t t;
  unsigned int seed = time(&t);
  srand(seed);

  totalSpace = CUBE + PADDING;
  center = (SIZE*(totalSpace))/2;

  state = malloc(sizeof(unsigned char**) * HEIGHT);
  hues = malloc(sizeof(float) * HEIGHT);
  for (unsigned int y = 0; y < HEIGHT; y++) {
    hues[y] = y*(720/HEIGHT);
    state[y] = malloc(sizeof(unsigned char*) * SIZE);
    for (unsigned int x = 0; x < SIZE; x++) {
      state[y][x] = malloc(sizeof(unsigned char) * SIZE);
      for (unsigned int z = 0; z < SIZE; z++) {
        state[y][x][z] = 0;
      }
    }
  }

  randomize(HEIGHT-1, 2);

  glutInit(&argc, argv);
  glutInitWindowSize(1280, 720);
  glutInitDisplayMode(GLUT_RGBA | GLUT_DEPTH | GLUT_DOUBLE);
  glutCreateWindow("Conway3d v2");

  glutDisplayFunc(display);
  glutReshapeFunc(reshape);
  glutTimerFunc(0, timer, 0);

  glEnable(GL_DEPTH_TEST);
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
  glEnable(GL_COLOR_MATERIAL);

  glutMainLoop();
  return 0;
}